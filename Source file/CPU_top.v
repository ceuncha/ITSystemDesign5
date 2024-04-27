module CPU_top(
    input clk
);

// wire declarations
// IF stage
wire [31:0] PC, PC_Branch;
wire PC_Stall, PCSrc;
wire [31:0] instOut;
wire IF_ID_Stall, IF_ID_Flush;
// ID stage
wire [31:0] IF_ID_instOut;
wire [31:0] IF_ID_PC;
    // parse instOut
wire [6:0] funct7 = IF_ID_instOut[31:25];
wire [4:0] IF_ID_Rs1 = IF_ID_instOut[19:15];
wire [4:0] IF_ID_Rs2 = IF_ID_instOut[24:20];
wire [2:0] funct3 = IF_ID_instOut[14:12];
wire [4:0] IF_ID_Rd = IF_ID_instOut[11:7];
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
wire Control_Sig_Stall, ID_EX_Flush;
wire [31:0]RData1, RData2;

    // pipeline reg
wire ID_EX_RegWrite;
wire ID_EX_MemWrite;
wire ID_EX_MemRead;
wire [3:0] ID_EX_ALUOp;
wire [1:0] ID_EX_ALUSrc;
wire ID_EX_MemToReg;
wire ID_EX_RWsel;
wire [31:0]ID_EX_PC;
wire ID_EX_Branch;
wire ID_EX_Jump;
wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
wire [2:0] ID_EX_funct3;
wire [31:0] ID_EX_RData1, ID_EX_RData2;
wire [31:0] ID_EX_imm32;
wire [31:0] Rd_data;
// EX stage
wire [1:0] ForwardA, ForwardB;
wire [31:0] ALUResult;
wire [31:0] ResultA, ResultB;
    // pipeline reg
wire EX_MEM_RegWrite;
wire EX_MEM_MemWrite;
wire EX_MEM_MemRead;
wire EX_MEM_MemToReg;
wire EX_MEM_RWsel;
wire [2:0] EX_MEM_funct3;
wire [4:0] EX_MEM_Rd;
wire [31:0] EX_MEM_ALUResult;
wire [31:0] EX_MEM_RData2;
wire [31:0] EX_MEM_Rd_data;
// MEM stage
wire [31:0] RData;
    //pipeline reg
wire MEM_WB_RegWrite;
wire MEM_WB_MemToReg;
wire MEM_WB_RWsel;
wire [4:0] MEM_WB_Rd;
wire [31:0] MEM_WB_Rd_data;
wire [31:0] MEM_WB_ALUResult;
wire [31:0] MEM_WB_RData;
// WB stage
wire [31:0] mem_out;
wire [31:0] MEM_WB_Result;

// module declaraions
// IF stage
Program_Counter u_Program_Counter(
    .clk (clk),
    .PC_Branch(PC_Branch),
    .PC_Stall (PC_Stall),
    .PCSrc(PCSrc),
    .PC (PC)
);

Instruction_memory u_Instruction_memory(
    .pc (PC),
    .instOut (instOut)
);
ifid_pipeline_register u_ifid_pipeline_register(
    .clk (clk),
    .IF_ID_Stall (IF_ID_Stall),
    .IF_ID_Flush (IF_ID_Flush),
    .instOut (instOut),
    .PC (PC),
    .IF_ID_instOut (IF_ID_instOut),
    .IF_ID_PC (IF_ID_PC)
);
// ID stage
register_file u_register_file(
    .clk (clk),
    .Rs1 (IF_ID_Rs1),.Rs2 (IF_ID_Rs2),.RD (EX_MEM_Rd),
    .MEM_WB_RegWrite (MEM_WB_RegWrite),
    .Write_Data (MEM_WB_Result),
    .RData1 (RData1),.RData2 (RData2)
);
sign_extend u_sign_extend(
    .inst(IF_ID_instOut),
    .Imm(imm32)
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
    .Jump(Jump),
    .Branch(Branch)
);
Hazard_Detection_unit u_Hazard_Detection_unit(
    .ID_EX_MemRead(ID_EX_MemRead),
    .IF_ID_Rs1(IF_ID_Rs1),.IF_ID_Rs2(iF_ID_Rs2),.IF_ID_Rd(IF_ID_Rd),
    .ID_EX_Rd(ID_EX_Rd),
    .PC_Stall(PC_Stall),
    .IF_ID_Stall(IF_ID_Stall),
    .Control_Sig_Stall(Control_Sig_Stall)
);

idex_pipeline_register u_idex_pipeline_register(
    .clk(clk),
    .RegWrite(RegWrite),
    .MemToReg(MemToReg),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .RWsel(RWsel),
    .Jump(Jump),
    .Branch(Branch),
    .Control_Sig_Stall(Control_Sig_Stall),
    .IF_ID_Rs1(IF_ID_Rs1),.IF_ID_Rs2(IF_ID_Rs2),.IF_ID_Rd(IF_ID_Rd),
    .IF_ID_funct3(IF_ID_instOut[14:12]),
    .IF_ID_PC(IF_ID_PC),
    .RData1(RData1),.RData2(RData2),
    .imm32(imm32),
    .ID_EX_RWsel(ID_EX_RWsel),
    .ID_EX_RegWrite(ID_EX_RegWrite),
    .ID_EX_MemWrite(ID_EX_MemWrite),
    .ID_EX_MemRead(ID_EX_MemRead),
    .ID_EX_ALUOp(ID_EX_ALUOp),
    .ID_EX_ALUSrc(ID_EX_ALUSrc),
    .ID_EX_MemToReg(ID_EX_MemToReg),
    .ID_EX_Jump(ID_EX_Jump),
    .ID_EX_Branch(ID_EX_Branch),
    .ID_EX_Rs1(ID_EX_Rs1), .ID_EX_Rs2(ID_EX_Rs2), .ID_EX_Rd(ID_EX_Rd),
    .ID_EX_funct3(ID_EX_funct3),
    .ID_EX_RData1(ID_EX_RData1), .ID_EX_RData2(ID_EX_RData2),
    .ID_EX_imm32(ID_EX_imm32),
    .ID_EX_PC(ID_EX_PC),
    .ID_EX_Flush(ID_EX_Flush)
);
// EX stage
ALU_top u_ALU_top(
    .A(ID_EX_RData1), .B(ID_EX_RData2),
    .WB_A(MEM_WB_Result),.WB_B(MEM_WB_Result),
    .ALU_A(EX_MEM_ALUResult),.ALU_B(EX_MEM_ALUResult),
    .immediate(ID_EX_imm32), .ID_EX_PC(ID_EX_PC),
    .SEL_A(ForwardA), .SEL_B(ForwardB),
    .ALUsrc(ID_EX_ALUSrc),
    .ALUop(ID_EX_ALUOp),
    .Result(ALUResult), .ResultA(ResultA) , .ResultB(ResultB)
    //.negative(),.overflow(),.zero(),.carry(),
);

branch_unit u_branch_unit (
    .ResultA(ResultA),      
    .ResultB(ResultB),       
    .ID_EX_PC(ID_EX_PC),     
    .ID_EX_Branch(ID_EX_Branch),   
    .ID_EX_funct3(ID_EX_funct3),  
    .ALUResult(ALUResult),   
    .ID_EX_Jump(ID_EX_Jump), 
    .PCSrc(PCSrc),           
    .PC_Branch(PC_Branch),   
    .Rd_data(Rd_data),       
    .IF_ID_Flush(IF_ID_Flush),   
    .ID_EX_Flush(ID_EX_Flush)    
);


data_forwarding_unit u_data_forwarding_unit(
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .EX_MEM_Rd(EX_MEM_Rd),.MEM_WB_Rd(MEM_WB_Rd),
    .ID_EX_Rs1(ID_EX_Rs1),.ID_EX_Rs2(ID_EX_Rs2),
    .ForwardA(ForwardA),.ForwardB(ForwardB)
);

exmem_pipeline_register u_exmem_pipeline_register(
    .clk(clk),
    .ID_EX_MemRead(ID_EX_MemRead),
    .ID_EX_RegWrite(ID_EX_RegWrite),
    .ID_EX_MemWrite(ID_EX_MemWrite),
    .ID_EX_MemToReg(ID_EX_MemToReg),
    .ID_EX_RWsel(ID_EX_RWsel),
    .ID_EX_funct3(ID_EX_funct3),
    .ID_EX_Rd(ID_EX_Rd),
    .ALUResult(ALUResult),
    .Rd_data(Rd_data),
    .ID_EX_RData2(ID_EX_RData2),
    .EX_MEM_MemRead(EX_MEM_MemRead),
    .EX_MEM_RWsel(EX_MEM_RWsel),
    .EX_MEM_MemToReg(EX_MEM_MemToReg),
    .EX_MEM_MemWrite(EX_MEM_MemWrite),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .EX_MEM_funct3(EX_MEM_funct3),
    .EX_MEM_Rd(EX_MEM_Rd),
    .EX_MEM_ALUResult(EX_MEM_ALUResult),
    .EX_MEM_RData2(EX_MEM_RData2),
    .EX_MEM_Rd_data(EX_MEM_Rd_data)
);
// MEM stage
DataMemory u_DataMemory(
    .MemRead(EX_MEM_MemRead),
    .MemWrite(EX_MEM_MemWrite),
    .funct3(EX_MEM_funct3),
    .ALUResult(EX_MEM_ALUResult),
    .WriteData(ID_EX_RData2),
    .ReadData(RData)
);
memwb_pipeline_register u_memwb_pipeline_register(
    .clk(clk),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .EX_MEM_MemToReg(EX_MEM_MemToReg),
    .EX_MEM_RWsel(EX_MEM_RWsel),
    .EX_MEM_Rd(EX_MEM_Rd),
    .EX_MEM_Rd_data(EX_MEM_Rd_data),
    .EX_MEM_ALUResult(EX_MEM_ALUResult),
    .RData(RData),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .MEM_WB_MemToReg(MEM_WB_MemToReg),
    .MEM_WB_RWsel(MEM_WB_RWsel),
    .MEM_WB_Rd(MEM_WB_Rd),
    .MEM_WB_Rd_data(MEM_WB_Rd_data),
    .MEM_WB_ALUResult(MEM_WB_ALUResult),
    .MEM_WB_RData(MEM_WB_RData)
);
//WB stage
WbMux u_WbMux(
    .Address(MEM_WB_ALUResult),
    .RData(MEM_WB_RData),
    .wm2reg(MEM_WB_MemToReg),
    .mem_out(mem_out)
);
pretty_mux u_pretty_mux(
    .mem_out(mem_out),
    .MEM_WB_Rd_data(MEM_WB_Rd_data),
    .MEM_WB_RWsel(MEM_WB_RWsel),
    .Write_Data(MEM_WB_Result)
);
endmodule
