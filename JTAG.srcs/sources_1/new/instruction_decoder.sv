`timescale 1ns / 1ps

module instruction_decoder #(parameter INSTR_LENGTH = 4) (
    input logic [INSTR_LENGTH-1:0] instruction_i
    ,output logic inTest_o
    ,output logic exTest_o
    ,output logic system_mode_o
    ,output logic bypass_o
    ,output logic device_id_o
    ,output logic akip_analyse_o
    ,output logic BIST_o
    );           

    typedef enum logic [2:0] {SAMP_PRE,INTEST,EXTEST,DEVICE_ID,ANALYSE,BIST,READ_BIST,
    BYPASS = 3'b111}instruct_code;
    
    always_comb begin
    inTest_o        = 0;
    exTest_o        = 0;
    system_mode_o   = 0;
    bypass_o        = 0;
    device_id_o     = 0;
    akip_analyse_o  = 0;
    BIST_o          = 0;
    
    case(instruction_i)
        SAMP_PRE: begin
            system_mode_o   = 1;
        end
        INTEST: begin
            inTest_o        = 1;
        end 
        EXTEST: begin
            exTest_o        = 1;
        end
        DEVICE_ID: begin
            system_mode_o   = 1;
            device_id_o     = 1;
        end
        BYPASS: begin
            system_mode_o   = 1;
            bypass_o        = 1;
        end
        ANALYSE: begin
            system_mode_o   = 1;
            akip_analyse_o  = 1;
        end
        BIST: begin
            BIST_o          = 1;
        end
        READ_BIST: begin
            system_mode_o   = 1;
            device_id_o     = 1;
            bypass_o        = 1;
        end
        default: begin
            system_mode_o   = 1;
            bypass_o        = 1;
        end
    endcase
    end
    
endmodule