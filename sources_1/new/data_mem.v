`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2025 06:31:14 PM
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input clk, reset,
    input MemWrite, MemRead,
    input   [31:0] addr,
    input   [31:0] Write_Data,
    output  [31:0] Read_Data
    );
    
    reg [7:0] memory [0:1023]; // 1024 bytes = 1KB, max of memory can be 2^32 bytes
    integer k;
    
    always@(posedge clk or posedge reset) begin
        if (MemWrite) begin
            memory[addr]     <= Write_Data[7:0];
            memory[addr+1]   <= Write_Data[15:8];
            memory[addr+2]   <= Write_Data[23:16];
            memory[addr+3]   <= Write_Data[31:24];
        end
        else if (reset) begin
            for (k = 0;k<1024;k = k+ 1) begin
                memory[k] <= 8'b0000_0000;
            end
        end
    end
    
    assign Read_Data = (MemRead) ? 
                       {memory[addr+3], memory[addr+2], memory[addr+1], memory[addr]} :
                       32'h0000_0000;
endmodule
