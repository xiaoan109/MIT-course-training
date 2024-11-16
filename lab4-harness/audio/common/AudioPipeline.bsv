
import ClientServer::*;
import GetPut::*;

import AudioProcessorTypes::*;
import Chunker::*;
import FFT::*;
import FIRFilter::*;
import Splitter::*;
import FilterCoefficients::*;
import FixedPoint::*;
import OverSampler::*;
import Overlayer::*;
import ToFromMP::*;
import PitchAdjust::*;
import Vector::*;

(* synthesize *)
module mkAudioPipelineFIR(AudioProcessor);
    AudioProcessor fir <- mkFIRFilter(c);
    return fir;
endmodule

(* synthesize *)
module mkAudioPipelineFFT(FFT#(N, FixedPoint#(ISIZE, FSIZE)));
    FFT#(N, FixedPoint#(ISIZE, FSIZE)) fft <- mkFFT();
    return fft;
endmodule

(* synthesize *)
module mkAudioPipelineToMP(ToMP#(N, ISIZE, FSIZE, PSIZE));
    ToMP#(N, ISIZE, FSIZE, PSIZE) toMP <- mkToMP();
    return toMP;
endmodule

(* synthesize *)
module mkAudioPipelinePitchAdjust(SettablePitchAdjust#(N, ISIZE, FSIZE, PSIZE));
    SettablePitchAdjust#(N, ISIZE, FSIZE, PSIZE) pitchAdjust <- mkPitchAdjust(valueOf(S));
    return pitchAdjust;
endmodule

(* synthesize *)
module mkAudioPipelineFromMP(FromMP#(N, ISIZE, FSIZE, PSIZE));
    FromMP#(N, ISIZE, FSIZE, PSIZE) fromMP <- mkFromMP();
    return fromMP;
endmodule

(* synthesize *)
module mkAudioPipelineIFFT(FFT#(N, FixedPoint#(ISIZE, FSIZE)));
    FFT#(N, FixedPoint#(ISIZE, FSIZE)) ifft <- mkIFFT();
    return ifft;
endmodule

(* synthesize *)
module mkAudioPipeline(AudioProcessor);

    // AudioProcessor fir <- mkFIRFilter(c);
    AudioProcessor fir <- mkAudioPipelineFIR();
    Chunker#(S, Sample) chunker <- mkChunker();
    OverSampler#(S, N, Sample) overSampler <- mkOverSampler(replicate(0));

    // Polymorphic
    // FFT#(N, FixedPoint#(ISIZE, FSIZE)) fft <- mkFFT();
    // ToMP#(N, ISIZE, FSIZE, PSIZE) toMP <- mkToMP();
    // PitchAdjust#(N, ISIZE, FSIZE, PSIZE) pitchAdjust <- mkPitchAdjust(valueOf(S), fromInteger(valueOf(FACTOR)));
    // FromMP#(N, ISIZE, FSIZE, PSIZE) fromMP <- mkFromMP();
    // FFT#(N, FixedPoint#(ISIZE, FSIZE)) ifft <- mkIFFT();

    // Non-polymorphic wrapper
    FFT#(N, FixedPoint#(ISIZE, FSIZE)) fft <- mkAudioPipelineFFT();
    ToMP#(N, ISIZE, FSIZE, PSIZE) toMP <- mkAudioPipelineToMP();
    SettablePitchAdjust#(N, ISIZE, FSIZE, PSIZE) settablePitchAdjust <- mkAudioPipelinePitchAdjust();
    PitchAdjust#(N, ISIZE, FSIZE, PSIZE) pitchAdjust = settablePitchAdjust.adjust;
    FromMP#(N, ISIZE, FSIZE, PSIZE) fromMP <- mkAudioPipelineFromMP();
    FFT#(N, FixedPoint#(ISIZE, FSIZE)) ifft <- mkAudioPipelineIFFT();

    Overlayer#(N, S, Sample) overlayer <- mkOverlayer(replicate(0));
    Splitter#(S, Sample) splitter <- mkSplitter();

    rule fir_to_chunker (True);
        let x <- fir.getSampleOutput();
        chunker.request.put(x);
    endrule

    rule chunker_to_overSampler (True);
        let x <- chunker.response.get();
        overSampler.request.put(x);
    endrule

    rule overSampler_to_fft (True);
        let x <- overSampler.response.get();
        Vector#(N, ComplexSample) data = replicate(0);
        for(Integer i = 0; i < valueOf(N); i = i + 1) begin
            data[i] = tocmplx(x[i]);
        end
        fft.request.put(data);
    endrule

    rule fft_to_toMP (True);
        let x <- fft.response.get();
        toMP.request.put(x);
    endrule

    rule toMP_to_pitchAdjust (True);
        let x <- toMP.response.get();
        pitchAdjust.request.put(x);
    endrule

    rule pitchAdjust_to_fromMP (True);
        let x <- pitchAdjust.response.get();
        fromMP.request.put(x);
    endrule

    rule fromMP_to_ifft (True);
        let x <- fromMP.response.get();
        ifft.request.put(x);
    endrule

    rule ifft_to_overlayer (True);
        let x <- ifft.response.get();
        Vector#(N, Sample) data = replicate(0);
        for(Integer i = 0; i < valueOf(N); i = i + 1) begin
            data[i] = frcmplx(x[i]);
        end
        overlayer.request.put(data);
    endrule

    rule overlayer_to_splitter (True);
        let x <- overlayer.response.get();
        splitter.request.put(x);
    endrule
    
    method Action putSampleInput(Sample x);
        fir.putSampleInput(x);
    endmethod

    method ActionValue#(Sample) getSampleOutput();
        let x <- splitter.response.get();
        return x;
    endmethod

    method Action setFactor(FixedPoint#(ISIZE, FSIZE) x);
        settablePitchAdjust.setFactor.put(x);
    endmethod

endmodule

