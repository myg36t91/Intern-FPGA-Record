`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/25 06:56:05
// Design Name: 
// Module Name: accum_tb
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


module accum_tb ();
    // input
    reg clk;
    reg reset;
    reg [7:0] D;
    // output
    wire [7:0] Q;
    
    accum uut (
        .clk(clk),
        .reset(reset),
        .D(D),
        .Q(Q)
    );
    
    initial begin
        // init input
        clk = 0;
        reset = 0;
        D = 0;
        #10;
        reset = 1;
        #10;
        reset = 0;
        #10;
        D = 4;
        #10;
        D = 8;
        #20;
        D = 2;
    end
    
    always #5 clk = ~clk;
    
endmodule
