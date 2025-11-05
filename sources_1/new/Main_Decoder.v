`timescale 1ns / 1ps
`include "defines.vh"

module Main_Decoder(
    input  [6:0]  opcode,
    output RegWrite,
    output ALUSrc,
    output MemWrite,
    output MemToReg,
    output Branch,
    output MemRead,
    output [2:0] ALUOp
);

    assign {MemWrite, RegWrite, Branch, MemRead, ALUSrc, MemToReg} =  
        (opcode == `OPCODE_LOAD)      ? {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1} :         // Load
        (opcode == `OPCODE_I_TYPE)    ? {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0} :       // ADDI, ANDI, ORI, ...
        (opcode == `OPCODE_STORE)     ? {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'bx} :         // Store
        (opcode == `OPCODE_R_TYPE)    ? {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0} :         // R-type
        (opcode == `OPCODE_BRANCH)    ? {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0} :         // Branch
                                         6'b000_000;
    
    assign ALUOp =  (opcode == `OPCODE_LOAD)    ? 3'b000 :
                    (opcode == `OPCODE_I_TYPE)  ? 3'b001 :
                    (opcode == `OPCODE_STORE)   ? 3'b011 :
                    (opcode == `OPCODE_R_TYPE)  ? 3'b100 :
                    (opcode == `OPCODE_BRANCH)  ? 3'b101 :  3'b111;
endmodule
