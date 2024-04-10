module ALU_top(A,WB_A,ALU_A,B,WB_B,ALU_B,immediate,SEL_A,SEL_B,ALUsrc,ALUop,Result,negative,overflow,zero,carry);
   input [31:0] A,WB_A,ALU_A,B,WB_B,ALU_B,immediate;
   input [1:0] SEL_A,SEL_B;
   input [3:0] ALUop;
   input ALUsrc;
   output [31:0] Result;
   output negative,overflow,zero,carry;
   wire [31:0] ResultA,ResultB,SrcB;
   
   MUX_3input MUXA(A,WB_A,ALU_A,SEL_A,ResultA);
   MUX_3input MUXB(B,WB_B,ALU_B,SEL_B,ResultB);
   MUX_2input MUXsrcB(ResultB,immediate,ALUsrc,SrcB);
   ALU ALU(ResultA,SrcB,ALUop,Result,negative,overflow,zero,carry);
endmodule

module ALU(A,B,ALUop,Result,negative,overflow,zero,carry);
    input [31:0] A,B;
    input [3:0] ALUop;
    output reg [31:0] Result;
    output reg negative;
    output reg overflow;
    output  reg zero;
    output reg carry;
    reg [31:0] compare;
    integer i;
    integer shift;
    reg [31:0] temp;

always @(*) begin
    case (ALUop)
        4'b0010: begin  //ADD
            Result = A + B; 

            end
        4'b0110: begin  //SUB
            Result = A - B; 

            end
        4'b0000: begin  //AND
            Result = A & B; // 

            end
        4'b0001: begin  //OR
            Result = A | B; 

            end
        4'b0011: begin  //XOR
            Result = A ^ B; 
           
            end
        4'b0100: begin  //SLL
            Result = A << B[4:0]; 

            end
        4'b0101: begin  //SRL
            Result = A >> B[4:0]; // SRL (Logical Right Shift)

            end
        4'b0111: begin  //SRA
          temp = A[31:0];
          if (A[31] == 1) begin
          for (i = 1; i <= B[4:0]; i = i + 1) begin
            temp = {temp[31], temp[31:1]};
           end
         end
         else begin
          for (i = 1; i <= B[4:0]; i = i + 1) begin
           temp = {1'b0, temp[31:1]};
          end
          end
         Result = temp;
         end
        4'b1000: begin  //SLT
            compare=A-B;
            Result=compare[31]?1:0;

            end
        4'b1001: begin  //SLTU
            Result = (A < B) ? 32'b1 : 32'b0; // SLTU (Set Less Than Unsigned)

            end
        default: Result = 32'b0; // Default: Output 0
    endcase
        negative = Result[31];
        overflow = ((A[31] == B[31]) && (Result[31] != A[31])); // Overflow occurs if sign of A and B are same but result sign is different
        zero = (Result == 32'b0);
        carry = ((ALUop == 4'b0010) && ((Result < A) || (Result < B))) | // Carry for ADD operation
            ((ALUop == 4'b0110) && (A < B)); // Carry for SUB operation
end
endmodule

  module MUX_3input (input1,input2,input3,select,Result);

    input [31:0] input1,input2,input3;
    input [1:0] select;
    output [31:0] Result;

assign Result = (select == 2'b00) ? input1 :
           (select == 2'b01) ? input2 :
           (select == 2'b10) ? input3 :
           32'b0; 

endmodule

  module MUX_2input (input1,input2,select,Result);

    input [31:0] input1,input2;
    input select;
    output [31:0] Result;

assign Result = (select) ? input2 : input1;

endmodule

  
