`timescale 1ns / 1ps

module inst_bench();
reg [31:0] pc;
wire [31:0] instOut;
Instruction_memory dut(
.pc(pc),
.instOut(instOut)
);
reg clk;
always #5 clk = ~clk;
initial begin
pc=0;
#10 pc=4;
#10 pc=100;
#10 pc=112;
#10 pc=120;
$stop;
end 
endmodule
