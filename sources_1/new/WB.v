`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2025 06:58:48 PM
// Design Name: 
// Module Name: WB
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


module WB(
    input [31:0] ALUResult_W,
    input [31:0] Read_Data,
    input MemToReg_W,
    output [31:0] Write_Data
);


mux2X1 #(.DATA_BITS(32)) result_mux  (
    .a(ALUResult_W),
    .b(Read_Data),
    .sel(MemToReg_W),
    .data_out(Write_Data)
);


endmodule
