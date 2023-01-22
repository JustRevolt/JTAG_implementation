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
    
    assign inTest_o        = (instruction_i == INTEST);
    assign exTest_o        = (instruction_i == EXTEST);
    assign system_mode_o   = ~((instruction_i == EXTEST) || (instruction_i == INTEST));
    assign bypass_o        = (instruction_i[INSTR_LENGTH-1] == 1);
    assign device_id_o     = (instruction_i == DEVICE_ID);
    
endmodule