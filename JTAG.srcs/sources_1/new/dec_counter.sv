`timescale 1ns / 1ps

module dec_counter(
    input logic clk_i,
    input logic rst_i,
    output logic [2:0] data_o
    );

    always @ (posedge clk_i or negedge rst_i) begin
        if (!rst_i) data_o <= 3'b111;
        else data_o <= data_o - 1;
    end
   
endmodule