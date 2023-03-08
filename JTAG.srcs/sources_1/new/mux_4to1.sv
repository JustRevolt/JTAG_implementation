`timescale 1ns / 1ps

module mux_4to1(
    input logic in0, in1, in2, in3,
    input logic [1:0] g,
    output logic out
    );
    
    logic low1_out, low2_out;
    
    mux_2to1 low1(
    .in0(in0),
    .in1(in1),
    .g(g[0]),
    .out(low1_out)
    );
    
    mux_2to1 low2(
    .in0(in2),
    .in1(in3),
    .g(g[0]),
    .out(low2_out)
    );
    
    mux_2to1 high(
    .in0(low1_out),
    .in1(low2_out),
    .g(g[1]),
    .out(out)
    ); 
    
endmodule