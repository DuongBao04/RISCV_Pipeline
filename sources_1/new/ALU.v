`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 11:07:04 PM
// Design Name: 
// Module Name: ALU
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
module ALU(
    input  [31:0] A, B,
    input  [3:0]  ALUControl,
  
    output [31:0] ALUResult,
    output Zero
);

    wire [31:0] and_result;
    wire [31:0] or_result;
    wire [31:0] add_result;
    wire [31:0] sub_result;
    wire [31:0] xor_result;
    wire [31:0] lls_result;
    wire [31:0] lrs_result;
    wire [31:0] ars_result;
    
    assign and_result   = A & B;
    assign or_result    = A | B;
    assign add_result   = A + B;
    assign xor_result   = A ^ B;
    assign lls_result   = A << B;
    assign lrs_result   = A >> B;
    assign ars_result = $signed(A) >>> B; 
    assign {Cout, sub_result} = {1'b0, A} + ~{1'b0, B} + 1'b1; //2's Complement
    

    assign ALUResult  = (ALUControl == `ALU_AND) ? and_result :
                      (ALUControl == `ALU_OR) ? or_result :
                      (ALUControl == `ALU_ADD) ? add_result :
                      (ALUControl == `ALU_XOR) ? xor_result :
                      (ALUControl == `ALU_SUB) ? sub_result :
                      (ALUControl == `ALU_LSHIFT_LEFT) ? lls_result :
                      (ALUControl == `ALU_LSHIFT_RIGHT) ? lrs_result :
                      (ALUControl == `ALU_ASHIFT_RIGHT) ? ars_result : 32'h0000_0000;
    assign Zero  = (sub_result == 0) ? 1'b1 : 1'b0;
    

endmodule
