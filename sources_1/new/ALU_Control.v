`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 02:34:50 PM
// Design Name: 
// Module Name: ALU_Control
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
module ALU_Control(
    input  [2:0]  ALUOp,
    input  [2:0]  funct3,
    input  [6:0]  funct7,
    output reg  [3:0]  ALUControl
);

    always @(ALUOp or funct3 or funct7) begin
        case(ALUOp)
            //LB, LH, LW, LBU, LHU
            3'b000: begin ALUControl = `ALU_ADD; end
            //ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
            3'b001: begin
                case(funct3)
                    //ADDI
                    3'h0: begin ALUControl = `ALU_ADD; end
                    3'h1: begin
                        if (funct7 == 0) begin ALUControl = `ALU_LSHIFT_LEFT; end
                        else begin  ALUControl = 4'bxxxx; end
                    end
                    3'h2: begin ALUControl = `ALU_SUB; end 
                    3'h3: begin ALUControl = `ALU_SUB; end
                    3'h4: begin ALUControl = `ALU_XOR; end
                    3'h5: begin 
                        if (funct7 == 7'h20) begin ALUControl = `ALU_ASHIFT_RIGHT; end
                        else if (funct7 == 7'h00) begin ALUControl = `ALU_LSHIFT_RIGHT; end
                        else begin  ALUControl = 3'bxxx; end
                    end
                    3'h6: begin ALUControl = `ALU_OR; end
                    3'h7: begin ALUControl = `ALU_AND; end
                    default: begin ALUControl = 3'bxxx; end
                endcase                
             end
             
            ////SB, SH, SW
            3'b011: begin
                if ((funct3 == 3'h0) | (funct3 == 3'h1) | (funct3 == 3'h2)) begin ALUControl = `ALU_ADD; end
                else begin  ALUControl = 3'bxxx; end
             end
             
            //ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
            3'b100: begin
                case(funct3)
                    // ADD / SUB
                    3'h0: begin 
                        ALUControl = (funct7 == 7'h00) ? `ALU_ADD : 
                                      (funct7 == 7'h20) ? `ALU_SUB :
                                      4'b1111; 
                    end
                    // SLL
                    3'h1: begin 
                        ALUControl = (funct7 == 7'h00) ? `ALU_LSHIFT_LEFT : 4'b1111; 
                    end
                    // SLT
                    3'h2: begin 
                        ALUControl = (funct7 == 7'h00) ? `ALU_SUB : 4'b1111; 
                    end
                    // SLTU
                    3'h3: begin 
                        ALUControl = (funct7 == 7'h00) ? `ALU_SUB : 4'b1111; 
                    end
                    // XOR
                    3'h4: begin 
                        ALUControl = (funct7 == 7'h00) ? `ALU_XOR : 4'b1111; 
                    end
                    // SRL / SRA
                    3'h5: begin 
                        ALUControl = (funct7 == 7'h00) ? `ALU_LSHIFT_RIGHT : 
                                      (funct7 == 7'h20) ? `ALU_ASHIFT_RIGHT :
                                      4'b1111; 
                    end
                    // OR
                    3'h6: begin 
                        ALUControl = (funct7 == 7'h00) ? `ALU_OR : 4'b1111; 
                    end
                    // AND
                    3'h7: begin 
                        ALUControl = (funct7 == 7'h00) ? `ALU_AND : 4'b1111; 
                    end
                    default: begin ALUControl = 4'b1111; end
                endcase
             end
         
            //BEQ, BNE, BLT, BGE, BLTU, BGEU
            3'b101: begin ALUControl = `ALU_SUB; end
            
            default: begin ALUControl = 4'b1111; end
        endcase
    end

endmodule

