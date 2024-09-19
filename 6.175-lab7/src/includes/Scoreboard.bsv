import SFifo::*;
import ProcTypes::*;

interface Scoreboard#(numeric type size);
    method Action insert(Maybe#(FullIndx) r);
    method Action remove;
    method Bool search1(Maybe#(FullIndx) r);
    method Bool search2(Maybe#(FullIndx) r);
    method Bool search3(Maybe#(FullIndx) r);
    method Action clear;
endinterface

function Bool isFound(Maybe#(FullIndx) x, Maybe#(FullIndx) k);
    if(x matches tagged Valid .xv &&& k matches tagged Valid .kv &&& kv == xv) begin
        return True;
    end else begin
        return False;
    end
endfunction

// search < insert < remove < clear
module mkBypassScoreboard(Scoreboard#(size));
    SFifo#(size, Maybe#(FullIndx), Maybe#(FullIndx))  f <- mkBypassSFifo(isFound);

    method insert = f.enq;

    method remove = f.deq;

    method search1 = f.search;
    method search2 = f.search;
    method search3 = f.search;

    method clear = f.clear;
endmodule

// remove < search < insert < clear
module mkPipelineScoreboard(Scoreboard#(size));
    SFifo#(size, Maybe#(FullIndx), Maybe#(FullIndx)) f <- mkPipelineSFifo(isFound);

    method insert = f.enq;

    method remove = f.deq;

    method search1 = f.search;
    method search2 = f.search;
    method search3 = f.search;

    method clear = f.clear;
endmodule

