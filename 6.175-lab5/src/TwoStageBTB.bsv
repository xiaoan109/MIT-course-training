// TwoStageBTB.bsv
//
// This is a two stage pipelined implementation of the SMIPS processor with a BTB.

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
import Btb::*;

(* synthesize *)
module mkProc(Proc);
    Reg#(Addr) pc <- mkRegU;
    RFile      rf <- mkRFile;
    IMemory  iMem <- mkIMemory;
    DMemory  dMem <- mkDMemory;
    Cop       cop <- mkCop;
    Btb#(6,8) btb <- mkBtb;

    Bool memReady = iMem.init.done() && dMem.init.done();


    // TODO: Complete the implementation of this processor


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

