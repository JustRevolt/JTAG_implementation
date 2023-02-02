`timescale 1ns / 1ps

module device_id_reg #(parameter REG_LENGTH = 32, parameter IDCODE = 32'h0) (
    input logic tck_i,
    input logic data_i,
    input logic shift_i,
    input logic capture_i,
    output logic data_o   
    );
    
    const logic [REG_LENGTH - 1:0] device_id = IDCODE; //32'h362F093
    logic [REG_LENGTH - 1:0] shift_reg = IDCODE;
    logic mux_out [REG_LENGTH - 1:0];
        
    genvar i;
    generate
        for (i=0; i<REG_LENGTH; i++) begin
            if (i == REG_LENGTH - 1)
                mux_2to1 shift_mux(
                    .in0(data_i),
                    .in1(device_id[i]),
                    .g(capture_i),
                    .out(mux_out[i])
                );
            else
                mux_2to1 shift_mux(
                    .in0(shift_reg[i+1]),
                    .in1(device_id[i]),
                    .g(capture_i),
                    .out(mux_out[i])
                );
        end 
    endgenerate
    
    assign data_o = shift_reg[0];
    
    always @ (posedge tck_i) begin
        if(shift_i) begin 
            for(int n=0; n<REG_LENGTH; n++) begin
                shift_reg[n] <= mux_out[n];
            end
        end
    end
    
endmodule