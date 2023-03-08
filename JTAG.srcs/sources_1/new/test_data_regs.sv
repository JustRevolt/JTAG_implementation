`timescale 1ns / 1ps

module test_data_regs 
    #(  parameter IN_BSC_COUNT = 1, 
        parameter OUT_BSC_COUNT = 1)
    (
        input logic tck_i,
        
        input logic shift_i,
        input logic capture_i,
        input logic upd_i,
        
        input logic inTest_i,
        input logic exTest_i,
        input logic normal_mode_i,
        input logic mux_g0_i,
        input logic mux_g1_i,
        input logic run_BIST_i,
        
        input logic data_i,
        input logic in_BSC_i [IN_BSC_COUNT-1:0],
        input logic out_BSC_i [OUT_BSC_COUNT-1:0],
        output logic data_o,
        output logic in_BSC_o [IN_BSC_COUNT-1:0],
        output logic out_BSC_o [OUT_BSC_COUNT-1:0]
    );
        
    logic bypass_out;
    logic device_id_out;
    logic in_bsc_test_data_o [IN_BSC_COUNT-1:0];
    logic out_bsc_test_data_o [OUT_BSC_COUNT-1:0];
    
    logic in_BSC_output [IN_BSC_COUNT-1:0];
    logic out_BSC_input [OUT_BSC_COUNT-1:0];
    
    logic BIST_result;
    logic [IN_BSC_COUNT-1:0] BIST_test_data;
    logic [OUT_BSC_COUNT-1:0] BIST_res_data;
    
    int i;
    
    always_comb begin
        out_BSC_input = out_BSC_i;
        if(run_BIST_i) begin
            for(i=0;i<IN_BSC_COUNT;i++) in_BSC_o[i] = BIST_test_data[i]; 
            {>>{BIST_res_data}} = out_BSC_i;
//            for(i=0;i<OUT_BSC_COUNT;i++) out_BSC_input[i] = 0;
        end
        else begin
            in_BSC_o = in_BSC_output;
            BIST_res_data = 0;
//            out_BSC_input = out_BSC_i;
        end
    end

    mux_4to1 out_mux(
        .in0(out_bsc_test_data_o[0]), 
        .in1(bypass_out), 
        .in2(device_id_out),
        .in3(BIST_result),
        .g({mux_g1_i, mux_g0_i}),
        .out(data_o)
    );

    bypass_reg #(.REG_LENGTH(1)) bypass
    (
        .tck_i(tck_i),
        .shift_i(shift_i),
        .data_i(data_i),
        .data_o(bypass_out)
    );
    
    device_id_reg #(.REG_LENGTH(32), 
                    .IDCODE(32'hdeadbeaf)) 
    device_id (
        .tck_i(tck_i),
        .data_i(data_i),
        .shift_i(shift_i),
        .capture_i(capture_i),
        .data_o(device_id_out)   
    );
    
    BIST #( .TEST_DATA_WEIGHT(IN_BSC_COUNT),     // размер тестовых данных
            .RES_DATA_WEIGHT(OUT_BSC_COUNT),      // размер реакции DUT на тестовые данные 
            .TEST_MEMORY_SIZE(256),   // максимальное кол-во тестов
            .END_TEST_VALUE(6'b110000) // значение окончания теста 
    ) bist (
    .clk_i(tck_i),
    .run_i(run_BIST_i),
    .res_data_i(BIST_res_data),
    .test_data_o(BIST_test_data),
    
    .BIST_result_tdi(data_i),
    .shift_i(shift_i),
    .capture_i(capture_i),
    .BIST_result_tdo(BIST_result)
    );
    
    genvar bsc_c;

    generate
        // generate in_BSC
        for(bsc_c=0; bsc_c<IN_BSC_COUNT; bsc_c++) begin
            if (bsc_c == IN_BSC_COUNT-1)
                BSC in_BSC(
                    .tck_i(tck_i),
                    .shift_i(shift_i),
                    .capture_i(capture_i),
                    .update_i(upd_i),
                    .test_mode_i(inTest_i),
                    .normal_mode_i(normal_mode_i),
                    .sys_data_i(in_BSC_i[bsc_c]),
                    .test_data_i(data_i),
                    .test_data_o(in_bsc_test_data_o[bsc_c]),
                    .sys_data_o(in_BSC_output[bsc_c])
                );
            else
                BSC in_BSC(
                    .tck_i(tck_i),
                    .shift_i(shift_i),
                    .capture_i(capture_i),
                    .update_i(upd_i),
                    .test_mode_i(inTest_i),
                    .normal_mode_i(normal_mode_i),
                    .sys_data_i(in_BSC_i[bsc_c]),
                    .test_data_i(in_bsc_test_data_o[bsc_c+1]),
                    .test_data_o(in_bsc_test_data_o[bsc_c]),
                    .sys_data_o(in_BSC_output[bsc_c])
                );
        end
        // generate out_BSC
        for(bsc_c=0; bsc_c<OUT_BSC_COUNT; bsc_c++) begin
            if (bsc_c == OUT_BSC_COUNT-1)
                BSC out_BSC(
                    .tck_i(tck_i),
                    .shift_i(shift_i),
                    .capture_i(capture_i),
                    .update_i(upd_i),
                    .test_mode_i(exTest_i),
                    .normal_mode_i(normal_mode_i),
                    .sys_data_i(out_BSC_input[bsc_c]),
                    .test_data_i(in_bsc_test_data_o[0]),
                    .test_data_o(out_bsc_test_data_o[bsc_c]),
                    .sys_data_o(out_BSC_o[bsc_c])
                );
            else
                BSC out_BSC(
                    .tck_i(tck_i),
                    .shift_i(shift_i),
                    .capture_i(capture_i),
                    .update_i(upd_i),
                    .test_mode_i(exTest_i),
                    .normal_mode_i(normal_mode_i),
                    .sys_data_i(out_BSC_input[bsc_c]),
                    .test_data_i(out_bsc_test_data_o[bsc_c+1]),
                    .test_data_o(out_bsc_test_data_o[bsc_c]),
                    .sys_data_o(out_BSC_o[bsc_c])
                );
        end
    endgenerate
    
endmodule