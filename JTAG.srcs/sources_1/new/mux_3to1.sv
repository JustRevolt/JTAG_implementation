`timescale 1ns / 1ps

module mux_3to1(
    input logic in0, in1, in2,
    input logic [1:0] g,
    output logic out
    );
    
    logic low_out;
    
    mux_2to1 low(
    .in0(in0),
    .in1(in1),
    .g(g[0]),
    .out(low_out)
    );
    
    mux_2to1 high(
    .in0(low_out),
    .in1(in2),
    .g(g[1]),
    .out(out)
    ); 
    
endmodule