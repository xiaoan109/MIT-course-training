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
    Reg#(StageIdx) k <- mkReg(0);
    Reg#(Vector#(FftPoints, ComplexData)) sReg <- mkRegU();

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
            let y = bfly[i].bfly4(twid, x);

            for(FftIdx j = 0; j < 4; j = j + 1 ) begin
                stage_temp[idx+j] = y[j];
            end
        end

        stage_out = permute(stage_temp);

        return stage_out;
    endfunction

    rule doFft;
        //TODO: Implement the rest of this module
        let n = fromInteger(valueOf(NumStages));
        //BUG: Why is it wrong? -> Some conflict? Maybe the function stage_f's input is not the same at different if-else cases, so it consider a multi-driven?
        //Solve: 1. If replace stage_f(k, inFifo.first/sReg) as stage_f(k, sxIn) and write let sxIn = k == 0 ? inFifo.first : sReg;, this will work..., wierd!
        //Solve: 2. Add (* split *) to the if-else
        // (* split *)
        let sxIn = k == 0 ? inFifo.first : sReg;
        if(k == 0) begin
            inFifo.deq;
            sReg <= stage_f(k, sxIn);
        end else if(k == n - 1) begin
            outFifo.enq(stage_f(k, sxIn));
        end else begin
            sReg <= stage_f(k, sxIn);
        end

        // This works, shown in the lecture

        // let sxIn = ?;
        // if (k == 0) begin
        //     inFifo.deq;
        //     sxIn = inFifo.first;
        // end else begin
        //     sxIn = sReg;
        // end
        // let sxOut = stage_f(k, sxIn);
        // if(k == n - 1) begin
        //     outFifo.enq(sxOut);
        // end else begin
        //     sReg <= sxOut;
        // end
        k <= (k == n - 1) ? 0 : k + 1;
    endrule

    // Another way, just like (* split *) added

    // rule foldedEntry if (k==0); 
    //     sReg <= stage_f(k, inFifo.first()); k <= k+1;
    //     inFifo.deq();   
    // endrule
    // rule foldedCirculate if (k!=0 && k<2);                          
    //     sReg <= stage_f(k, sReg);  k <= k+1;
    // endrule
    // rule foldedExit if (k==2);                          
    //     outFifo.enq(stage_f(k, sReg));  k <= 0;
    // endrule


    method Action enq(Vector#(FftPoints, ComplexData) in) if( inFifo.notFull );
        inFifo.enq(in);
    endmethod

    method ActionValue#(Vector#(FftPoints, ComplexData)) deq if( outFifo.notEmpty );
        outFifo.deq;
        return outFifo.first;
    endmethod
endmodule

typedef union tagged {void Valid; void Invalid;} Validbit deriving (Eq, Bits);

(* synthesize *)
module mkFftInelasticPipeline(Fft);
    Fifo#(2,Vector#(FftPoints, ComplexData)) inFifo <- mkCFFifo;
    Fifo#(2,Vector#(FftPoints, ComplexData)) outFifo <- mkCFFifo;
    Vector#(3, Vector#(16, Bfly4)) bfly <- replicateM(replicateM(mkBfly4));

    Reg#(Vector#(FftPoints, ComplexData)) sReg0 <- mkRegU();
    Reg#(Vector#(FftPoints, ComplexData)) sReg1 <- mkRegU();
    Reg#(Validbit) sReg0v <- mkReg(Invalid);
    Reg#(Validbit) sReg1v <- mkReg(Invalid);

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
        //TODO: Implement the rest of this module

        //What if outFifo is full and sReg1v == Valid, but sReg0v == Invalid ?
        //Like backpress every pipe at the same time.
        // if(outFifo.notFull || sReg1v == Invalid) begin
        //     if(inFifo.notEmpty) begin    
        //         inFifo.deq;
        //         sReg0 <= stage_f(0, inFifo.first);
        //         sReg0v <= Valid;
        //     end else begin
        //         sReg0v <= Invalid;
        //     end
        //     sReg1 <= stage_f(1, sReg0);
        //     sReg1v <= sReg0v;
        //     if(sReg1v == Valid) outFifo.enq(stage_f(2, sReg1));
        // end

        // Add sReg0v == Invalid to avoid above issue
        let sReg1Rdy = outFifo.notFull || sReg1v == Invalid;
        let sReg0Rdy = sReg1Rdy || sReg0v == Invalid;
        if(sReg0Rdy) begin
            if(inFifo.notEmpty) begin    
                inFifo.deq;
                sReg0 <= stage_f(0, inFifo.first);
                sReg0v <= Valid;
            end else begin
                sReg0v <= Invalid;
            end
        end
        if(sReg1Rdy) begin
            sReg1 <= stage_f(1, sReg0);
            sReg1v <= sReg0v;
            if(sReg1v == Valid) outFifo.enq(stage_f(2, sReg1));
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
module mkFftElasticPipeline(Fft);
    Fifo#(2,Vector#(FftPoints, ComplexData)) inFifo <- mkCFFifo;
    Fifo#(2,Vector#(FftPoints, ComplexData)) outFifo <- mkCFFifo;
    Vector#(3, Vector#(16, Bfly4)) bfly <- replicateM(replicateM(mkBfly4));

    Fifo#(2,Vector#(FftPoints, ComplexData)) fifo0 <- mkCFFifo;
    Fifo#(2,Vector#(FftPoints, ComplexData)) fifo1 <- mkCFFifo;

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

    //TODO: Implement the rest of this module
    // You should use more than one rule
    rule stage0;
        inFifo.deq;
        fifo0.enq(stage_f(0, inFifo.first));
    endrule

    rule stage1;
        fifo0.deq;
        fifo1.enq(stage_f(1, fifo0.first));
    endrule

    rule stage2;
        fifo1.deq;
        outFifo.enq(stage_f(2, fifo1.first));
    endrule

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

typedef Bit#(TLog#(TMul#(NumStages, BflysPerStage))) StageIdxExt; //3 * 16 = 48

module mkFftSuperFolded(SuperFoldedFft#(radix)) provisos(Div#(TDiv#(FftPoints, 4), radix, times), Mul#(radix, times, TDiv#(FftPoints, 4)));
    Fifo#(2,Vector#(FftPoints, ComplexData)) inFifo <- mkCFFifo;
    Fifo#(2,Vector#(FftPoints, ComplexData)) outFifo <- mkCFFifo;
    Vector#(radix, Bfly4) bfly <- replicateM(mkBfly4);

    Reg#(Vector#(FftPoints, ComplexData)) sReg <- mkRegU();
    Reg#(StageIdxExt) k <- mkReg(0);
    let r = fromInteger(valueOf(radix));

    
    function Vector#(FftPoints, ComplexData) stage_f(StageIdxExt stage, Vector#(FftPoints, ComplexData) stage_in);
        Vector#(FftPoints, ComplexData) stage_temp, stage_out;
        let stage0 = stage / (fromInteger(valueOf(BflysPerStage)) / r); //outer loop
        let stage1 = stage % (fromInteger(valueOf(BflysPerStage)) / r); //inner loop
        
        stage_temp = stage_in;
        for(StageIdxExt i = 0 ; i < r; i = i + 1) begin
            let idx = (stage1 * r + i) * 4;
            Vector#(4, ComplexData) x;
            Vector#(4, ComplexData) twid;
            for (StageIdxExt j = 0; j < 4; j = j + 1 ) begin
                x[j] = stage_in[idx+j];
                twid[j] = getTwiddle(stage0[2:0], idx+j);
            end
            let y = bfly[i].bfly4(twid, x);
            for(StageIdxExt j = 0; j < 4; j = j + 1 ) begin
                stage_temp[idx+j] = y[j];
            end

            if(stage1 == 16 / r -1) begin 
                stage_out = permute(stage_temp);
            end else begin
                stage_out = stage_temp;
            end
        end
        return stage_out;
    endfunction

    rule doFft;
        //TODO: Implement the rest of this module
        let n = fromInteger(valueOf(TMul#(NumStages, BflysPerStage))) / r;
        let sxIn = k == 0 ? inFifo.first : sReg;
        if(k == 0) begin
            inFifo.deq;
            sReg <= stage_f(k, sxIn);
        end else if(k == n - 1) begin
            outFifo.enq(stage_f(k, sxIn));
        end else begin
            sReg <= stage_f(k, sxIn);
        end
        k <= (k == n - 1) ? 0 : k + 1;
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
