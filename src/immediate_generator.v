`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 04:20:17 AM
// Design Name: 
// Module Name: immediate_generator
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


module immediate_generator(
    input wire [31:0] instruction,
    output reg [31:0] imm_out
    );
    
    wire [6:0] opcode;
    assign opcode = instruction [6:0];
    
    always @(*) begin
        case (opcode)
            7'b0000011,  
            7'b0010011, 
            7'b1100111:  
                imm_out = {{20{instruction[31]}}, instruction[31:20]};

          
            7'b0100011:  
                imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

         
            7'b1100011:  
                imm_out = {{19{instruction[31]}}, instruction[31], instruction[7],
                            instruction[30:25], instruction[11:8], 1'b0};  

           
            7'b0110111,  // LUI
            7'b0010111:  // AUIPC
                imm_out = {instruction[31:12], 12'b0}; 

            7'b1101111:  // JAL
                imm_out = {{11{instruction[31]}}, instruction[31], instruction[19:12],
                            instruction[20], instruction[30:21], 1'b0};

            default:
                imm_out = 32'b0;  
        endcase
    end


   endmodule
