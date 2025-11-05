`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 12:01:17 AM
// Design Name: 
// Module Name: Register_File
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


module Register_File(
    input clk, reset,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] WriteReg,
    input RegWrite,
    input [31:0] WriteData,
    
    output [31:0] Read_Data1, Read_Data2
);

reg [31:0] register [31:0];
integer k;

assign Read_Data1 = (reset == 1) ? 32'h0 : register[rs1];
assign Read_Data2 = (reset == 1) ? 32'h0 : register[rs2];    

always@(posedge reset or posedge clk) begin
    if (reset) begin
        for (k = 0; k < 32; k = k + 1) begin
            register[k] = 32'b0;
        end    
    end else if (RegWrite && (WriteReg != 5'h0)) begin
        register[WriteReg] <= WriteData;
    end 
end

endmodule
