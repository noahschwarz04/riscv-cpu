`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 04:37:28 AM
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input wire clk,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    input wire mem_read,
    input wire mem_write,
    output reg [31:0] read_data
    );
    
    reg [31:0] memory [0:255];
    
    
    always @(*) begin
        if (mem_read)
            read_data = memory[addr[9:2]];
        else
            read_data = 32'b0;
    end
    
    always @(posedge clk) begin
        if (mem_write)
            memory[addr[9:2]] <= write_data;
    end
endmodule
