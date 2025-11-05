`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 05:11:48 PM
// Design Name: 
// Module Name: Execute_Cycle
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


module EX_MEM(
    input clk, reset,
    // From ID_EX
    input RegWrite_E, ALUSrc_E, MemWrite_E, MemToReg_E, Branch_E, MemRead_E,
    input [31:0] Rd1_E, Rd2_E,
    input [4:0] Rd_E,
    input [3:0] ALUControl,
    input [31:0] intermediate,
    input [9:0] current_pc,
    
    // Data_Forwarding
    input [31:0] Result_W,    
    input [1:0] ForwardA, ForwardB,    
    
    
    output [9:0] PCTarget,
    output PCSrc,
    output reg [31:0] ALUResult_M,
    output reg RegWrite_M, MemWrite_M, MemToReg_M, MemRead_M,
    output reg [4:0] Rd_M,
    output reg [31:0] Rd2_M
);
    
    wire [31:0] SrcA, SrcB, SrcB_tmp;
    wire [31:0] ALUResult;

    mux3X1 srca_mux (
        .a(Rd1_E),
        .b(Result_W),
        .c(ALUResult_M),
        .sel(ForwardA),
        .data_out(SrcA)
    );
    
    mux3X1 srcb_mux (
        .a(Rd2_E),
        .b(Result_W),
        .c(ALUResult_M),
        .sel(ForwardB),
        .data_out(SrcB_tmp)
    );

    mux2X1 #(.DATA_BITS(32)) alu_mux (
        .a(SrcB_tmp),
        .b(intermediate),
        .sel(ALUSrc_E),
        .data_out(SrcB)
    );
    
    PC_Adder branch_adder (
        .a(current_pc),
        .b(intermediate),
        .result(PCTarget)
    );
    
    ALU alu_inst (
        .A(SrcA),
        .B(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );
    
    assign PCSrc = Zero & Branch_E;
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            ALUResult_M <= 32'b0;
            RegWrite_M <= 0;
            MemWrite_M <= 0;
            MemToReg_M <= 0;
            MemRead_M <= 0;
            Rd_M <= 4'b0;
        end else begin
            ALUResult_M <= ALUResult;
            RegWrite_M <= RegWrite_E ;
            MemWrite_M <= MemWrite_E ;
            MemToReg_M <= MemToReg_E ;
            MemRead_M  <= MemRead_E;
            Rd_M <= Rd_E;
            Rd2_M <= SrcB_tmp;
        end
    end

endmodule
