`timescale 1ns / 1ps

module top(
    input logic dut_rst_i,          // btn_rst  = C12
    input logic dut_clk_i,          // btn_c  = N17
    input logic [3:0] dut_data_i,   // sw_3:0 = R15 M13 L16 J15
    output logic [3:0] dut_data_o,  // led_3:0  = N14 J13, K15, H17 
    
    input logic tap_tck_i,          // JA_4 = G17
    input logic tap_tms_i,          // JA_3 = E18
    input logic tap_tdi_i,          // JA_2 = D18
    output logic tap_tdo_o          // JA_1 = C17

    ,output logic anlz_tap_tck_o    // JB_4 = H14
    ,output logic anlz_tap_tms_o    // JB_3 = G16
    ,output logic anlz_tap_tdi_o    // JB_2 = F16
    ,output logic anlz_tap_tdo_o    // JB_1 = D14
    ,output logic anlz_akip_trig_o  // JB_7 = E16
    );
    
    localparam IN_BSC_COUNT = 6;
    localparam OUT_BSC_COUNT = 4;
    
    logic dut_rst;
    logic dut_clk;
    logic [3:0] dut_data_in;
    logic [3:0] dut_data_out;
    
    logic in_BSC_input [IN_BSC_COUNT-1:0];
    logic in_BSC_output [IN_BSC_COUNT-1:0];
    
    logic out_BSC_input [OUT_BSC_COUNT-1:0];
    logic out_BSC_output [OUT_BSC_COUNT-1:0];
    
    assign in_BSC_input[4] = ~dut_rst_i;
    assign in_BSC_input[5] = dut_clk_i;
    
    assign in_BSC_input[3:0] = {dut_data_i[3], dut_data_i[2], dut_data_i[1], dut_data_i[0]};
    
    //ADD MUX between BSC & BIST
    assign dut_rst = in_BSC_output[4];
    assign dut_clk = in_BSC_output[5];
    
    assign {>>{dut_data_in}} = in_BSC_output[3:0];
    
    assign out_BSC_input = {dut_data_out[3], dut_data_out[2], dut_data_out[1], dut_data_out[0]};
    
    assign {>>{dut_data_o}} = out_BSC_output;

    assign anlz_tap_tck_o = tap_tck_i;
    assign anlz_tap_tms_o = tap_tms_i;
    assign anlz_tap_tdi_o = tap_tdi_i;
    assign anlz_tap_tdo_o = tap_tdo_o;
    
    Moore_machine dut(
    .rst(dut_rst)
   ,.clk(dut_clk)
   ,.data_i(dut_data_in)
   ,.data_o(dut_data_out)
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
        .out_BSC_o(out_BSC_output),
        .akip_analyse_o(anlz_akip_trig_o)
    );

endmodule