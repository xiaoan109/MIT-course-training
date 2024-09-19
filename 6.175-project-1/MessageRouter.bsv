import Vector::*;

import CacheTypes::*;
import MessageFifo::*;

module mkMessageRouter(  Vector#(NumCaches,MessageFifo#(n)) c2r,
                         Vector#(NumCaches,MessageFifo#(n)) r2c,
                         MessageFifo#(n) m2r,
                         MessageFifo#(n) r2m,
                         Empty ifc );
    // TODO: implement message router
    // you can assume that NumCaches is 2
endmodule

