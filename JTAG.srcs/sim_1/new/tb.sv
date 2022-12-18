`timescale 1ns / 1ps

module tb();

logic tap_control_tb_res;
logic instruct_reg_tb_res; 
logic inst_decode_tb_res;
logic device_id_tb_res;
logic bypass_tb_res;

tap_control_tb tap_controller(.result(tap_control_tb_res));
//instruct_reg_tb instruct_reg(.result(instruct_reg_tb_res)); 
//inst_decode_tb decode(.result(inst_decode_tb_res));
//device_id_tb device_id(.result(device_id_tb_res));
//bypass_tb bypass(.result(bypass_tb_res));


endmodule