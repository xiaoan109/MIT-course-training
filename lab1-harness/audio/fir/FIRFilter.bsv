
import FIFO::*;
import FixedPoint::*;
import Vector::*;

import AudioProcessorTypes::*;
import FilterCoefficients::*;
import Multiplier::*;

module mkFIRFilter (AudioProcessor);

    FIFO#(Sample) infifo <- mkFIFO();
    FIFO#(Sample) outfifo <- mkFIFO();

    // 8-tap filter
    Vector#(8, Reg#(Sample)) r <- replicateM(mkReg(0));

    // 9 Multiplier
    Vector#(9, Multiplier) multiplier <- replicateM(mkMultiplier);

    rule mult;
        Sample sample = infifo.first();
        infifo.deq();
        r[0] <= sample;
         for(Integer i = 0; i < 7; i = i + 1) begin
             r[i+1] <= r[i];
        end
        multiplier[0].putOperands(c[0], sample);
        for(Integer i = 0; i < 8; i = i + 1) begin
             multiplier[i+1].putOperands(c[i+1], r[i]);
        end
    endrule

    rule acc;
        FixedPoint#(16, 16) acc_res = 0;
        for(Integer i = 0; i < 9; i = i + 1) begin
            FixedPoint#(16, 16) x <- multiplier[i].getResult();
            acc_res = acc_res + x;
        end
        outfifo.enq(fxptGetInt(acc_res));
    endrule

    method Action putSampleInput(Sample in);
        infifo.enq(in);
    endmethod

    method ActionValue#(Sample) getSampleOutput();
        outfifo.deq();
        return outfifo.first();
    endmethod

endmodule