import ClientServer::*;
import FIFO::*;
import GetPut::*;
import DefaultValue::*;
import SceMi::*;
import Clocks::*;
import ResetXactor::*;
import Memory::*;
import RegFile::*;

import Types::*;
import ProcTypes::*;
import MemTypes::*;
import Connectable::*;

// Where to find mkProc
// PROCFILE is defined differently for each scemi build target
import `PROC_FILE::*;

typedef Proc DutInterface;
typedef Tuple2#(RIndx, Data) ToHost;
typedef Addr FromHost;

`ifdef DDR3
typedef DDR3_Client SceMiLayer;
`else
typedef Empty SceMiLayer;
`endif


(* synthesize *)
module [Module] mkDutWrapper (DutInterface);
    let m <- mkProc();
    return m;
endmodule

module [SceMiModule] mkSceMiLayer( SceMiLayer );

    SceMiClockConfiguration conf = defaultValue;

    SceMiClockPortIfc clk_port <- mkSceMiClockPort(conf);
    DutInterface dut <- buildDutWithSoftReset(mkDutWrapper, clk_port);

    Empty mem <- mkPutXactor(dut.memInit.request, clk_port);
    Empty tohost <- mkGetXactor(toGet(dut.cpuToHost), clk_port);
    Empty fromhost <- mkPutXactor(toPut(dut.hostToCpu), clk_port);

    Empty shutdown <- mkShutdownXactor();

`ifdef DDR3
    // cross ddr3 into uncontrolled domain
    let uclock <- sceMiGetUClock;
    let ureset <- sceMiGetUReset;
    SyncFIFOIfc#(DDR3_Req) reqFifo <- mkSyncFIFO(1, clk_port.cclock, clk_port.creset, uclock);
    SyncFIFOIfc#(DDR3_Resp) respFifo <- mkSyncFIFO(1, uclock, ureset, clk_port.cclock);
    let connect <- mkConnection( dut.ddr3client , toGPServer( reqFifo, respFifo ) );
    return toGPClient( reqFifo, respFifo );
`else
    RegFile#(Bit#(24),Bit#(512)) simMem <- mkRegFileFull( clocked_by clk_port.cclock, reset_by clk_port.creset );
    let memConnect <- mkConnection( clocked_by clk_port.cclock, reset_by clk_port.creset, dut.ddr3client, simMem );
`endif
endmodule

