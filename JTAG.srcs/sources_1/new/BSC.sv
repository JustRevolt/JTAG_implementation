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
    logic shift_mux_o;
    logic test_mux_o;
    
    mux_2to1 shift_mux(
        .in0(test_data_i),
        .in1(sys_data_i),
        .g(capture_i),
        .out(shift_mux_o)
    );
    
    mux_2to1 test_mux(
        .in0(1'b0),
        .in1(save_reg),
        .g(test_mode_i),
        .out(test_mux_o)
    );
    
    mux_2to1 out_mux(
        .in0(test_mux_o),
        .in1(sys_data_i),
        .g(normal_mode_i),
        .out(sys_data_o)
    );
    
    assign test_data_o = shift_reg;
    
    always @ (posedge tck_i) begin
        if(shift_i) shift_reg <= shift_mux_o;
        if (update_i) save_reg <= shift_reg;
    end     
    
endmodule