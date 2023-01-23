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
    output logic rst_o
    );
    
    typedef enum logic [3:0] {RESET,IDLE,DR_SCAN,IR_SCAN,
    IR_CAPTURE,IR_SHIFT,IR_EXIT1,IR_PAUSE,IR_EXIT2,IR_UPDATE,
    DR_CAPTURE,DR_SHIFT,DR_EXIT1,DR_PAUSE,DR_EXIT2,DR_UPDATE}tap_state;
    
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
    
    assign shiftDR_o = (state == DR_SHIFT);
    assign captureDR_o = (state == DR_CAPTURE);
    assign updDR_o = (state == DR_UPDATE);
    
    assign shiftIR_o = (state == IR_SHIFT);
    assign captureIR_o = (state == IR_CAPTURE);
    assign updIR_o = (state == IR_UPDATE);
    
    assign reg_select_o = (    (state == RESET)     || (state == IDLE)
                            || (state == IR_CAPTURE)|| (state == IR_SHIFT)
                            || (state == IR_EXIT1)  || (state == IR_PAUSE)
                            || (state == IR_EXIT2)  || (state == IR_UPDATE));  
    assign rst_o = (state == RESET);
    
endmodule