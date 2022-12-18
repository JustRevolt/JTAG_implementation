`timescale 1ns / 1ps

module mux_2to1 (
    input logic in0, in1,
    input logic g,
    output logic out
    );
    
    always_comb begin
        case(g)
            1'b0: out = in0;
            1'b1: out = in1;
        endcase    
    end    
    
endmodule