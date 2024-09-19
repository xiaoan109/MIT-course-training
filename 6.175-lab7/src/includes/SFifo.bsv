import Ehr::*;
import Vector::*;
import GetPut::*;

//////////////////
// SFifo interface 

interface SFifo#(numeric type n, type dt, type st);
    method Bool search(st x);
    method Bool notFull;
    method Action enq(dt x);
    method Bool notEmpty;
    method Action deq;
    method dt first;
    method Action clear;
endinterface

//////////////////
// Pipeline SFIFO

// deq < search < enq < clear
module mkPipelineSFifo( function Bool isFound(dt x, st y), SFifo#(n, dt, st) ifc ) provisos (Bits#(dt,dtSz));
    // n is size of the FIFO
    // dt is data type
    // st is search type
    Vector#(n, Reg#(dt))    data     <- replicateM(mkRegU());
    Ehr#(2, Bit#(TLog#(n))) enqP     <- mkEhr(0);
    Ehr#(2, Bit#(TLog#(n))) deqP     <- mkEhr(0);
    Ehr#(3, Bool)           empty    <- mkEhr(True);
    Ehr#(3, Bool)           full     <- mkEhr(False);
    Bit#(TLog#(n))          max_index = fromInteger(valueOf(n)-1);

    method Bool search(st x);
        // look between deqP[1] and enqP[0]
        Bool ret = False;
        Bool enqP_lt_deqP = enqP[0] < deqP[1];
        for( Integer i = 0 ; i < valueOf(n) ; i = i+1 ) begin
            Bool lt_enqP = fromInteger(i) < enqP[0];
            Bool gte_deqP = fromInteger(i) >= deqP[1];
            Bool is_match = isFound(data[i], x);
            if( full[1] || (enqP_lt_deqP && lt_enqP) || (enqP_lt_deqP && gte_deqP) || (lt_enqP && gte_deqP) ) begin
                // index i is valid
                if( is_match ) begin
                    ret = True;
                end
            end
        end
        return ret;
    endmethod

    method Bool notFull = !full[1];

    method Action enq(dt x) if( !full[1] );
        data[enqP[0]] <= x;
        empty[1] <= False;
        enqP[0] <= (enqP[0] == max_index) ? 0 : enqP[0] + 1;
        if( enqP[1] == deqP[1] ) begin
            full[1] <= True;
        end
    endmethod

    method Bool notEmpty = !empty[0];

    method Action deq if( !empty[0] );
        // Tell later stages a dequeue was requested
        full[0] <= False;
        deqP[0] <= (deqP[0] == max_index) ? 0 : deqP[0] + 1;
        if( deqP[1] == enqP[0] ) begin
            empty[0] <= True;
        end
    endmethod

    method dt first if( !empty[0] );
        return data[deqP[0]];
    endmethod

    method Action clear;
        enqP[1] <= 0;
        deqP[1] <= 0;
        empty[2] <= True;
        full[2] <= False;
    endmethod
endmodule

////////////////
// Bypass SFIFO

module mkBypassSFifo( function Bool isFound(dt x, st y), SFifo#(n, dt, st) ifc ) provisos (Bits#(dt,dtSz));
    // n is size of fifo
    // t is data type of fifo
    Vector#(n, Ehr#(2,dt))  data     <- replicateM(mkEhr(?));
    Ehr#(2, Bit#(TLog#(n))) enqP     <- mkEhr(0);
    Ehr#(2, Bit#(TLog#(n))) deqP     <- mkEhr(0);
    Ehr#(3, Bool)           empty    <- mkEhr(True);
    Ehr#(3, Bool)           full     <- mkEhr(False);
    Bit#(TLog#(n))          max_index = fromInteger(valueOf(n)-1);

    method Bool search(st x);
        // look between deqP[0] and enqP[0]
        Bool ret = False;
        Bool enqP_lt_deqP = enqP[0] < deqP[0];
        for( Integer i = 0 ; i < valueOf(n) ; i = i+1 ) begin
            Bool lt_enqP = fromInteger(i) < enqP[0];
            Bool gte_deqP = fromInteger(i) >= deqP[0];
            Bool is_match = isFound(data[i][0], x);
            if( full[0] || (enqP_lt_deqP && lt_enqP) || (enqP_lt_deqP && gte_deqP) || (lt_enqP && gte_deqP) ) begin
                // index i is valid
                if( is_match ) begin
                    ret = True;
                end
            end
        end
        return ret;
    endmethod

    method Bool notFull = !full[0];

    method Action enq(dt x) if( !full[0] );
        data[enqP[0]][0] <= x;
        empty[0] <= False;
        enqP[0] <= (enqP[0] == max_index) ? 0 : enqP[0] + 1;
        if( enqP[1] == deqP[0] ) begin
            full[0] <= True;
        end
    endmethod

    method Bool notEmpty = !empty[1];

    method Action deq if( !empty[1] );
        // Tell later stages a dequeue was requested
        full[1] <= False;
        deqP[0] <= (deqP[0] == max_index) ? 0 : deqP[0] + 1;
        if( deqP[1] == enqP[1] ) begin
            empty[1] <= True;
        end
    endmethod

    method dt first if( !empty[1] );
        return data[deqP[0]][1];
    endmethod

    method Action clear;
        enqP[1] <= 0;
        deqP[1] <= 0;
        empty[2] <= True;
        full[2] <= False;
    endmethod
endmodule

