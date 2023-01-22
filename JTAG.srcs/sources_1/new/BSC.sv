`timescale 1ns / 1ps

module BSC(
    input logic tck_i,
    input logic shift_i,
    input logic capture_i,
    input logic update_i,
    input logic test_mode_i,
    input logic normal_mode_i,
    input logic sys_data_i,
    input logic test_data_i,
    output logic test_data_o,
    output logic sys_data_o
    );
    
    logic shift_reg = 1'b0, save_reg = 1'b0;
    
    assign test_data_o = shift_reg;
    
    always_comb begin
        if(normal_mode_i) sys_data_o <= sys_data_i;
        else sys_data_o <= save_reg&test_mode_i;
    end
    
    always @ (posedge tck_i) begin
        if(shift_i) begin
            if(capture_i) shift_reg <= sys_data_i;
            else shift_reg <= test_data_i;
        end 
        if (update_i) save_reg <= shift_reg;
    end     
    
endmodule