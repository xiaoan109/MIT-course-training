// FourCycle.bsv
//
// This is a four cycle implementation of the SMIPS processor.

import Types::*;
import ProcTypes::*;
import MemTypes::*;
import RFile::*;
import DelayedMemory::*;
import MemInit::*;
import Decode::*;
import Exec::*;
import Cop::*;
import Vector::*;
import Fifo::*;
import Ehr::*;

typedef enum {Fetch, Decode, Execute, WriteBack} Stage deriving (Bits, Eq, FShow);

(* synthesize *)
module mkProc(Proc);
    Reg#(Addr)     pc <- mkRegU;
    RFile          rf <- mkRFile;
    DelayedMemory mem <- mkDelayedMemory;
    Cop           cop <- mkCop;

    MemInitIfc dummyMemInit <- mkDummyMemInit;
    Bool memReady = mem.init.done() && dummyMemInit.done();


    // TODO: Complete the implementation of this processor


    method ActionValue#(Tuple2#(RIndx, Data)) cpuToHost;
        let ret <- cop.cpuToHost;
        return ret;
    endmethod

    method Action hostToCpu(Bit#(32) startpc) if ( !cop.started && memReady );
        cop.start;
        pc <= startpc;
    endmethod

    interface MemInit iMemInit = dummyMemInit;
    interface MemInit dMemInit = mem.init;
endmodule

