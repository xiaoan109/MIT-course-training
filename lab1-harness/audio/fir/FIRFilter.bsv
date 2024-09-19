import FIFO::*;
import FixedPoint::*;

import AudioProcessorTypes :: *;
import FilterCoefficients::*;

module mkFIRFilter(AudioProcessor);
    FIFO#(Sample) infifo <- mkFIFO();
    FIFO#(Sample) outfifo <- mkFIFO();

    Reg#(Sample) r0 <- mkReg(0);
    Reg#(Sample) r1 <- mkReg(0);
    Reg#(Sample) r2 <- mkReg(0);
    Reg#(Sample) r3 <- mkReg(0);
    Reg#(Sample) r4 <- mkReg(0);
    Reg#(Sample) r5 <- mkReg(0);
    Reg#(Sample) r6 <- mkReg(0);
    Reg#(Sample) r7 <- mkReg(0);

    rule process (True);
        Sample sample = infifo.first();
        infifo.deq();

        r0 <= sample;
        r1 <= r0;
        r2 <= r1;
        r3 <= r2;
        r4 <= r3;
        r5 <= r4;
        r6 <= r5;
        r7 <= r6;
        
        FixedPoint#(16,16) accumulate = 
                c[0] * fromInt(sample)
            +   c[1] * fromInt(r0)
            +   c[2] * fromInt(r1)
            +   c[3] * fromInt(r2)
            +   c[4] * fromInt(r3)
            +   c[5] * fromInt(r4)
            +   c[6] * fromInt(r5)
            +   c[7] * fromInt(r6)
            +   c[8] * fromInt(r7);
        
        outfifo.enq(fxptGetInt(accumulate));
    endrule

    method Action putSampleInput(Sample in);
        infifo.enq(in);
    endmethod

    method ActionValue#(Sample) getSampleOutput();
        outfifo.deq();
        return outfifo.first();
    endmethod
endmodule