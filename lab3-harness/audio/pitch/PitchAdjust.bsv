
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

    // sequential implementation
    Reg#(Bit#(TAdd#(TLog#(nbins), 1))) i <- mkReg(fromInteger(valueOf(nbins)) + 1);

    Reg#(Vector#(nbins, ComplexMP#(isize, fsize, psize))) in <- mkReg(replicate(cmplxmp(0, 0)));
    Reg#(Vector#(nbins, ComplexMP#(isize, fsize, psize))) out <- mkReg(replicate(cmplxmp(0, 0)));

    Reg#(Vector#(nbins, Phase#(psize))) inphases <- mkReg(replicate(0));
    Reg#(Vector#(nbins, Phase#(psize))) outphases <- mkReg(replicate(0));
    // Both work because of no double write.
    // Vector#(nbins, Reg#(Phase#(psize))) inphases <- replicateM(mkReg(0)); // static double inphases[N] = {0};
    // Vector#(nbins, Reg#(Phase#(psize))) outphases <- replicateM(mkReg(0)); // static double outphases[N] = {0};

    Reg#(FixedPoint#(isize, fsize)) bin <- mkReg(0);

    rule seq_pitch;
        if(i == fromInteger(valueOf(nbins)) + 1) begin
            in <= infifo.first();
            infifo.deq();
            i <= 0;
            out <= replicate(cmplxmp(0, 0));
            bin <= 0;
        end else if(i == fromInteger(valueOf(nbins))) begin
            outfifo.enq(out);
            i <= i + 1;
        end else begin
            FixedPoint#(isize, fsize) mag = in[i].magnitude;
            Phase#(psize) phase = in[i].phase;
            Phase#(psize) dphase = phase - inphases[i];
            inphases[i] <= phase;
            FixedPoint#(isize, fsize) dphase_f = fromInt(dphase);

            FixedPoint#(isize, fsize) nbin = bin + factor;
            Int#(isize) bin_int = fxptGetInt(bin);
            Int#(isize) nbin_int = fxptGetInt(nbin);
            if (nbin_int != bin_int && bin_int >= 0 && bin_int < fromInteger(valueOf(nbins))) begin
                Phase#(psize) shifted = truncate(fxptGetInt(fxptMult(dphase_f, factor))); // Assume psize is less than 2*isize
                Phase#(psize) newphase = outphases[bin_int] + shifted;
                outphases[bin_int] <= newphase;
                out[bin_int] <= cmplxmp(mag, newphase);
            end
            i <= i + 1;
            bin <= nbin;
        end
    endrule






    // combinational implementation
    // rule comb_pitch;
    //     //Local Vars: NEED INITIALIZE
    //     Vector#(nbins, Phase#(psize)) inphases = replicate(0);
    //     Vector#(nbins, Phase#(psize)) outphases =  replicate(0);
    //     Vector#(nbins, ComplexMP#(isize, fsize, psize)) in = replicate(cmplxmp(0, 0));
    //     Vector#(nbins, ComplexMP#(isize, fsize, psize)) out = replicate(cmplxmp(0, 0));
    //     in = infifo.first();
    //     infifo.deq();
    //     for(Integer i = 0; i < valueOf(nbins); i = i + 1) begin
    //         FixedPoint#(isize, fsize) mag = in[i].magnitude;
    //         Phase#(psize) phase = in[i].phase;
    //         Phase#(psize) dphase = phase - inphases[i];
    //         inphases[i] = phase;
    //         FixedPoint#(isize, fsize) dphase_f = fromInt(dphase);

    //         // Int#(isize) bin = fromInteger(i) * fxptGetInt(factor); // TODO: fixed point mult
    //         // Int#(isize) nbin = fromInteger(i + 1) * fxptGetInt(factor);
    //         Int#(isize) bin = fxptGetInt(fromInteger(i) * factor);  // Assume using * will not cause overflow
    //         Int#(isize) nbin = fxptGetInt(fromInteger(i + 1) * factor);

    //         if (nbin != bin && bin >= 0 && bin < fromInteger(valueOf(nbins))) begin
    //             Phase#(psize) shifted = truncate(fxptGetInt(fxptMult(dphase_f, factor))); // Assume psize is less than 2*isize
    //             outphases[bin] = outphases[bin] + shifted;
    //             out[bin] = cmplxmp(mag, outphases[bin]);
    //         end
    //     end
    //     outfifo.enq(out);
    // endrule

    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);
endmodule

