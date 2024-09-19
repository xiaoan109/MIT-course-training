import Vector::*;
import Complex::*;
import Real::*;
import Randomizable::*;

import FftCommon::*;
import Fft::*;

module mkTestBench#(Fft fft)();
    let fft_comb <- mkFftCombinational;

    Vector#(FftPoints, Randomize#(Data)) randomVal1 <- replicateM(mkGenericRandomizer);
    Vector#(FftPoints, Randomize#(Data)) randomVal2 <- replicateM(mkGenericRandomizer);

    Reg#(Bool) init <- mkReg(False);
    Reg#(Bit#(32)) cycle_count <- mkReg(0);
    Reg#(Bit#(8)) stream_count <- mkReg(0);
    Reg#(Bit#(8)) feed_count <- mkReg(0);

    rule initialize(init == False);
        for (Integer i = 0; i < fftPoints; i = i + 1 ) begin
            randomVal1[i].cntrl.init;
            randomVal2[i].cntrl.init;
        end
        init <= True;
    endrule

    rule feed(feed_count < 128 && init);
        Vector#(FftPoints, ComplexData) d;
        for (Integer i = 0; i < fftPoints; i = i + 1 ) begin
            let rv <- randomVal1[i].next;
            let iv <- randomVal2[i].next;
            d[i] = cmplx(rv, iv);
        end
        fft_comb.enq(d);
        fft.enq(d);
        feed_count <= feed_count + 1;
    endrule

    rule stream(init);
        stream_count <= stream_count + 1;
        let rc <- fft_comb.deq;
        let rf <- fft.deq;
        if ( rc != rf ) begin
            $display("FAILED!");
            for (Integer i = 0; i < fftPoints; i = i + 1) begin
                $display ("\t(%x, %x) != (%x, %x)", rc[i].rel, rc[i].img, rf[i].rel, rf[i].img);
            end
            $finish;
        end
    endrule

    rule pass (stream_count == 128 && init);
        $display("PASSED");
        $finish;
    endrule

    rule timeout(init);
        if( cycle_count == 128 * 128 * 128 ) begin
            $display("FAILED: Only saw %0d out of 128 outputs after %0d cycles", stream_count, cycle_count);
            $finish;
        end
        cycle_count <= cycle_count + 1;
    endrule
endmodule

(* synthesize *)
module mkTbFftFolded();
    let fft <- mkFftFolded;
    mkTestBench(fft);
endmodule

(* synthesize *)
module mkTbFftInelasticPipeline();
    let fft <- mkFftInelasticPipeline;
    mkTestBench(fft);
endmodule

(* synthesize *)
module mkTbFftElasticPipeline();
    let fft <- mkFftElasticPipeline;
    mkTestBench(fft);
endmodule

(* synthesize *)
module mkTbFftSuperFolded();
    let fft <- mkFftSuperFolded4;
    mkTestBench(fft);
endmodule
