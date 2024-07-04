`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/04 17:40:31
// Design Name: 
// Module Name: BUFF
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


module BUFF(     input clk,
input rst,                                          // 내보내줘야 한다. priority encodcr은 이 역할을 수행한다.
    input PC_taken,
    output reg real_taken // 64비트 Y 출력
    );
 always @(posedge clk) begin
        if (rst) begin
            // 由ъ뀑 ?떊?샇媛? ?솢?꽦?솕?릺硫? 珥덇린?솕
            real_taken <= 1'b0;
        end else begin
         real_taken <= PC_taken;
        end
    end
endmodule
