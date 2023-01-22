`timescale 1ns / 1ps

module device_id_reg #(parameter REG_LENGTH = 32, parameter IDCODE = 32'h0) (
    input logic tck_i,
    input logic data_i,
    input logic shift_i,
    input logic capture_i,
    output logic data_o   
    );
    
    const logic [REG_LENGTH - 1:0] device_id = IDCODE; //32'h362F093
    logic [REG_LENGTH - 1:0] shift_reg = 0;
    
    assign data_o = shift_reg[0];
    
    always @ (posedge tck_i) begin
        if(shift_i) begin 
            if(capture_i) shift_reg <= device_id; 
            else shift_reg <= {data_i, shift_reg[REG_LENGTH - 1:1]};
        end
    end
    
endmodule