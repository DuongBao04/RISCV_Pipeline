`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 06:43:06 AM
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit(
    input reset, 
    input MemRead_E,               // t? stage EX (ID/EX)
    input [4:0] Rd_E,              // thanh ghi ?ích c?a l?nh EX
    input [4:0] Rs1_D, Rs2_D,      // 2 thanh ghi ngu?n c?a l?nh ID
    output reg ID_EX_Flush,        // flush ID/EX (chèn bubble)
    output reg PCWrite,            // ?i?u khi?n PC
    output reg IF_ID_Write         // ?i?u khi?n IF/ID
);

always @(*) begin
    if (reset) begin
        // Khi reset, cho phép pipeline ch?y bình th??ng
        PCWrite     = 1'b1;
        IF_ID_Write = 1'b1;
        ID_EX_Flush = 1'b0;
    end 
    // ?i?u ki?n load-use hazard
    else if (MemRead_E &&
            ((Rd_E == Rs1_D) || (Rd_E == Rs2_D)) &&
            (Rd_E != 5'd0)) begin   // b? qua tr??ng h?p x0
        // Stall 1 chu k?
        PCWrite     = 1'b0;  // gi? PC
        IF_ID_Write = 1'b0;  // gi? IF/ID
        ID_EX_Flush = 1'b1;  // chèn bubble
    end 
    else begin
        // Không có hazard
        PCWrite     = 1'b1;
        IF_ID_Write = 1'b1;
        ID_EX_Flush = 1'b0;
    end
end

endmodule

