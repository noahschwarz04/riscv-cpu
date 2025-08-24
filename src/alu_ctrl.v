`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 04:11:12 AM
// Design Name: 
// Module Name: alu_ctrl
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


module alu_ctrl(
    input wire [1:0] alu_op,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [3:0] alu_control
);
    always @(*) begin
        case (alu_op)
            // Load/Store: use ADD
            2'b00: alu_control = 4'b0010;

            // Branch: use SUB
            2'b01: alu_control = 4'b0110;

            // R-type instructions
            2'b10: begin
                case ({funct7, funct3})
                    10'b0000000000: alu_control = 4'b0010; // ADD
                    10'b0100000000: alu_control = 4'b0110; // SUB
                    10'b0000000111: alu_control = 4'b0000; // AND
                    10'b0000000110: alu_control = 4'b0001; // OR
                    10'b0000000100: alu_control = 4'b0011; // XOR
                    10'b0000000001: alu_control = 4'b1000; // SLL
                    10'b0000000101: alu_control = 4'b1001; // SRL
                    10'b0100000101: alu_control = 4'b1010; // SRA
                    10'b0000000010: alu_control = 4'b0111; // SLT
                    10'b0000000011: alu_control = 4'b1100; // SLTU

                    10'b0000001000: alu_control = 4'b1011; // MUL
                    10'b0000001100: alu_control = 4'b1101; // DIV
                    10'b0000001110: alu_control = 4'b1110; // REM
                    default: alu_control = 4'b0000;
                endcase
            end

            // I-type ALU instructions
            2'b11: begin
                case (funct3)
                    3'b000: alu_control = 4'b0010; // ADDI
                    3'b010: alu_control = 4'b0111; // SLTI
                    3'b011: alu_control = 4'b1100; // SLTIU
                    3'b100: alu_control = 4'b0011; // XORI
                    3'b110: alu_control = 4'b0001; // ORI
                    3'b111: alu_control = 4'b0000; // ANDI
                    3'b001: alu_control = 4'b1000; // SLLI
                    3'b101: begin
                        if (funct7 == 7'b0000000) alu_control = 4'b1001; // SRLI
                        else if (funct7 == 7'b0100000) alu_control = 4'b1010; // SRAI
                        else alu_control = 4'b0000;
                    end
                    default: alu_control = 4'b0000;
                endcase
            end

            default: alu_control = 4'b0000;
        endcase
    end
endmodule
