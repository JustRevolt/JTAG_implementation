`timescale 1ns / 1ps

module instruction_regs #(parameter REG_LENGTH = 4, 
                            parameter SPEC_DATA = 4'h0, 
                            DEFAULT_INSTRUCT = 4'hf)
    (
        input logic rst_i,
        input logic tck_i,
        input logic shift_i,
        input logic capture_i,
        input logic upd_i,
        input logic data_i,
        output logic data_o,
        output logic [REG_LENGTH - 1:0] instruction_o
    );

    logic [REG_LENGTH - 1:0] shift_reg;
           
    assign data_o = shift_reg[0];
    
    always @ (posedge tck_i or posedge rst_i) begin
        if (rst_i) shift_reg <= '0; 
        else if (capture_i) shift_reg <= SPEC_DATA;
        else if(shift_i) shift_reg <= {data_i, shift_reg[REG_LENGTH - 1:1]};
    end
    
    always @ (posedge tck_i or posedge rst_i) begin
        if (rst_i) instruction_o <= DEFAULT_INSTRUCT;
        else if(upd_i) instruction_o <= shift_reg;
    end

endmodule