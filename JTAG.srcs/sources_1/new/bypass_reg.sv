`timescale 1ns / 1ps

module bypass_reg #(parameter REG_LENGTH = 1)
    (
    input logic tck_i,
    input logic shift_i,
    input logic data_i,
    output logic data_o
    );
    
    logic [REG_LENGTH-1:0] shift_reg = 1'b0;
    
    assign data_o = shift_reg[0];
    
    always @(posedge tck_i) begin
        if(shift_i) begin 
            for(int i=0; i<REG_LENGTH-1; i++)
                shift_reg[i] <= shift_reg[i+1];
            shift_reg[REG_LENGTH-1] <= data_i;
        end
    end
    
endmodule