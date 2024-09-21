import TestBenchTemplates::*;
import Multipliers::*;

// Example testbenches
(* synthesize *)
module mkTbDumb();
    function Bit#(16) test_function( Bit#(8) a, Bit#(8) b ) = multiply_unsigned( a, b );
    // Discussion Question 2: remove above line 7
    // Error: "TestBench.bsv", line 8, column 17: (T0035)
    //   Bit vector of unknown size introduced near this location.
    //   Please remove unnecessary extensions, truncations and concatenations and/or
    //   provide more type information to resolve this ambiguity
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
    function Bit#(16) test_function( Bit#(8) a, Bit#(8) b ) = multiply_signed( a, b );
    Empty tb <- mkTbMulFunction(test_function, multiply_unsigned, True);
    return tb;
endmodule

(* synthesize *)
module mkTbEx3();
    // TODO: Implement test bench for Exercise 3
    Bool isUnsign = True;
    // Bool isUnsign = False;
    function Bit#(16) test_function( Bit#(8) a, Bit#(8) b ) = multiply_by_adding( a, b , isUnsign);
    Empty tb;
    if(isUnsign) begin
        tb <- mkTbMulFunction(test_function, multiply_unsigned, True);
    end else begin
        tb <- mkTbMulFunction(test_function, multiply_signed, True);
    end
    return tb;
endmodule

(* synthesize *)
module mkTbEx5();
    // TODO: Implement test bench for Exercise 5
    Bool isUnsign = True;
    Multiplier#(8) dut <- mkFoldedMultiplier();
    function Bit#(16) ref_function( Bit#(8) a, Bit#(8) b ) = multiply_by_adding( a, b , isUnsign);
    Empty tb <- mkTbMulModule(dut, ref_function, True);
    return tb;
endmodule

(* synthesize *)
module mkTbEx7a();
    // TODO: Implement test bench for Exercise 7
    Bool isUnsign = False;
    Multiplier#(8) dut <- mkBoothMultiplier();
    function Bit#(16) ref_function( Bit#(8) a, Bit#(8) b ) = multiply_by_adding( a, b , isUnsign);
    Empty tb <- mkTbMulModule(dut, ref_function, True);
    return tb;
endmodule

(* synthesize *)
module mkTbEx7b();
    // TODO: Implement test bench for Exercise 7
    Bool isUnsign = False;
    Multiplier#(16) dut <- mkBoothMultiplier();
    function Bit#(32) ref_function( Bit#(16) a, Bit#(16) b ) = multiply_by_adding( a, b , isUnsign);
    Empty tb <- mkTbMulModule(dut, ref_function, True);
    return tb;
endmodule

(* synthesize *)
module mkTbEx9a();
    // TODO: Implement test bench for Exercise 9
    Bool isUnsign = False;
    Multiplier#(8) dut <- mkBoothMultiplierRadix4();
    function Bit#(16) ref_function( Bit#(8) a, Bit#(8) b ) = multiply_by_adding( a, b , isUnsign);
    Empty tb <- mkTbMulModule(dut, ref_function, True);
    return tb;
endmodule

(* synthesize *)
module mkTbEx9b();
    // TODO: Implement test bench for Exercise 9
    Bool isUnsign = False;
    Multiplier#(32) dut <- mkBoothMultiplierRadix4();
    function Bit#(64) ref_function( Bit#(32) a, Bit#(32) b ) = multiply_by_adding( a, b , isUnsign);
    Empty tb <- mkTbMulModule(dut, ref_function, True);
    return tb;
endmodule

