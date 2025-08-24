`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 04:21:19 AM
// Design Name: 
// Module Name: register
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


module register(
    input wire clk,
    input wire regwrite,
    input wire [4:0] ra,
    input wire [4:0] rb,
    input wire [4:0] rd,
    input wire [31:0] writedata,
    output wire [31:0] read_datab,
    output wire [31:0] read_dataa
    
);
    reg [31:0] registers[0:31];

    
    assign read_dataa = (ra == 0) ? 32'b0 : registers[ra];
    assign read_datab = (rb == 0) ? 32'b0 : registers[rb];

    always @(posedge clk) begin
        if (regwrite && rd != 0) begin
            registers[rd] <= writedata;
        end
    end
endmodule
