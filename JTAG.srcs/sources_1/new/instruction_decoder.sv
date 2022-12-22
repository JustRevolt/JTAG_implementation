`timescale 1ns / 1ps

module instruction_decoder #(parameter INSTR_LENGTH = 4) (
    input logic [INSTR_LENGTH-1:0] instruction_i,
    output logic inTest_o,
    output logic exTest_o,
    output logic system_mode_o,
    output logic bypass_o,
    output logic device_id_o
    );           

    typedef enum logic [2:0] {SAMP_PRE,INTEST,EXTEST,DEVICE_ID,
    BYPASS = 3'b111}instruct_code;
    
    always_comb begin
    case(instruction_i)
        SAMP_PRE: begin
            inTest_o        = 0;
            exTest_o        = 0;
            system_mode_o   = 1;
            bypass_o        = 0;
            device_id_o     = 0;
        end
        INTEST: begin
            inTest_o        = 1;
            exTest_o        = 0;
            system_mode_o   = 0;
            bypass_o        = 0;
            device_id_o     = 0;
        end 
        EXTEST: begin
            inTest_o        = 0;
            exTest_o        = 1;
            system_mode_o   = 0;
            bypass_o        = 0;
            device_id_o     = 0;
        end
        DEVICE_ID: begin
            inTest_o        = 0;
            exTest_o        = 0;
            system_mode_o   = 1;
            bypass_o        = 0;
            device_id_o     = 1;
        end
        BYPASS: begin
            inTest_o        = 0;
            exTest_o        = 0;
            system_mode_o   = 1;
            bypass_o        = 1;
            device_id_o     = 0;
        end
        default: begin
            inTest_o        = 0;
            exTest_o        = 0;
            system_mode_o   = 1;
            bypass_o        = 1;
            device_id_o     = 0;
        end
    endcase
    end
    
endmodule