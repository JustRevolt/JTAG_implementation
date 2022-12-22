`timescale 1ns / 1ps

`define HALF_PERIOD 10

module bsc_tb(
    output logic result
    ,output logic tb_end
    ); 
    
    integer fd;
    
    logic clk;
	
	logic shift;
	logic capture;
    logic update;
    logic test_mode;
    logic normal_mode;
    logic in_sys_data;
    logic in_test_data;
    logic out_test_data;
    logic out_sys_data;
	
    BSC BSC(
    .tck_i(clk),
    .shift_i(shift),
    .capture_i(capture),
    .update_i(update),
    .test_mode_i(test_mode),
    .normal_mode_i(normal_mode),
    .sys_data_i(in_sys_data),
    .test_data_i(in_test_data),
    .test_data_o(out_test_data),
    .sys_data_o(out_sys_data)
    );
    
    logic [0:9] test_data [0:64];
    logic [13:0] test_cntr;
    logic [13:0] test_true_cntr;
    
	always
		#(`HALF_PERIOD) clk = ~clk;
    
    initial begin
        $timeformat(-9, 0, "", 4);  
        $readmemb("tap_bsc_test.mem", test_data);
        fd = $fopen("tap_bsc_test.log", "w");
        clk = 0;
        
        tb_end = 0;
         
        test_cntr = 0;
        test_true_cntr = 0;
        
        #(`HALF_PERIOD*2);
        
        $fwrite(fd, "                                                 BSC TEST                                            ||\n");
        $fwrite(fd, "-----------------------------------------------------------------------------------------------------||\n");
        $fwrite(fd, " TEST| TIME |Capt|Shift|Upd|TESTmode|NORMALmode|inTESTdata|inSYSdata|SAVE|outTESTdata|outSYSdata|true||\n");
	   
        while(test_data[test_cntr][0] !== 1'bx) begin
            capture =       test_data[test_cntr][0];
            shift =         test_data[test_cntr][1];
            update =        test_data[test_cntr][2];

            test_mode =     test_data[test_cntr][3];
            normal_mode =   test_data[test_cntr][4];

            in_test_data =  test_data[test_cntr][5];
            in_sys_data =   test_data[test_cntr][6];
            
            #(`HALF_PERIOD+3);
            
            $fdisplay(fd, "%d| %t |  %b |  %b  | %b |    %b   |     %b    |    %b     |    %b    |  %b |     %b     |     %b    |  %b ||", 
                   test_cntr
                   ,$realtime 
                   ,capture
                   ,shift
                   ,update
                   ,test_mode
                   ,normal_mode
                   ,in_test_data
                   ,in_sys_data
                   ,BSC.save_reg
                   ,out_test_data
                   ,out_sys_data
                 ,(out_test_data === test_data[test_cntr][8]
                 & out_sys_data === test_data[test_cntr][9] 
                 & BSC.save_reg === test_data[test_cntr][7]
                 ));
                   
            if(out_test_data === test_data[test_cntr][8]
                 & out_sys_data === test_data[test_cntr][9] 
                 & BSC.save_reg === test_data[test_cntr][7]
                 ) 
                   test_true_cntr += 1;

            test_cntr += 1;
            #(`HALF_PERIOD-3);
        end
        $fdisplay(fd, "%d COMPLETE, \t||", 
                    test_true_cntr);
        $fdisplay(fd, "%d ERRORS\t\t||", 
                    test_cntr-test_true_cntr);
        
        if(test_cntr-test_true_cntr == 0) result = 1;
        else result = 0;
        
        #10
        $fclose(fd);
        tb_end = 1;
        //$stop;
		end

endmodule