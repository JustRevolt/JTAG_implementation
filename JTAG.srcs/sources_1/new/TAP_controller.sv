`timescale 1ns / 1ps

module TAP_controller
    #( parameter RUN_BIST_TIMER_WEIGHT = 3)
    (
    input logic tck_i,
    input logic tms_i,
    
    output logic shiftDR_o,
    output logic captureDR_o,
    output logic updDR_o,
  
    output logic shiftIR_o,
    output logic captureIR_o,
    output logic updIR_o,
    
    output logic reg_select_o, //0 - DR, 1 - IR  
    output logic tck_o,
    output logic rst_o,
    output logic enable_o,
    output logic run_BIST_o
    );

    
    typedef enum logic [3:0] {RESET,IDLE,DR_SCAN,IR_SCAN,
    IR_CAPTURE,IR_SHIFT,IR_EXIT1,IR_PAUSE,IR_EXIT2,IR_UPDATE,
    DR_CAPTURE,DR_SHIFT,DR_EXIT1,DR_PAUSE,DR_EXIT2,DR_UPDATE}tap_state;
    
    tap_state state, next_state;
    
    logic [RUN_BIST_TIMER_WEIGHT-1:0] run_BIST_timer = 0;
    
    
    assign tck_o = tck_i;
    
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
    
    assign rst_o = (state == RESET);
    
    always_comb begin
        case(state)
            RESET: begin 
                reg_select_o = 1;
            end
            IDLE: begin 
                reg_select_o = 1;
            end
            DR_SCAN: begin 
                reg_select_o = 0;
            end
            IR_SCAN: begin 
                reg_select_o = 0;
            end
            IR_CAPTURE: begin 
                reg_select_o = 1;
            end
            IR_SHIFT: begin 
                reg_select_o = 1;
            end
            IR_EXIT1: begin 
                reg_select_o = 1;
            end
            IR_PAUSE: begin 
                reg_select_o = 1;
            end
            IR_EXIT2: begin 
                reg_select_o = 1;
            end
            IR_UPDATE: begin 
                reg_select_o = 1;
            end
            DR_CAPTURE: begin 
                reg_select_o = 0;
            end
            DR_SHIFT: begin 
                reg_select_o = 0;
            end
            DR_EXIT1: begin 
                reg_select_o = 0;
            end
            DR_PAUSE: begin 
                reg_select_o = 0;
            end
            DR_EXIT2: begin 
                reg_select_o = 0;
            end
            DR_UPDATE: begin 
                reg_select_o = 0;
            end
        endcase
    end
    
    always @ (negedge tck_i) begin
        case(state)
            RESET: begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
            end
            IDLE: begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
                
                if(& run_BIST_timer) run_BIST_o <= 1;
                else run_BIST_timer <= run_BIST_timer + 1; 
            end
            DR_SCAN:    begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
                
                run_BIST_timer <= 0;
                run_BIST_o  <= 0;
            end
            IR_SCAN:    begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
            end
            IR_CAPTURE: begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 1;
                captureIR_o <= 1;
                updIR_o     <= 0;
                
                enable_o    <= 0;
            end
            IR_SHIFT:   begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 1;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 1;
            end
            IR_EXIT1:   begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
            end
            IR_PAUSE:   begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
            end
            IR_EXIT2:   begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
            end
            IR_UPDATE:  begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 1;
                
                enable_o    <= 0;
            end
            DR_CAPTURE: begin
                shiftDR_o   <= 1;
                captureDR_o <= 1;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
            end
            DR_SHIFT:   begin
                shiftDR_o   <= 1;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 1;
            end
            DR_EXIT1:   begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
            end
            DR_PAUSE:   begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
            end
            DR_EXIT2:   begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 0;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
            end
            DR_UPDATE:  begin
                shiftDR_o   <= 0;
                captureDR_o <= 0;
                updDR_o     <= 1;
                
                shiftIR_o   <= 0;
                captureIR_o <= 0;
                updIR_o     <= 0;
                
                enable_o    <= 0;
            end
        endcase
    end
    
endmodule