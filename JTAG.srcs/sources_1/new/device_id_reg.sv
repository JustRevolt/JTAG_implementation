`timescale 1ns / 1ps

module device_id_reg #(parameter REG_LENGTH = 32, parameter IDCODE = 32'h0) (
    input logic rst_i,
    input logic tck_i,
    input logic data_i,
    input logic shift_i,
    input logic capture_i,
    output logic data_o   
    );
    
    logic [REG_LENGTH - 1:0] shift_reg = IDCODE;
    
    assign data_o = shift_reg[0];
    
    always @ (posedge tck_i or posedge rst_i) begin
        if(rst_i | (capture_i)) shift_reg <= IDCODE; 
        else if(shift_i) shift_reg <= {data_i, shift_reg[REG_LENGTH - 1:1]}; 
    end
    
endmodule