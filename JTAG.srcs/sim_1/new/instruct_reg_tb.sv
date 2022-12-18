`timescale 1ns / 1ps

`define HALF_PERIOD 10

module instruct_reg_tb(
    output result
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

    
    //INSTRUCTION REG TEST
    logic [6:0] instruct_test_data_cntr;
    logic [0:12] instruct_test_data [0:64];
    logic [13:0] instruct_test_cntr;
    logic [13:0] instruct_test_true_cntr;
    
	always
		#(`HALF_PERIOD) clk = ~clk;
    
    initial begin	   
        $timeformat(-9, 0, "", 4);
        $readmemb("tap_instr_reg_test.mem", instruct_test_data);
        fd = $fopen("tap_instr_reg_test.log", "w");
        clk = 0;
        
        ////INSTRUCTION REG TEST
        instruct_test_data_cntr = 0;       
        instruct_test_cntr = 0;
        instruct_test_true_cntr = 0;
        
        #(`HALF_PERIOD*2);
        
        tap_tms = instruct_test_data[instruct_test_cntr][0];
        tap_tdi = instruct_test_data[instruct_test_cntr][5];
        instruct_test_cntr +=1;
        
        #(`HALF_PERIOD*2);
        
        $fwrite(fd, "               INST REG TEST                  ||\n");
        $fwrite(fd, "----------------------------------------------||\n");
        $fwrite(fd, " TEST| TIME |TMS|STATE|TDI|SHIFT|SAVE|OUT|true||\n");
	   
        while(instruct_test_data[instruct_test_cntr][0] !== 1'bx) begin
            tap_tms = instruct_test_data[instruct_test_cntr][0];
            tap_tdi = instruct_test_data[instruct_test_cntr][5];
            
            #(3);
            
            $fdisplay(fd, "%d| %t | %d |  %h  | %d |  %d  |  %d | %d |  %b ||", 
                   instruct_test_cntr, $realtime, tap_tms, 
                   tap.tap_control.state, tap.IR.data_i,
                   tap.IR.shift_reg, tap.IR.save_reg, tap.IR.data_o,
                  (tap.IR.data_i === tap_tdi &
                   tap.tap_control.state === instruct_test_data[instruct_test_cntr][1:4] &
                   tap.IR.shift_reg === instruct_test_data[instruct_test_cntr][6:8] &
                   tap.IR.save_reg === instruct_test_data[instruct_test_cntr][9:11] &
                   tap.IR.data_o === instruct_test_data[instruct_test_cntr][12]));
                   
            if(tap.IR.data_i === tap_tdi &
               tap.IR.shift_reg === instruct_test_data[instruct_test_cntr][6:8] &
               tap.IR.save_reg === instruct_test_data[instruct_test_cntr][9:11] &
               tap.IR.data_o === instruct_test_data[instruct_test_cntr][12]) 
                   instruct_test_true_cntr += 1;
            
            instruct_test_data_cntr += 1;
            instruct_test_cntr += 1;
            #(`HALF_PERIOD*2-3);
        end
        $fdisplay(fd, "%d COMPLETE, \t||", 
                    instruct_test_true_cntr);
        $fdisplay(fd, "%d ERRORS\t\t||", 
                    instruct_test_cntr-instruct_test_true_cntr-1);

        
        #10
        $fclose(fd);
        $stop;
		end

endmodule