module CPU_top(
    input clk,
    input rst,
    output [31:0] x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15,
    output [31:0] x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31
);

//program counter
wire first_and_Pcsrc;
wire Wrong;
wire hit;
wire ID_EX_hit;
wire taken;
wire PC_taken;

//////////IF_ID_Wire    
wire [31:0] PC, PC_Branch;   
wire  PCSrc;
wire [31:0] instOut;
wire [31:0] inst_num;
wire [4:0] Rs1 = instOut[19:15];
wire [4:0] Rs2 = instOut[24:20];
wire [4:0] Rd =instOut[11:7];
wire [6:0] instOut_opcode = instOut[6:0];
// ID stage
wire IF_ID_taken;
wire IF_ID_hit;
wire [31:0] IF_ID_instOut;
wire [31:0] IF_ID_PC;
wire [31:0] IF_ID_inst_num;
wire IF_ID_Flush;
wire ROB_Flush;
    // parse instOut
wire [6:0] funct7 = IF_ID_instOut[31:25];
wire [2:0] funct3 = IF_ID_instOut[14:12];
wire [6:0] opcode = IF_ID_instOut[6:0];

wire [31:0] RS_alu_inst_num;
wire [31:0] imm32;
wire RegWrite;
wire MemToReg;
wire MemRead;
wire MemWrite;
wire [3:0] ALUOp;
wire [1:0] ALUSrc;
wire RWsel;
wire Jump;
wire Branch;
wire ALUSrc1 = ALUSrc[0];
wire ALUSrc2 = ALUSrc[1];
//RAT to chuchu
wire [7:0] original_phy_addr;
//chuchu to RAT
wire [7:0] chuchu_addr;
//RAT to pfile
wire [7:0] Phy_addr_OP1;
wire [7:0] Phy_addr_OP2;
//pfile to decoder
wire Valid1;
wire Valid2;
wire [1:0] Valid = {Valid2,Valid1};
wire [31:0] RData1;
wire [31:0] RData2;
wire [7:0] Rd_phy;
//BB to RAT and Pfile
wire save_on;
wire [4:0] save_page;
wire restore_on;
wire [4:0] restore_page;
//Branch unit to BB
wire [31:0] branch_index;
//forwarding wb

/////////////////////RS_EX_decoder wires
    
    wire [31:0] RS_alu_operand1_data, RS_alu_operand2_data, RS_alu_PC;
    wire [2:0] RS_alu_funct3;
    wire RS_alu_MemToReg, RS_alu_MemRead, RS_alu_MemWrite, RS_alu_ALUSrc1, RS_alu_ALUSrc2, RS_alu_Jump, RS_alu_Branch;
    wire [3:0] RS_alu_ALUOP;
    wire [7:0] RS_alu_Rd, RS_alu_operand1, RS_alu_operand2;
    wire [1:0] RS_alu_valid;
    wire [31:0] RS_alu_immediate;
    wire RS_alu_start;

    wire [31:0] RS_mul_operand1_data, RS_mul_operand2_data, RS_mul_inst_num;
    wire [2:0] RS_mul_funct3;
    wire RS_mul_MemToReg, RS_mul_MemRead, RS_mul_MemWrite, RS_mul_ALUSrc1, RS_mul_ALUSrc2, RS_mul_Jump, RS_mul_Branch;
    wire [3:0] RS_mul_ALUOP;
    wire [7:0] RS_mul_Rd, RS_mul_operand1, RS_mul_operand2;
    wire [1:0] RS_mul_valid;
    wire [31:0] RS_mul_immediate;
    wire RS_mul_start;

    wire [31:0] RS_div_operand1_data, RS_div_operand2_data, RS_div_inst_num;
    wire [2:0] RS_div_funct3;
    wire RS_div_MemToReg, RS_div_MenRead, RS_div_MemWrite, RS_div_ALUSrc1, RS_div_ALUSrc2, RS_div_Jump, RS_div_Branch;
    wire [3:0] RS_div_ALUOP;
    wire [7:0] RS_div_Rd, RS_div_operand1, RS_div_operand2;
    wire [1:0] RS_div_valid;
    wire [31:0] RS_div_immediate;
    wire RS_div_start;

            // rs_alu_wire
    wire RS_alu_start;
    wire [31:0] RS_alu_PC;
    wire [7:0] RS_alu_Rd;
    wire RS_alu_MemToReg;
    wire RS_alu_MemWrite;
    wire [3:0] RS_alu_ALUOP;
    wire RS_alu_ALUSrc1;
    wire RS_alu_ALUSrc2;
    wire RS_alu_Jump;
    wire RS_alu_Branch;
    wire [2:0] RS_alu_funct3;
    wire [31:0] RS_alu_immediate;
   
    wire [7:0] RS_alu_operand1;
    wire [7:0] RS_alu_operand2;
    wire [31:0] RS_mul_operand1_data;
    wire [31:0] RS_mul_operand2_data;
    wire [1:0] RS_alu_valid;
    wire [184:0]result_out_alu;
    wire RS_alu_IF_ID_taken;
    wire RS_alu_IF_ID_hit;

 wire [31:0] Operand2_ALU = result_out_alu[31:0];
wire [31:0] Operand1_ALU = result_out_alu[63:32];
wire [31:0] immediate = result_out_alu[95:64];
wire [2:0] RS_EX_funct3 = result_out_alu[98:96];
wire RS_EX_Branch = result_out_alu[99];
wire RS_EX_Jump = result_out_alu[100];
wire RS_EX_ALU_Src1 = result_out_alu[101];
wire RS_EX_ALU_Src2 = result_out_alu[102];
wire [3:0] ALUop = result_out_alu[106:103];
wire RS_EX_MemWrite = result_out_alu[107];
wire RS_EX_MemRead = result_out_alu[108];
wire RS_EX_MemToReg = result_out_alu[109];
wire [7:0] ALU_Phy = result_out_alu[117:110];
wire [31:0] RS_EX_PC_ALU = result_out_alu[149:118];
wire ALU_Done = result_out_alu[150];
wire [31:0] RS_EX_inst_num = result_out_alu[182:151];
wire RS_EX_taken=result_out_alu[183];
wire RS_EX_hit=result_out_alu[184];
wire RS_alu_IF_ID_taken;

    // Internal signals for RS_mul wire
    wire RS_mul_start;
    wire [31:0] RS_mul_PC;
    wire [7:0] RS_mul_Rd;
    wire Load_Done;
    wire [31:0] Load_Data;
    wire [7:0] Load_Phy;
    wire [7:0] RS_mul_operand1;
    wire [7:0] RS_mul_operand2;
    wire [31:0] RS_mul_operand1_data;
    wire [31:0] RS_mul_operand2_data;
    wire [1:0] RS_mul_valid;
    wire [31:0] ALU_Data;

    wire ALU_Done;
    wire [63:0] MUL_Data;
    wire [7:0] MUL_Phy;
    wire [31:0] DIV_Data;
    wire [7:0] DIV_Phy;
   wire [104:0]result_out_mul;
   wire [31:0] RS_EX_inst_num_Mul_out;

wire [31:0] Operand2_Mul = result_out_mul[31:0];
wire [31:0] Operand1_Mul = result_out_mul[63:32];
wire [7:0] RS_EX_Mul_Physical_address_in = result_out_mul[71:64];
wire [31:0] RS_EX_inst_num_Mul_in = result_out_mul[103:72];
wire  Mul_start_in= result_out_mul[104];
wire MUL_Done;




  /////////////////////  //RS_div_wire


    wire RS_div_start;
    wire [31:0] RS_div_PC;
    wire [7:0] RS_div_Rd;
    wire [7:0] RS_div_operand1;
    wire [7:0] RS_div_operand2;
    wire [31:0] RS_div_operand1_data;
    wire [31:0] RS_div_operand2_data;
    wire [1:0] RS_div_valid;
    wire [3:0] RS_div_ALUOP;
    wire [108:0]result_out_div;

wire [31:0] Operand2_Div = result_out_div[31:0];
wire [31:0] Operand1_Div = result_out_div[63:32];
wire [4:0] divider_op = result_out_div[67:64];
wire [7:0] RS_EX_Div_Physical_address_in = result_out_div[75:68];
wire [31:0] RS_EX_Div_inst_num= result_out_div[107:76];
wire Div_start_in = result_out_div[108];



    ////////////////ex_mem wire
    //////////
   wire RS_EX_Branch;
   wire Predict_Result;
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
   wire ALU_done;
   wire [31:0] RS_EX_PC_ALU;
   wire [31:0] Operand2_ALU;
   wire [31:0] immediate;
   wire [31:0] Operand1_Mul;
   wire [7:0] RS_EX_Mul_Physical_address_in;
   wire Mul_start_in;
   wire [31:0] RS_EX_PC_Mul_in;
   wire [31:0] Operand2_Mul;
   wire [31:0] RS_EX_PC_Mul_out;
   wire [31:0] Operand1_Div;
   wire [7:0] RS_EX_Div_Physical_address_in;
   wire Div_start_in;
   wire [31:0] RS_EX_PC_Div_in;
   wire [31:0] Operand2_Div;
   wire [31:0] RS_EX_PC_Div_out;
   wire [3:0]divider_op;
   wire [31:0] RS_EX_Div_inst_num_out;


       //MEM_WB////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    wire EX_MEM_MemToReg, Load_Done, EX_MEM_MemWrite, EX_MEM_alu_exec_done, mul_exec_done, div_exec_done;
    wire [2:0] EX_MEM_funct3;
    wire [31:0] EX_MEM_Rdata2, EX_MEM_ALUResult, EX_MEM_alu_inst_num, EX_MEM_alu_physical_address;
    wire [31:0] mul_exec_value, mul_exec_PC, div_exec_value, div_exec_PC;
    wire [31:0] Load_Data;
    wire MEM_WB_MemToReg;
    wire [31:0] MEM_WB_ALUResult, MEM_WB_RData, alu_exec_value, alu_exec_PC;
    wire alu_exec_done;
    wire [31:0] out_value;
    wire [4:0] out_dest;
    wire out_reg_write;
    wire [31:0] EX_MEM_div_inst_num;
    wire [31:0] EX_MEM_mul_inst_num;
    

    wire [31:0] Branch_index;
wire real_taken;
///////////////////////////IF_ID////////////////////////////////////////////////
(* keep_hierarchy = "yes" *)
global_prediction_top u_global_prediction_top(
    .clk(clk),
    .reset(rst),
    .ID_EX_Branch(RS_EX_Branch),
    .Pcsrc(PCSrc),
    .ID_EX_PC(RS_EX_PC_ALU),
    .PC_Branch(PC_Branch),
    .ID_EX_Jump(RS_EX_Jump),
    .PC(PC),
    .Wrong(Wrong),
    .hit(hit),    
    .PC_taken(PC_taken),
    .ID_EX_hit(RS_EX_hit)
);
BUFF BUFF(
.clk(clk),
    .rst(rst),
    .PC_taken(PC_taken),
    .real_taken(real_taken)
);

ROB_Counter u_ROB_Counter(
    .clk(clk),
    .rst(rst),
    .inst_num(inst_num)
);
Instruction_memory u_Instruction_memory(
    .pc(PC),
    .instOut(instOut)
);

ifid_pipeline_register u_ifid_pipeline_register(
    .clk(clk),
    .reset(rst),
    .instOut(instOut),
    .PC(PC),
    .taken(real_taken),
    .hit(hit),
    .IF_ID_taken(IF_ID_taken),
    .IF_ID_hit(IF_ID_hit),
    .Predict_Result(Predict_Result),
    .IF_ID_instOut(IF_ID_instOut),  
    .inst_num(inst_num),
    .IF_ID_inst_num(IF_ID_inst_num),
    .IF_ID_PC(IF_ID_PC),
    .ROB_Flush(ROB_Flush)
);

sign_extend u_sign_extend(
    .inst(instOut),  // 전체 명령어 입력
    .clk(clk),          // 클락 신호 입력
    .Imm(imm32)  // 신호 확장된 즉시값 출력
);

RAT u_RAT(
    .clk(clk),
    .reset(rst),

    .if_id_flush(Predict_Result),
    .save_state(save_on),    // 사본 레지스터에 상태 저장 신호
    .restore_state(restore_on), // 사본 레지스터에서 상태 복원 신호
    .save_page(save_page),     // 상태 저장용 사본 레지스터 페이지 선택 신호
    .restore_page(restore_page),  // 상태 복원 신호
    .logical_addr1(Rs1), // 오퍼랜드 1 논리 주소
    .logical_addr2(Rs2), // 오퍼랜드 2 논리 주소
    .rd_logical_addr(Rd), // 쓰기 작업을 하는 논리 주소 (Rd)
    .free_phy_addr(chuchu_addr),   // 프리리스트로부터 받은 비어있는 물리 주소
    .opcode(instOut_opcode),

    .phy_addr_out1(Phy_addr_OP1),   // 오퍼랜드 1 물리 주소 출력
    .phy_addr_out2(Phy_addr_OP2),   // 오퍼랜드 2 물리 주소 출력
    .rd_phy_out(Rd_phy),

    .free_phy_addr_out(original_phy_addr) // 프리리스트로 비어있는 주소 전송
);

physical_register_file u_physical_register_file(
    .clk(clk),
    .reset(rst),
    .Operand1_phy(Phy_addr_OP1),
    .Operand2_phy(Phy_addr_OP2),
    .Rd_phy(Rd_phy), // 명령어의 Rd 주소

    .ALU_add_Write(ALU_Done),
    .ALU_load_Write(Load_Done),
    .ALU_mul_Write(MUL_Done),
    .ALU_div_Write(DIV_Done),
    .ALU_add_Data(ALU_Data),
    .ALU_load_Data(Load_Data),
    .ALU_mul_Data(MUL_Data[31:0]),
    .ALU_div_Data(DIV_Data),
    .ALU_add_phy(ALU_Phy),
    .ALU_load_phy(Load_Phy),
    .ALU_mul_phy(MUL_Phy),
    .ALU_div_phy(DIV_Phy),

    .Operand1_data(RData1),
    .Operand2_data(RData2),
    .valid1(Valid1),
    .valid2(Valid2)
);

BB u_BB(
    .clk(clk),                      // Clock signal
    .rst(rst),                      // Reset signal
    .opcode(instOut_opcode),             // Input opcode
    .PCSrc(Predict_Result),                    // Branch decision signal
    .branch_PC(Branch_index),         // Branch index in ROB
    .PC(inst_num),                // Current PC value (expanded to 32 bits)
    .tail_num(save_page),           // Output value
    .Copy_RAT(save_on),                 // Output register destination extracted from instr[11:7]
    .head_num(restore_page),           // Output RegWrite signal to indicate a register write operation
    .Paste_RAT(restore_on),
    .RS_EX_Branch(RS_EX_Branch), 
    .RS_EX_Jump(RS_EX_Jump)
);

chuchu u_chuchu(
    .clk(clk),
    .reset(rst),
    .save_state(save_on),          // 상태 저장 신호
    .restore_state(restore_on),       // 상태 복원 신호
    .save_page(save_page),     // 상태 저장 페이지 선택 신호
    .restore_page(restore_page),  // 상태 복원 페이지 선택 신호
    .rat_data(original_phy_addr),
    .chuchu_out(chuchu_addr)
);

control_unit_top u_control_unit_top(
    .rst(rst),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .RegWrite(RegWrite),
    .MemToReg(MemToReg),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .RWsel(RWsel),
    .Branch(Branch),
    .Jump(Jump)
);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//RS_EX_decoder top Line
    


   RS_EX_decoder rs_ex_decoder_inst (
        .clk(clk),
        .reset(rst),
        .in_opcode(opcode),
        .in_operand1(RData1),
        .in_operand2(RData2),
        .in_func3(funct3),
        .in_funct7(funct7),
        .in_pc(IF_ID_PC),
        .inst_num(IF_ID_inst_num),
        .MemToReg(MemToReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUOP(ALUOp),
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        .Jump(Jump),
        .Branch(Branch),
        .rd_phy_reg(Rd_phy),
        .Operand1_phy(Phy_addr_OP1),
        .Operand2_phy(Phy_addr_OP2),
        .valid(Valid),
        .immediate(imm32),
        .add_alu_operand1(RS_alu_operand1_data),
        .add_alu_operand2(RS_alu_operand2_data),
        .add_alu_func3(RS_alu_funct3),
        .add_alu_pc(RS_alu_PC),
        .out_add_MemToReg(RS_alu_MemToReg),
       .out_add_MemRead(RS_alu_MemRead),
        .out_add_MemWrite(RS_alu_MemWrite),
        .out_add_ALUOP(RS_alu_ALUOP),
        .out_add_ALUSrc1(RS_alu_ALUSrc1),
        .out_add_ALUSrc2(RS_alu_ALUSrc2),
        .out_add_Jump(RS_alu_Jump),
        .out_add_Branch(RS_alu_Branch),
        .add_rd_phy_reg(RS_alu_Rd),
        .add_rs_on(RS_alu_start),
        .out_add_Operand1_phy(RS_alu_operand1),
        .out_add_Operand2_phy(RS_alu_operand2),
        .out_add_valid(RS_alu_valid),
        .out_add_immediate(RS_alu_immediate),
        .out_add_inst_num(RS_alu_inst_num),
        .mul_alu_operand1(RS_mul_operand1_data),
        .mul_alu_operand2(RS_mul_operand2_data),
        .mul_alu_func3(RS_mul_funct3),
        .out_mul_inst_num(RS_mul_inst_num),
        .out_mul_MemToReg(RS_mul_MemToReg),
       .out_mul_MemRead(RS_mul_MemRead),
        .out_mul_MemWrite(RS_mul_MemWrite),
        .out_mul_ALUOP(RS_mul_ALUOP),
        .out_mul_ALUSrc1(RS_mul_ALUSrc1),
        .out_mul_ALUSrc2(RS_mul_ALUSrc2),
        .out_mul_Jump(RS_mul_Jump),
        .out_mul_Branch(RS_mul_Branch),
        .mul_rd_phy_reg(RS_mul_Rd),
        .mul_rs_on(RS_mul_start),
        .out_mul_Operand1_phy(RS_mul_operand1),
        .out_mul_Operand2_phy(RS_mul_operand2),
        .out_mul_valid(RS_mul_valid),
        .out_mul_immediate(RS_mul_immediate),
        .div_alu_operand1(RS_div_operand1_data),
        .div_alu_operand2(RS_div_operand2_data),
        .div_alu_func3(RS_div_funct3),
       .out_div_inst_num(RS_div_inst_num),
        .out_div_MemToReg(RS_div_MemToReg),
       .out_div_MemRead(RS_div_MemRead),
        .out_div_MemWrite(RS_div_MemWrite),
        .out_div_ALUOP(RS_div_ALUOP),
        .out_div_ALUSrc1(RS_div_ALUSrc1),
        .out_div_ALUSrc2(RS_div_ALUSrc2),
        .out_div_Jump(RS_div_Jump),
        .out_div_Branch(RS_div_Branch),
        .div_rd_phy_reg(RS_div_Rd),
        .div_rs_on(RS_div_start),
        .out_div_Operand1_phy(RS_div_operand1),
        .out_div_Operand2_phy(RS_div_operand2),
        .out_div_valid(RS_div_valid),
        .out_div_immediate(RS_div_immediate),
        .IF_ID_taken(IF_ID_taken),
        .RS_alu_IF_ID_taken(RS_alu_IF_ID_taken),
        .IF_ID_hit(IF_ID_hit),
        .RS_alu_IF_ID_hit(RS_alu_IF_ID_hit)
    );


 

  

    
        RS_ALU rs_alu (
        .clk(clk),
        .reset(rst),
        .start(RS_alu_start),
        .PC(RS_alu_PC),
        .Rd(RS_alu_Rd),
        .RS_alu_inst_num(RS_alu_inst_num),
        .MemToReg(RS_alu_MemToReg),
        .MemRead(RS_alu_MemRead),
        .MemWrite(RS_alu_MemWrite),
        .ALUOP(RS_alu_ALUOP),
        .ALUSrc1(RS_alu_ALUSrc1),
        .ALUSrc2(RS_alu_ALUSrc2),
        .Jump(RS_alu_Jump),
        .Branch(RS_alu_Branch),
        .funct3(RS_alu_funct3),
        .immediate(RS_alu_immediate),
        .EX_MEM_MemRead(Load_Done),
        .RData(Load_Data),
        .EX_MEM_Physical_Address(Load_Phy),
        .operand1(RS_alu_operand1),
        .operand2(RS_alu_operand2),
        .operand1_data(RS_alu_operand1_data),
        .operand2_data(RS_alu_operand2_data),
        .valid(RS_alu_valid),
        .ALU_result(ALU_Data),
        .ALU_result_dest(ALU_Phy),
        .ALU_result_valid(ALU_Done),
        .MUL_result(MUL_Data[31:0]),
        .MUL_result_dest(MUL_Phy),
        .MUL_result_valid(MUL_Done),
        .DIV_result(DIV_Data),
        .DIV_result_dest(DIV_Phy),
        .DIV_result_valid(DIV_Done),
        .RS_alu_IF_ID_taken(RS_alu_IF_ID_taken),
        .RS_alu_IF_ID_hit(RS_alu_IF_ID_hit),
         .result_out(result_out_alu)
    );







    
    RS_Mul rs_mul (
        .clk(clk),
        .reset(rst),
        .RS_mul_start(RS_mul_start),
        .RS_mul_PC(RS_mul_inst_num),
        .RS_mul_Rd(RS_mul_Rd),
        .EX_MEM_MemRead(Load_Done),
        .RData(Load_Data),
        .EX_MEM_Physical_Address(Load_Phy),
        .RS_mul_operand1(RS_mul_operand1),
        .RS_mul_operand2(RS_mul_operand2),
        .RS_mul_operand1_data(RS_mul_operand1_data),
        .RS_mul_operand2_data(RS_mul_operand2_data),
        .RS_mul_valid(RS_mul_valid),
        .ALU_result(ALU_Data),
        .ALU_result_dest(ALU_Phy),
        .ALU_result_valid(ALU_Done),
        .MUL_result(MUL_Data[31:0]),
        .MUL_result_dest(MUL_Phy),
        .MUL_result_valid(MUL_Done),
        .DIV_result(DIV_Data),
        .DIV_result_dest(DIV_Phy),
        .DIV_result_valid(DIV_Done),
        .result_out(result_out_mul)
    );
 



    RS_Div RS_Div (.clk(clk),.reset(rst),.RS_div_start(RS_div_start),.RS_div_PC(RS_div_inst_num),
                   .RS_div_Rd(RS_div_Rd),.RS_div_ALUOP(RS_div_ALUOP),.EX_MEM_MemRead(Load_Done),
                   .RData(Load_Data),.EX_MEM_Physical_Address(Load_Phy),.RS_div_operand1(RS_div_operand1),
                   .RS_div_operand2(RS_div_operand2),.RS_div_operand1_data(RS_div_operand1_data),
                   .RS_div_operand2_data(RS_div_operand2_data),.RS_div_valid(RS_div_valid),.ALU_result(ALU_Data),
                   .ALU_result_dest(ALU_Phy),.ALU_result_valid(ALU_Done),.MUL_result(MUL_Data[31:0]),.MUL_result_dest(MUL_Phy),
                   .MUL_result_valid(MUL_Done),.DIV_result(DIV_Data),.DIV_result_dest(DIV_Phy),.DIV_result_valid(DIV_Done),
                   .result_out(result_out_div));



  ////////////ALU
    ALU ALU(.A(ALU_A),.B(ALU_B),.ALUop(ALUop),.Result(ALUResult),.negative(negative),.overflow(overflow),
            .zero(zero),.carry(carry));
    BranchUnit branchUnit(.ID_EX_Jump(RS_EX_Jump),.ID_EX_Branch(RS_EX_Branch),.ID_EX_funct3(RS_EX_funct3),.RS_EX_taken(RS_EX_taken),.Predict_Result(Predict_Result),
                         .ALUResult(ALUResult),.imm(immediate),.PC(RS_EX_PC_ALU),.ALUNegative(negative),
                         .ALUZero(zero),.ALUOverflow(overflow),.ALUCarry(carry),.PC_Branch(PC_Branch),
                         .branch_index(branch_index),.PCSrc(PCSrc),.IF_ID_Flush(IF_ID_Flush));
   add4 add4 (.in(RS_EX_PC_ALU),.out(PC_Return));
    MUX_2input pretty_mux (.a(ALUResult),.b(PC_Return),.sel(RS_EX_Jump),.y(ALU_Data));
    MUX_2input MUX_A (.a(RS_EX_PC_ALU),.b(Operand1_ALU),.sel(RS_EX_ALU_Src1),.y(ALU_A)); 
    MUX_2input MUX_B (.a(Operand2_ALU),.b(immediate),.sel(RS_EX_ALU_Src2),.y(ALU_B)); 
   multiplier multiplier (.clk(clk),.rst(rst),.start(Mul_start_in),.A(Operand1_Mul),.B(Operand2_Mul),
                          .Physical_address_in(RS_EX_Mul_Physical_address_in),
                          .PC_in(RS_EX_inst_num_Mul_in),.Product(MUL_Data),.done(MUL_Done),.Physical_address_out(MUL_Phy),
                          .PC_out(RS_EX_inst_num_Mul_out));
    divider divider (.clk(clk),.reset(rst),.start(Div_start_in),.A(Operand1_Div),.B(Operand2_Div),
                     .Physical_address_in(RS_EX_Div_Physical_address_in),
                     .PC_in(RS_EX_Div_inst_num),.Result(DIV_Data),.divider_op_in(divider_op),.done(DIV_Done),
                     .Physical_address_out(DIV_Phy),.PC_out(RS_EX_Div_inst_num_out));


////////////////////EX_MEM
    exmem_pipeline_register exmem (
        .clk(clk),
        .reset(rst),
        .ID_EX_MemToReg(RS_EX_MemToReg),
        .ID_EX_MemRead(RS_EX_MemRead),
        .ID_EX_MemWrite(RS_EX_MemWrite),
        .RS_EX_funt3(RS_EX_funct3),
        .operand2_Phy_Data(Operand2_ALU),
        .RS_EX_ALUResult(ALU_Data),
        .RS_EX_PC_ALU(RS_EX_inst_num),
        .ALU_done(ALU_Done),
        .RS_EX_alu_Physical_address(ALU_Phy),
        .Mul_Result(MUL_Data[31:0]),
        .RS_EX_PC_Mul_out(RS_EX_inst_num_Mul_out),
        .Mul_done_out(MUL_Done),
        .Div_Result(DIV_Data),
        .RS_EX_PC_Div_out(RS_EX_Div_inst_num_out),
        .Div_done_out(DIV_Done),
        .EX_MEM_MemToReg(EX_MEM_MemToReg),
        .Load_Done(Load_Done),
        .EX_MEM_MemWrite(EX_MEM_MemWrite),
        .EX_MEM_funct3(EX_MEM_funct3),
        .EX_MEM_Rdata2(EX_MEM_Rdata2),
        .EX_MEM_ALUResult(EX_MEM_ALUResult),
        .EX_MEM_alu_exec_PC(EX_MEM_alu_inst_num),
        .EX_MEM_alu_exec_done(EX_MEM_alu_exec_done),
        .EX_MEM_alu_physical_address(Load_Phy),
        .mul_exec_value(mul_exec_value),
        .mul_exec_PC(EX_MEM_mul_inst_num),
        .mul_exec_done(mul_exec_done),
        .div_exec_value(div_exec_value),
        .div_exec_PC(EX_MEM_div_inst_num),
        .div_exec_done(div_exec_done)
    );

    // DataMemory instantiation
    DataMemory datamem (
        .Load_Done(Load_Done),
        .EX_MEM_MemWrite(EX_MEM_MemWrite),
        .reset(rst),
        .EX_MEM_funct3(EX_MEM_funct3),
        .EX_MEM_ALUResult(EX_MEM_ALUResult),
        .EX_MEM_Rdata2(EX_MEM_Rdata2),
        .Load_Data(Load_Data)
    );

  

    // WbMux instantiation
    WbMux wb_mux (
        .MEM_WB_ALUResult(EX_MEM_ALUResult),
        .MEM_WB_RData(Load_Data),
        .MEM_WB_MemToReg(EX_MEM_MemToReg),
        .alu_exec_value(alu_exec_value)
    );
    
    MUX_2input Savage_Mux (.a(EX_MEM_alu_exec_done),.b(Load_Done),
    .sel(Load_Done),.y(alu_exec_done)); 

    // ROB instantiation
    ROB rob (
        .clk(clk),
        .rst(rst),
        .ROB_Flush(ROB_Flush),
        .IF_ID_instOut(IF_ID_instOut),
        .reg_write(RegWrite),
        .alu_exec_done(alu_exec_done),
        .alu_exec_value(alu_exec_value),
        .alu_exec_PC(EX_MEM_alu_inst_num),
        .mul_exec_done(mul_exec_done),
        .mul_exec_value(mul_exec_value),
        .mul_exec_PC(EX_MEM_mul_inst_num),
        .div_exec_done(div_exec_done),
        .div_exec_value(div_exec_value),
        .div_exec_PC(EX_MEM_div_inst_num),
        .PcSrc(Predict_Result),
        .PC_Return(PC_Return),
        .branch_index(Branch_index),
        .PC(IF_ID_inst_num),
        .out_value(out_value),
        .out_dest(out_dest),
        .out_reg_write(out_reg_write)
    );

    // logical_address_register instantiation
    logical_address_register logical_reg (
        .clk(clk),
        .reset(rst),
        .Reg_write(out_reg_write),
        .logical_address(out_dest),
        .write_data(out_value),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .x6(x6),
        .x7(x7),
        .x8(x8),
        .x9(x9),
        .x10(x10),
        .x11(x11),
        .x12(x12),
        .x13(x13),
        .x14(x14),
        .x15(x15),
        .x16(x16),
        .x17(x17),
        .x18(x18),
        .x19(x19),
        .x20(x20),
        .x21(x21),
        .x22(x22),
        .x23(x23),
        .x24(x24),
        .x25(x25),
        .x26(x26),
        .x27(x27),
        .x28(x28),
        .x29(x29),
        .x30(x30),
        .x31(x31)
    );
endmodule
