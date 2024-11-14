
import ClientServer::*;
import FIFO::*;
import GetPut::*;

import FixedPoint::*;
import Vector::*;

import ComplexMP::*;


typedef Server#(
    Vector#(nbins, ComplexMP#(isize, fsize, psize)),
    Vector#(nbins, ComplexMP#(isize, fsize, psize))
) PitchAdjust#(numeric type nbins, numeric type isize, numeric type fsize, numeric type psize);


// s - the amount each window is shifted from the previous window.
//
// factor - the amount to adjust the pitch.
//  1.0 makes no change. 2.0 goes up an octave, 0.5 goes down an octave, etc...
module mkPitchAdjust(Integer s, FixedPoint#(isize, fsize) factor, PitchAdjust#(nbins, isize, fsize, psize) ifc) provisos (Add#(a__, psize, TAdd#(isize, isize)), Add#(psize, b__, isize));
    
    // TODO: implement this module 
    FIFO#(Vector#(nbins, ComplexMP#(isize, fsize, psize))) infifo <- mkFIFO();
    FIFO#(Vector#(nbins, ComplexMP#(isize, fsize, psize))) outfifo <- mkFIFO();

    rule comb_pitch;
        //Local Vars: NEED INITIALIZE
        Vector#(nbins, Phase#(psize)) inphases = replicate(0);
        Vector#(nbins, Phase#(psize)) outphases =  replicate(0);
        Vector#(nbins, ComplexMP#(isize, fsize, psize)) in = replicate(cmplxmp(0, 0));
        Vector#(nbins, ComplexMP#(isize, fsize, psize)) out = replicate(cmplxmp(0, 0));
        in = infifo.first();
        infifo.deq();
        for(Integer i = 0; i < valueOf(nbins); i = i + 1) begin
            FixedPoint#(isize, fsize) mag = in[i].magnitude;
            Phase#(psize) phase = in[i].phase;
            Phase#(psize) dphase = phase - inphases[i];
            inphases[i] = phase;
            FixedPoint#(isize, fsize) dphase_f = fromInt(dphase);

            // Int#(isize) bin = fromInteger(i) * fxptGetInt(factor); // TODO: fixed point mult
            // Int#(isize) nbin = fromInteger(i + 1) * fxptGetInt(factor);
            Int#(isize) bin = fxptGetInt(fromInteger(i) * factor);  // Assume using * will not cause overflow
            Int#(isize) nbin = fxptGetInt(fromInteger(i + 1) * factor);

            if (nbin != bin && bin >= 0 && bin < fromInteger(valueOf(nbins))) begin
                Phase#(psize) shifted = truncate(fxptGetInt(fxptMult(dphase_f, factor))); // Assume psize is less than 2*isize
                outphases[bin] = outphases[bin] + shifted;
                out[bin] = cmplxmp(mag, outphases[bin]);
            end
        end
        outfifo.enq(out);
    endrule

    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);
endmodule

