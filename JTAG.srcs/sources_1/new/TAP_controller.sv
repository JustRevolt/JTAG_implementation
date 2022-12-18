`timescale 1ns / 1ps

module TAP_controller(
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
    output logic enable_o
    );

    
    typedef enum logic [3:0] {RESET,IDLE,DR_SCAN,IR_SCAN,
    IR_CAPTURE,IR_SHIFT,IR_EXIT1,IR_PAUSE,IR_EXIT2,IR_UPDATE,
    DR_CAPTURE,DR_SHIFT,DR_EXIT1,DR_PAUSE,DR_EXIT2,DR_UPDATE}tap_state;
    
    tap_state state, next_state;
    
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
    
    always_comb begin
        case(state)
            RESET: begin 
                rst_o <= 1;
                reg_select_o <= 1;
            end
            IDLE: begin 
                rst_o <= 0;
                reg_select_o <= 1;
            end
            DR_SCAN: begin 
                rst_o <= 0;
                reg_select_o <= 0;
            end
            IR_SCAN: begin 
                rst_o <= 0;
                reg_select_o <= 0;
            end
            IR_CAPTURE: begin 
                rst_o <= 0;
                reg_select_o <= 1;
            end
            IR_SHIFT: begin 
                rst_o <= 0;
                reg_select_o <= 1;
            end
            IR_EXIT1: begin 
                rst_o <= 0;
                reg_select_o <= 1;
            end
            IR_PAUSE: begin 
                rst_o <= 0;
                reg_select_o <= 1;
            end
            IR_EXIT2: begin 
                rst_o <= 0;
                reg_select_o <= 1;
            end
            IR_UPDATE: begin 
                rst_o <= 0;
                reg_select_o <= 1;
            end
            DR_CAPTURE: begin 
                rst_o <= 0;
                reg_select_o <= 0;
            end
            DR_SHIFT: begin 
                rst_o <= 0;
                reg_select_o <= 0;
            end
            DR_EXIT1: begin 
                rst_o <= 0;
                reg_select_o <= 0;
            end
            DR_PAUSE: begin 
                rst_o <= 0;
                reg_select_o <= 0;
            end
            DR_EXIT2: begin 
                rst_o <= 0;
                reg_select_o <= 0;
            end
            DR_UPDATE: begin 
                rst_o <= 0;
                reg_select_o <= 0;
            end
        endcase
    end
    
    always @ (negedge tck_i) begin
        case(state)
            RESET: begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= 0;
            end
            IDLE: begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= 0;
            end
            DR_SCAN:    begin
                shiftDR_o <= ~tms_i;
                captureDR_o <= ~tms_i;
                updDR_o <= 0;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= 0;
            end
            IR_SCAN:    begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= ~tms_i;
                captureIR_o <= ~tms_i;
                updIR_o <= 0;

                enable_o <= 0;
            end
            IR_CAPTURE: begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= ~tms_i;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= ~tms_i;
            end
            IR_SHIFT:   begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= ~tms_i;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= ~tms_i;
            end
            IR_EXIT1:   begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= tms_i;

                enable_o <= 0;
            end
            IR_PAUSE:   begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= 0;
            end
            IR_EXIT2:   begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= ~tms_i;
                captureIR_o <= 0;
                updIR_o <= tms_i;

                enable_o <= ~tms_i;
            end
            IR_UPDATE:  begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= 0;
            end
            DR_CAPTURE: begin
                shiftDR_o <= ~tms_i;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= ~tms_i;
            end
            DR_SHIFT:   begin
                shiftDR_o <= ~tms_i;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= ~tms_i;
            end
            DR_EXIT1:   begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= tms_i;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= 0;
            end
            DR_PAUSE:   begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= 0;
            end
            DR_EXIT2:   begin
                shiftDR_o <= ~tms_i;
                captureDR_o <= 0;
                updDR_o <= tms_i;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= ~tms_i;
            end
            DR_UPDATE:  begin
                shiftDR_o <= 0;
                captureDR_o <= 0;
                updDR_o <= 0;
                
                shiftIR_o <= 0;
                captureIR_o <= 0;
                updIR_o <= 0;

                enable_o <= 0;
            end
        endcase
    end

endmodule