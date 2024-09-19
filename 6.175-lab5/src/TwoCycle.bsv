// TwoCycle.bsv
//
// This is a two cycle implementation of the SMIPS processor.

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

typedef enum {Fetch, Execute} Stage deriving (Bits, Eq, FShow);

(* synthesize *)
module mkProc(Proc);
    Reg#(Addr) pc <- mkRegU;
    RFile      rf <- mkRFile;
    DMemory   mem <- mkDMemory;
    Cop       cop <- mkCop;

    Bool memReady = mem.init.done();


    // TODO: Complete the implementation of this processor


    method ActionValue#(Tuple2#(RIndx, Data)) cpuToHost;
        let ret <- cop.cpuToHost;
        return ret;
    endmethod

    method Action hostToCpu(Bit#(32) startpc) if ( !cop.started && memReady );
        cop.start;
        pc <= startpc;
    endmethod

    interface MemInit iMemInit = mem.init;
    interface MemInit dMemInit = mem.init;
endmodule

