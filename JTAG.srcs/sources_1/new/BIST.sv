`timescale 1ns / 1ps

module BIST
    #(  parameter TEST_DATA_WEIGHT = 1,     // размер тестовых данных
        parameter RES_DATA_WEIGHT = 1,      // размер реакции DUT на тестовые данные 
        parameter TEST_MEMORY_SIZE = 256,   // максимальное кол-во тестов
        parameter END_TEST_VALUE = 6'b110000 // значение окончания теста 
        )   
    (
    input logic clk_i,
    input logic run_i,
    input logic [RES_DATA_WEIGHT-1:0] res_data_i,
    output logic [TEST_DATA_WEIGHT-1:0] test_data_o, 
    
    input logic BIST_result_tdi,
    input logic shift_i,
    input logic capture_i,
    output logic BIST_result_tdo
    );
    
    localparam TEST_MEMORY_SIZE_WEIGHT = $clog2(TEST_MEMORY_SIZE); // кол-во бит для записи номера теста
    localparam BIST_result_weight = RES_DATA_WEIGHT*2+TEST_DATA_WEIGHT+TEST_MEMORY_SIZE_WEIGHT+2; // кол-во бит для записи результата BIST
    
    typedef struct packed {
        bit [RES_DATA_WEIGHT-1:0] prestep_res_data;
        bit [RES_DATA_WEIGHT-1:0] res_data;
        bit [TEST_DATA_WEIGHT-1:0] test_data;
        bit [TEST_MEMORY_SIZE_WEIGHT-1:0] last_step;
        bit    test_success;
        bit    test_end;
    } bist_reg;
    
    logic [TEST_DATA_WEIGHT-1:0] test_data_mem [0:TEST_MEMORY_SIZE-1];   // память с тестовыми данными
    logic [RES_DATA_WEIGHT-1:0] true_res_data_mem [0:TEST_MEMORY_SIZE-1];   // память с правитьными реакциями DUT на тестовые данные 
    
    /*
    |23            20|19    16|15     10|9      2|      1|  0|
    |prestep_res_data|res_data|test_data|end_step|success|end|
    */
    bist_reg BIST_result;
    
    logic [TEST_MEMORY_SIZE_WEIGHT-1:0] step;
    logic BIST_stop, test_end, test_success;    
    
    initial begin
        $readmemb("BIST_test1_in_data.mem",test_data_mem);
        $readmemb("BIST_test1_res_data.mem",true_res_data_mem);
    end
    
    assign BIST_stop = test_end || ~test_success;
    
    // put test data to DUT 
    always @ (posedge clk_i) begin
        if(~run_i) begin
            test_end <= 0;
        end
        else if(BIST_stop == 0) begin
            BIST_result.last_step <= step;
            
            if(test_data_mem[step] == END_TEST_VALUE) begin
                BIST_result.test_end <= 1;
                test_end <= 1;
            end
            else begin
                BIST_result.test_data <= test_data_mem[step];
                BIST_result.test_end <= 0;
                test_end <= 0;
                test_data_o <= test_data_mem[step];
            end
        end
    end
    
    // get res data from DUT and check
    always @ (negedge clk_i) begin
        if(~run_i) begin
            step <= 0;
            test_success <= 1;
        end
        else if(BIST_stop == 0) begin
            BIST_result.res_data <= res_data_i;
            BIST_result.prestep_res_data <= BIST_result.res_data;
            
            if(res_data_i == true_res_data_mem[step]) begin
                BIST_result.test_success <= 1;
                test_success <= 1;
                step++;
            end
            else begin
                BIST_result.test_success <= 0;
                test_success <= 0;
            end
        end
    end
    
    logic [BIST_result_weight-1:0] shift_reg = 0;
    logic mux_out [BIST_result_weight-1:0];
        
    genvar i;
    generate
        for (i=0; i<BIST_result_weight; i++) begin
            if (i == BIST_result_weight - 1)
                mux_2to1 shift_mux(
                    .in0(BIST_result_tdi),
                    .in1(BIST_result[i]),
                    .g(capture_i),
                    .out(mux_out[i])
                );
            else
                mux_2to1 shift_mux(
                    .in0(shift_reg[i+1]),
                    .in1(BIST_result[i]),
                    .g(capture_i),
                    .out(mux_out[i])
                );
        end 
    endgenerate
    
    assign BIST_result_tdo = shift_reg[0];
    
    always @ (posedge clk_i) begin
        if(shift_i) begin 
            for(int n=0; n<BIST_result_weight; n++) begin
                shift_reg[n] <= mux_out[n];
            end
        end
    end
    
    
endmodule
