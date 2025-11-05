`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 10:25:12 AM
// Design Name: 
// Module Name: Fetch_Cycle
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


module IF_ID(
    input clk, reset,
    input PCWrite, IF_ID_Write,
    input PCSrc,
    input [9:0] PCTarget,
    
    output reg [31:0] instruction_D,
    output reg [9:0] current_pc_D
);
    
// Declaring interim wires
wire [9:0] next_pc, pc_plus4;
wire [31:0] instr_wire;
wire [9:0] current_pc_wire;

    // mux before the PC block
    mux2X1 #(.DATA_BITS(10)) pc_mux (
        .a(pc_plus4),
        .b(PCTarget),
        .sel(PCSrc),
        .data_out(next_pc)
    );

    // Program Counter
    program_counter pc_inst (
        .clk(clk),
        .reset(reset),
        .PCWrite(PCWrite),
        .next_pc(next_pc),
        .current_pc(current_pc_wire)
    );   
    
    PC_Adder pc_add_inst (
        .a(current_pc_wire),
        .b(10'd4),
        .result(pc_plus4)
    ); 
    
    // Instruction Memory
    instruction_mem imem_inst (
        .reset(reset),
        .current_pc(current_pc_wire),
        .instr(instr_wire)
    );
    
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_D <= 32'b0;
            current_pc_D  <= 10'b0;
        end else if (IF_ID_Write) begin
            instruction_D <= instr_wire;
            current_pc_D  <= current_pc_wire;
        end
    end
endmodule
