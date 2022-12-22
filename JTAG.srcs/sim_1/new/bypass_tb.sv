`timescale 1ns / 1ps

`define HALF_PERIOD 10

module bypass_tb(
    output logic result
    ,output logic tb_end
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

    
    //device id TEST
    logic [0:7] test_data [0:64];
    logic [13:0] test_cntr;
    logic [13:0] test_true_cntr;
    
	always
		#(`HALF_PERIOD) clk = ~clk;
    
    initial begin
        $timeformat(-9, 0, "", 4);  
        $readmemb("tap_bypass_test.mem", test_data);
        fd = $fopen("tap_bypass_test.log", "w");
        clk = 0;
        
        tb_end = 0;
        ////decode REG TEST    
        test_cntr = 0;
        test_true_cntr = 0;
        
        #(`HALF_PERIOD*2);
        
        tap_tms = test_data[test_cntr][0];
        tap_tdi = test_data[test_cntr][5];
        test_cntr +=1;
        
        #(`HALF_PERIOD*2);
        
        $fwrite(fd, "               BYPASS TEST               ||\n");
        $fwrite(fd, "-----------------------------------------||\n");
        $fwrite(fd, " TEST| TIME |TMS|STATE|TDI|BPreg|TDO|true||\n");
	   
        while(test_data[test_cntr][0] !== 1'bx) begin
            tap_tms = test_data[test_cntr][0];
            tap_tdi = test_data[test_cntr][5];
            
            #(3);
            
            $fdisplay(fd, "%d| %t | %d |  %h  | %b |  %b  | %b | %b  ||", 
                   test_cntr
                   ,$realtime 
                   ,tap_tms 
                   ,tap.tap_control.state 
                   ,tap.DR.bypass.data_i
                   ,tap.DR.bypass.shift_reg
                   ,tap.DR.bypass.data_o
                 ,(tap.tap_control.state === test_data[test_cntr][1:4]
                 & tap.DR.bypass.data_i === test_data[test_cntr][5] 
                 & tap.DR.bypass.shift_reg === test_data[test_cntr][6]
                 & tap.DR.bypass.data_o === test_data[test_cntr][7]
                 ));
                   
            if(tap.tap_control.state === test_data[test_cntr][1:4]
                 & tap.DR.bypass.data_i === test_data[test_cntr][5] 
                 & tap.DR.bypass.shift_reg === test_data[test_cntr][6]
                 & tap.DR.bypass.data_o === test_data[test_cntr][7]
                 ) 
                   test_true_cntr += 1;

            test_cntr += 1;
            #(`HALF_PERIOD*2-3);
        end
        $fdisplay(fd, "%d COMPLETE, \t||", 
                    test_true_cntr);
        $fdisplay(fd, "%d ERRORS\t\t||", 
                    test_cntr-test_true_cntr-1);
        
        if(test_cntr-test_true_cntr-1 == 0) result = 1;
        else result = 0;
        
        #10
        $fclose(fd);
        tb_end = 1;
        //$stop;
		end

endmodule