`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 04:20:49 AM
// Design Name: 
// Module Name: pc
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


module pc(

    input wire clk,
    input wire rst,
    input wire pc_write_en,
    input wire [31:0] pc_next,
    output reg [31:0] pc // current pc value
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'h00000000;
         else if (pc_write_en)
            pc <= pc_next;
    end
    
endmodule
