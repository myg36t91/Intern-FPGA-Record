`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/25 06:57:56
// Design Name: 
// Module Name: accum
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


module accum (
    input clk,
    input reset,
    input [7:0] D,
    output reg[7:0] Q
    ); 
 
 always@(posedge clk)begin
   if(reset)
     Q = 0;
   else
     Q = Q + D;
 end
    
endmodule
