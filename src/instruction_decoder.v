`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 04:22:38 AM
// Design Name: 
// Module Name: instruction_decoder
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


module instruction_decoder(
    input wire [31:0] instruction,
    output wire [4:0] ra,
    output wire [4:0] rb,
    output wire [4:0] rd,
    output wire [6:0] opcode,
    output wire [2:0] funct3,
    output wire [6:0] funct7
   
    );
    
    assign ra = instruction [19:15];
    
    assign rb = instruction [24:20];
    
    assign rd = instruction [11:7];
    
    assign opcode = instruction [6:0];
    
    assign funct3 = instruction[14:12];
    
    assign funct7 = instruction [31:25];
endmodule
