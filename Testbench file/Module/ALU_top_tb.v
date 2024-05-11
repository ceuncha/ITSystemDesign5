`timescale 1ns / 1ps

module ALU_top_tb( );
reg [31:0] A,WB_A,ALU_A,B,WB_B,ALU_B,immediate;
reg [1:0] SEL_A,SEL_B;
reg [3:0] ALUop;
reg ALUsrc;
wire [31:0] Result;
wire negative,overflow,zero,carry;
 ALU_top ALU_top(A,WB_A,ALU_A,B,WB_B,ALU_B,immediate,SEL_A,SEL_B,ALUsrc,ALUop,Result,negative,overflow,zero,carry);
initial begin
A=10;
WB_A=0;
ALU_A=0;
B=5;
WB_B=0;
ALU_B=0;
immediate=0;
SEL_A=0;
SEL_B=0;
ALUsrc=0;
ALUop=4'b0010;
#10 ALUop=4'b0110;
#10 ALUop=4'b0000;
#10 ALUop=4'b0001;
#10 ALUop=4'b0011;
#10 ALUop=4'b0100;
    A=10;
    B=2;
#10 ALUop=4'b0101;
#10 ALUop=4'b0111;
    A=-10;
#10 ALUop=4'b1000;
#10 ALUop=4'b1001;
A=10;
#10 $stop;
end
endmodule
