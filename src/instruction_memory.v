`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 04:17:47 AM
// Design Name: 
// Module Name: instruction_memory
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

module instruction_memory(
    input wire [31:0] addr,
    output wire [31:0] instruction
);
    reg [31:0] memory [0:63];

    initial begin
        // I-Type Instructions
        memory[0]  = 32'h00500093; // ADDI x1, x0, 5
        memory[1]  = 32'h00a00113; // ADDI x2, x0, 10
        memory[2]  = 32'h00314193; // XORI x3, x2, 3
        memory[3]  = 32'h00516213; // ORI x4, x2, 5
        memory[4]  = 32'h00617293; // ANDI x5, x2, 6
        memory[5]  = 32'h00b1a313; // SLTI x6, x3, 11
        memory[6]  = 32'h0091a393; // SLTIU x7, x3, 9
        memory[7]  = 32'h00111413; // SLLI x8, x2, 1
        memory[8]  = 32'h00115493; // SRLI x9, x2, 1
        memory[9]  = 32'h40115513; // SRAI x10, x2, 1

        // R-Type Instructions
        memory[10] = 32'h002085B3;  // ADD x11, x1, x2 (5 + 10)
        memory[11] = 32'h40110633;  // SUB x12, x2, x1 (10 - 5) 
        memory[12] = 32'h0020F6B3;  // AND x13, x1, x2 (5 & 10)
        memory[13] = 32'h0020e733;  // OR x14, x1, x2 (5 | 10)
        memory[14] = 32'h0020C7B3;  // XOR x15, x1, x2 (5 ^ 10)
        memory[15] = 32'h0020A833;  // SLT x16, x1, x2 (5 < 10) 
        memory[16] = 32'h0020B8B3;  // SLTU x17, x1, x2 (5 < 10 unsigned) 
        memory[17] = 32'h000094B3;  // SLL x18, x1, x0 (5 << 0)
        memory[18] = 32'h0000D933;  // SRL x19, x2, x0 (10 >> 0)
        memory[19] = 32'h4000DA33;  // SRA x20, x2, x0 (10 >>> 0)

        
        // U-Type Instructions
        memory[20] = 32'h123450b7; // LUI x1, 0x12345
        memory[21] = 32'h00010117; // AUIPC x2, 0x10

        // J-Type Instructions
        memory[22] = 32'h008001ef; // JAL x3, 8
        memory[23] = 32'h3e800193; // ADDI x3, x0, 999 (should be skipped)
        memory[24] = 32'h06f00193; // ADDI x3, x0, 111 (should execute)

        // S-Type 
        memory[25] = 32'h00102023; // SW x1, 0(x0)

        // B-Type
        memory[26] = 32'h0010c463; // BEQ x1, x1, 8
        memory[27] = 32'h30900193; // ADDI x3, x0, 777 (skipped)
        memory[28] = 32'h0de00193; // ADDI x3, x0, 222 (executes)

        // Load Word
        memory[29] = 32'h00002183; // LW x3, 0(x0) 
    end

    assign instruction = memory[addr[31:2]];
endmodule
