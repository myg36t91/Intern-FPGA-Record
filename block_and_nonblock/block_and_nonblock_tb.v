`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/25 07:49:22
// Design Name: 
// Module Name: block_and_nonblock_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module block_and_nonblock_tb();
    // input
    reg clk;
    reg reset;
    reg [7:0] in;
    // output
    wire [7:0] x;
    wire [7:0] y;
    wire [7:0] z;
    
    block_and_nonblock uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .x(x),
        .y(y),
        .z(z)
    );
    
    initial begin
        clk = 0;
        reset = 0;
        in = 0;
        #10;
        reset = 1;
        #10;
        reset = 0;
        #10;
        in = 2;
        #10;
        in = 4;
        #10;
        in = 6;
        #30
        in = 8;
    end
    
    always #5 clk = ~clk;
    
endmodule
