`timescale 1ns / 1ps

`define HALF_PERIOD 10

module top_tb(
    output logic result
    ,output logic tb_end
    ); 
    
    integer fd;
        
    logic clk;
	
    logic tap_tms;
    logic tap_tdi;
    logic tap_tdo;
    
    logic [3:0] dut_in;
    logic dut_rst;
    logic dut_clk;
    logic [3:0] dut_out;
    
    top project_top(
        .dut_rst_i(dut_rst),          // btn_rst  = C12
        .dut_clk_i(dut_clk),
        .dut_data_i(dut_in),   // sw_3:0 = R15 M13 L16 J15
        .dut_data_o(dut_out),  // led_3:0  = N14 J13, K15, H17 
        
        .tap_tck_i(clk),          // JA_4 = G17
        .tap_tms_i(tap_tms),          // JA_3 = E18
        .tap_tdi_i(tap_tdi),          // JA_2 = D18
        .tap_tdo_o(tap_tdo)         // JA_1 = C17
    );

    //device id TEST
    logic [0:12] test_data [0:512];
    logic [13:0] test_cntr;
    logic [13:0] test_true_cntr;
    
	always
		#(`HALF_PERIOD) clk = ~clk;
    
    initial begin
        $timeformat(-9, 0, "", 4);  
        $readmemb("top_test.mem", test_data);
        fd = $fopen("top_test.log", "w");
        clk = 0;
        
        tb_end = 0;
        ////decode REG TEST    
        test_cntr = 0;
        test_true_cntr = 0;
        
        #(`HALF_PERIOD*2);
        
        tap_tms = test_data[test_cntr][0];
        tap_tdi = test_data[test_cntr][1];
        dut_rst = ~test_data[test_cntr][3];
        dut_clk = test_data[test_cntr][4];
        dut_in  = test_data[test_cntr][5:8];
        test_cntr +=1;
        
        #(`HALF_PERIOD*2);
	    
        while(test_data[test_cntr][0] !== 1'bx) begin
        
            if(test_cntr == 1) begin
                $fwrite(fd, "          BYPASS TEST         |        SIR 6 TDI(111111)          ||\n");
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dut_IN|dut_CLK|dut_RST|dut_OUT|true||\n");
            end
            else if (test_cntr == 20) begin
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, "               SDR 9 TDI(001001101) TDO(010011010)                ||\n");
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dut_IN|dut_CLK|dut_RST|dut_OUT|true||\n");
            end
            else if (test_cntr == 33) begin
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, "           DeviceID TEST         |        SIR 3 TDI(011)          ||\n");
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dut_IN|dut_CLK|dut_RST|dut_OUT|true||\n");
            end
            else if (test_cntr == 42) begin
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, "                SDR 32 TDI(00000000) TDO(DEADBEAF)                ||\n");
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dut_IN|dut_CLK|dut_RST|dut_OUT|true||\n");
            end
            else if (test_cntr == 78) begin
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, "                         Core Logic TEST                          ||\n");
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dut_IN|dut_CLK|dut_RST|dut_OUT|true||\n");
            end
            else if (test_cntr == 89) begin
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, "            RUN BIST TEST           |       SIR 3 TDI(101)        ||\n");
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dut_IN|dut_CLK|dut_RST|dut_OUT|true||\n");

            end
            else if (test_cntr == 97) begin
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, "            RUN BIST TEST           |      RUNTEST 220 TCK;       ||\n");
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dut_IN|dut_CLK|dut_RST|dut_OUT|true||\n");

            end
            else if (test_cntr == 318) begin
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, "      BIST RESULT READ TEST         |        SIR 3 TDI(110)       ||\n");
                $fwrite(fd, "------------------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dut_IN|dut_CLK|dut_RST|dut_OUT|true||\n");
            end
            else if (test_cntr == 327) begin
                $fwrite(fd, "--------------------------------------------------------------------------------||\n");
                $fwrite(fd, " SDR 24 TDI(0000 0000 00 0000 0000 0000 00) TDO(0000 0000 00 0000 1101 0011 11) ||\n");
                $fwrite(fd, "--------------------------------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dut_IN|dut_CLK|dut_RST|dut_OUT|true|             ||\n");

            end
            	               
            tap_tms = test_data[test_cntr][0];
            tap_tdi = test_data[test_cntr][1];
            dut_rst = ~test_data[test_cntr][3];
            dut_clk = test_data[test_cntr][4];
            dut_in  = test_data[test_cntr][5:8];
            
            #(3);
            
            $fdisplay(fd, "%d| %t |  %h  | %d | %b | %b | %b |   %b   |   %b   | %b  | %b  ||", 
                   test_cntr
                   ,$realtime 
                   ,project_top.tap.tap_control.state
                   ,tap_tms
                   ,tap_tdi 
                   ,tap_tdo
                   ,dut_in
                   ,dut_clk
                   ,~dut_rst
                   ,dut_out
                 ,(tap_tdo === test_data[test_cntr][2]
                 & dut_out === test_data[test_cntr][9:12]
                 ));
                   
            if(tap_tdo === test_data[test_cntr][2]
                & dut_out === test_data[test_cntr][9:12]) 
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