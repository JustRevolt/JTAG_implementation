`timescale 1ns / 1ps

module top(
    input logic dec_clk_i,          // btn_c    = N17
    input logic dec_rst_i,          // btn_rst  = C12
    output logic [2:0] dec_data_o,  // led_2:0  = J13, K15, H17 
    
    input logic tap_tck_i,          // JA_4 = G17
    input logic tap_tms_i,          // JA_3 = E18
    input logic tap_tdi_i,          // JA_2 = D18
    output logic tap_tdo_o,         // JA_1 = C17
    
    input logic [2:0] data_pass_i,  // sw_2:0 = M13 L16 J15
    input logic test_reg_i         // btn_l = P17
     
//    ,output logic anlz_dec_clk_o    // JC_1         = K1
//    ,output logic anlz_dec_rst_o    // JC_2         = F6
//    ,output logic [2:0] anlz_dec_data_o // JC_9:7   = G13, F13, E16
    
//    ,output logic anlz_tap_tck_o    // JD_1 = H4
//    ,output logic anlz_tap_tms_o    // JD_2 = H1
//    ,output logic anlz_tap_tdi_o    // JD_3 = G1
//    ,output logic anlz_tap_tdo_o     // JD_4 = G3
    );
    
    localparam IN_BSC_COUNT = 3;
    localparam OUT_BSC_COUNT = 3;
    
    logic dec_clk;
    logic dec_rst;
    logic [2:0] dec_data;
    logic test_reg;
    
    logic in_BSC_input [IN_BSC_COUNT-1:0];
    logic in_BSC_output [IN_BSC_COUNT-1:0];
    
    logic out_BSC_input [OUT_BSC_COUNT-1:0];
    logic out_BSC_output [OUT_BSC_COUNT-1:0];
    
    assign dec_rst = in_BSC_output[2];
    assign dec_clk = in_BSC_output[1];
    
    always @ (posedge tap_tck_i) 
        test_reg <= in_BSC_output[0];
    
    assign out_BSC_input = {dec_data[2], dec_data[1], dec_data[0]};
    
    assign dec_data_o[2] = out_BSC_output[2];
    assign dec_data_o[1] = out_BSC_output[1];
    assign dec_data_o[0] = out_BSC_output[0];
    
//    assign anlz_dec_clk_o = dec_clk_i;
//    assign anlz_dec_rst_o = dec_rst_i;
//    assign anlz_dec_data_o = dec_data_o;
    
//    assign anlz_tap_tck_o = tap_tck_i;
//    assign anlz_tap_tms_o = tap_tms_i;
//    assign anlz_tap_tdi_o = tap_tdi_i;
//    assign anlz_tap_tdo_o = tap_tdo_o;
    
    mux_2to1 dec_rst_mux (
        .in0(dec_data_o[0]), 
        .in1(dec_rst_i),
        .g(data_pass_i[2]),
        .out(in_BSC_input[2])
    );
    
    mux_2to1 dec_clk_mux (
        .in0(dec_data_o[1]), 
        .in1(dec_clk_i),
        .g(data_pass_i[1]),
        .out(in_BSC_input[1])
    );
    
    mux_2to1 test_reg_mux (
        .in0(dec_data_o[2]), 
        .in1(test_reg_i),
        .g(data_pass_i[0]),
        .out(in_BSC_input[0])
    );
    
    dec_counter dec(
        .clk_i(dec_clk),
        .rst_i(dec_rst),
        .data_o(dec_data)
    );

    TAP
    #(  .IN_BSC_COUNT(IN_BSC_COUNT), 
        .OUT_BSC_COUNT(OUT_BSC_COUNT)) 
    tap(
        .TCK_i(tap_tck_i),
        .TMS_i(tap_tms_i),
        .TDI_i(tap_tdi_i),
        .in_BSC_i(in_BSC_input),
        .out_BSC_i(out_BSC_input),
        .TDO_o(tap_tdo_o),
        .in_BSC_o(in_BSC_output),
        .out_BSC_o(out_BSC_output)
    );

endmodule