`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 04:13:55 AM
// Design Name: 
// Module Name: control_unit
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


module control_unit (
    input wire clk,
    input wire rst,
    input wire [6:0] opcode,
    input wire zero,

    output reg reg_write,
    output reg alu_src_a,
    output reg [1:0] alu_src_b,
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] result_src,
    output reg [1:0] alu_op,
    output reg pc_write,
    output reg ir_write,
    output reg [1:0] pc_src,
    
    output reg a_write,
    output reg b_write,
    output reg aluout_write,
    output reg mdr_write
);

    // FSM states
    parameter FETCH     = 3'b000;
    parameter DECODE    = 3'b001;
    parameter EXECUTE   = 3'b010;
    parameter MEMORY    = 3'b011;
    parameter WRITEBACK = 3'b100;

    reg [2:0] state, next_state;

   
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= FETCH;
        else
            state <= next_state;
    end

    
    always @(*) begin
        case (state)
            FETCH: next_state = DECODE;

            DECODE: begin
                case (opcode)
                    7'b0110011, 
                    7'b0010011, 
                    7'b0000011, 
                    7'b0100011, 
                    7'b1100011,
                    7'b1101111, 
                    7'b1100111, 
                    7'b0110111, 
                    7'b0010111: 
                        next_state = EXECUTE;
                    default: next_state = FETCH;
                endcase
            end

            EXECUTE: begin
                case (opcode)
                    7'b0000011, 
                    7'b0100011,
                    7'b1100011:
                        next_state = MEMORY;

                    7'b1101111, 
                    7'b1100111, 
                    7'b0110111, 
                    7'b0010111: 
                        next_state = WRITEBACK;

                    default: next_state = WRITEBACK;
                endcase
            end

            MEMORY: begin
                if (opcode == 7'b0000011)
                    next_state = WRITEBACK;
                else
                    next_state = FETCH;
            end

            WRITEBACK: next_state = FETCH;

            default: next_state = FETCH;
        endcase
    end

   
    always @(*) begin
        
        reg_write   = 0;
        alu_src_a   = 0;
        alu_src_b   = 2'b00;
        mem_read    = 0;
        mem_write   = 0;
        result_src  = 2'b00;
        alu_op      = 2'b00;
        pc_write    = 0;
        ir_write    = 0;
        pc_src      = 2'b00;
        
        a_write = 0;
        b_write = 0;
        aluout_write = 0;
        mdr_write = 0;

        case (state)
            FETCH: begin
                pc_write  = 1;
                ir_write  = 1;
                alu_src_a = 0;       
                alu_src_b = 2'b01;   
                alu_op    = 2'b00;    
                pc_src    = 2'b00;   
                
            end

            DECODE: begin
            
                a_write = 1;
                b_write = 1;
                
                alu_src_a = 0;        
                alu_src_b = 2'b11;    
                alu_op    = 2'b00;  
         
            end

            EXECUTE: begin
            
                aluout_write = 1;
                alu_src_a = (opcode == 7'b1100111 || opcode == 7'b0010111) ? 0 : 1;
                case (opcode)
                    7'b0110011: begin alu_src_b = 2'b00; alu_op = 2'b10; end
                    7'b0010011: begin alu_src_b = 2'b10; alu_op = 2'b11; end
                    7'b0000011,
                    7'b0100011,
                    7'b0010111: begin alu_src_b = 2'b10; alu_op = 2'b00; end
                    7'b1100011: begin alu_src_b = 2'b00; alu_op = 2'b01; end
                    7'b1101111,
                    7'b1100111: begin alu_src_b = 2'b01; alu_op = 2'b00; end
                    7'b0110111: begin alu_src_b = 2'b10; alu_op = 2'b00; end
                endcase
            end

            MEMORY: begin
            
                mdr_write = (opcode == 7'b0000011);
                
                if (opcode == 7'b0000011)
                    mem_read = 1;
                else if (opcode == 7'b0100011)
                    mem_write = 1;
                else if (opcode == 7'b1100011) begin
                    if (zero)
                        pc_src = 2'b01;
                    pc_write = zero;
                end
            end

            WRITEBACK: begin
                reg_write = 1;
                case (opcode)
                    7'b0000011: result_src = 2'b01; 
                    7'b1101111,
                    7'b1100111: begin result_src = 2'b10; 
                        pc_write = 1; 
                        pc_src = (opcode == 7'b1101111) ? 2'b10 : 2'b11; 
                         end 
                    7'b0110111,
                    7'b0010111: result_src = 2'b00; 
                    default: result_src = 2'b00; 
                endcase
            end
        endcase
    end

endmodule
