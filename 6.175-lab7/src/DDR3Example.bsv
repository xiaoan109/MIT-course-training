import GetPut::*;
import ClientServer::*;
import Memory::*;

// other packages and type definitions

module mkProc(Proc);
    Fifo#(2, DDR3_Req)  ddr3ReqFifo  <- mkCFFifo;
    Fifo#(2, DDR3_Resp) ddr3RespFifo <- mkCFFifo;
    MemInitIFC ddr3InitIfc <- mkMemInitDDR3( ddr3ReqFifo );
    Bool memReady = ddr3InitIfc.done;

    // optional: easy to use wrapper and interfaces for ddr3 FIFOs
    WideMem wideMemWrapper <- mkWideMemFromDDR3( ddr3ReqFifo, ddr3RespFifo );
    Vector#(2, WideMem) wideMems <- mkSplitWideMem( wideMemWrapper );
    // Data cache should use wideMems[0]
    // Instruction cache should use wideMems[1]

    // lots of other code

    // This rule is needed for running the lab on the FPGA
    rule drainMemResponses( !cop.started );
        ddr3RespFifo.deq;
    endrule

    // other interface methods

    interface WideMemInitIfc memInit = ddr3InitIfc;
    interface DDR3_Client ddr3client = toGPClient( ddr3ReqFifo, ddr3RespFifo );
endmodule
