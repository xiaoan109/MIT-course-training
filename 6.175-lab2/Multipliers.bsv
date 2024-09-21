// Reference functions that use Bluespec's '*' operator
function Bit#(TAdd#(n,n)) multiply_unsigned( Bit#(n) a, Bit#(n) b );
    UInt#(n) a_uint = unpack(a);
    UInt#(n) b_uint = unpack(b);
    UInt#(TAdd#(n,n)) product_uint = zeroExtend(a_uint) * zeroExtend(b_uint);
    return pack( product_uint );
endfunction

function Bit#(TAdd#(n,n)) multiply_signed( Bit#(n) a, Bit#(n) b );
    Int#(n) a_int = unpack(a);
    Int#(n) b_int = unpack(b);
    Int#(TAdd#(n,n)) product_int = signExtend(a_int) * signExtend(b_int);
    return pack( product_int );
endfunction



// Multiplication by repeated addition
function Bit#(TAdd#(n,n)) multiply_by_adding( Bit#(n) a, Bit#(n) b, Bool isUnsign);
    // TODO: Implement this function in Exercise 2
    // return 0;
    Integer valn = valueOf(n);
    if(a==0 || b==0) begin
        return 0;
    end else if(isUnsign == True) begin
        Bit#(n) tp = 0;
        Bit#(n) prod = 0;
        for(Integer i=0; i<valn; i=i+1) begin
            Bit#(n) m = (a[i] == 0) ? 0 : b;
            Bit#(TAdd#(n,1)) sum = zeroExtend(tp) + zeroExtend(m);
            prod[i] = sum[0];
            tp = sum[valn:1];
        end
        return {tp, prod};
    end else begin
        Bit#(TSub#(n,1)) a_complement = (a[valn-1]==0) ? a[valn-2:0] : ~a[valn-2:0]+1;
        Bit#(TSub#(n,1)) b_complement = (b[valn-1]==0) ? b[valn-2:0] : ~b[valn-2:0]+1;
        Bit#(2) signBits = {a[valn-1] ^ b[valn-1], a[valn-1] ^ b[valn-1]};
        Bit#(TSub#(TAdd#(n,n),2)) mult_tmp = multiply_by_adding(a_complement, b_complement, True);
        Bit#(TSub#(TAdd#(n,n),2)) mult_complement = ((a[valn-1] ^ b[valn-1]) == 0) ?  mult_tmp : ~mult_tmp+1;
        Bit#(TAdd#(n,n)) mult_result = {signBits, mult_complement};
        return mult_result;
    end
endfunction



// Multiplier Interface
interface Multiplier#( numeric type n );
    method Bool start_ready();
    method Action start( Bit#(n) a, Bit#(n) b );
    method Bool result_ready();
    method ActionValue#(Bit#(TAdd#(n,n))) result();
endinterface

// Folded multiplier by repeated addition
module mkFoldedMultiplier( Multiplier#(n) ) provisos(Add#(1, a__, n));
    // You can use these registers or create your own if you want
    Reg#(Bit#(n)) a <- mkRegU();
    Reg#(Bit#(n)) b <- mkRegU();
    Reg#(Bit#(n)) prod <- mkRegU();
    Reg#(Bit#(n)) tp <- mkRegU();
    Reg#(Bit#(TAdd#(TLog#(n),1))) i <- mkReg( fromInteger(valueOf(n)+1) );

    rule mulStep(i < fromInteger(valueOf(n)));
        // TODO: Implement this in Exercise 4
        // Can you implement it without using a variable-shift bit shifter? Without using dynamic bit selection? 
        // (In other words, can you avoid shifting or bit selection by a value stored in a register?)
        // Bit#(n) m = (a[i] == 0 ) ? 0 : b;
        Bit#(n) m = (a[0] == 0 ) ? 0 : b;
        a <= a >> 1;
        Bit#(TAdd#(n,1)) sum = zeroExtend(tp) + zeroExtend(m);
        // prod[i] <= sum[0];
        prod <= {sum[0], prod[valueOf(n)-1:1]};
        tp <= sum[valueOf(n):1];
        i <= i + 1;
    endrule

    method Bool start_ready();
        // TODO: Implement this in Exercise 4
        return i == fromInteger(valueOf(n)) + 1;
    endmethod

    method Action start( Bit#(n) aIn, Bit#(n) bIn );
        // TODO: Implement this in Exercise 4
        a <= aIn;
        b <= bIn;
        prod <= 0;
        tp <= 0;
        i <= 0;
    endmethod

    method Bool result_ready();
        // TODO: Implement this in Exercise 4
        return i == fromInteger(valueOf(n));
    endmethod

    method ActionValue#(Bit#(TAdd#(n,n))) result();
        // TODO: Implement this in Exercise 4
        i <= i + 1;
        return {tp, prod};
    endmethod
endmodule



// Booth Multiplier
module mkBoothMultiplier( Multiplier#(n) );
    Reg#(Bit#(TAdd#(TAdd#(n,n),1))) m_neg <- mkRegU;
    Reg#(Bit#(TAdd#(TAdd#(n,n),1))) m_pos <- mkRegU;
    Reg#(Bit#(TAdd#(TAdd#(n,n),1))) p <- mkRegU;
    Reg#(Bit#(TAdd#(TLog#(n),1))) i <- mkReg( fromInteger(valueOf(n)+1) );

    rule mul_step(i < fromInteger(valueOf(n)));
        // TODO: Implement this in Exercise 6
        Bit#(2) pr = p[1:0];
        Bit#(TAdd#(TAdd#(n,n),1)) p_tmp = 0;
        if(pr == 2'b01) begin
            p_tmp = p + m_pos;
        end else if(pr == 2'b10) begin
            p_tmp = p + m_neg;
        end else begin
            p_tmp = p;
        end
        Int#(TAdd#(TAdd#(n,n),1)) p_int = unpack(p_tmp);
        p <= pack(p_int >> 1);
        i <= i + 1;
    endrule

    method Bool start_ready();
        // TODO: Implement this in Exercise 6
        return  i == fromInteger(valueOf(n) + 1);
    endmethod

    method Action start( Bit#(n) m, Bit#(n) r );
        // TODO: Implement this in Exercise 6
        m_pos <= {m, 0};
        m_neg <= {-m, 0};
        p <= {0, r, 1'b0};
        i <= 0;
    endmethod

    method Bool result_ready();
        // TODO: Implement this in Exercise 6
        return  i == fromInteger(valueOf(n));
    endmethod

    method ActionValue#(Bit#(TAdd#(n,n))) result();
        // TODO: Implement this in Exercise 6
        // return 0;
        i <= i + 1;
        return p[2*valueOf(n):1];
    endmethod
endmodule



// Radix-4 Booth Multiplier
module mkBoothMultiplierRadix4( Multiplier#(n) );
    Reg#(Bit#(TAdd#(TAdd#(n,n),2))) m_neg <- mkRegU;
    Reg#(Bit#(TAdd#(TAdd#(n,n),2))) m_pos <- mkRegU;
    Reg#(Bit#(TAdd#(TAdd#(n,n),2))) p <- mkRegU;
    Reg#(Bit#(TAdd#(TLog#(n),1))) i <- mkReg( fromInteger(valueOf(n)/2+1) );

    rule mul_step(i < fromInteger(valueOf(n)/2));
        // TODO: Implement this in Exercise 8
        Bit#(3) pr = p[2:0];
        Bit#(TAdd#(TAdd#(n,n),2)) p_tmp = 0;
        p_tmp = case(pr)
            3'b000: return p;
            3'b001: return p + m_pos;
            3'b010: return p + m_pos;
            3'b011: return p + (m_pos << 1);
            3'b100: return p + (m_neg << 1);
            3'b101: return p + m_neg;
            3'b110: return p + m_neg;
            3'b111: return p;
        endcase;
        Int#(TAdd#(TAdd#(n,n),2)) p_int = unpack(p_tmp);
        p <= pack(p_int >> 2);
        i <= i + 1;
    endrule

    method Bool start_ready();
        // TODO: Implement this in Exercise 8
        // return False;
        return  i == fromInteger(valueOf(n)/2 + 1);
    endmethod

    method Action start( Bit#(n) m, Bit#(n) r );
        // TODO: Implement this in Exercise 8
        m_pos <= {m[valueOf(n)-1], m, 0};
        m_neg <= {(-m)[valueOf(n)-1], -m, 0};
        p <= {0, r, 1'b0};
        i <= 0;
    endmethod

    method Bool result_ready();
        // TODO: Implement this in Exercise 8
        // return False;
        return  i == fromInteger(valueOf(n)/2);
    endmethod

    method ActionValue#(Bit#(TAdd#(n,n))) result();
        // TODO: Implement this in Exercise 8
        // return 0;
        i <= i + 1;
        return p[2*valueOf(n):1];
    endmethod
endmodule

