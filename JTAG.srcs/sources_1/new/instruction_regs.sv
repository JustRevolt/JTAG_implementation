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

    const logic [REG_LENGTH - 1:0] design_spec_data = SPEC_DATA; //32'h362F093
    logic [REG_LENGTH - 1:0] shift_reg;
    logic [REG_LENGTH - 1:0] save_reg;
    logic mux_out [REG_LENGTH - 1:0];
        
    genvar i;
    generate
        for (i=0; i<REG_LENGTH; i++) begin
            
            if (i == REG_LENGTH - 1)
                mux_2to1 shift_mux(
                    .in0(data_i),
                    .in1(design_spec_data[i]),
                    .g(capture_i),
                    .out(mux_out[i])
                );
            else
                mux_2to1 shift_mux(
                    .in0(shift_reg[i+1]),
                    .in1(design_spec_data[i]),
                    .g(capture_i),
                    .out(mux_out[i])
                );
        end 
    endgenerate
    
    assign data_o = shift_reg[0];
    
    assign instruction_o = save_reg;
    
    always @ (posedge tck_i) begin
        if(shift_i) begin
            for(int n=0; n<REG_LENGTH; n++)
                shift_reg[n] <= mux_out[n];
        end
        if (upd_i) begin
            save_reg <= shift_reg;
        end
        if (rst_i) begin
            save_reg <= DEFAULT_INSTRUCT;
        end
    end

endmodule