`timescale 1ns / 1ps

`define HALF_PERIOD 10

module tap_control_tb(
    output logic result
    ); 
    
    integer fd;
    
    localparam IN_BSC_COUNT = 2;
    localparam OUT_BSC_COUNT = 3;
    
    logic clk;
	
    logic tap_tms;
    logic tap_tdi;
    logic tap_tdo;

    logic in_BSC_input [IN_BSC_COUNT-1:0];
    logic in_BSC_output [IN_BSC_COUNT-1:0];
    
    logic out_BSC_input [OUT_BSC_COUNT-1:0];
    logic out_BSC_output [OUT_BSC_COUNT-1:0];
    
    TAP
    #(  .IN_BSC_COUNT(IN_BSC_COUNT), 
        .OUT_BSC_COUNT(OUT_BSC_COUNT)) 
    tap(
        .TCK_i(clk),
        .TMS_i(tap_tms),
        .TDI_i(tap_tdi),
        .in_BSC_i(in_BSC_input),
        .out_BSC_i(out_BSC_input),
        .TDO_o(tap_tdo),
        .in_BSC_o(in_BSC_output),
        .out_BSC_o(out_BSC_output)
    );

    //TAP_CONTROL_TEST
    logic [6:0] control_test_data_cntr;
    logic [0:14] control_test_data [0:64];
    logic [13:0] control_test_cntr;
    logic [13:0] fsm_test_true_cntr;
    logic [13:0] out_control_test_true_cntr;
    logic [3:0] real_state;
    
	always
		#(`HALF_PERIOD) clk = ~clk;
    
    initial begin	   
        $timeformat(-9, 0, "", 4);
        $readmemb("tap_control_test.mem", control_test_data);
        fd = $fopen("tap_control_test.log", "w");
        clk = 0;
        result = 0;
        
        //TAP_CONTROL_TEST
        control_test_data_cntr = 0;       
        control_test_cntr = 0;
        fsm_test_true_cntr = 0;
        out_control_test_true_cntr = 0;
        
        #(`HALF_PERIOD*2);
        
        tap_tms = control_test_data[control_test_data_cntr][0];
        control_test_cntr +=1;
        
        #(`HALF_PERIOD*2);
        
        $fwrite(fd, "          FSM TEST         ||                                    OUTPUT TEST                               ||\n");
        $fwrite(fd, "---------------------------||------------------------------------------------------------------------------||\n");
        $fwrite(fd, " TEST| TIME |TMS|STATE|true||shiftDR|captureDR|updDR|shiftIR|captureIR|updIR|TAPmode|Select|Enable|RST|true||\n");
	   
        while(control_test_data[control_test_data_cntr][0] !== 1'bx) begin
            tap_tms = control_test_data[control_test_data_cntr][0];
            
            #(3);
            real_state[3] = control_test_data[control_test_data_cntr][1];
            real_state[2] = control_test_data[control_test_data_cntr][2];
            real_state[1] = control_test_data[control_test_data_cntr][3];
            real_state[0] = control_test_data[control_test_data_cntr][4];
            
            $fwrite(fd, "%d| %t | %d |  %h  | %d  ||", control_test_cntr, $realtime, tap_tms, tap.tap_control.state, (tap.tap_control.state == real_state));
            if(tap.tap_control.state == real_state) fsm_test_true_cntr += 1;
            
            $fwrite(fd, "   %d   |    %d    |  %d  |   %d   |    %d    |  %d  |   %d   |  %d   |  %d   | %d | %b  ||\n",  
            tap.shiftDR,
            tap.captureDR,
            tap.updDR,
            tap.shiftIR,
            tap.captureIR,
            tap.updIR,
            tap.TAPmode,
            tap.reg_select,
            tap.enable,
            tap.rst,
           (tap.shiftDR == control_test_data[control_test_data_cntr][5] &
            tap.captureDR == control_test_data[control_test_data_cntr][6] &
            tap.updDR == control_test_data[control_test_data_cntr][7] &
            tap.shiftIR == control_test_data[control_test_data_cntr][8] &
            tap.captureIR == control_test_data[control_test_data_cntr][9] &
            tap.updIR == control_test_data[control_test_data_cntr][10] &
            tap.TAPmode == control_test_data[control_test_data_cntr][11] &
            tap.reg_select == control_test_data[control_test_data_cntr][12] &
            tap.enable == control_test_data[control_test_data_cntr][13] &
            tap.rst == control_test_data[control_test_data_cntr][14]));
            
            if( tap.shiftDR == control_test_data[control_test_data_cntr][5] &
                tap.captureDR == control_test_data[control_test_data_cntr][6] &
                tap.updDR == control_test_data[control_test_data_cntr][7] &
                tap.shiftIR == control_test_data[control_test_data_cntr][8] &
                tap.captureIR == control_test_data[control_test_data_cntr][9] &
                tap.updIR == control_test_data[control_test_data_cntr][10] &
                tap.TAPmode == control_test_data[control_test_data_cntr][11] &
                tap.reg_select == control_test_data[control_test_data_cntr][12] &
                tap.enable == control_test_data[control_test_data_cntr][13] &
                tap.rst == control_test_data[control_test_data_cntr][14]) 
                    out_control_test_true_cntr += 1;

            control_test_data_cntr += 1;
            control_test_cntr += 1;
            #(`HALF_PERIOD*2-3);
        end
        $fdisplay(fd, "%d COMPLETE,    || %d COMPLETE,", 
                    fsm_test_true_cntr,
                    out_control_test_true_cntr);
        $fdisplay(fd, "%d ERRORS       || %d ERRORS", 
                    control_test_cntr-fsm_test_true_cntr-1,
                    control_test_cntr-out_control_test_true_cntr-1);
        
        if (!(control_test_cntr-fsm_test_true_cntr-1 & control_test_cntr-out_control_test_true_cntr-1)) result = 1;
        #10
        $fclose(fd);
        $stop;
		end
    
endmodule