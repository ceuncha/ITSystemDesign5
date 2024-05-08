`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/06 21:57:09
// Design Name: 
// Module Name: tb_CPU_top
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


module tb_CPU_top();

reg clk;

CPU_top CPU_top(.clk(clk));

initial begin
    clk=1'b1;
    $dumpfile("pipeline cpu.vcd");
    $dumpvars(0);
 end
 
 always begin
    clk =~ clk;
    #100;
 end    
initial begin
#2000;
$finish;
end


endmodule
