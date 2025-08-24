`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 04:23:10 AM
// Design Name: 
// Module Name: cpu
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


module cpu (
    input wire clk,
    input wire rst
);

    
    wire PCWrite, IRWrite, MemRead, MemWrite, RegWrite;
    wire ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [1:0] PCSource;
    wire [1:0] ALUOp;
    wire [1:0] ResultSrc;

    
    wire [31:0] pc;
    wire [31:0] pc_next;
    wire pc_write_en;

    assign pc_write_en = PCWrite;

    
    wire [31:0] alu_result;
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire zero, carryout, negative, overflow;

    
    reg [31:0] IR;
    wire [4:0] rs1, rs2, rd;
    wire [2:0] funct3;
    wire [6:0] opcode, funct7;

    
    wire [31:0] reg_data_a, reg_data_b;
    reg [31:0] A, B;
    wire [31:0] write_data;

    
    wire [31:0] imm;

    
    wire [3:0] alu_ctrl;

    
    reg [31:0] ALUOut;
    reg [31:0] MDR;

    
    wire [31:0] instr_mem_out;

    
    wire [31:0] mem_data;
    
    wire Awrite, Bwrite, aluoutwrite, MDRwrite;

    
    assign pc_next = (PCSource == 2'b00) ? alu_result :
                     (PCSource == 2'b01) ? ALUOut :
                                           pc;

    
    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_write_en(pc_write_en),
        .pc_next(pc_next),
        .pc(pc)
    );

    
    instruction_memory imem (
        .addr(pc),
        .instruction(instr_mem_out)
    );

    
    instruction_decoder decoder (
        .instruction(IR),
        .ra(rs1),
        .rb(rs2),
        .rd(rd),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7)
    );

    
    register regfile (
        .clk(clk),
        .regwrite(RegWrite),
        .ra(rs1),
        .rb(rs2),
        .rd(rd),
        .writedata(write_data),
        .read_dataa(reg_data_a),
        .read_datab(reg_data_b)
    );

    
    immediate_generator imm_gen (
        .instruction(IR),
        .imm_out(imm)
    );

    
    alu_ctrl alu_cntrl (
        .alu_op(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_ctrl)
    );

    
    assign alu_a = (ALUSrcA) ? A : pc;
    assign alu_b = (ALUSrcB == 2'b00) ? B :
                   (ALUSrcB == 2'b01) ? 32'd4 :
                   (ALUSrcB == 2'b10) ? imm :
                   32'd0;

    
    alu alu_unit (
        .a(alu_a),
        .b(alu_b),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero),
        .carryout(carryout),
        .negative(negative),
        .overflow(overflow)
    );

    
    control_unit ctrl (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .zero(zero),
        .pc_write(PCWrite),
        .ir_write(IRWrite),
        .mem_read(MemRead),
        .mem_write(MemWrite),
        .reg_write(RegWrite),
        .alu_src_a(ALUSrcA),
        .alu_src_b(ALUSrcB),
        .pc_src(PCSource),
        .alu_op(ALUOp),
        .result_src(ResultSrc),
        .a_write(Awrite),
        .b_write(Bwrite),
        .aluout_write(aluoutwrite),
        .mdr_write(MDRwrite)
    );

    
    data_memory dmem (
        .clk(clk),
        .addr(ALUOut),
        .write_data(B),
        .mem_read(MemRead),
        .mem_write(MemWrite),
        .read_data(mem_data)
    );

    
    assign write_data = (ResultSrc == 2'b00) ? ALUOut :
                        (ResultSrc == 2'b01) ? MDR :
                        (ResultSrc == 2'b10) ? pc :
                        32'b0;

    
    always @(posedge clk) begin
        if (IRWrite)
            IR <= instr_mem_out;
        if (Awrite)
            A <= reg_data_a;
        if (Bwrite) 
            B <= reg_data_b;
        if (aluoutwrite)
            ALUOut <= alu_result;
        if (MDRwrite)
            MDR <= mem_data;

        
    end

    
    always @(posedge clk) begin
        $display("Time=%0t | State=CPU | PC=0x%08h | IR=0x%08h | rs1=%0d rs2=%0d rd=%0d | A=%0d B=%0d | ALUOut=%0d | MDR=%0d",
            $time,
            pc,
            IR,
            rs1, rs2, rd,
            A, B,
            ALUOut,
            MDR
        );
    end

endmodule
