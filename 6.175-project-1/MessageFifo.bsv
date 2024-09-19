import CacheTypes::*;
import Fifo::*;

module mkMessageFifo(MessageFifo#(n));
    // TODO: implement message FIFO


    method Action enq_resp( CacheMemResp d );
    endmethod

    method Action enq_req( CacheMemReq d );
    endmethod
    
    method Bool hasResp = False;
    method Bool hasReq = False;
    method Bool notEmpty = False;
    
    method CacheMemMessage first;
        return unpack(0);
    endmethod
    
    method Action deq if( False );
    endmethod
endmodule

