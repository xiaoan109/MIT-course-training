import Vector::*;
import Complex::*;

import FftCommon::*;
import Fifo::*;

interface Fft;
    method Action enq(Vector#(FftPoints, ComplexData) in);
    method ActionValue#(Vector#(FftPoints, ComplexData)) deq;
endinterface

(* synthesize *)
module mkFftCombinational(Fft);
    Fifo#(2,Vector#(FftPoints, ComplexData)) inFifo <- mkCFFifo;
    Fifo#(2,Vector#(FftPoints, ComplexData)) outFifo <- mkCFFifo;
    Vector#(NumStages, Vector#(BflysPerStage, Bfly4)) bfly <- replicateM(replicateM(mkBfly4));

    function Vector#(FftPoints, ComplexData) stage_f(StageIdx stage, Vector#(FftPoints, ComplexData) stage_in);
        Vector#(FftPoints, ComplexData) stage_temp, stage_out;
        for (FftIdx i = 0; i < fromInteger(valueOf(BflysPerStage)); i = i + 1)  begin
            FftIdx idx = i * 4;
            Vector#(4, ComplexData) x;
            Vector#(4, ComplexData) twid;
            for (FftIdx j = 0; j < 4; j = j + 1 ) begin
                x[j] = stage_in[idx+j];
                twid[j] = getTwiddle(stage, idx+j);
            end
            let y = bfly[stage][i].bfly4(twid, x);

            for(FftIdx j = 0; j < 4; j = j + 1 ) begin
                stage_temp[idx+j] = y[j];
            end
        end

        stage_out = permute(stage_temp);

        return stage_out;
    endfunction
  
    rule doFft;
        if( inFifo.notEmpty && outFifo.notFull ) begin
            inFifo.deq;
            Vector#(4, Vector#(FftPoints, ComplexData)) stage_data;
            stage_data[0] = inFifo.first;
      
            for (StageIdx stage = 0; stage < 3; stage = stage + 1) begin
                stage_data[stage+1] = stage_f(stage, stage_data[stage]);
            end
            outFifo.enq(stage_data[3]);
        end
    endrule
    
    method Action enq(Vector#(FftPoints, ComplexData) in);
        inFifo.enq(in);
    endmethod
  
    method ActionValue#(Vector#(FftPoints, ComplexData)) deq;
        outFifo.deq;
        return outFifo.first;
    endmethod
endmodule

(* synthesize *)
module mkFftFolded(Fft);
    Fifo#(2,Vector#(FftPoints, ComplexData)) inFifo <- mkCFFifo;
    Fifo#(2,Vector#(FftPoints, ComplexData)) outFifo <- mkCFFifo;
    Vector#(16, Bfly4) bfly <- replicateM(mkBfly4);

    rule doFft;
        //TODO: Implement the rest of this module
    endrule

    method Action enq(Vector#(FftPoints, ComplexData) in) if( inFifo.notFull );
        inFifo.enq(in);
    endmethod
  
    method ActionValue#(Vector#(FftPoints, ComplexData)) deq if( outFifo.notEmpty );
        outFifo.deq;
        return outFifo.first;
    endmethod
endmodule

(* synthesize *)
module mkFftInelasticPipeline(Fft);
    Fifo#(2,Vector#(FftPoints, ComplexData)) inFifo <- mkCFFifo;
    Fifo#(2,Vector#(FftPoints, ComplexData)) outFifo <- mkCFFifo;
    Vector#(3, Vector#(16, Bfly4)) bfly <- replicateM(replicateM(mkBfly4));

    rule doFft;
        //TODO: Implement the rest of this module
    endrule

    method Action enq(Vector#(FftPoints, ComplexData) in);
        inFifo.enq(in);
    endmethod
  
    method ActionValue#(Vector#(FftPoints, ComplexData)) deq;
        outFifo.deq;
        return outFifo.first;
    endmethod
endmodule

(* synthesize *)
module mkFftElasticPipeline(Fft);
    Fifo#(2,Vector#(FftPoints, ComplexData)) inFifo <- mkCFFifo;
    Fifo#(2,Vector#(FftPoints, ComplexData)) outFifo <- mkCFFifo;
    Vector#(3, Vector#(16, Bfly4)) bfly <- replicateM(replicateM(mkBfly4));

    //TODO: Implement the rest of this module
    // You should use more than one rule

    method Action enq(Vector#(FftPoints, ComplexData) in);
        inFifo.enq(in);
    endmethod
  
    method ActionValue#(Vector#(FftPoints, ComplexData)) deq;
        outFifo.deq;
        return outFifo.first;
    endmethod
endmodule

interface SuperFoldedFft#(numeric type radix);
    method ActionValue#(Vector#(FftPoints, ComplexData)) deq;
    method Action enq(Vector#(FftPoints, ComplexData) in);
endinterface

module mkFftSuperFolded(SuperFoldedFft#(radix)) provisos(Div#(TDiv#(FftPoints, 4), radix, times), Mul#(radix, times, TDiv#(FftPoints, 4)));
    Fifo#(2,Vector#(FftPoints, ComplexData)) inFifo <- mkCFFifo;
    Fifo#(2,Vector#(FftPoints, ComplexData)) outFifo <- mkCFFifo;
    Vector#(radix, Bfly4) bfly <- replicateM(mkBfly4);

    rule doFft;
        //TODO: Implement the rest of this module
    endrule

    method Action enq(Vector#(FftPoints, ComplexData) in);
        inFifo.enq(in);
    endmethod
  
    method ActionValue#(Vector#(FftPoints, ComplexData)) deq;
        outFifo.deq;
        return outFifo.first;
    endmethod
endmodule

function Fft getFft(SuperFoldedFft#(radix) f);
    return (interface Fft;
        method enq = f.enq;
        method deq = f.deq;
    endinterface);
endfunction

(* synthesize *)
module mkFftSuperFolded4(Fft);
    SuperFoldedFft#(4) sfFft <- mkFftSuperFolded;
    return (getFft(sfFft));
endmodule
