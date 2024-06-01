module MEM_WB_top (
    input clk,
    input reset,
    input ID_EX_MemToReg,
    input ID_EX_MemRead,
    input ID_EX_MemWrite,
    input [3:0] RS_EX_funt3,
    input [31:0] operand2_Phy_Data,
    input [31:0] RS_EX_ALUResult,
    input [31:0] RS_EX_PC_ALU,
    input ALU_done,
    input [7:0] RS_EX_alu_Physical_address,
    input [31:0] Mul_Result,
    input [31:0] RS_EX_PC_Mul_out,
    input Mul_done_out,
    input [31:0] Div_Result,
    input [31:0] RS_EX_PC_Div_out,
    input Div_done_out,
    input [31:0] IF_ID_instOut,
    input reg_write,
    input PcSrc,
    input [31:0] PC_Return,
    input [31:0] branch_index,
    input [31:0] PC,

    output [31:0] out_value,
    output [4:0] out_dest,
    output out_reg_write,
    output [31:0] read_data // 추가된 출력 신호
);
    // Intermediate signals
    wire EX_MEM_MemToReg, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_alu_exec_done, mul_exec_done, div_exec_done;
    wire [2:0] EX_MEM_funct3;
    wire [31:0] EX_MEM_Rdata2, EX_MEM_ALUResult, EX_MEM_alu_exec_PC, EX_MEM_alu_physical_address;
    wire [31:0] mul_exec_value, mul_exec_PC, div_exec_value, div_exec_PC;
    wire [31:0] RData;
    wire MEM_WB_MemToReg;
    wire [31:0] MEM_WB_ALUResult, MEM_WB_RData, alu_exec_value, alu_exec_PC;
    wire alu_exec_done;

    // exmem_pipeline_register instantiation
    exmem_pipeline_register exmem (
        .clk(clk),
        .reset(reset),
        .ID_EX_MemToReg(ID_EX_MemToReg),
        .ID_EX_MemRead(ID_EX_MemRead),
        .ID_EX_MemWrite(ID_EX_MemWrite),
        .RS_EX_funt3(RS_EX_funt3),
        .operand2_Phy_Data(operand2_Phy_Data),
        .RS_EX_ALUResult(RS_EX_ALUResult),
        .RS_EX_PC_ALU(RS_EX_PC_ALU),
        .ALU_done(ALU_done),
        .RS_EX_alu_Physical_address(RS_EX_alu_Physical_address),
        .Mul_Result(Mul_Result),
        .RS_EX_PC_Mul_out(RS_EX_PC_Mul_out),
        .Mul_done_out(Mul_done_out),
        .Div_Result(Div_Result),
        .RS_EX_PC_Div_out(RS_EX_PC_Div_out),
        .Div_done_out(Div_done_out),
        .EX_MEM_MemToReg(EX_MEM_MemToReg),
        .EX_MEM_MemRead(EX_MEM_MemRead),
        .EX_MEM_MemWrite(EX_MEM_MemWrite),
        .EX_MEM_funct3(EX_MEM_funct3),
        .EX_MEM_Rdata2(EX_MEM_Rdata2),
        .EX_MEM_ALUResult(EX_MEM_ALUResult),
        .EX_MEM_alu_exec_PC(EX_MEM_alu_exec_PC),
        .EX_MEM_alu_exec_done(EX_MEM_alu_exec_done),
        .EX_MEM_alu_physical_address(EX_MEM_alu_physical_address),
        .mul_exec_value(mul_exec_value),
        .mul_exec_PC(mul_exec_PC),
        .mul_exec_done(mul_exec_done),
        .div_exec_value(div_exec_value),
        .div_exec_PC(div_exec_PC),
        .div_exec_done(div_exec_done)
    );

    // DataMemory instantiation
    DataMemory datamem (
        .EX_MEM_MemRead(EX_MEM_MemRead),
        .EX_MEM_MemWrite(EX_MEM_MemWrite),
        .EX_MEM_funct3(EX_MEM_funct3),
        .EX_MEM_ALUResult(EX_MEM_ALUResult),
        .EX_MEM_Rdata2(EX_MEM_Rdata2),
        .RData(RData)
    );

    // memwb_pipeline_register instantiation
    memwb_pipeline_register memwb (
        .clk(clk),
        .reset(reset),
        .EX_MEM_MemToReg(EX_MEM_MemToReg),
        .EX_MEM_ALUResult(EX_MEM_ALUResult),
        .RData(RData),
        .EX_MEM_alu_exec_PC(EX_MEM_alu_exec_PC),
        .EX_MEM_alu_exec_done(EX_MEM_alu_exec_done),
        .MEM_WB_MemToReg(MEM_WB_MemToReg),
        .MEM_WB_ALUResult(MEM_WB_ALUResult),
        .MEM_WB_RData(MEM_WB_RData),
        .alu_exec_done(alu_exec_done),
        .alu_exec_PC(alu_exec_PC)
    );

    // WbMux instantiation
    WbMux wb_mux (
        .MEM_WB_ALUResult(MEM_WB_ALUResult),
        .MEM_WB_RData(MEM_WB_RData),
        .MEM_WB_MemToReg(MEM_WB_MemToReg),
        .alu_exec_value(alu_exec_value)
    );

    // ROB instantiation
    ROB rob (
        .clk(clk),
        .rst(reset),
        .IF_ID_instOut(IF_ID_instOut),
        .reg_write(reg_write),
        .alu_exec_done(alu_exec_done),
        .alu_exec_value(alu_exec_value),
        .alu_exec_PC(alu_exec_PC),
        .mul_exec_done(mul_exec_done),
        .mul_exec_value(mul_exec_value),
        .mul_exec_PC(mul_exec_PC),
        .div_exec_done(div_exec_done),
        .div_exec_value(div_exec_value),
        .div_exec_PC(div_exec_PC),
        .PcSrc(PcSrc),
        .PC_Return(PC_Return),
        .branch_index(branch_index),
        .PC(PC),
        .out_value(out_value),
        .out_dest(out_dest),
        .out_reg_write(out_reg_write)
    );

    // logical_address_register instantiation
    logical_address_register logical_reg (
        .clk(clk),
        .reset(reset),
        .mem_to_write(out_reg_write),
        .logical_address(out_dest),
        .write_data(out_value),
        .read_data(read_data)
    );
endmodule
