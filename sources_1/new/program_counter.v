`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2025 08:11:34 PM
// Design Name: 
// Module Name: program_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Instruction fetch
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module program_counter(
    input clk, reset,
    input PCWrite,
    input [9:0] next_pc, //10 bit address space
    
    output reg [9:0] current_pc
);
    always@(posedge clk or posedge reset) begin
        if (reset)
            current_pc <= 10'b0;
        else if (PCWrite)
            current_pc <= next_pc;
    end
endmodule
