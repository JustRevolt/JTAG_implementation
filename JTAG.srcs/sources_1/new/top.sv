`timescale 1ns / 1ps

module top(
    input logic dec_clk_i,          // btn_c    = N17
    input logic dec_rst_i,          // btn_rst  = C12
    output logic [2:0] dec_data_o,  // led_2:0  = J13, K15, H17 
    
    input logic tap_tck_i,          // JA_4 = G17
    input logic tap_tms_i,          // JA_3 = E18
    input logic tap_tdi_i,          // JA_2 = D18
    output logic tap_tdo_o         // JA_1 = C17
    );
    
    localparam IN_BSC = 2;
    localparam OUT_BSC = 3;
    
    logic dec_clk, dec_rst;
    logic [2:0] dec_data;
    
    logic in_BSC_output [IN_BSC-1:0];
    logic out_BSC_output [OUT_BSC-1:0];
    
    assign dec_clk = in_BSC_output[0];
    assign dec_rst = in_BSC_output[1];
    
    assign {>>{dec_data_o}} = out_BSC_output;
    
    dec_counter dec(
        .clk_i(dec_clk),
        .rst_i(dec_rst),
        .data_o(dec_data)
    );
    
    //TAP
    TAP #(
        .IN_BSC_COUNT(IN_BSC), 
        .OUT_BSC_COUNT(OUT_BSC))
    tap(
        .TCK_i(tap_tck_i)
      , .TMS_i(tap_tms_i)
      , .TDI_i(tap_tdi_i)
      , .in_BSC_i({~dec_rst_i, dec_clk_i})
      , .out_BSC_i({dec_data[2],dec_data[1],dec_data[0]})
      , .TDO_o(tap_tdo_o)
      , .in_BSC_o(in_BSC_output)
      , .out_BSC_o(out_BSC_output)
    );
endmodule