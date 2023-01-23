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
    
    //BSR
    
    logic in_bsc_shift [IN_BSC_COUNT-1:0];
    logic in_bsc_save [IN_BSC_COUNT-1:0];
    
    logic out_bsc_shift [OUT_BSC_COUNT-1:0];
    logic out_bsc_save [OUT_BSC_COUNT-1:0];
    
    logic bsr_update;
    
    initial begin
        foreach(in_bsc_shift[i]) in_bsc_shift[i] = 0;
        foreach(in_bsc_save[i]) in_bsc_save[i] = 0;
        foreach(out_bsc_shift[i]) out_bsc_shift[i] = 0;
        foreach(out_bsc_save[i]) out_bsc_save[i] = 0;
    end
    
    assign bsr_update = upd_i & (~normal_mode_i);
    
    always @ (posedge tck_i) begin
        if(shift_i) begin
            if(capture_i) begin
                in_bsc_shift <=  in_BSC_i;
                out_bsc_shift <= out_BSC_i;
            end
            else begin
                out_bsc_shift <= {in_bsc_shift[0], out_bsc_shift[OUT_BSC_COUNT-1:1]};
                in_bsc_shift <= {data_i, in_bsc_shift[IN_BSC_COUNT-1:1]};
            end
        end 
        if (bsr_update) begin
            in_bsc_save  <= in_bsc_shift;  
            out_bsc_save <= out_bsc_shift;
        end
    end  
    
    always_comb begin
        if(normal_mode_i) begin
            in_BSC_o  = in_BSC_i;
            out_BSC_o = out_BSC_i;
        end
        else begin
            if(inTest_i) in_BSC_o  = in_bsc_save;
            else begin
                foreach(in_BSC_o[i]) in_BSC_o[i] = 0; 
            end
            
            if(exTest_i) out_BSC_o  = out_bsc_save;
            else begin
                foreach(out_BSC_o[j]) out_BSC_o[j] = 0; 
            end
        end
    end
    
    
    always_comb begin
        if(mux_g0_i) data_o = bypass_out;
        else if(mux_g1_i) data_o = device_id_out;
        else data_o = out_bsc_shift[0];
    end
    
endmodule