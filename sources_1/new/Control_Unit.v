`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 12:50:37 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input [6:0] opcode,
    input [6:0] funct7,
    input [2:0] funct3,
    
    output RegWrite, ALUSrc, MemWrite, MemToReg, Branch, MemRead,
    output [3:0] ALUControl
);
    
wire [2:0] ALUOp;
    
    // Main decoder
    Main_Decoder cu_decoder_inst (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .MemRead(MemRead),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp)
    );
    
    // ALU Control
    ALU_Control alu_ctrl_inst(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );
endmodule
