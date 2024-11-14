
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


typedef 16 ISIZE;
typedef 16 FSIZE;
typedef 16 PSIZE;
typedef 8 N;
typedef 2 S;
typedef 2 FACTOR;

module mkAudioPipeline(AudioProcessor);

    AudioProcessor fir <- mkFIRFilter(c);
    Chunker#(S, Sample) chunker <- mkChunker();
    OverSampler#(S, N, Sample) overSampler <- mkOverSampler(replicate(0));
    FFT#(N, FixedPoint#(ISIZE, FSIZE)) fft <- mkFFT();
    ToMP#(N, ISIZE, FSIZE, PSIZE) toMP <- mkToMP();
    PitchAdjust#(N, ISIZE, FSIZE, PSIZE) pitchAdjust <- mkPitchAdjust(valueOf(S), fromInteger(valueOf(FACTOR)));
    FromMP#(N, ISIZE, FSIZE, PSIZE) fromMP <- mkFromMP();
    FFT#(N, FixedPoint#(ISIZE, FSIZE)) ifft <- mkIFFT();
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

endmodule

