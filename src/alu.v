`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 04:10:50 AM
// Design Name: 
// Module Name: alu
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


module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] alu_ctrl,
    output reg [31:0] result,
    output reg zero,
    output reg negative,
    output reg carryout,
    output reg overflow
);

    reg [32:0] temp;

    always @(*) begin
        carryout = 0;
        overflow = 0;

        case (alu_ctrl)
            4'b0000: result = a & b;                      // AND
            4'b0001: result = a | b;                      // OR
            4'b0010: begin                                // ADD
                temp = {1'b0, a} + {1'b0, b};
                result = temp[31:0];
                carryout = temp[32];
                overflow = (a[31] == b[31]) && (result[31] != a[31]);
            end
            4'b0110: begin                                // SUB
                temp = {1'b0, a} - {1'b0, b};
                result = temp[31:0];
                carryout = temp[32];
                overflow = (a[31] != b[31]) && (result[31] != a[31]);
            end
            4'b0111: result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;     // SLT (signed)
            4'b1100: result = ($unsigned(a) < $unsigned(b)) ? 32'b1 : 32'b0; // SLTU (unsigned)
            4'b0011: result = a ^ b;                       // XOR
            4'b1000: result = a << b[4:0];                 // SLL
            4'b1001: result = a >> b[4:0];                 // SRL 
            4'b1010: result = $signed(a) >>> b[4:0];       // SRA 
            4'b1011: result = a * b;                       // MUL
            4'b1101: result = (b != 0) ? a / b : 32'b0;    // DIV
            4'b1110: result = (b != 0) ? a % b : 32'b0;    // REM

            default: result = 32'b0;
        endcase

        zero = (result == 0);
        negative = result[31];
    end
endmodule
