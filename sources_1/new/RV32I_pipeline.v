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
//////////////////////////////////////////////////////////////////////////////////

module RV32I_pipeline(
    input clk, reset
);

// =====================
// Program Counter wires
// =====================
wire PCSrc;
wire [9:0] PCTarget, current_pc;
wire [31:0] instruction;

// =====================
// Fetch -> Decode wires
// =====================
wire [31:0] instruction_D;
wire [9:0] current_pc_D;

// =====================
// Decode -> Execute wires
// =====================
wire RegWrite_E, ALUSrc_E, MemWrite_E, MemToReg_E, Branch_E, MemRead_E;
wire [31:0] Rd1_E, Rd2_E, intermediate;
wire [4:0] Rd_E;
wire [3:0] ALUControl;
wire [9:0] current_pc_E;

// =====================
// Execute -> Memory wires
// =====================
wire RegWrite_M, MemWrite_M, MemToReg_M, MemRead_M;
wire [31:0] ALUResult_M;
wire [31:0] Rd2_M;
wire [4:0] Rd_M;

// =====================
// Memory -> Writeback wires
// =====================
wire [31:0] Read_Data;
wire [31:0] ALUResult_W;
wire [4:0] Rd_W;
wire MemToReg_W, RegWrite_W;
wire [31:0] Result_W; // From WriteBack mux output

// =====================
// Forwarding and hazard control wires
// =====================
wire [1:0] ForwardA, ForwardB;
wire [4:0] Rs1_E, Rs2_E;
wire IF_ID_Write, PCWrite, ID_EX_Flush;

// =====================
// Instruction Fetch stage
// =====================
IF_ID Fetch (
    .clk(clk),
    .reset(reset),
    .PCWrite(PCWrite),
    .IF_ID_Write(IF_ID_Write),
    .PCSrc(PCSrc),
    .PCTarget(PCTarget),
    .instruction_D(instruction_D),
    .current_pc_D(current_pc_D)
); 

// =====================
// Instruction Decode stage
// =====================
ID_EX Decode (
    .clk(clk),
    .reset(reset),
    .ID_EX_Flush(ID_EX_Flush),
    .instruction_D(instruction_D),
    .current_pc_D(current_pc_D),
    
    .Result_W(Result_W),
    .RegWrite_W(RegWrite_W),
    .Rd_W(Rd_W),

    .RegWrite_E(RegWrite_E), 
    .ALUSrc_E(ALUSrc_E), 
    .MemWrite_E(MemWrite_E), 
    .MemToReg_E(MemToReg_E), 
    .Branch_E(Branch_E), 
    .MemRead_E(MemRead_E),

    .Rd1_E(Rd1_E), 
    .Rd2_E(Rd2_E),
    .Rd_E(Rd_E),
    .Rs1_E(Rs1_E),
    .Rs2_E(Rs2_E),
    .intermediate(intermediate),
    .ALUControl(ALUControl),
    .current_pc_E(current_pc_E)
);

// =====================
// Execute stage
// =====================
EX_MEM Execute (
    .clk(clk),
    .reset(reset),
    .RegWrite_E(RegWrite_E), 
    .ALUSrc_E(ALUSrc_E), 
    .MemWrite_E(MemWrite_E), 
    .MemToReg_E(MemToReg_E), 
    .Branch_E(Branch_E), 
    .MemRead_E(MemRead_E),
    .Rd1_E(Rd1_E), 
    .Rd2_E(Rd2_E),
    .Rd_E(Rd_E),
    .intermediate(intermediate),
    .ALUControl(ALUControl),
    .current_pc(current_pc_E),

    // forwarding
    .ForwardA(ForwardA),
    .ForwardB(ForwardB),
    .Result_W(Result_W),
    
    .RegWrite_M(RegWrite_M), 
    .MemWrite_M(MemWrite_M), 
    .MemToReg_M(MemToReg_M), 
    .MemRead_M(MemRead_M),
    .ALUResult_M(ALUResult_M),
    .Rd_M(Rd_M),
    .Rd2_M(Rd2_M),
    .PCSrc(PCSrc),
    .PCTarget(PCTarget)
);

// =====================
// Memory stage
// =====================
MEM_WB Mem (
    .clk(clk),
    .reset(reset),
    .RegWrite_M(RegWrite_M), 
    .MemWrite_M(MemWrite_M), 
    .MemToReg_M(MemToReg_M), 
    .MemRead_M(MemRead_M),
    .ALUResult_M(ALUResult_M),
    .Rd_M(Rd_M),
    .Rd2_M(Rd2_M),

    .Read_Data(Read_Data),
    .ALUResult_W(ALUResult_W),
    .Rd_W(Rd_W),
    .MemToReg_W(MemToReg_W),
    .RegWrite_W(RegWrite_W)
);

// =====================
// Writeback stage
// =====================
mux2X1 #(.DATA_BITS(32)) WriteBack (
    .a(ALUResult_W),
    .b(Read_Data),
    .sel(MemToReg_W),
    .data_out(Result_W)
);

// =====================
// Forwarding Unit
// =====================
forwarding_unit fu_inst (
    .reset(reset),
    .RegWrite_M(RegWrite_M),
    .RegWrite_W(RegWrite_W),
    .Rd_M(Rd_M), 
    .Rd_W(Rd_W), 
    .Rs1_E(Rs1_E), 
    .Rs2_E(Rs2_E),
    .ForwardA(ForwardA), 
    .ForwardB(ForwardB)
);

// =====================
// Hazard Detection Unit
// =====================
hazard_detection_unit hd_inst (
    .reset(reset),
    .MemRead_E(MemRead_E),
    .Rd_E(Rd_E),
    .Rs1_D(instruction_D[19:15]),
    .Rs2_D(instruction_D[24:20]),
    .ID_EX_Flush(ID_EX_Flush),
    .PCWrite(PCWrite),
    .IF_ID_Write(IF_ID_Write)
);

endmodule

