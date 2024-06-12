`timescale 1ns / 1ps

module tb_CPU_top();
reg clk;
reg reset;
wire [31:0] PC;
integer file;

CPU_top CPU_top(
    .clk(clk),
    .reset(reset),
    .PC(PC)
);

initial begin
    clk = 1'b1;
    reset = 1'b0; // Reset 신호 활성화
    #20;          // 몇 클럭 사이클 기다림
    reset = 1'b1; // Reset 신호 비활성화
end

always begin
    #10 clk = ~clk; // 10ns마다 클럭 반전
end    

initial begin
    #2000;
    $finish;
end
endmodule
