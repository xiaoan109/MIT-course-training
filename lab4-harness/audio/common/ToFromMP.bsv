
import ClientServer::*;
import FIFO::*;
import GetPut::*;
import Vector::*;
import Complex::*;
import FixedPoint::*;
import ComplexMP::*;
import Cordic::*;

typedef Server#(
    Vector#(nbins, Complex#(FixedPoint#(isize, fsize))),
    Vector#(nbins, ComplexMP#(isize, fsize, psize))
) ToMP#(numeric type nbins, numeric type isize, numeric type fsize, numeric type psize);

typedef Server#(
    Vector#(nbins, ComplexMP#(isize, fsize, psize)),
    Vector#(nbins, Complex#(FixedPoint#(isize, fsize)))
) FromMP#(numeric type nbins, numeric type isize, numeric type fsize, numeric type psize);

module mkToMP(ToMP#(nbins, isize, fsize, psize));

    FIFO#(Vector#(nbins, Complex#(FixedPoint#(isize, fsize)))) infifo <- mkFIFO();
    FIFO#(Vector#(nbins, ComplexMP#(isize, fsize, psize))) outfifo <- mkFIFO();

    Vector#(nbins, ToMagnitudePhase#(isize, fsize, psize)) cordicToMP <- replicateM(mkCordicToMagnitudePhase());

    //Can not put the two rules together in one.
    rule putCordic;
        for(Integer i = 0; i < valueOf(nbins); i = i + 1) begin
            cordicToMP[i].request.put(infifo.first[i]);
        end
        infifo.deq();
    endrule

    rule getCordic;
        Vector#(nbins, ComplexMP#(isize, fsize, psize)) data = replicate(cmplxmp(0, 0));
        for(Integer i = 0; i < valueOf(nbins); i = i + 1) begin
            data[i] <- cordicToMP[i].response.get();
        end
        outfifo.enq(data);
    endrule

    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);
endmodule

module mkFromMP(FromMP#(nbins, isize, fsize, psize));

    FIFO#(Vector#(nbins, ComplexMP#(isize, fsize, psize))) infifo <- mkFIFO();
    FIFO#(Vector#(nbins, Complex#(FixedPoint#(isize, fsize)))) outfifo <- mkFIFO();

    Vector#(nbins, FromMagnitudePhase#(isize, fsize, psize)) cordicFromMP <- replicateM(mkCordicFromMagnitudePhase());

    rule putCordic;
        for(Integer i = 0; i < valueOf(nbins); i = i + 1) begin
            cordicFromMP[i].request.put(infifo.first[i]);
        end
        infifo.deq();
    endrule

    rule getCordic;
        Vector#(nbins, Complex#(FixedPoint#(isize, fsize))) data = replicate(0);
        for(Integer i = 0; i < valueOf(nbins); i = i + 1) begin
            data[i] <- cordicFromMP[i].response.get();
        end
        outfifo.enq(data);
    endrule

    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);
endmodule