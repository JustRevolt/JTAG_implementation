`timescale 1ns / 1ps

module top(
    input logic dec_clk_i,          // btn_c    = N17
    input logic dec_rst_i,          // btn_rst  = C12
    output logic [2:0] dec_data_o,  // led_2:0  = J13, K15, H17 
    
    input logic tap_tck_i,          // JA_4 = G17
    input logic tap_tms_i,          // JA_3 = E18
    input logic tap_tdi_i,          // JA_2 = D18
    output logic tap_tdo_o         // JA_1 = C17
     
    ,output logic anlz_dec_clk_o    // JC_1         = K1
    ,output logic anlz_dec_rst_o    // JC_2         = F6
//    ,output logic [2:0] anlz_dec_data_o // JC_9:7   = G13, F13, E16
    
    ,output logic anlz_tap_tck_o    // JD_1 = H4
    ,output logic anlz_tap_tms_o    // JD_2 = H1
    ,output logic anlz_tap_tdi_o    // JD_3 = G1
    ,output logic anlz_tap_tdo_o     // JD_4 = G3
    );
    
    assign anlz_dec_clk_o = dec_clk_i;
    assign anlz_dec_rst_o = dec_rst_i;
//    assign anlz_dec_data_o = dec_data_o;
    
    assign anlz_tap_tck_o = tap_tck_i;
    assign anlz_tap_tms_o = tap_tms_i;
    assign anlz_tap_tdi_o = tap_tdi_i;
    assign anlz_tap_tdo_o = tap_tdo_o;
    
    dec_counter dec(
        .clk_i(dec_clk_i),
        .rst_i(dec_rst_i),
        .data_o(dec_data_o)
    );
    
    always @ (posedge tap_tck_i) begin
        tap_tdo_o <= tap_tdi_i;
    end
    
endmodule