`timescale 1ns / 1ps

module Moore_machine(
    input rst
   ,input clk
   ,input logic [3:0] data_i
   ,output logic [3:0] data_o
    );
    
    logic [3:0] state;
    
    assign data_o = state;

    always@ (posedge clk or posedge rst) begin
        if(rst) state = 'b0000;
        else begin
            case(state)
                'b0000: begin
                    if(data_i == 'b0000) state = 'b0010;
                    else if(data_i == 'b0001) state = 'b0010;
                    else if(data_i == 'b1000) state = 'b0110;
                    else if(data_i == 'b1001) state = 'b1010;
                    else if(data_i == 'b1101) state = 'b1010;
                    else if(data_i == 'b1111) state = 'b1101;
                end
                'b0001: begin
                    if(data_i == 'b1111) state = 'b0000;
                    else if(data_i == 'b1011) state = 'b0101;
                    else if(data_i == 'b1100) state = 'b1000; // true data_i 1100
                    else if(data_i == 'b0010) state = 'b1011;
                end
                'b0010: begin
                    if(data_i == 'b1011) state = 'b0001;
                    else if(data_i == 'b1111) state = 'b0011;
                    else if(data_i == 'b0110) state = 'b0110;
                    else if(data_i == 'b0000) state = 'b1001;
                    else if(data_i == 'b0010) state = 'b1001;
                    else if(data_i == 'b1100) state = 'b1110;
                end
                'b0011: begin
                    if(data_i == 'b1010) state = 'b0100;
                    else if(data_i == 'b0110) state = 'b1111;
                end
                'b0100: begin
                    if(data_i == 'b1111) state = 'b0001;
                    else if(data_i == 'b0001) state = 'b0111;
                    else if(data_i == 'b0101) state = 'b1100;
                end
                'b0101: begin
                    if(data_i == 'b1100) state = 'b0000;
                    else if(data_i == 'b0011) state = 'b0010;
                    else if(data_i == 'b1111) state = 'b0100;
                    else if(data_i == 'b0010) state = 'b1001;
                end
                'b0110: begin
                    if(data_i == 'b0001) state = 'b0001;
                    else if(data_i == 'b0010) state = 'b0101;
                    else if(data_i == 'b0011) state = 'b1000;
                    else if(data_i == 'b1001) state = 'b1011;
                    else if(data_i == 'b1111) state = 'b1110;
                    else if(data_i == 'b1110) state = 'b1111;
                end
                'b0111: begin
                    if(data_i == 'b0000) state = 'b0000;
                    else if(data_i == 'b1100) state = 'b0010;
                    else if(data_i == 'b1110) state = 'b0010;
                    else if(data_i == 'b0101) state = 'b0101;
                    else if(data_i == 'b1010) state = 'b1001;
                    else if(data_i == 'b0011) state = 'b1010;
                    else if(data_i == 'b1101) state = 'b1011;
                end
                'b1000: begin
                    if(data_i == 'b1010) state = 'b0001;
                    else if(data_i == 'b1101) state = 'b0011;
                    else if(data_i == 'b0011) state = 'b0111;
                    else if(data_i == 'b0010) state = 'b1101;
                    else if(data_i == 'b1011) state = 'b1111;
                end
                'b1001: begin
                    if(data_i == 'b0000) state = 'b0100;
                    else if(data_i == 'b0001) state = 'b0110;
                    else if(data_i == 'b1110) state = 'b1100;
                    else if(data_i == 'b1010) state = 'b1110;
                end
                'b1010: begin
                    if(data_i == 'b0011) state = 'b0010;
                    else if(data_i == 'b1111) state = 'b0101;
                    else if(data_i == 'b1010) state = 'b1000;
                    else if(data_i == 'b0001) state = 'b1101;
                end
                'b1011: begin
                    if(data_i == 'b1010) state = 'b0001;
                    else if(data_i == 'b0101) state = 'b0100;
                    else if(data_i == 'b1101) state = 'b1000;
                    else if(data_i == 'b1001) state = 'b1110;
                end
                'b1100: begin
                    if(data_i == 'b1110) state = 'b0011;
                    else if(data_i == 'b1001) state = 'b0110;
                    else if(data_i == 'b1010) state = 'b1001;
                    else if(data_i == 'b0000) state = 'b1110;
                    else if(data_i == 'b1111) state = 'b1111;
                end
                'b1101: begin
                    if(data_i == 'b0010) state = 'b0000;
                    else if(data_i == 'b0101) state = 'b0010;
                    else if(data_i == 'b1000) state = 'b0011;
                    else if(data_i == 'b1001) state = 'b0011;
                    else if(data_i == 'b1010) state = 'b0011;
                    else if(data_i == 'b1011) state = 'b0011;
                end
                'b1110: begin
                    if(data_i == 'b1111) state = 'b0001;
                    else if(data_i == 'b1101) state = 'b0100;
                    else if(data_i == 'b1100) state = 'b1010;
                end
                'b1111: begin
                    if(data_i == 'b1100) state = 'b0011;
                    else if(data_i == 'b1010) state = 'b0110;
                    else if(data_i == 'b0000) state = 'b1010;
                    else if(data_i == 'b1111) state = 'b1101;
                end
            endcase
        end
    end
    
    
endmodule
