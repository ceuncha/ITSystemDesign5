module CPU_top(
    input clk,
    input reset,
    output [7:0] debug_PC
);


// wire declarations
// IF stage
(* keep = "true" *)wire [31:0] PC, PC_Branch;
assign debug_PC = PC[7:0];
(* keep = "true" *)wire PC_Stall, PCSrc;
(* keep = "true" *)wire [31:0] instOut;
(* keep = "true" *)wire IF_ID_Stall, IF_ID_Flush;
// ID stage
(* keep = "true" *)wire [31:0] IF_ID_instOut;
(* keep = "true" *)wire [31:0] IF_ID_PC;
    // parse instOut
(* keep = "true" *)wire [6:0] funct7 = IF_ID_instOut[31:25];
(* keep = "true" *)wire [4:0] IF_ID_Rs1 = IF_ID_instOut[19:15];
(* keep = "true" *)wire [4:0] IF_ID_Rs2 = IF_ID_instOut[24:20];
(* keep = "true" *)wire [2:0] funct3 = IF_ID_instOut[14:12];
(* keep = "true" *)wire [4:0] IF_ID_Rd = IF_ID_instOut[11:7];
(* keep = "true" *)wire [6:0] opcode = IF_ID_instOut[6:0];
(* keep = "true" *)wire [31:0] imm32;
(* keep = "true" *)wire RegWrite;
(* keep = "true" *)wire MemToReg;
(* keep = "true" *)wire MemRead;
(* keep = "true" *)wire MemWrite;
(* keep = "true" *)wire [3:0] ALUOp;
(* keep = "true" *)wire [1:0] ALUSrc;
(* keep = "true" *)wire RWsel;
(* keep = "true" *)wire Jump;
(* keep = "true" *)wire Branch;
(* keep = "true" *)wire Control_Sig_Stall, ID_EX_Flush;
(* keep = "true" *)wire [31:0]RData1, RData2;

    // pipeline reg
(* keep = "true" *)wire ID_EX_RegWrite;
(* keep = "true" *)wire ID_EX_MemWrite;
(* keep = "true" *)wire ID_EX_MemRead;
(* keep = "true" *)wire [3:0] ID_EX_ALUOp;
(* keep = "true" *)wire [1:0] ID_EX_ALUSrc;
(* keep = "true" *)wire ID_EX_MemToReg;
(* keep = "true" *)wire ID_EX_RWsel;
(* keep = "true" *)wire [31:0]ID_EX_PC;
(* keep = "true" *)wire ID_EX_Branch;
(* keep = "true" *)wire ID_EX_Jump;
(* keep = "true" *)wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
(* keep = "true" *)wire [2:0] ID_EX_funct3;
(* keep = "true" *)wire [31:0] ID_EX_RData1, ID_EX_RData2;
(* keep = "true" *)wire [31:0] ID_EX_imm32;
(* keep = "true" *)wire [31:0] Rd_data;
// EX stage
(* keep = "true" *)wire [1:0] ForwardA, ForwardB;
(* keep = "true" *)wire [31:0] ALUResult;
(* keep = "true" *)wire [31:0] ResultA, ResultB;
    // pipeline reg
(* keep = "true" *)wire EX_MEM_RegWrite;
(* keep = "true" *)wire EX_MEM_MemWrite;
(* keep = "true" *)wire EX_MEM_MemRead;
(* keep = "true" *)wire EX_MEM_MemToReg;
(* keep = "true" *)wire EX_MEM_RWsel;
(* keep = "true" *)wire [2:0] EX_MEM_funct3;
(* keep = "true" *)wire [4:0] EX_MEM_Rd;
(* keep = "true" *)wire [31:0] EX_MEM_ALUResult;
(* keep = "true" *)wire [31:0] EX_MEM_RData2;
(* keep = "true" *)wire [31:0] EX_MEM_Rd_data;
// MEM stage
(* keep = "true" *)wire [31:0] RData;
    //pipeline reg
(* keep = "true" *)wire MEM_WB_RegWrite;
(* keep = "true" *)wire MEM_WB_MemToReg;
(* keep = "true" *)wire MEM_WB_RWsel;
(* keep = "true" *)wire [4:0] MEM_WB_Rd;
(* keep = "true" *)wire [31:0] MEM_WB_Rd_data;
(* keep = "true" *)wire [31:0] MEM_WB_ALUResult;
(* keep = "true" *)wire [31:0] MEM_WB_RData;
// WB stage
(* keep = "true" *)wire [31:0] mem_out;
(* keep = "true" *)wire [31:0] MEM_WB_Result;
(* keep = "true" *)wire [2:0] MEM_WB_funct3; 

// module declaraions
// IF stage
(* keep_hierarchy = "yes" *)
Program_Counter u_Program_Counter(
    .clk (clk),
    .reset(reset),
    .PC_Branch(PC_Branch),
    .PC_Stall (PC_Stall),
    .PCSrc(PCSrc),
    .PC (PC)
);



//(* keep_hierarchy = "yes" *)
//Inst_mem u_InstructionMemory (
//    .clk(clk),           // input wire clka           // input wire ena (always enabled)
//    .a(PC[11:2]),     // input wire [9:0] addra (assuming 1024 depth)
//    .spo(instOut),
//    .we(1'b0)
          // output wire [31:0] douta
//);


(* keep_hierarchy = "yes" *)
ifid_pipeline_register u_ifid_pipeline_register(
    .clk (clk),
    .IF_ID_Stall (IF_ID_Stall),
    .IF_ID_Flush (IF_ID_Flush),
    .PC (PC),
    .IF_ID_instOut (IF_ID_instOut),
    .IF_ID_PC (IF_ID_PC)
);
// ID stage
(* keep_hierarchy = "yes" *)
register_file u_register_file(
    .clk (clk),
    .reset(reset),
    .Rs1 (IF_ID_Rs1),.Rs2 (IF_ID_Rs2),.RD (MEM_WB_Rd),
    .MEM_WB_RegWrite (MEM_WB_RegWrite),
    .Write_Data (MEM_WB_Result),
    .RData1 (RData1),.RData2 (RData2)
);
(* keep_hierarchy = "yes" *)
sign_extend u_sign_extend(
    .inst(IF_ID_instOut),
    .Imm(imm32)
);
(* keep_hierarchy = "yes" *)
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
(* keep_hierarchy = "yes" *)
Hazard_Detection_unit u_Hazard_Detection_unit(
    .ID_EX_MemRead(ID_EX_MemRead),
    .IF_ID_Rs1(IF_ID_Rs1),.IF_ID_Rs2(IF_ID_Rs2),
    .ID_EX_Rd(ID_EX_Rd),
    .PC_Stall(PC_Stall),
    .IF_ID_Stall(IF_ID_Stall),
    .Control_Sig_Stall(Control_Sig_Stall)
);
(* keep_hierarchy = "yes" *)
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
(* keep_hierarchy = "yes" *)
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
(* keep_hierarchy = "yes" *)
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
(* keep_hierarchy = "yes" *)
data_forwarding_unit u_data_forwarding_unit(
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .EX_MEM_Rd(EX_MEM_Rd),.MEM_WB_Rd(MEM_WB_Rd),
    .ID_EX_Rs1(ID_EX_Rs1),.ID_EX_Rs2(ID_EX_Rs2),
    .ForwardA(ForwardA),.ForwardB(ForwardB)
);
(* keep_hierarchy = "yes" *)
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
    .ResultB(ResultB),
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
(* keep_hierarchy = "yes" *)
DataMemory u_DataMemory(
    .clk(clk),
    .reset(reset),
    .MemWrite(EX_MEM_MemWrite),
    .funct3(EX_MEM_funct3),
    .ALUResult(EX_MEM_ALUResult),
    .WriteData(EX_MEM_RData2),
    .ReadData(RData)
  
);
(* keep_hierarchy = "yes" *)
memwb_pipeline_register u_memwb_pipeline_register(
    .clk(clk),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .EX_MEM_MemToReg(EX_MEM_MemToReg),
    .EX_MEM_RWsel(EX_MEM_RWsel),
    .EX_MEM_Rd(EX_MEM_Rd),
    .EX_MEM_Rd_data(EX_MEM_Rd_data),
    .EX_MEM_ALUResult(EX_MEM_ALUResult),
    .EX_MEM_funct3(EX_MEM_funct3),
    
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .MEM_WB_MemToReg(MEM_WB_MemToReg),
    .MEM_WB_RWsel(MEM_WB_RWsel),
    .MEM_WB_Rd(MEM_WB_Rd),
    .MEM_WB_Rd_data(MEM_WB_Rd_data),
    .MEM_WB_ALUResult(MEM_WB_ALUResult),
    .MEM_WB_funct3(MEM_WB_funct3)
    
);
//WB stage
(* keep_hierarchy = "yes" *)
WbMux u_WbMux(
    .Address(MEM_WB_ALUResult),
    .RData(RData),
    .wm2reg(MEM_WB_MemToReg),
    .mem_out(mem_out),
    .MEM_WB_funct3(MEM_WB_funct3)
);
(* keep_hierarchy = "yes" *)
pretty_mux u_pretty_mux(
    .mem_out(mem_out),
    .MEM_WB_Rd_data(MEM_WB_Rd_data),
    .MEM_WB_RWsel(MEM_WB_RWsel),
    .Write_Data(MEM_WB_Result)
);

// Buffered MEM_WB_Rd
wire [31:0] buffered_MEM_WB_Rd;

// ���� ���?? �ν��Ͻ�ȭ
Buffer #(.DELAY(0.03)) buffer_inst (
    .clk(clk),
    .in_data(MEM_WB_Rd),
    .out_data(buffered_MEM_WB_Rd)
);

endmodule
