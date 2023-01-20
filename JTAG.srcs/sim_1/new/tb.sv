`timescale 1ns / 1ps

module tb();

logic tap_control_tb_res;
logic instruct_reg_tb_res; 
logic inst_decode_tb_res;
logic device_id_tb_res;
logic bypass_tb_res;
logic bsc_tb_res;
logic top_tb_res;

logic tap_control_tb_end;
logic instruct_reg_tb_end; 
logic inst_decode_tb_end;
logic device_id_tb_end;
logic bypass_tb_end;
logic bsc_tb_end;
logic top_tb_end;

tap_control_tb tap_controller(.result(tap_control_tb_res), .tb_end(tap_control_tb_end));
instruct_reg_tb instruct_reg(.result(instruct_reg_tb_res), .tb_end(instruct_reg_tb_end)); 
inst_decode_tb decode(.result(inst_decode_tb_res), .tb_end(inst_decode_tb_end));
device_id_tb device_id(.result(device_id_tb_res), .tb_end(device_id_tb_end));
bypass_tb bypass(.result(bypass_tb_res), .tb_end(bypass_tb_end));
bsc_tb bsc(.result(bsc_tb_res), .tb_end(bsc_tb_end));
top_tb top(.result(top_tb_res), .tb_end(top_tb_end));

initial begin 
    #10;
    while(!(tap_control_tb_end & instruct_reg_tb_end 
            & inst_decode_tb_end & device_id_tb_end 
            & bypass_tb_end & bsc_tb_end & top_tb_end)) begin
            #20;
            end
    $stop;
end

endmodule