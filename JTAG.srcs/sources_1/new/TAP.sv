`timescale 1ns / 1ps

`include "TAP.vh"

module TAP
    #(  parameter IN_BSC_COUNT = 1, 
        parameter OUT_BSC_COUNT = 1)
    (
    input logic tck_i,
    input logic tms_i,
    input logic TDI_i,
    input logic in_BSC_i [IN_BSC_COUNT-1:0],
    input logic out_BSC_i [OUT_BSC_COUNT-1:0],
    output logic TDO_o,
    output logic in_BSC_o [IN_BSC_COUNT-1:0],
    output logic out_BSC_o [OUT_BSC_COUNT-1:0]
    );
    
    //TAP_controller 
    logic shiftDR, captureDR, updDR, outDR;
    logic shiftIR, captureIR, updIR, outIR;
    logic reg_select, rst;
    
    tap_state state, next_state;
    
    always @ (posedge tck_i) begin
        state <= next_state;
    end 
    
    always_comb begin
        case (state)
            RESET:      begin
                if(tms_i) next_state = RESET;
                else next_state = IDLE;
            end
            IDLE:       begin
                if(tms_i) next_state = DR_SCAN;
                else next_state = IDLE;
            end
            DR_SCAN:    begin
                if(tms_i) next_state = IR_SCAN;
                else next_state = DR_CAPTURE;
            end
            IR_SCAN:    begin
                if(tms_i) next_state = RESET;
                else next_state = IR_CAPTURE;
            end
            IR_CAPTURE: begin
                if(tms_i) next_state = IR_EXIT1;
                else next_state = IR_SHIFT;
            end
            IR_SHIFT:   begin
                if(tms_i) next_state = IR_EXIT1;
                else next_state = IR_SHIFT;
            end
            IR_EXIT1:   begin
                if(tms_i) next_state = IR_UPDATE;
                else next_state = IR_PAUSE;
            end
            IR_PAUSE:   begin
                if(tms_i) next_state = IR_EXIT2;
                else next_state = IR_PAUSE;
            end
            IR_EXIT2:   begin
                if(tms_i) next_state = IR_UPDATE;
                else next_state = IR_SHIFT;
            end
            IR_UPDATE:  begin
                if(tms_i) next_state = DR_SCAN;
                else next_state = IDLE;
            end
            DR_CAPTURE: begin
                if(tms_i) next_state = DR_EXIT1;
                else next_state = DR_SHIFT;
            end
            DR_SHIFT:   begin
                if(tms_i) next_state = DR_EXIT1;
                else next_state = DR_SHIFT;
            end
            DR_EXIT1:   begin
                if(tms_i) next_state = DR_UPDATE;
                else next_state = DR_PAUSE;
            end
            DR_PAUSE:   begin
                if(tms_i) next_state = DR_EXIT2;
                else next_state = DR_PAUSE;
            end
            DR_EXIT2:   begin
                if(tms_i) next_state = DR_UPDATE;
                else next_state = DR_SHIFT;
            end
            DR_UPDATE:  begin
                if(tms_i) next_state = DR_SCAN;
                else next_state = IDLE;
            end
            default: next_state = RESET;
        endcase
    end
    
    assign shiftDR = (state == DR_SHIFT);
    assign captureDR = (state == DR_CAPTURE);
    assign updDR = (state == DR_UPDATE);
    
    assign shiftIR = (state == IR_SHIFT);
    assign captureIR = (state == IR_CAPTURE);
    assign updIR = (state == IR_UPDATE);
    
    assign reg_select = (    (state == RESET)     || (state == IDLE)
                            || (state == IR_CAPTURE)|| (state == IR_SHIFT)
                            || (state == IR_EXIT1)  || (state == IR_PAUSE)
                            || (state == IR_EXIT2)  || (state == IR_UPDATE));  
    assign rst = (state == RESET);
    
    //instruction_regs
    logic [IR_LENGTH - 1:0] ir_shift_reg, instruction;
    
    always @ (posedge tck_i or posedge rst) begin
        if (rst) ir_shift_reg <= '0; 
        else if (captureIR) ir_shift_reg <= IR_SPEC_DATA;
        else if(shiftIR) ir_shift_reg <= {TDI_i, ir_shift_reg[IR_LENGTH - 1:1]};
    end
    
    always @ (posedge tck_i or posedge rst) begin
        if (rst) instruction <= DEFAULT_INSTRUCT;
        else if(updIR) instruction <= ir_shift_reg;
    end
    
    //instruction_decoder
    logic inTest_mode, exTest_mode, bypass_mode, device_id_mode, SamplePreload_mode;
    
    assign inTest_mode        = (instruction == INTEST);
    assign exTest_mode        = (instruction == EXTEST);
    assign SamplePreload_mode = (instruction == SAMP_PRE);
    assign bypass_mode        = (instruction[IR_LENGTH-1] == 1);
    assign device_id_mode     = (instruction == DEVICE_ID);
    
    //BSR
    logic in_bsc_shift [IN_BSC_COUNT-1:0];
    logic in_bsc_save [IN_BSC_COUNT-1:0];
    
    logic out_bsc_shift [OUT_BSC_COUNT-1:0];
    logic out_bsc_save [OUT_BSC_COUNT-1:0];
    
    logic bsr_instr;
    
    assign bsr_instr = inTest_mode | exTest_mode | SamplePreload_mode;
    
    assign in_BSC_o = inTest_mode ? in_bsc_save : in_BSC_i;
    assign out_BSC_o = exTest_mode ? out_bsc_save : out_BSC_i;
    
    //in BSC shift
    always @ (posedge tck_i) begin
        if(bsr_instr) begin
            if(captureDR) in_bsc_shift <=  in_BSC_i;
            else if(shiftDR) in_bsc_shift <= {TDI_i, in_bsc_shift[IN_BSC_COUNT-1:1]};
        end
    end
    
    //out BSC shift
    always @ (posedge tck_i) begin
        if(bsr_instr) begin
            if(captureDR) out_bsc_shift <= out_BSC_i;
            else if(shiftDR) out_bsc_shift <= {in_bsc_shift[0], out_bsc_shift[OUT_BSC_COUNT-1:1]};
        end
    end
    
    //in BSC save
    always @ (posedge tck_i) begin
        if (updDR & bsr_instr) in_bsc_save  <= in_bsc_shift;
    end
    
    //out BSC save
    always @ (posedge tck_i) begin
        if (updDR & bsr_instr) out_bsc_save  <= out_bsc_shift;
    end
    
    //bypass
    logic bypass_shift_reg = 0;
    
    always @(posedge tck_i or posedge rst) begin
        if(rst) bypass_shift_reg <= 0;
        else if(shiftDR & bypass_mode) bypass_shift_reg <= TDI_i;
    end
    
    //device_id_reg
    logic [IDCODE_LENGTH - 1:0] dr_shift_reg = IDCODE;
    
    always @ (posedge tck_i or posedge rst) begin
        if(rst | (captureDR & device_id_mode)) dr_shift_reg <= IDCODE; 
        else if(shiftDR & device_id_mode) dr_shift_reg <= {TDI_i, dr_shift_reg[IDCODE_LENGTH - 1:1]}; 
    end
          
    //out mux
    always @ (negedge tck_i) begin
        if(reg_select) TDO_o <= ir_shift_reg[0];
        else if(bypass_mode) TDO_o <= bypass_shift_reg;
        else if(device_id_mode) TDO_o <= dr_shift_reg[0];
        else TDO_o <= out_bsc_shift[0];
    end
    
endmodule