
import Complex::*;
import FixedPoint::*;
import Reg6375::*;

export AudioProcessorTypes::*;
export Reg6375::*;

typedef 16 ISIZE;
typedef 16 FSIZE;
typedef 16 PSIZE;
typedef 8 N;
typedef 2 S;
typedef 2 FACTOR;

typedef Int#(ISIZE) Sample;

interface AudioProcessor;
    method Action putSampleInput(Sample in);
    method ActionValue#(Sample) getSampleOutput();
    method Action setFactor(FixedPoint#(ISIZE, FSIZE) factor);
endinterface


typedef Complex#(FixedPoint#(ISIZE, FSIZE)) ComplexSample;

// Turn a real Sample into a ComplexSample.
function ComplexSample tocmplx(Sample x);
    return cmplx(fromInt(x), 0);
endfunction

// Extract the real component from complex.
function Sample frcmplx(ComplexSample x);
    return unpack(truncate(x.rel.i));
endfunction


typedef 8 FFT_POINTS;
typedef TLog#(FFT_POINTS) FFT_LOG_POINTS;

