`timescale 1ns / 1ps

module TAP
    #(  parameter IN_BSC_COUNT = 1, 
        parameter OUT_BSC_COUNT = 1)
    (
    input logic TCK_i,
    input logic TMS_i,
    input logic TDI_i,
    input logic in_BSC_i [IN_BSC_COUNT-1:0],
    input logic out_BSC_i [OUT_BSC_COUNT-1:0],
    output logic TDO_o,
    output logic in_BSC_o [IN_BSC_COUNT-1:0],
    output logic out_BSC_o [OUT_BSC_COUNT-1:0]
    );
    
    localparam INSRUCT_LENGTH = 3;
    
    logic inTest_mode, exTest_mode, bypass_mode, device_id_mode, SamplePreload_mode;

    logic shiftDR, captureDR, updDR, outDR;
    logic shiftIR, captureIR, updIR, outIR;

    logic [INSRUCT_LENGTH-1:0] instruction;

    logic reg_select, out_reg, enable, rst;

    test_data_regs #(.IN_BSC_COUNT(IN_BSC_COUNT), 
                        .OUT_BSC_COUNT(OUT_BSC_COUNT)) DR 
    (
        .rst_i(rst),
        .tck_i(TCK_i),
        .shift_i(shiftDR),
        .capture_i(captureDR),
        .upd_i(updDR),
        .inTest_i(inTest_mode),
        .exTest_i(exTest_mode),
        .SamplePreload_i(SamplePreload_mode),
        .bypass_i(bypass_mode),
        .device_id_i(device_id_mode),
        .data_i(TDI_i),
        .in_BSC_i(in_BSC_i),
        .out_BSC_i(out_BSC_i),
        .data_o(outDR),
        .in_BSC_o(in_BSC_o),
        .out_BSC_o(out_BSC_o)
    );

    instruction_regs 
    #(  .REG_LENGTH(INSRUCT_LENGTH), 
        .SPEC_DATA(3'b101),
        .DEFAULT_INSTRUCT(3'b011)) 
    IR (
        .rst_i(rst),
        .tck_i(TCK_i),
        .shift_i(shiftIR),
        .capture_i(captureIR),
        .upd_i(updIR),
        .data_i(TDI_i),
        .data_o(outIR),
        .instruction_o(instruction)
    );

    instruction_decoder #(.INSTR_LENGTH(INSRUCT_LENGTH)) inst_decoder(
        .instruction_i(instruction),
        .inTest_o(inTest_mode),
        .exTest_o(exTest_mode),
        .SamplePreload_o(SamplePreload_mode),
        .bypass_o(bypass_mode),
        .device_id_o(device_id_mode)
    );

    TAP_controller tap_control(
        .tck_i(TCK_i),
        .tms_i(TMS_i),
        
        .shiftDR_o(shiftDR),
        .captureDR_o(captureDR),
        .updDR_o(updDR),
        
        .shiftIR_o(shiftIR),
        .captureIR_o(captureIR),
        .updIR_o(updIR),
        
        .reg_select_o(reg_select),
        .rst_o(rst)
    );
      
//TODO Check the slack
    always @ (negedge TCK_i) begin
        if(reg_select) TDO_o <= outIR;
        else TDO_o <= outDR;
    end
    
endmodule