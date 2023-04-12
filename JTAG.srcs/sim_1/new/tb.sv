`timescale 1ns / 1ps

module tb();

logic top_tb_res;

logic top_tb_end;

top_tb top(.result(top_tb_res), .tb_end(top_tb_end));

initial begin 
    #10;
    while(!(top_tb_end)) begin
            #20;
            end
    $stop;
end

endmodule