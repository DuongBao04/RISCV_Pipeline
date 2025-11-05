// ============================================================
//  RISC-V Base ISA Opcode Definitions (Main_Decoder subset)
// ============================================================

`define OPCODE_R_TYPE   7'b011_0011   // R-type: ADD, SUB, AND, OR, SLT, ...
`define OPCODE_I_TYPE   7'b001_0011   // I-type: ADDI, ANDI, ORI, SLTI, ...
`define OPCODE_LOAD     7'b000_0011   // LOAD: LB, LH, LW, ...
`define OPCODE_STORE    7'b010_0011   // STORE: SB, SH, SW
`define OPCODE_BRANCH   7'b110_0011   // BRANCH: BEQ, BNE, BLT, ...

// ============================================================
// RISC-V ALU Control Signal Definitions
// ============================================================

`define ALU_AND             4'b0000   // Logical AND
`define ALU_OR              4'b0001   // Logical OR
`define ALU_ADD             4'b0010   // Addition
`define ALU_SUB             4'b0011   // Subtraction
`define ALU_LSHIFT_LEFT     4'b0100   // Logical Shift Left
`define ALU_LSHIFT_RIGHT    4'b0101   // Logical Shift Right
`define ALU_ASHIFT_RIGHT    4'b0110   // Arithmetic Shift Right
`define ALU_XOR             4'b0111   // Subtraction
`define NOP                 4'b1111    // Not doing anything
