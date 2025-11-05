`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2025 08:44:17 PM
// Design Name: 
// Module Name: instruction_mem
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


module instruction_mem(
    input reset,
    input [9:0] current_pc,
    
    output [31:0] instr
);

reg [7:0] mem [1023:0];
integer k;

assign instr = (reset) ? 32'h0 : {mem[current_pc + 3], mem[current_pc + 2], 
                    mem[current_pc + 1], mem[current_pc]};

always@(posedge reset) begin
    if (reset) begin
        for (k = 0;k<1024;k = k+1) begin
            mem[k] = 8'b0;
        end
        // ----------------------------------
        // For testing only
        mem[0]  = 8'h13; //addi x2, x0, 5 -> x2 = 5;
        mem[1]  = 8'h01;
        mem[2]  = 8'h50;
        mem[3]  = 8'h00;
                        
        mem[4]  = 8'h93; // addi x3, x2, 3 -> x3 = 8;
        mem[5]  = 8'h01;
        mem[6]  = 8'h31;
        mem[7]  = 8'h00;
                       
        // ----------------------------------
    end 
end

endmodule
