`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2025 05:34:12 PM
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(
    input reset, RegWrite_M, RegWrite_W,
    input [4:0] Rd_M, Rd_W, Rs1_E, Rs2_E,
    output [1:0] ForwardA, ForwardB
);
    
    assign ForwardA = (reset) ? 2'b00 : 
                    ((RegWrite_W) & (Rd_W != 0) &(Rd_W == Rs1_E)) ? 2'b01 :
                    ((RegWrite_M) & (Rd_M != 0) &(Rd_M == Rs1_E)) ? 2'b10 : 2'b00;
   
    assign ForwardB = (reset) ? 2'b00 : 
                    ((RegWrite_W) & (Rd_W != 0) &(Rd_W == Rs2_E)) ? 2'b01 :
                    ((RegWrite_M) & (Rd_M != 0) &(Rd_M == Rs2_E)) ? 2'b10 : 2'b00;
endmodule
