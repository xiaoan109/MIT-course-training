import Ehr::*;
import Vector::*;

//////////////////
// Fifo interface

interface Fifo#(numeric type n, type t);
    method Bool notFull;
    method Action enq(t x);
    method Bool notEmpty;
    method Action deq;
    method t first;
    method Action clear;
endinterface

/////////////////
// Conflict FIFO

module mkMyConflictFifo( Fifo#(n, t) ) provisos (Bits#(t,tSz));
    // n is size of fifo
    // t is data type of fifo
    Vector#(n, Reg#(t))     data     <- replicateM(mkRegU());
    Reg#(Bit#(TLog#(n)))    enqP     <- mkReg(0);
    Reg#(Bit#(TLog#(n)))    deqP     <- mkReg(0);
    Reg#(Bool)              empty    <- mkReg(True);
    Reg#(Bool)              full     <- mkReg(False);

    // useful value
    Bit#(TLog#(n))          max_index = fromInteger(valueOf(n)-1);

    // TODO: Implement all the methods for this module
    method Bool notFull = !full;

    method Action enq(t x) if(!full);
        data[enqP] <= x;
        let enqP_tmp = enqP == max_index ? 0 : enqP + 1;
        enqP <= enqP_tmp;
        empty <= False;
        if(enqP_tmp == deqP) begin
            full <= True;
        end
    endmethod

    method Bool notEmpty = !empty;

    method Action deq if(!empty);
        let deqP_tmp = deqP == max_index ? 0 : deqP + 1;
        deqP <= deqP_tmp;
        full <= False;
        if(enqP == deqP_tmp) begin
            empty <= True;
        end
    endmethod

    method t first if(!empty);
        return data[deqP];
    endmethod

    method Action clear;
        enqP <= 0;
        deqP <= 0;
        empty <= True;
        full <= False;
    endmethod

endmodule

/////////////////
// Pipeline FIFO

// Intended schedule:
//      {notEmpty, first, deq} < {notFull, enq} < clear
module mkMyPipelineFifo( Fifo#(n, t) ) provisos (Bits#(t,tSz));
    // n is size of fifo
    // t is data type of fifo
    Vector#(n, Reg#(t))        data     <- replicateM(mkRegU());
    Ehr#(3, Bit#(TLog#(n)))    enqP     <- mkEhr(0);
    Ehr#(3, Bit#(TLog#(n)))    deqP     <- mkEhr(0);
    Ehr#(3, Bool)              empty    <- mkEhr(True);
    Ehr#(3, Bool)              full     <- mkEhr(False);

    // useful value
    Bit#(TLog#(n))          max_index = fromInteger(valueOf(n)-1);

    // TODO: Implement all the methods for this module
    method Bool notFull = !full[1];

    method Action enq(t x) if(!full[1]);
        data[enqP[1]] <= x;
        let enqP_tmp = enqP[1] == max_index ? 0 : enqP[1] + 1;
        enqP[1] <= enqP_tmp;
        empty[1] <= False;
        if(enqP_tmp == deqP[1]) begin
            full[1] <= True;
        end
    endmethod

    method Bool notEmpty = !empty[0];

    method Action deq if(!empty[0]);
        let deqP_tmp = deqP[0] == max_index ? 0 : deqP[0] + 1;
        deqP[0] <= deqP_tmp;
        full[0] <= False;
        if(enqP[0] == deqP_tmp) begin
            empty[0] <= True;
        end
    endmethod

    method t first if(!empty[0]);
        return data[deqP[0]];
    endmethod

    method Action clear;
        enqP[2] <= 0;
        deqP[2] <= 0;
        empty[2] <= True;
        full[2] <= False;
    endmethod
endmodule

/////////////////////////////
// Bypass FIFO without clear

// Intended schedule:
//      {notFull, enq} < {notEmpty, first, deq} < clear
module mkMyBypassFifo( Fifo#(n, t) ) provisos (Bits#(t,tSz));
    // n is size of fifo
    // t is data type of fifo
    Vector#(n, Ehr#(3, t))     data     <- replicateM(mkEhrU());
    Ehr#(3, Bit#(TLog#(n)))    enqP     <- mkEhr(0);
    Ehr#(3, Bit#(TLog#(n)))    deqP     <- mkEhr(0);
    Ehr#(3, Bool)              empty    <- mkEhr(True);
    Ehr#(3, Bool)              full     <- mkEhr(False);

    // useful value
    Bit#(TLog#(n))          max_index = fromInteger(valueOf(n)-1);

    // TODO: Implement all the methods for this module
    method Bool notFull = !full[0];

    method Action enq(t x) if(!full[0]);
        data[enqP[0]][0] <= x;
        let enqP_tmp = enqP[0] == max_index ? 0 : enqP[0] + 1;
        enqP[0] <= enqP_tmp;
        empty[0] <= False;
        if(enqP_tmp == deqP[0]) begin
            full[0] <= True;
        end
    endmethod

    method Bool notEmpty = !empty[1];

    method Action deq if(!empty[1]);
        let deqP_tmp = deqP[1] == max_index ? 0 : deqP[1] + 1;
        deqP[1] <= deqP_tmp;
        full[1] <= False;
        if(enqP[1] == deqP_tmp) begin
            empty[1] <= True;
        end
    endmethod

    method t first if(!empty[1]);
        return data[deqP[1]][1];
    endmethod

    method Action clear;
        enqP[2] <= 0;
        deqP[2] <= 0;
        empty[2] <= True;
        full[2] <= False;
    endmethod
endmodule

//////////////////////
// Conflict free fifo

// Intended schedule:
//      {notFull, enq} CF {notEmpty, first, deq}
//      {notFull, enq, notEmpty, first, deq} < clear

// Just like the procedure for pipeline and bypass fifos, there is a procedure to get the desired conflict-free scheduling annotation using EHRs.

// 1.For each conflicting Action and ActionValue method that needs to be conflict-free with another method, add an EHR to represent a request to call that method.
//   If the method takes no arguments, the data type in the EHR should be Bool (True for a request, False for no request).
//   If the method takes one argument of type t, the data type in the EHR should be Maybe#(t) (tagged Valid x for a request with argument x, tagged Invalid for no request).
//   If the method takes arguments of type t1, t2, etc., the data type in the EHR should be Maybe#(TupleN#(t1,t2,...)).
// 2.Replace the actions in each conflicting Action and ActionValue method with a write to the newly added EHR corresponding to the method.
// 3.Create a canonicalize rule to take requests from the EHRs and perform the actions that used to be in each of the methods.
//   This canonicalize rule should fire at the end of each cycle after all of the other methods.
module mkMyCFFifo( Fifo#(n, t) ) provisos (Bits#(t,tSz));
    // n is size of fifo
    // t is data type of fifo
    Vector#(n, Reg#(t))        data     <- replicateM(mkRegU());
    Ehr#(2, Bit#(TLog#(n)))    enqP     <- mkEhr(0);
    Ehr#(2, Bit#(TLog#(n)))    deqP     <- mkEhr(0);
    Ehr#(2, Bool)              empty    <- mkEhr(True);
    Ehr#(2, Bool)              full     <- mkEhr(False);

    Ehr#(2, Maybe#(t))         enqReq   <- mkEhr(tagged Invalid);
    Ehr#(2, Bool)              deqReq   <- mkEhr(False);
    // Ehr#(2, Bool)              clearReq <- mkEhr(False);

    // useful value
    Bit#(TLog#(n))          max_index = fromInteger(valueOf(n)-1);

    // TODO: Implement all the methods for this module

    (* no_implicit_conditions *)
    (* fire_when_enabled *)
    rule canonicalize;
        let enqP_tmp = enqP[0];
        let deqP_tmp = deqP[0];
        // enq always update data and enqP
        if(isValid(enqReq[1]) && !full[0]) begin
            data[enqP[0]] <= fromMaybe(?, enqReq[1]);
            enqP_tmp = enqP[0] == max_index ? 0 : enqP[0] + 1;
            enqP[0] <= enqP_tmp;
        end
        // deq always update deqP
        if(deqReq[1] && !empty[0]) begin
            deqP_tmp = deqP[0] == max_index ? 0 : deqP[0] + 1;
            deqP[0] <= deqP_tmp;
        end
        // different comb of enq and deq change full and empty
        if(isValid(enqReq[1]) && !full[0]) begin
            empty[0] <= False;
            if(deqReq[1] && !empty[0]) begin
                full[0] <= False;
            end else if(enqP_tmp == deqP_tmp) begin
                full[0] <= True;
            end
        end else if(deqReq[1] && !empty[0]) begin
            full[0] <= False;
            if(isValid(enqReq[1]) && !full[0]) begin
                empty[0] <= False;
            end else if(enqP_tmp == deqP_tmp) begin
                empty[0] <= True;
            end
        end
        // clear the request
        enqReq[1] <= tagged Invalid;
        deqReq[1] <= False;
    endrule

    method Bool notFull = !full[0];

    method Action enq(t x) if(!full[0]);
        enqReq[0] <= tagged Valid x;
    endmethod

    method Bool notEmpty = !empty[0];

    method Action deq if(!empty[0]);
        deqReq[0] <= True;
    endmethod

    method t first if(!empty[0]);
        return data[deqP[0]];
    endmethod

    method Action clear;
       enqP[1] <= 0;
       deqP[1] <= 0;
       empty[1] <= True;
       full[1] <= False;
    endmethod
endmodule

