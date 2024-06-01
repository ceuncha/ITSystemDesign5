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



//ID_RS_Decoder

    wire [31:0] RS_alu_operand1_data, RS_alu_operand2_data, RS_alu_PC;
    wire [2:0] RS_alu_funct3;
    wire RS_alu_MemToReg, RS_alu_MenRead, RS_alu_MemWrite, RS_alu_ALUSrc1, RS_alu_ALUSrc2, RS_alu_Jump, RS_alu_Branch;
    wire [3:0] RS_alu_ALUOP;
    wire [7:0] RS_alu_Rd, RS_alu_operand1, RS_alu_operand2;
    wire [1:0] RS_alu_valid;
    wire [31:0] RS_alu_immediate;
    wire RS_alu_start;

    wire [31:0] RS_mul_operand1_data, RS_mul_operand2_data, RS_mul_PC;
    wire [2:0] RS_mul_funct3;
    wire RS_mul_MemToReg, RS_mul_MenRead, RS_mul_MemWrite, RS_mul_ALUSrc1, RS_mul_ALUSrc2, RS_mul_Jump, RS_mul_Branch;
    wire [3:0] RS_mul_ALUOP;
    wire [7:0] RS_mul_Rd, RS_mul_operand1, RS_mul_operand2;
    wire [1:0] RS_mul_valid;
    wire [31:0] RS_mul_immediate;
    wire RS_mul_start;

    wire [31:0] RS_div_operand1_data, RS_div_operand2_data, RS_div_pc;
    wire [2:0] RS_div_funct3;
    wire RS_div_MemToReg, RS_div_MenRead, RS_div_MemWrite, RS_div_ALUSrc1, RS_div_ALUSrc2, RS_div_Jump, RS_div_Branch;
    wire [3:0] RS_div_ALUOP;
    wire [7:0] RS_div_Rd, RS_div_operand1, RS_div_operand2;
    wire [1:0] RS_div_valid;
    wire [31:0] RS_div_immediate;
    wire RS_div_start;

    RS_EX_decoder rs_ex_decoder_inst (
        .clk(clk),
        .reset(reset),
        .in_opcode(opcode),
        .in_operand1(operand1),
        .in_operand2(operand2),
        .in_func3(funct3),
        .in_pc(pc),
        .MemToReg(MemToReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUOP(ALUOP),
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        .Jump(Jump),
        .Branch(Branch),
        .rd_phy_reg(Rd_phy),
        .Operand1_phy(Phy_addr_OP1),
        .Operand2_phy(Phy_addr_OP2),
        .valid(valid),
        .immediate(imm32),
        .add_alu_operand1(RS_alu_operand1_data),
        .add_alu_operand2(RS_alu_operand2_data),
        .add_alu_func3(RS_alu_funct3),
        .add_alu_pc(RS_alu_PC),
        .out_add_MemToReg(RS_alu_MemToReg),
        .out_add_MemRead(RS_alu_MenRead),
        .out_add_MemWrite(RS_alu_MemWrite),
        .out_add_ALUOP(RS_alu_ALUOP),
        .out_add_ALUSrc1(RS_alu_ALUSrc1),
        .out_add_ALUSrc2(RS_alu_ALUSrc2),
        .out_add_Jump(RS_alu_Jump),
        .out_add_Branch(RS_alu_Branch),
        .add_rd_phy_reg(Rd_phy),
        .add_rs_on(RS_alu_start),
        .out_add_Operand1_phy(Phy_addr_OP1),
        .out_add_Operand2_phy(Phy_addr_OP2),
        .out_add_valid(valid),
        .out_add_immediate(imm32),
        .mul_alu_operand1(RS_mul_operand1_data),
        .mul_alu_operand2(RS_mul_operand2_data),
        .mul_alu_func3(RS_mul_funct3),
        .mul_alu_pc(RS_mul_PC),
        .out_mul_MemToReg(RS_mul_MemToReg),
        .out_mul_MemRead(RS_mul_MenRead),
        .out_mul_MemWrite(RS_mul_MemWrite),
        .out_mul_ALUOP(RS_mul_ALUOP),
        .out_mul_ALUSrc1(RS_mul_ALUSrc1),
        .out_mul_ALUSrc2(RS_mul_ALUSrc2),
        .out_mul_Jump(RS_mul_Jump),
        .out_mul_Branch(RS_mul_Branch),
        .mul_rd_phy_reg(Rd_phy),
        .mul_rs_on(RS_mul_start),
        .out_mul_Operand1_phy(Phy_addr_OP1),
        .out_mul_Operand2_phy(Phy_addr_OP2),
        .out_mul_valid(valid),
        .out_mul_immediate(imm32),
        .div_alu_operand1(RS_div_operand1_data),
        .div_alu_operand2(RS_div_operand2_data),
        .div_alu_func3(RS_div_funct3),
        .div_alu_pc(RS_div_pc),
        .out_div_MemToReg(RS_div_MemToReg),
        .out_div_MemRead(RS_div_MenRead),
        .out_div_MemWrite(RS_div_MemWrite),
        .out_div_ALUOP(RS_div_ALUOP),
        .out_div_ALUSrc1(RS_div_ALUSrc1),
        .out_div_ALUSrc2(RS_div_ALUSrc2),
        .out_div_Jump(RS_div_Jump),
        .out_div_Branch(RS_div_Branch),
        .div_rd_phy_reg(Rd_phy),
        .div_rs_on(RS_div_start),
        .out_div_Operand1_phy(Phy_addr_OP1),
        .out_div_Operand2_phy(Phy_addr_OP2),
        .out_div_valid(valid),
        .out_div_immediate(imm32)
    );

    endmodule

    
