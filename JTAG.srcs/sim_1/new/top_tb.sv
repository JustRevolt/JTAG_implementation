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
    logic [0:10] test_data [0:256];
    logic [13:0] test_cntr;
    logic [13:0] test_true_cntr;
    
	always
		#(`HALF_PERIOD) clk = ~clk;
    
    initial begin
        $timeformat(-9, 0, "", 4);  
        $readmemb("top_test.mem", test_data);
        fd = $fopen("top_test.log", "w");
        clk = 0;
               
        test_reg = 0;
        
        tb_end = 0;
        ////decode REG TEST    
        test_cntr = 0;
        test_true_cntr = 0;
        
        #(`HALF_PERIOD*2);
        
        tap_tms = test_data[test_cntr][0];
        tap_tdi = test_data[test_cntr][1];
        dec_clk = test_data[test_cntr][3];
        dec_rst = ~test_data[test_cntr][4];
        data_pass = test_data[test_cntr][8:10];
        test_cntr +=1;
        
        #(`HALF_PERIOD*2);
	    
        while(test_data[test_cntr][0] !== 1'bx) begin
        
            if(test_cntr == 1) begin
                $fwrite(fd, "        BYPASS TEST       |     SIR 6 TDI(111111)          ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 20) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "            SDR 9 TDI(001001101) TDO(010011010)            ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 33) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "         DeviceID TEST       |     SIR 3 TDI(011)          ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 43) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "            SDR 32 TDI(00000000) TDO(DEADBEAF)             ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 78) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "                     Core Logic TEST                       ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 83) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "          Preload TEST       |     SIR 3 TDI(000)          ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 92) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "                 SDR 5 TDI(00000) TDO(00101)               ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 99) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "        InTest TEST       |      SIR 3 TDI(001)            ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 109) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "                 SDR 5 TDI(10000) TDO(00101)               ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 118) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "                 SDR 5 TDI(01000) TDO(00111)               ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 127) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "                 SDR 5 TDI(00000) TDO(00110)               ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 135) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "          Preload TEST       |     SIR 3 TDI(000)          ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
            else if (test_cntr == 142) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "                 SDR 6 TDI(000111) TDO(000110)             ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
	        else if (test_cntr == 153) begin
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, "           ExTest TEST       |     SIR 3 TDI(010)          ||\n");
                $fwrite(fd, "-----------------------------------------------------------||\n");
                $fwrite(fd, " TEST| TIME |STATE|TMS|TDI|TDO|dec_CLK|dec_RST|dec_OUT|true||\n");
            end
	               
            tap_tms = test_data[test_cntr][0];
            tap_tdi = test_data[test_cntr][1];
            dec_clk = test_data[test_cntr][3];
            dec_rst = ~test_data[test_cntr][4];
            data_pass = test_data[test_cntr][8:10];
            
            #(3);
            
            $fdisplay(fd, "%d| %t |  %h  | %d | %b | %b |   %b   |   %b   |  %b  | %b  ||", 
                   test_cntr
                   ,$realtime 
                   ,project_top.tap.tap_control.state
                   ,tap_tms
                   ,tap_tdi 
                   ,tap_tdo
                   ,dec_clk
                   ,~dec_rst
                   ,dec_data
                 ,(tap_tdo === test_data[test_cntr][2]
                 & dec_data === test_data[test_cntr][5:7]
                 ));
                   
            if(tap_tdo === test_data[test_cntr][2]
                & dec_data === test_data[test_cntr][5:7]) 
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