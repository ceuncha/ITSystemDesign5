//IFID PIPELINE REGISTER
module ifid_pipeline_register (
    input clk,
    input reset,
    input IF_ID_Stall, IF_ID_Flush,
    input [31:0] instOut,
    input [31:0] PC,
    output reg [31:0] IF_ID_instOut,  
    output reg [31:0] IF_ID_PC,
    output reg id_on
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 리셋 신호가 활성화되면 초기화
            IF_ID_instOut <= 32'b0;
            IF_ID_PC <= 32'b0;
            id_on <= 1'b0;
        end else if (IF_ID_Flush) begin
            // NOP 명령어 출력
            IF_ID_instOut <= 32'h00000013; // RV32I에서의 NOP 명령어
            IF_ID_PC <= PC; // PC는 NOP 상태에서도 업데이트 될 수 있도록 유지
        end else begin
            // 플러시가 아니고 스톨도 아닐 때 정상 동작
            IF_ID_instOut <= instOut;
            IF_ID_PC <= PC;
            id_on <= 1'b1;
        end
    end

    always @(negedge clk) begin
        id_on <= 1'b0;
    end
endmodule

//IDRS PIPELINE REGISTER
module idrs_pipeline_register (
    input clk,
    input reset,
    input Control_Sig_Stall,
    input RegWrite,
    input MemToReg,
    input MemRead,
    input MemWrite,
    input [3:0] ALUOp,
    input [1:0] ALUSrc,
    input RWsel,
    input [4:0] IF_ID_Rs1, IF_ID_Rs2, IF_ID_Rd,
    input [2:0] IF_ID_funct3,
    input [31:0] RData1, RData2,
    input [31:0] imm32,  // sign extend output
    input Jump,
    input Branch,
    input [31:0] IF_ID_PC,
    input ID_RS_Flush,

    output reg ID_RS_RWsel,
    output reg [1:0] ID_RS_ALUSrc,
    output reg [3:0] ID_RS_ALUOp,
    output reg ID_RS_MemWrite,
    output reg ID_RS_MemRead,
    output reg ID_RS_MemToReg,
    output reg ID_RS_RegWrite,
    output reg [4:0] ID_RS_Rs1, ID_RS_Rs2, ID_RS_Rd,
    output reg [2:0] ID_RS_funct3,
    output reg [31:0] ID_RS_RData1, ID_RS_RData2,
    output reg [31:0] ID_RS_imm32,
    output reg ID_RS_Jump,
    output reg ID_RS_Branch,
    output reg [31:0] ID_RS_PC,
    output reg rs_on
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 리셋 신호가 활성화되면 초기화
            ID_RS_RWsel <= 1'b0;
            ID_RS_ALUSrc <= 2'b00;
            ID_RS_ALUOp <= 4'b0000;
            ID_RS_MemWrite <= 1'b0;
            ID_RS_MemRead <= 1'b0;
            ID_RS_MemToReg <= 1'b0;
            ID_RS_RegWrite <= 1'b0;
            ID_RS_Rs1 <= 5'b00000;
            ID_RS_Rs2 <= 5'b00000;
            ID_RS_Rd <= 5'b00000;
            ID_RS_funct3 <= 3'b000;
            ID_RS_RData1 <= 32'b0;
            ID_RS_RData2 <= 32'b0;
            ID_RS_imm32 <= 32'b0;
            ID_RS_Jump <= 1'b0;
            ID_RS_Branch <= 1'b0;
            ID_RS_PC <= 32'b0;
            rs_on <= 1'b0;
        end else if (ID_RS_Flush) begin
            // 플러시 신호가 활성화되면 NOP 상태로 초기화
            ID_RS_RWsel <= 1'b0;
            ID_RS_ALUSrc <= 2'b00;
            ID_RS_ALUOp <= 4'b0000;
            ID_RS_MemWrite <= 1'b0;
            ID_RS_MemRead <= 1'b0;
            ID_RS_MemToReg <= 1'b0;
            ID_RS_RegWrite <= 1'b0;
            ID_RS_Rs1 <= 5'b00000;
            ID_RS_Rs2 <= 5'b00000;
            ID_RS_Rd <= 5'b00000;
            ID_RS_funct3 <= 3'b000;
            ID_RS_RData1 <= 32'b0;
            ID_RS_RData2 <= 32'b0;
            ID_RS_imm32 <= 32'b0;
            ID_RS_Jump <= 1'b0;
            ID_RS_Branch <= 1'b0;
            ID_RS_PC <= 32'b0;
            rs_on <= 1'b0;
        end else if (!Control_Sig_Stall) begin
            // 정상 동작
            ID_RS_RWsel <= RWsel;
            ID_RS_ALUSrc <= ALUSrc;
            ID_RS_ALUOp <= ALUOp;
            ID_RS_MemWrite <= MemWrite;
            ID_RS_MemRead <= MemRead;
            ID_RS_MemToReg <= MemToReg;
            ID_RS_RegWrite <= RegWrite;
            ID_RS_RData1 <= RData1;
            ID_RS_RData2 <= RData2;
            ID_RS_Rs1 <= IF_ID_Rs1;
            ID_RS_Rs2 <= IF_ID_Rs2;
            ID_RS_Rd <= IF_ID_Rd;
            ID_RS_funct3 <= IF_ID_funct3;
            ID_RS_imm32 <= imm32;
            ID_RS_Jump <= Jump;
            ID_RS_Branch <= Branch;
            ID_RS_PC <= IF_ID_PC;
            rs_on <= 1'b1;
        end
    end
    
    always @(negedge clk) begin
        rs_on <= 1'b0;
    end
endmodule

//EXMEM PIPELINE REGISTER
module exmem_pipeline_register (
    input clk,
    input reset,
    input ID_EX_RegWrite,
    input ID_EX_MemToReg,
    input ID_EX_MemRead,
    input ID_EX_MemWrite,
    input ID_EX_RWsel,
    input [2:0] ID_EX_funct3,
    input [4:0] ID_EX_Rd, // inst decode
    input [31:0] ALUResult,  // ALU output
    input [31:0] ID_EX_RData2,  // regfile
    input [31:0] Rd_data,
    
    output reg EX_MEM_MemToReg,
    output reg EX_MEM_MemRead,
    output reg EX_MEM_MemWrite,
    output reg [2:0] EX_MEM_funct3,
    output reg [4:0] EX_MEM_Rd,
    output reg [31:0] EX_MEM_ALUResult,
    output reg [31:0] EX_MEM_RData2,
    output reg [31:0] EX_MEM_Rd_data

    output reg [31:0] mul_exec_value,
    output reg mul_exec_done,
    output reg [6:0] mul_phys_addr,
    output reg [31:0] mul_exec_index,

    output reg [31:0] div_exec_value
    output reg div_exec_done,
    output reg [6:0] div_phys_addr,
    output reg [31:0] div_exec_index
);
        
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 리셋 신호가 활성화되면 초기화
            EX_MEM_RegWrite <= 1'b0;
            EX_MEM_MemToReg <= 1'b0;
            EX_MEM_MemRead <= 1'b0;
            EX_MEM_MemWrite <= 1'b0;
            EX_MEM_RWsel <= 1'b0;
            EX_MEM_funct3 <= 3'b000;
            EX_MEM_Rd <= 5'b00000;
            EX_MEM_ALUResult <= 32'b0;
            EX_MEM_RData2 <= 32'b0;
            EX_MEM_Rd_data <= 32'b0;
        end else begin
            // 정상 동작
            EX_MEM_RegWrite <= ID_EX_RegWrite;
            EX_MEM_MemToReg <= ID_EX_MemToReg;
            EX_MEM_MemRead <= ID_EX_MemRead;
            EX_MEM_MemWrite <= ID_EX_MemWrite;
            EX_MEM_RWsel <= ID_EX_RWsel;
            EX_MEM_Rd <= ID_EX_Rd;
            EX_MEM_funct3 <= ID_EX_funct3;
            EX_MEM_ALUResult <= ALUResult;
            EX_MEM_RData2 <= ID_EX_RData2;
            EX_MEM_Rd_data <= Rd_data;
        end
    end
endmodule

//MEMWB PIPELINE REGISTER
module memwb_pipeline_register (
    input clk,
    input reset,
    input EX_MEM_MemToReg,
    input [31:0] EX_MEM_ALUResult,
    input [31:0] RData, // data memory
    input EX_MEM_alu_done,
    input [6:0]EX_MEM_alu_phys_addr,
    input [31:0]EX_MEM_alu_exec_index,
    
    input EX_MEM_mul_done,
    input [6:0]EX_MEM_mul_phys_addr,
    input [31:0]EX_MEM_mul_exec_index,
    
    output reg MEM_WB_MemToReg,
    output reg [31:0] MEM_WB_ALUResult,
    output reg [31:0] MEM_WB_RData
    output reg alu_exec_done,
    output reg [6:0] alu_phys_addr,
    output reg [31:0] alu_exec_index

);
        
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 리셋 신호가 활성화되면 초기화
            MEM_WB_MemToReg <= 1'b0;
            MEM_WB_ALUResult <= 32'b0;
            MEM_WB_RData <= 32'b0;
        end else begin
            // 정상 동작
            MEM_WB_MemToReg <= EX_MEM_MemToReg;
            MEM_WB_Rd <= EX_MEM_Rd;
            MEM_WB_ALUResult <= EX_MEM_ALUResult;
            MEM_WB_RData <= RData;
        end
    end
endmodule
