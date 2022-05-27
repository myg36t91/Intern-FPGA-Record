`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/21 03:33:24
// Design Name: 
// Module Name: block_and_nonblock
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


module block_and_nonblock (
    input clk,
    input reset,
    input [7:0] in,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg [7:0] z
    );
 
    always @ (posedge clk) begin
        if (reset) begin
            x = 0;
            y = 0;
            z = 0;
        end
        else begin
            // Non-blocking Assignment
            x <= in + 1; 
            y <= x + 1;
            z <= y + 1;
            // Blocking Assignment
            x = in + 1; 
            y = x + 1;
            z = y + 1;
        end
    end
 
endmodule
