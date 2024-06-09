`timescale 1ns / 1ps

module tb_CPU_top();

reg clk;
reg reset;

CPU_top CPU_top(.clk(clk), .reset(reset));

initial begin
    clk = 0;
    reset = 0;  // Reset initially inactive (active-low)
end

always begin
    #0.5;
    clk = ~clk;  // 20ns clock period
end

initial begin
   
    #1;
    reset = 1;  // Deactivate reset

    #200;
    $finish;
end

endmodule
