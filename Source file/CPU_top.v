module CPU_top(
    input clk,
    input rst,
);

wire [31:0] PC, PC_Branch;   
wire  PCSrc;
wire [31:0] instOut;
wire [4:0] Rs1 = instOut[19:15];
wire [4:0] Rs2 = instOut[24:20];
wire [4:0] Rd =instOut[11:7];
wire [6:0] instOut_opcode = instOut[6:0];
// ID stage
wire [31:0] IF_ID_instOut;
wire [31:0] IF_ID_PC;
wire IF_ID_Flush;
wire ROB_Flush;
    // parse instOut
wire [6:0] funct7 = IF_ID_instOut[31:25];
wire [2:0] funct3 = IF_ID_instOut[14:12];
wire [6:0] opcode = IF_ID_instOut[6:0];
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
wire Phy_addr_OP1;
wire Phy_addr_OP2;
//pfile to decoder
wire Valid1;
wire Valid2;
wire [1:0] Valid = {Valid2,Valid1};
wire [31:0] RData1;
wire [31:0] RData2;
wire [7:0] Rd_phy;
//BB to RAT and Pfile
wire save_on;
wire [2:0] save_page;
wire restore_on;
wire [2:0] restore_page;
//Branch unit to BB
wire [31:0] Branch_PC;
//forwarding wb
wire [31:0] ALU_Data;
wire [31:0] DIV_Data;
wire [31:0] MUL_Data;
wire [31:0] Load_Data;
wire [7:0] ALU_Phy;
wire [7:0] DIV_Phy;
wire [7:0] MUL_Phy;
wire [7:0] Load_Phy;
wire ALU_Done;
wire DIV_Done;
wire MUL_Done;
wire Load_Done;


///////////////////////////IF_ID////////////////////////////////////////////////
Program_Counter u_Program_Counter(
    .clk(clk),
    .rst(rst),
    .PC_Branch(PC_Branch),
    .PCSrc(PCSrc),
    .PC(PC)
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
    .IF_ID_Flush(IF_ID_Flush),
    .IF_ID_instOut(IF_ID_instOut),  
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

    .save_state(save_on),    // 사본 레지스터에 상태 저장 신호
    .restore_state(restore_on), // 사본 레지스터에서 상태 복원 신호
    .save_page(save_page),     // 상태 저장용 사본 레지스터 페이지 선택 신호
    .restore_page(restore_page),  // 상태 복원 신호
    .logical_addr1(Rs1), // 오퍼랜드 1 논리 주소
    .logical_addr2(Rs2), // 오퍼랜드 2 논리 주소
    .rd_logical_addr(Rd), // 쓰기 작업을 하는 논리 주소 (Rd)
    .free_phy_addr(chuchu_addr),   // 프리리스트로부터 받은 비어있는 물리 주소
    .opcode(opcode),

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
    .ALU_mul_Data(MUL_Data),
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
    .PCSrc(PCSrc),                    // Branch decision signal
    .branch_PC(Branch_PC),         // Branch index in ROB
    .PC(PC),                // Current PC value (expanded to 32 bits)
    .tail_num(save_page),           // Output value
    .Copy_RAT(save_on),                 // Output register destination extracted from instr[11:7]
    .head_num(restore_page),           // Output RegWrite signal to indicate a register write operation
    .Paste_RAT(restore_on)
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
endmodule
