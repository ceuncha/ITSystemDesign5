module CPU_top(
    input clk,
    input rst,
    output instOut
);

    // RS_EX
   wire RS_EX_Branch;
   wire RS_Ex_Jump;
   wire RS_EX_MemRead;
   wire RS_Ex_MemToReg;
   wire RS_EX_ALU_Src1;
   wire RS_EX_ALU_Src2;
   wire RS_EX_MemWrite;
   wire [3:0] ALUop;
   wire [2:0] RS_EX_funct3;
   wire negaive,overflow,zero,carry;
   wire [31:0] ALU_A;
   wire [31:0] ALU_B;
   wire [31:0] ALUResult;
   wire [31:0] PC_Return;
   wire [31:0] Operand1_ALU;
   wire [7:0] RS_EX_alu_Physical_address;
   wire ALU_done;
   wire [31:0] RS_EX_PC_ALU;
   wire [31:0] Operand2_ALU;
   wire [31:0] immediate;
   wire [31:0] RS_EX_ALUResult;
   wire [31:0] Operand1_Mul;
   wire [7:0] RS_EX_Mul_Physical_address_in;
   wire Mul_start_in;
   wire [31:0] RS_EX_PC_Mul_in;
   wire [31:0] Operand2_Mul;
   wire [63:0]Mul_Result;
   wire [31:0] RS_EX_Mul_Physical_address_out;
   wire [31:0] RS_EX_PC_Mul_out;
   wire Mul_done_out;
   wire [31:0] Operand1_Div;
   wire [7:0] RS_EX_Div_Physical_address_in;
   wire Div_start_in;
   wire [31:0] RS_EX_PC_Div_in;
   wire [31:0] Operand2_Div;
   wire [31:0]Div_Result;
   wire [7:0] RS_EX_Div_Physical_address_out;
   wire [31:0] RS_EX_PC_Div_out;
   wire Div_done_out;
   wire [3:0]divider_op;
   
   ALU ALU(.A(ALU_A),.B(Operand2),.ALUop(ALUop),.Result(ALUResult),.negative(negative),.overflow(overflow),.zero(zero),.carry(carry));
    branchUnit branchUnit(.ID_EX_Jump(RS_Ex_Jump),.ID_EX_Branch(RS_EX_Branch),.ID_EX_funct3(RS_EX_func3),.ALUResult(ALUResult),.imm(immediate),.PC(RS_EX_PC_ALU),.ALUNegative(negative),.ALUZero(zero),.ALUOverflow(overflow),.ALUCarry(carry),.PC_Branch(PC_Branch),.branch_index(branch_index),.PCSrc(PCSrc),.IF_ID_Flush(IF_ID_Flush),.ID_RS_Flush(ID_RS_Flush));
   add4 add4 (.in(RS_EX_PC_ALU),.out(PC_Return));
   MUX_2input pretty_mux (.a(ALUResult),.b(PC_Return),.sel(ID_EX_jump),.y(EX_MEM_ALUResult));
   MUX_2input MUX_A (.a(RS_EX_PC_ALU),.b(Operand1_ALU),.sel(RS_EX_ALU_Src1),.y(ALU_A));
   MUX_2input MUX_B (.a(Operand2_ALU),.b(immediate),.sel(RS_EX_ALU_Src2),.y(ALU_B));
   multiplier multiplier (.clk(clk),.rst(rst),.start(Mul_start_in),.A(Operand1_Mul),.B(Operand2_Mul),.Physical_address_in(RS_EX_Mul_Physical_address_in),.PC_in(RS_EX_PC_Mul_in),.Product(Mul_Result),.done(Mul_done_out),.Physical_address_out(RS_EX_Mul_Physical_address_out),.PC_out(RS_EX_PC_Mul_out));
   divider divider (.clk(clk),.rst(rst),.start(Div_start_in),.A(Operand1_Div),.B(Operand2_Div),.Physical_address_in(RS_EX_Div_Physical_address_in),.PC_in(RS_EX_PC_Div_in),.Result(Div_Result),.divider_op_in(divider_op),.done(Div_done_out),.Physical_address_out(RS_EX_Div_Physical_address_out),.PC_out(RS_EX_PC_Div_out));
