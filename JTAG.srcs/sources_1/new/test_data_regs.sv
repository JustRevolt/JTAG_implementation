`timescale 1ns / 1ps

module test_data_regs 
    #(  parameter IN_BSC_COUNT = 1, 
        parameter OUT_BSC_COUNT = 1)
    (
        input logic rst_i,
        input logic tck_i,
        input logic shift_i,
        input logic capture_i,
        input logic upd_i,
        input logic inTest_i,
        input logic exTest_i,
        input logic SamplePreload_i,
        input logic bypass_i,
        input logic device_id_i,
        input logic data_i,
        input logic in_BSC_i [IN_BSC_COUNT-1:0],
        input logic out_BSC_i [OUT_BSC_COUNT-1:0],
        output logic data_o,
        output logic in_BSC_o [IN_BSC_COUNT-1:0],
        output logic out_BSC_o [OUT_BSC_COUNT-1:0]
    );
    
    logic bypass_out;
    logic device_id_out;

    bypass_reg #(.REG_LENGTH(1)) bypass
    (
        .rst_i(rst_i),
        .tck_i(tck_i),
        .shift_i(shift_i & bypass_i),
        .data_i(data_i),
        .data_o(bypass_out)
    );
    
    device_id_reg #(.REG_LENGTH(32), 
                    .IDCODE(32'hdeadbeaf)) 
    device_id (
        .rst_i(rst_i),
        .tck_i(tck_i),
        .data_i(data_i),
        .shift_i(shift_i & device_id_i),
        .capture_i(capture_i & device_id_i),
        .data_o(device_id_out)   
    );
    
    //BSR
    logic in_bsc_shift [IN_BSC_COUNT-1:0];
    logic in_bsc_save [IN_BSC_COUNT-1:0];
    
    logic out_bsc_shift [OUT_BSC_COUNT-1:0];
    logic out_bsc_save [OUT_BSC_COUNT-1:0];
    
    logic bsr_instr;
    
    assign bsr_instr = inTest_i | exTest_i | SamplePreload_i;
    
    assign in_BSC_o = inTest_i ? in_bsc_save : in_BSC_i;
    assign out_BSC_o = exTest_i ? out_bsc_save : out_BSC_i;
    
    //in BSC shift
    always @ (posedge tck_i) begin
        if(bsr_instr) begin
            if(capture_i) in_bsc_shift <=  in_BSC_i;
            else if(shift_i) in_bsc_shift <= {data_i, in_bsc_shift[IN_BSC_COUNT-1:1]};
        end
    end
    
    //out BSC shift
    always @ (posedge tck_i) begin
        if(bsr_instr) begin
            if(capture_i) out_bsc_shift <= out_BSC_i;
            else if(shift_i) out_bsc_shift <= {in_bsc_shift[0], out_bsc_shift[OUT_BSC_COUNT-1:1]};
        end
    end
    
    //in BSC save
    always @ (posedge tck_i) begin
        if (upd_i & bsr_instr) in_bsc_save  <= in_bsc_shift;
    end
    
    //out BSC save
    always @ (posedge tck_i) begin
        if (upd_i & bsr_instr) out_bsc_save  <= out_bsc_shift;
    end
    
    always_comb begin
        if(bypass_i) data_o = bypass_out;
        else if(device_id_i) data_o = device_id_out;
        else data_o = out_bsc_shift[0];
    end
    
endmodule