function Bit#(1) and1(Bit#(1) a, Bit#(1) b);
    return a & b;
endfunction

function Bit#(1) or1(Bit#(1) a, Bit#(1) b);
    return a | b;
endfunction

function Bit#(1) xor1( Bit#(1) a, Bit#(1) b );
    return a ^ b;
endfunction

function Bit#(1) not1(Bit#(1) a);
    return ~ a;
endfunction

function Bit#(1) multiplexer1(Bit#(1) sel, Bit#(1) a, Bit#(1) b);
    // return (sel == 0)? a : b;
    // Exercise 1
    // For a 2-way multiplexer, we can use y = a & ~ sel + b & sel
    return or1(and1(a, not1(sel)), and1(b, sel));
endfunction

function Bit#(5) multiplexer5(Bit#(1) sel, Bit#(5) a, Bit#(5) b);
    // return (sel == 0)? a : b;
    // Exercise 2
    // Bit#(5) ret;
    // for(Integer i=0; i<5; i=i+1) begin
    //     ret[i] = multiplexer1(sel, a[i], b[i]);
    // end
    // return ret;
    // Exercise 3
    return multiplexer_n(sel, a, b);
endfunction

typedef 5 N;
function Bit#(N) multiplexerN(Bit#(1) sel, Bit#(N) a, Bit#(N) b);
    // return (sel == 0)? a : b;
    // Exercise 3
    Bit#(N) ret;
    for(Integer i=0; i<valueof(N); i=i+1) begin
        ret[i] = multiplexer1(sel, a[i], b[i]);
    end
    return ret;
endfunction

//typedef 32 N; // Not needed
function Bit#(n) multiplexer_n(Bit#(1) sel, Bit#(n) a, Bit#(n) b);
    // return (sel == 0)? a : b;
    // Exercise 3
    Bit#(n) ret;
    for(Integer i=0; i<valueof(n); i=i+1) begin
        ret[i] = multiplexer1(sel, a[i], b[i]);
    end
    return ret;
endfunction
