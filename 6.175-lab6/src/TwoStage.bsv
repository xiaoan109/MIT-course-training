import Types::*;
import ProcTypes::*;
import MemTypes::*;
import Btb::*;
import RFile::*;
import Scoreboard::*;
import IMemory::*;
import DMemory::*;
import Decode::*;
import Exec::*;
import Cop::*;
import Vector::*;
import Fifo::*;
import Ehr::*;

// Data structure for Fetch to Execute stage
typedef struct {
    Addr pc;
    Addr ppc;
    DecodedInst dInst;
    Data rVal1;
    Data rVal2;
    Data copVal;
    Bool instEpoch;
} Fetch2Execute deriving (Bits, Eq);

(* synthesize *)
module mkProc(Proc);
    // The pc register is called pc_reg to avoid conflicts with rules reusing
    // the name pc to denote the pc for the current instruction.
    // Example: rule doExecute can name a variable pc to denote the pc of the
    // instruction being executed.
    Reg#(Addr) pc_reg <- mkRegU;
    Btb#(6,8)     btb <- mkBtb;
    RFile          rf <- mkRFile;
    Scoreboard#(2) sb <- mkBypassScoreboard;
    IMemory      iMem <- mkIMemory;
    DMemory      dMem <- mkDMemory;
    Cop           cop <- mkCop;

    Reg#(Bool) fetchEpoch <- mkReg(False);
    Reg#(Bool) executeEpoch <- mkReg(False);

    Bool memReady = iMem.init.done() && dMem.init.done();

    Fifo#(2, Redirect) redirectFifo <- mkCFFifo();
    Fifo#(2, Fetch2Execute) f2eFifo <- mkCFFifo();

    rule doFetch(cop.started && memReady);
        if( redirectFifo.notEmpty ) begin
            // Correct for misprediction
            let redirect_msg = redirectFifo.first;
            pc_reg <= redirect_msg.nextPc;
            redirectFifo.deq;
            fetchEpoch <= ! fetchEpoch;
            $display("Fetch: Mispredict");
            
            // Train BTB
            btb.update( redirect_msg.pc, redirect_msg.nextPc );
        end else begin
            // Fetch
            Addr pc = pc_reg;
            Data inst = iMem.req(pc);
            Addr ppc = btb.predPc(pc);
            Bool instEpoch = fetchEpoch;

            // Decode
            DecodedInst dInst = decode(inst);

            // Register Read
            Data rVal1 = rf.rd1(validRegValue(dInst.src1));
            Data rVal2 = rf.rd2(validRegValue(dInst.src2));
            Data copVal = cop.rd(validRegValue(dInst.src1));

            // Prepare data structure for fetch to execute fifo
            Fetch2Execute f2e;
            f2e.pc = pc;
            f2e.ppc = ppc;
            f2e.dInst = dInst;
            f2e.rVal1 = rVal1;
            f2e.rVal2 = rVal2;
            f2e.copVal = copVal;
            f2e.instEpoch = instEpoch;

            if( !sb.search1( dInst.src1 ) && !sb.search2( dInst.src2 ) ) begin
                // Enqueue data into fetch to execute fifo and update state
                f2eFifo.enq( f2e );
                sb.insert( dInst.dst );
                pc_reg <= ppc;
                $display("Fetch: PC = %x, inst = %x, expanded = ", pc, inst, showInst(inst));
            end else begin
                $display("Fetch Stalled: PC = %x, inst = %x, expanded = ", pc, inst, showInst(inst));
            end
        end
    endrule

    rule doExecute(cop.started && memReady);
        // Unpack data from fetch to execute fifo
        Fetch2Execute f2e = f2eFifo.first;
        let pc = f2e.pc;
        let ppc = f2e.ppc;
        let dInst = f2e.dInst;
        let rVal1 = f2e.rVal1;
        let rVal2 = f2e.rVal2;
        let copVal = f2e.copVal;
        let instEpoch = f2e.instEpoch;
        f2eFifo.deq;

        if( instEpoch != executeEpoch ) begin
            // Kill instruction because it is from misprediction
            sb.remove();
            $display("Execute: Kill instruction");
        end else begin
            // Execute
            ExecInst eInst = exec(dInst, rVal1, rVal2, pc, ppc, copVal);
            if(eInst.iType == Unsupported) begin
                $fwrite(stderr, "Executing unsupported instruction at pc: %x. Exiting\n", pc);
                $finish;
            end

            // Memory
            if(eInst.iType == Ld) begin
                eInst.data <- dMem.req(MemReq{op: Ld, addr: eInst.addr, data: ?});
            end else if(eInst.iType == St) begin
                let d <- dMem.req(MemReq{op: St, addr: eInst.addr, data: eInst.data});
            end

            // Write Back
            if(isValid(eInst.dst) && validValue(eInst.dst).regType == Normal) begin
                rf.wr(validRegValue(eInst.dst), eInst.data);
            end
            sb.remove();
            cop.wr(eInst.dst, eInst.data);
            if( eInst.mispredict ) begin
                // Handle misprediction
                $display("Execute Mispredict: PC = %x", pc);
                redirectFifo.enq( Redirect{ pc: pc, nextPc: eInst.addr, brType: eInst.iType, taken: eInst.brTaken, mispredict: eInst.mispredict } );
                executeEpoch <= ! executeEpoch;
            end else begin
                $display("Execute: PC = %x", pc);
            end
        end
    endrule

    method ActionValue#(Tuple2#(RIndx, Data)) cpuToHost;
        let ret <- cop.cpuToHost;
        return ret;
    endmethod

    method Action hostToCpu(Bit#(32) startpc) if ( !cop.started && memReady );
        cop.start;
        pc_reg <= startpc;
    endmethod

    interface MemInit iMemInit = iMem.init;
    interface MemInit dMemInit = dMem.init;
endmodule

