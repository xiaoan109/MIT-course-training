//
// Generated by Bluespec Compiler, version 2023.01 (build 52adafa5)
//
// On Wed Sep 25 07:59:51 UTC 2024
//
//
// Ports:
// Name                         I/O  size props
// RDY_putSampleInput             O     1 reg
// getSampleOutput                O    16 reg
// RDY_getSampleOutput            O     1 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// putSampleInput_in              I    16 reg
// EN_putSampleInput              I     1
// EN_getSampleOutput             I     1
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkFIRFilter(CLK,
		   RST_N,

		   putSampleInput_in,
		   EN_putSampleInput,
		   RDY_putSampleInput,

		   EN_getSampleOutput,
		   getSampleOutput,
		   RDY_getSampleOutput);
  input  CLK;
  input  RST_N;

  // action method putSampleInput
  input  [15 : 0] putSampleInput_in;
  input  EN_putSampleInput;
  output RDY_putSampleInput;

  // actionvalue method getSampleOutput
  input  EN_getSampleOutput;
  output [15 : 0] getSampleOutput;
  output RDY_getSampleOutput;

  // signals for module outputs
  wire [15 : 0] getSampleOutput;
  wire RDY_getSampleOutput, RDY_putSampleInput;

  // register r_0
  reg [15 : 0] r_0;
  wire [15 : 0] r_0$D_IN;
  wire r_0$EN;

  // register r_1
  reg [15 : 0] r_1;
  wire [15 : 0] r_1$D_IN;
  wire r_1$EN;

  // register r_2
  reg [15 : 0] r_2;
  wire [15 : 0] r_2$D_IN;
  wire r_2$EN;

  // register r_3
  reg [15 : 0] r_3;
  wire [15 : 0] r_3$D_IN;
  wire r_3$EN;

  // register r_4
  reg [15 : 0] r_4;
  wire [15 : 0] r_4$D_IN;
  wire r_4$EN;

  // register r_5
  reg [15 : 0] r_5;
  wire [15 : 0] r_5$D_IN;
  wire r_5$EN;

  // register r_6
  reg [15 : 0] r_6;
  wire [15 : 0] r_6$D_IN;
  wire r_6$EN;

  // register r_7
  reg [15 : 0] r_7;
  wire [15 : 0] r_7$D_IN;
  wire r_7$EN;

  // ports of submodule infifo
  wire [15 : 0] infifo$D_IN, infifo$D_OUT;
  wire infifo$CLR, infifo$DEQ, infifo$EMPTY_N, infifo$ENQ, infifo$FULL_N;

  // ports of submodule multiplier_0
  wire [31 : 0] multiplier_0$getResult, multiplier_0$putOperands_coeff;
  wire [15 : 0] multiplier_0$putOperands_samp;
  wire multiplier_0$EN_getResult,
       multiplier_0$EN_putOperands,
       multiplier_0$RDY_getResult,
       multiplier_0$RDY_putOperands;

  // ports of submodule multiplier_1
  wire [31 : 0] multiplier_1$getResult, multiplier_1$putOperands_coeff;
  wire [15 : 0] multiplier_1$putOperands_samp;
  wire multiplier_1$EN_getResult,
       multiplier_1$EN_putOperands,
       multiplier_1$RDY_getResult,
       multiplier_1$RDY_putOperands;

  // ports of submodule multiplier_2
  wire [31 : 0] multiplier_2$getResult, multiplier_2$putOperands_coeff;
  wire [15 : 0] multiplier_2$putOperands_samp;
  wire multiplier_2$EN_getResult,
       multiplier_2$EN_putOperands,
       multiplier_2$RDY_getResult,
       multiplier_2$RDY_putOperands;

  // ports of submodule multiplier_3
  wire [31 : 0] multiplier_3$getResult, multiplier_3$putOperands_coeff;
  wire [15 : 0] multiplier_3$putOperands_samp;
  wire multiplier_3$EN_getResult,
       multiplier_3$EN_putOperands,
       multiplier_3$RDY_getResult,
       multiplier_3$RDY_putOperands;

  // ports of submodule multiplier_4
  wire [31 : 0] multiplier_4$getResult, multiplier_4$putOperands_coeff;
  wire [15 : 0] multiplier_4$putOperands_samp;
  wire multiplier_4$EN_getResult,
       multiplier_4$EN_putOperands,
       multiplier_4$RDY_getResult,
       multiplier_4$RDY_putOperands;

  // ports of submodule multiplier_5
  wire [31 : 0] multiplier_5$getResult, multiplier_5$putOperands_coeff;
  wire [15 : 0] multiplier_5$putOperands_samp;
  wire multiplier_5$EN_getResult,
       multiplier_5$EN_putOperands,
       multiplier_5$RDY_getResult,
       multiplier_5$RDY_putOperands;

  // ports of submodule multiplier_6
  wire [31 : 0] multiplier_6$getResult, multiplier_6$putOperands_coeff;
  wire [15 : 0] multiplier_6$putOperands_samp;
  wire multiplier_6$EN_getResult,
       multiplier_6$EN_putOperands,
       multiplier_6$RDY_getResult,
       multiplier_6$RDY_putOperands;

  // ports of submodule multiplier_7
  wire [31 : 0] multiplier_7$getResult, multiplier_7$putOperands_coeff;
  wire [15 : 0] multiplier_7$putOperands_samp;
  wire multiplier_7$EN_getResult,
       multiplier_7$EN_putOperands,
       multiplier_7$RDY_getResult,
       multiplier_7$RDY_putOperands;

  // ports of submodule multiplier_8
  wire [31 : 0] multiplier_8$getResult, multiplier_8$putOperands_coeff;
  wire [15 : 0] multiplier_8$putOperands_samp;
  wire multiplier_8$EN_getResult,
       multiplier_8$EN_putOperands,
       multiplier_8$RDY_getResult,
       multiplier_8$RDY_putOperands;

  // ports of submodule outfifo
  wire [15 : 0] outfifo$D_IN, outfifo$D_OUT;
  wire outfifo$CLR, outfifo$DEQ, outfifo$EMPTY_N, outfifo$ENQ, outfifo$FULL_N;

  // rule scheduling signals
  wire CAN_FIRE_RL_acc,
       CAN_FIRE_RL_mult,
       CAN_FIRE_getSampleOutput,
       CAN_FIRE_putSampleInput,
       WILL_FIRE_RL_acc,
       WILL_FIRE_RL_mult,
       WILL_FIRE_getSampleOutput,
       WILL_FIRE_putSampleInput;

  // remaining internal signals
  wire [31 : 0] x__h5397,
		x__h5459,
		x__h5521,
		x__h5583,
		x__h5645,
		x__h5707,
		x__h5769,
		x__h5831;
  wire multiplier_3_RDY_getResult__2_AND_multiplier_4_ETC___d44,
       multiplier_3_RDY_putOperands_AND_multiplier_4__ETC___d16;

  // action method putSampleInput
  assign RDY_putSampleInput = infifo$FULL_N ;
  assign CAN_FIRE_putSampleInput = infifo$FULL_N ;
  assign WILL_FIRE_putSampleInput = EN_putSampleInput ;

  // actionvalue method getSampleOutput
  assign getSampleOutput = outfifo$D_OUT ;
  assign RDY_getSampleOutput = outfifo$EMPTY_N ;
  assign CAN_FIRE_getSampleOutput = outfifo$EMPTY_N ;
  assign WILL_FIRE_getSampleOutput = EN_getSampleOutput ;

  // submodule infifo
  FIFO2 #(.width(32'd16), .guarded(1'd1)) infifo(.RST(RST_N),
						 .CLK(CLK),
						 .D_IN(infifo$D_IN),
						 .ENQ(infifo$ENQ),
						 .DEQ(infifo$DEQ),
						 .CLR(infifo$CLR),
						 .D_OUT(infifo$D_OUT),
						 .FULL_N(infifo$FULL_N),
						 .EMPTY_N(infifo$EMPTY_N));

  // submodule multiplier_0
  mkMultiplier multiplier_0(.CLK(CLK),
			    .RST_N(RST_N),
			    .putOperands_coeff(multiplier_0$putOperands_coeff),
			    .putOperands_samp(multiplier_0$putOperands_samp),
			    .EN_putOperands(multiplier_0$EN_putOperands),
			    .EN_getResult(multiplier_0$EN_getResult),
			    .RDY_putOperands(multiplier_0$RDY_putOperands),
			    .getResult(multiplier_0$getResult),
			    .RDY_getResult(multiplier_0$RDY_getResult));

  // submodule multiplier_1
  mkMultiplier multiplier_1(.CLK(CLK),
			    .RST_N(RST_N),
			    .putOperands_coeff(multiplier_1$putOperands_coeff),
			    .putOperands_samp(multiplier_1$putOperands_samp),
			    .EN_putOperands(multiplier_1$EN_putOperands),
			    .EN_getResult(multiplier_1$EN_getResult),
			    .RDY_putOperands(multiplier_1$RDY_putOperands),
			    .getResult(multiplier_1$getResult),
			    .RDY_getResult(multiplier_1$RDY_getResult));

  // submodule multiplier_2
  mkMultiplier multiplier_2(.CLK(CLK),
			    .RST_N(RST_N),
			    .putOperands_coeff(multiplier_2$putOperands_coeff),
			    .putOperands_samp(multiplier_2$putOperands_samp),
			    .EN_putOperands(multiplier_2$EN_putOperands),
			    .EN_getResult(multiplier_2$EN_getResult),
			    .RDY_putOperands(multiplier_2$RDY_putOperands),
			    .getResult(multiplier_2$getResult),
			    .RDY_getResult(multiplier_2$RDY_getResult));

  // submodule multiplier_3
  mkMultiplier multiplier_3(.CLK(CLK),
			    .RST_N(RST_N),
			    .putOperands_coeff(multiplier_3$putOperands_coeff),
			    .putOperands_samp(multiplier_3$putOperands_samp),
			    .EN_putOperands(multiplier_3$EN_putOperands),
			    .EN_getResult(multiplier_3$EN_getResult),
			    .RDY_putOperands(multiplier_3$RDY_putOperands),
			    .getResult(multiplier_3$getResult),
			    .RDY_getResult(multiplier_3$RDY_getResult));

  // submodule multiplier_4
  mkMultiplier multiplier_4(.CLK(CLK),
			    .RST_N(RST_N),
			    .putOperands_coeff(multiplier_4$putOperands_coeff),
			    .putOperands_samp(multiplier_4$putOperands_samp),
			    .EN_putOperands(multiplier_4$EN_putOperands),
			    .EN_getResult(multiplier_4$EN_getResult),
			    .RDY_putOperands(multiplier_4$RDY_putOperands),
			    .getResult(multiplier_4$getResult),
			    .RDY_getResult(multiplier_4$RDY_getResult));

  // submodule multiplier_5
  mkMultiplier multiplier_5(.CLK(CLK),
			    .RST_N(RST_N),
			    .putOperands_coeff(multiplier_5$putOperands_coeff),
			    .putOperands_samp(multiplier_5$putOperands_samp),
			    .EN_putOperands(multiplier_5$EN_putOperands),
			    .EN_getResult(multiplier_5$EN_getResult),
			    .RDY_putOperands(multiplier_5$RDY_putOperands),
			    .getResult(multiplier_5$getResult),
			    .RDY_getResult(multiplier_5$RDY_getResult));

  // submodule multiplier_6
  mkMultiplier multiplier_6(.CLK(CLK),
			    .RST_N(RST_N),
			    .putOperands_coeff(multiplier_6$putOperands_coeff),
			    .putOperands_samp(multiplier_6$putOperands_samp),
			    .EN_putOperands(multiplier_6$EN_putOperands),
			    .EN_getResult(multiplier_6$EN_getResult),
			    .RDY_putOperands(multiplier_6$RDY_putOperands),
			    .getResult(multiplier_6$getResult),
			    .RDY_getResult(multiplier_6$RDY_getResult));

  // submodule multiplier_7
  mkMultiplier multiplier_7(.CLK(CLK),
			    .RST_N(RST_N),
			    .putOperands_coeff(multiplier_7$putOperands_coeff),
			    .putOperands_samp(multiplier_7$putOperands_samp),
			    .EN_putOperands(multiplier_7$EN_putOperands),
			    .EN_getResult(multiplier_7$EN_getResult),
			    .RDY_putOperands(multiplier_7$RDY_putOperands),
			    .getResult(multiplier_7$getResult),
			    .RDY_getResult(multiplier_7$RDY_getResult));

  // submodule multiplier_8
  mkMultiplier multiplier_8(.CLK(CLK),
			    .RST_N(RST_N),
			    .putOperands_coeff(multiplier_8$putOperands_coeff),
			    .putOperands_samp(multiplier_8$putOperands_samp),
			    .EN_putOperands(multiplier_8$EN_putOperands),
			    .EN_getResult(multiplier_8$EN_getResult),
			    .RDY_putOperands(multiplier_8$RDY_putOperands),
			    .getResult(multiplier_8$getResult),
			    .RDY_getResult(multiplier_8$RDY_getResult));

  // submodule outfifo
  FIFO2 #(.width(32'd16), .guarded(1'd1)) outfifo(.RST(RST_N),
						  .CLK(CLK),
						  .D_IN(outfifo$D_IN),
						  .ENQ(outfifo$ENQ),
						  .DEQ(outfifo$DEQ),
						  .CLR(outfifo$CLR),
						  .D_OUT(outfifo$D_OUT),
						  .FULL_N(outfifo$FULL_N),
						  .EMPTY_N(outfifo$EMPTY_N));

  // rule RL_mult
  assign CAN_FIRE_RL_mult =
	     multiplier_0$RDY_putOperands && multiplier_1$RDY_putOperands &&
	     multiplier_2$RDY_putOperands &&
	     multiplier_3_RDY_putOperands_AND_multiplier_4__ETC___d16 ;
  assign WILL_FIRE_RL_mult = CAN_FIRE_RL_mult ;

  // rule RL_acc
  assign CAN_FIRE_RL_acc =
	     multiplier_0$RDY_getResult && multiplier_1$RDY_getResult &&
	     multiplier_2$RDY_getResult &&
	     multiplier_3_RDY_getResult__2_AND_multiplier_4_ETC___d44 ;
  assign WILL_FIRE_RL_acc = CAN_FIRE_RL_acc ;

  // register r_0
  assign r_0$D_IN = infifo$D_OUT ;
  assign r_0$EN = CAN_FIRE_RL_mult ;

  // register r_1
  assign r_1$D_IN = r_0 ;
  assign r_1$EN = CAN_FIRE_RL_mult ;

  // register r_2
  assign r_2$D_IN = r_1 ;
  assign r_2$EN = CAN_FIRE_RL_mult ;

  // register r_3
  assign r_3$D_IN = r_2 ;
  assign r_3$EN = CAN_FIRE_RL_mult ;

  // register r_4
  assign r_4$D_IN = r_3 ;
  assign r_4$EN = CAN_FIRE_RL_mult ;

  // register r_5
  assign r_5$D_IN = r_4 ;
  assign r_5$EN = CAN_FIRE_RL_mult ;

  // register r_6
  assign r_6$D_IN = r_5 ;
  assign r_6$EN = CAN_FIRE_RL_mult ;

  // register r_7
  assign r_7$D_IN = r_6 ;
  assign r_7$EN = CAN_FIRE_RL_mult ;

  // submodule infifo
  assign infifo$D_IN = putSampleInput_in ;
  assign infifo$ENQ = EN_putSampleInput ;
  assign infifo$DEQ = CAN_FIRE_RL_mult ;
  assign infifo$CLR = 1'b0 ;

  // submodule multiplier_0
  assign multiplier_0$putOperands_coeff = 32'hFFFFFCD3 ;
  assign multiplier_0$putOperands_samp = infifo$D_OUT ;
  assign multiplier_0$EN_putOperands = CAN_FIRE_RL_mult ;
  assign multiplier_0$EN_getResult = CAN_FIRE_RL_acc ;

  // submodule multiplier_1
  assign multiplier_1$putOperands_coeff = 32'd0 ;
  assign multiplier_1$putOperands_samp = r_0 ;
  assign multiplier_1$EN_putOperands = CAN_FIRE_RL_mult ;
  assign multiplier_1$EN_getResult = CAN_FIRE_RL_acc ;

  // submodule multiplier_2
  assign multiplier_2$putOperands_coeff = 32'hFFFFFC98 ;
  assign multiplier_2$putOperands_samp = r_1 ;
  assign multiplier_2$EN_putOperands = CAN_FIRE_RL_mult ;
  assign multiplier_2$EN_getResult = CAN_FIRE_RL_acc ;

  // submodule multiplier_3
  assign multiplier_3$putOperands_coeff = 32'd0 ;
  assign multiplier_3$putOperands_samp = r_2 ;
  assign multiplier_3$EN_putOperands = CAN_FIRE_RL_mult ;
  assign multiplier_3$EN_getResult = CAN_FIRE_RL_acc ;

  // submodule multiplier_4
  assign multiplier_4$putOperands_coeff = 32'd53615 ;
  assign multiplier_4$putOperands_samp = r_3 ;
  assign multiplier_4$EN_putOperands = CAN_FIRE_RL_mult ;
  assign multiplier_4$EN_getResult = CAN_FIRE_RL_acc ;

  // submodule multiplier_5
  assign multiplier_5$putOperands_coeff = 32'd0 ;
  assign multiplier_5$putOperands_samp = r_4 ;
  assign multiplier_5$EN_putOperands = CAN_FIRE_RL_mult ;
  assign multiplier_5$EN_getResult = CAN_FIRE_RL_acc ;

  // submodule multiplier_6
  assign multiplier_6$putOperands_coeff = 32'hFFFFFC98 ;
  assign multiplier_6$putOperands_samp = r_5 ;
  assign multiplier_6$EN_putOperands = CAN_FIRE_RL_mult ;
  assign multiplier_6$EN_getResult = CAN_FIRE_RL_acc ;

  // submodule multiplier_7
  assign multiplier_7$putOperands_coeff = 32'd0 ;
  assign multiplier_7$putOperands_samp = r_6 ;
  assign multiplier_7$EN_putOperands = CAN_FIRE_RL_mult ;
  assign multiplier_7$EN_getResult = CAN_FIRE_RL_acc ;

  // submodule multiplier_8
  assign multiplier_8$putOperands_coeff = 32'hFFFFFCD3 ;
  assign multiplier_8$putOperands_samp = r_7 ;
  assign multiplier_8$EN_putOperands = CAN_FIRE_RL_mult ;
  assign multiplier_8$EN_getResult = CAN_FIRE_RL_acc ;

  // submodule outfifo
  assign outfifo$D_IN = x__h5831[31:16] ;
  assign outfifo$ENQ = CAN_FIRE_RL_acc ;
  assign outfifo$DEQ = EN_getSampleOutput ;
  assign outfifo$CLR = 1'b0 ;

  // remaining internal signals
  assign multiplier_3_RDY_getResult__2_AND_multiplier_4_ETC___d44 =
	     multiplier_3$RDY_getResult && multiplier_4$RDY_getResult &&
	     multiplier_5$RDY_getResult &&
	     multiplier_6$RDY_getResult &&
	     multiplier_7$RDY_getResult &&
	     multiplier_8$RDY_getResult &&
	     outfifo$FULL_N ;
  assign multiplier_3_RDY_putOperands_AND_multiplier_4__ETC___d16 =
	     multiplier_3$RDY_putOperands && multiplier_4$RDY_putOperands &&
	     multiplier_5$RDY_putOperands &&
	     multiplier_6$RDY_putOperands &&
	     multiplier_7$RDY_putOperands &&
	     multiplier_8$RDY_putOperands &&
	     infifo$EMPTY_N ;
  assign x__h5397 = multiplier_0$getResult + multiplier_1$getResult ;
  assign x__h5459 = x__h5397 + multiplier_2$getResult ;
  assign x__h5521 = x__h5459 + multiplier_3$getResult ;
  assign x__h5583 = x__h5521 + multiplier_4$getResult ;
  assign x__h5645 = x__h5583 + multiplier_5$getResult ;
  assign x__h5707 = x__h5645 + multiplier_6$getResult ;
  assign x__h5769 = x__h5707 + multiplier_7$getResult ;
  assign x__h5831 = x__h5769 + multiplier_8$getResult ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        r_0 <= `BSV_ASSIGNMENT_DELAY 16'd0;
	r_1 <= `BSV_ASSIGNMENT_DELAY 16'd0;
	r_2 <= `BSV_ASSIGNMENT_DELAY 16'd0;
	r_3 <= `BSV_ASSIGNMENT_DELAY 16'd0;
	r_4 <= `BSV_ASSIGNMENT_DELAY 16'd0;
	r_5 <= `BSV_ASSIGNMENT_DELAY 16'd0;
	r_6 <= `BSV_ASSIGNMENT_DELAY 16'd0;
	r_7 <= `BSV_ASSIGNMENT_DELAY 16'd0;
      end
    else
      begin
        if (r_0$EN) r_0 <= `BSV_ASSIGNMENT_DELAY r_0$D_IN;
	if (r_1$EN) r_1 <= `BSV_ASSIGNMENT_DELAY r_1$D_IN;
	if (r_2$EN) r_2 <= `BSV_ASSIGNMENT_DELAY r_2$D_IN;
	if (r_3$EN) r_3 <= `BSV_ASSIGNMENT_DELAY r_3$D_IN;
	if (r_4$EN) r_4 <= `BSV_ASSIGNMENT_DELAY r_4$D_IN;
	if (r_5$EN) r_5 <= `BSV_ASSIGNMENT_DELAY r_5$D_IN;
	if (r_6$EN) r_6 <= `BSV_ASSIGNMENT_DELAY r_6$D_IN;
	if (r_7$EN) r_7 <= `BSV_ASSIGNMENT_DELAY r_7$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    r_0 = 16'hAAAA;
    r_1 = 16'hAAAA;
    r_2 = 16'hAAAA;
    r_3 = 16'hAAAA;
    r_4 = 16'hAAAA;
    r_5 = 16'hAAAA;
    r_6 = 16'hAAAA;
    r_7 = 16'hAAAA;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // mkFIRFilter

