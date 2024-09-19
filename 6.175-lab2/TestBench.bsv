import TestBenchTemplates::*;
import Multipliers::*;

// Example testbenches
(* synthesize *)
module mkTbDumb();
    function Bit#(16) test_function( Bit#(8) a, Bit#(8) b ) = multiply_unsigned( a, b );
    Empty tb <- mkTbMulFunction(test_function, multiply_unsigned, True);
    return tb;
endmodule

(* synthesize *)
module mkTbFoldedMultiplier();
    Multiplier#(8) dut <- mkFoldedMultiplier();
    Empty tb <- mkTbMulModule(dut, multiply_signed, True);
    return tb;
endmodule

(* synthesize *)
module mkTbSignedVsUnsigned();
    // TODO: Implement test bench for Exercise 1
endmodule

(* synthesize *)
module mkTbEx3();
    // TODO: Implement test bench for Exercise 3
endmodule

(* synthesize *)
module mkTbEx5();
    // TODO: Implement test bench for Exercise 5
endmodule

(* synthesize *)
module mkTbEx7a();
    // TODO: Implement test bench for Exercise 7
endmodule

(* synthesize *)
module mkTbEx7b();
    // TODO: Implement test bench for Exercise 7
endmodule

(* synthesize *)
module mkTbEx9a();
    // TODO: Implement test bench for Exercise 9
endmodule

(* synthesize *)
module mkTbEx9b();
    // TODO: Implement test bench for Exercise 9
endmodule

