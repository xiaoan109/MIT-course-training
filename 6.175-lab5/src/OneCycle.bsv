// OneCycle.bsv
//
// This is a one cycle implementation of the SMIPS processor.

import Types::*;
import ProcTypes::*;
import MemTypes::*;
import RFile::*;
import IMemory::*;
import DMemory::*;
import Decode::*;
import Exec::*;
import Cop::*;
import Vector::*;
import Fifo::*;
import Ehr::*;

(* synthesize *)
module mkProc(Proc);
    Reg#(Addr) pc <- mkRegU;
    RFile      rf <- mkRFile;
    IMemory  iMem <- mkIMemory;
    DMemory  dMem <- mkDMemory;
    Cop       cop <- mkCop;

    Bool memReady = iMem.init.done() && dMem.init.done();

    rule doProc(cop.started);
        Data inst = iMem.req(pc);

        // decode
        DecodedInst dInst = decode(inst);

        // trace - print the instruction
        $display("pc: %h inst: (%h) expanded: ", pc, inst, showInst(inst));

        // read register values 
        Data rVal1 = rf.rd1(validRegValue(dInst.src1));
        Data rVal2 = rf.rd2(validRegValue(dInst.src2));

        // Co-processor read for debugging
        Data copVal = cop.rd(validRegValue(dInst.src1));

        // execute
        ExecInst eInst = exec(dInst, rVal1, rVal2, pc, ?, copVal);  // The fifth argument is the predicted pc, to detect if it was mispredicted. Since there is no branch prediction, this field is sent with a random value

        // Executing unsupported instruction. Exiting
        if(eInst.iType == Unsupported) begin
            $fwrite(stderr, "Executing unsupported instruction at pc: %x. Exiting\n", pc);
            $finish;
        end

        // memory
        if(eInst.iType == Ld) begin
            eInst.data <- dMem.req(MemReq{op: Ld, addr: eInst.addr, data: ?});
        end else if(eInst.iType == St) begin
            let d <- dMem.req(MemReq{op: St, addr: eInst.addr, data: eInst.data});
        end

        // write back
        if(isValid(eInst.dst) && validValue(eInst.dst).regType == Normal) begin
            rf.wr(validRegValue(eInst.dst), eInst.data);
        end

        // update the pc depending on whether the branch is taken or not
        pc <= eInst.brTaken ? eInst.addr : pc + 4;

        // Co-processor write for debugging and stats
        cop.wr(eInst.dst, eInst.data);
    endrule

    method ActionValue#(Tuple2#(RIndx, Data)) cpuToHost;
        let ret <- cop.cpuToHost;
        return ret;
    endmethod

    method Action hostToCpu(Bit#(32) startpc) if ( !cop.started && memReady );
        cop.start;
        pc <= startpc;
    endmethod

    interface MemInit iMemInit = iMem.init;
    interface MemInit dMemInit = dMem.init;
endmodule

