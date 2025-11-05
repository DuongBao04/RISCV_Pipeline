`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 01:40:25 PM
// Design Name: 
// Module Name: Decode_Cycle
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

`include "defines.vh"
module ID_EX(
    input clk, reset, 
    input ID_EX_Flush,
    input [31:0] instruction_D,
    input [9:0] current_pc_D,
    
    // Signal from WriteBack
    input [31:0] Result_W,
    input RegWrite_W,
    input [4:0] Rd_W,
    
    output reg RegWrite_E, ALUSrc_E, MemWrite_E, MemToReg_E, Branch_E, MemRead_E,
    output reg [31:0] Rd1_E, Rd2_E,
    output reg [3:0] ALUControl,
    output reg [31:0] intermediate,
    output reg [4:0] Rd_E, Rs1_E, Rs2_E,
    output reg [9:0] current_pc_E
);

    wire RegWrite_wire;
    wire ALUSrc_wire;
    wire MemWrite_wire;
    wire MemToReg_wire;
    wire Branch_wire, MemRead_wire;
    
    wire [31:0] Read_Data1;
    wire [31:0] Read_Data2;
    wire [3:0]  ALUControl_wire;
    wire [31:0] intermediate_wire;

    // Register File
    Register_File register_inst (
        .clk(clk), .reset(reset), .rs1(instruction_D[19:15]),
        .rs2(instruction_D[24:20]), .WriteReg(Rd_W),
        .WriteData(Result_W), .RegWrite(RegWrite_W),
        .Read_Data1(Read_Data1), .Read_Data2(Read_Data2)
    );
    
    // Control Unit
    Control_Unit cu_inst (
        .opcode(instruction_D[6:0]),
        .funct3(instruction_D[14:12]),
        .funct7(instruction_D[31:25]),
        
        .RegWrite(RegWrite_wire),
        .ALUControl(ALUControl_wire),
        .ALUSrc(ALUSrc_wire),
        .MemWrite(MemWrite_wire),
        .MemToReg(MemToReg_wire),
        .Branch(Branch_wire),
        .MemRead(MemRead_wire)
    );
    
    Imm_Gen imm_gen_inst (
        .instruction(instruction_D[31:0]),
        .immediate(intermediate_wire)
    );
    
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_E     <= 0;
            ALUSrc_E       <= 0;
            MemWrite_E     <= 0;
            MemToReg_E     <= 0;
            Branch_E       <= 0;
            ALUControl     <= `NOP;
            Rd_E           <= 5'b0;
            Rs1_E          <= 5'b0;
            Rs2_E          <= 5'b0;

            Rd1_E   <= 32'b0;
            Rd2_E   <= 32'b0;
            intermediate <= 32'b0;
            
            current_pc_E <= 10'b0;
        end else if (ID_EX_Flush) begin
            RegWrite_E     <= 1'b0   ;
            ALUSrc_E       <= 1'b0   ;
            MemWrite_E     <= 1'b0   ;
            MemToReg_E     <= 1'b0   ;
            Branch_E       <= 1'b0   ;
            MemRead_E      <= 1'b0   ;
            ALUControl     <= `NOP   ;
        end else begin
            RegWrite_E     <= RegWrite_wire   ;
            ALUSrc_E       <= ALUSrc_wire     ;
            MemWrite_E     <= MemWrite_wire   ;
            MemToReg_E     <= MemToReg_wire   ;
            Branch_E       <= Branch_wire     ;
            MemRead_E      <= MemRead_wire    ;
            ALUControl   <= ALUControl_wire   ;
            Rd1_E   <= Read_Data1   ;
            Rd2_E   <= Read_Data2   ;
            intermediate <= intermediate_wire ;
            Rd_E           <= instruction_D[11:7] ;
            Rs1_E          <= instruction_D[19:15];
            Rs2_E          <= instruction_D[24:20];
            current_pc_E <= current_pc_D;
        end
    
    end
    
    
endmodule
