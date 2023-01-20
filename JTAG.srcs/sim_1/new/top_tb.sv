`timescale 1ns / 1ps

`define HALF_PERIOD 10

module top_tb(
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
    
    logic dec_clk;
    logic dec_rst;
    logic [2:0] dec_data;
    
    logic [2:0] data_pass;
    logic test_reg;
    
    top project_top(
        .dec_clk_i(dec_clk),          // btn_c    = N17
        .dec_rst_i(dec_rst),          // btn_rst  = C12
        .dec_data_o(dec_data),  // led_2:0  = J13, K15, H17 
        
        .tap_tck_i(clk),          // JA_4 = G17
        .tap_tms_i(tap_tms),          // JA_3 = E18
        .tap_tdi_i(tap_tdi),          // JA_2 = D18
        .tap_tdo_o(tap_tdo),         // JA_1 = C17
        
        .data_pass_i(data_pass),  // sw_2:0 = M13 L16 J15
        .test_reg_i(test_reg)         // btn_l = P17
    );

    //device id TEST
    logic [0:2] test_data [0:256];
    logic [13:0] test_cntr;
    logic [13:0] test_true_cntr;
    
	always
		#(`HALF_PERIOD) clk = ~clk;
    
    initial begin
        $timeformat(-9, 0, "", 4);  
        $readmemb("top_bypass_test.mem", test_data);
        fd = $fopen("top_test.log", "w");
        clk = 0;
        
        dec_clk = 0;
        dec_rst = 1; 
               
        data_pass = 3'b111;
        test_reg = 0;
        
        tb_end = 0;
        ////decode REG TEST    
        test_cntr = 0;
        test_true_cntr = 0;
        
        #(`HALF_PERIOD*2);
        
        tap_tms = test_data[test_cntr][0];
        tap_tdi = test_data[test_cntr][1];
        test_cntr +=1;
        
        #(`HALF_PERIOD*2);
	    
        while(test_data[test_cntr][0] !== 1'bx) begin
        
            if(test_cntr == 1) begin
                $fwrite(fd, "                 BYPASS TEST               ||\n");
                $fwrite(fd, "-------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_OUT|true||\n");
            end
            else if (test_cntr == 33) begin
                $fwrite(fd, "-------------------------------------------||\n");
                $fwrite(fd, "               DeviceID TEST               ||\n");
                $fwrite(fd, "-------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_OUT|true||\n");
            end
	               
            tap_tms = test_data[test_cntr][0];
            tap_tdi = test_data[test_cntr][1];
            
            #(3);
            
            $fdisplay(fd, "%d| %t |  %h  | %d | %b | %b |  %b  | %b  ||", 
                   test_cntr
                   ,$realtime 
                   ,project_top.tap.tap_control.state
                   ,tap_tms
                   ,tap_tdi 
                   ,tap_tdo
                   ,dec_data
                 ,(tap_tdo === test_data[test_cntr][2]

));
                   
            if(tap_tdo === test_data[test_cntr][2]) 
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