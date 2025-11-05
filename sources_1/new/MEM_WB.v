`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gia Bao Duong
// 
// Create Date: 11/03/2025 05:56:05 PM
// Design Name: 
// Module Name: MEM_WB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This Code was Written by Duong Gia Bao
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MEM_WB(
    input clk, reset, 
    input RegWrite_M, MemWrite_M, MemToReg_M, MemRead_M,
    input [31:0] ALUResult_M,
    input [31:0] Rd2_M,
    input [4:0] Rd_M,
    
    output reg [31:0] Read_Data,
    output reg [31:0] ALUResult_W, 
    output reg [4:0] Rd_W,
    output reg MemToReg_W, RegWrite_W
    
);

    wire [31:0] Read_Data_wire;
    
    data_mem dmen_inst (
        .clk(clk),
        .reset(reset),
        .MemRead(MemRead_M),
        .MemWrite(MemWrite_M),
        .addr(ALUResult_M),
        .Write_Data(Rd2_M),
        .Read_Data(Read_Data_wire)
    );
    
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            Read_Data <= 32'b0;
            ALUResult_W <= 32'b0;
            MemToReg_W <= 1'b0;
            RegWrite_W <= 1'b0;
            Rd_W <= 5'b0;
        end else begin
            Read_Data <= Read_Data_wire;
            ALUResult_W <= ALUResult_M;
            Rd_W <= Rd_M;
            MemToReg_W <= MemToReg_W;
            RegWrite_W <= RegWrite_M;
        end
    end
endmodule
