/*
기존 코드 대비 변경한 것: 

- 신호 이름 변경함. 파이프라인 내 요소는 IF_ID_instOut 형태로, 다른 모듈의 출력은 접두어 없이
- top module 내용은 빼고 module 내용물만 기술하였음
- Control 신호는 하나로 뭉쳐 놓음: 회의 때 얘기해봅시다.

앞으로 할 일:

- 테스트벤치 만들어서 시뮬레이션
- 기능 추가될 때마다 꼼꼼히 유지보수
*/

/*보수내용(기호민)
1. //IDEX PIPELINE REGISTER 에 Control_Sig_Stall 인풋 추가
2. control 신호 넣어둠.
*/


//IFID PIPELINE REGISTER
module ifid_pipeline_register (
    input clk,
    input IF_ID_Stall,
    input [31:0] instOut,  // inst mem의 출력
    input [31:0] PC,
    output reg [31:0] IF_ID_instOut,  // ID 단계의 inst
    output reg [31:0] IF_ID_PC
);
    
    always @(posedge clk) begin
        if(!IF_ID_Stall) begin
            IF_ID_instOut <= instOut;
            IF_ID_PC <= PC;
        end
        else begin
            // Stall 발생 시 동작
        end
    end
endmodule

//IDEX PIPELINE REGISTER
module idex_pipeline_register (    
    input clk,
    
    input RegWrite, MemToReg, MemRead, MemWrite, ALUSrc,
    input [3:0] ALUOp,
    input RWSel,
    
    input Control_Sig_Stall,
    input [4:0] IF_ID_Rs1, IF_ID_Rs2, IF_ID_Rd,
    input [2:0] IF_ID_funct3,
    input [31:0] RData1, RData2,
    input [31:0] imm32,  // sign extend의 output
    input [31:0] PC_Plus4, PC_imm, imm_out,

    output reg ID_EX_RegWrite, ID_EX_MemToReg, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_ALUSrc,
    output reg [3:0] ID_EX_ALUOp,
    output reg ID_EX_RWSel,
    
    output reg [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd,
    output reg [2:0] ID_EX_funct3,
    output reg [31:0] ID_EX_RData1, ID_EX_RData2,
    output reg [31:0] ID_EX_imm32,
    output reg [31:0] ID_EX_PC_Plus4, ID_EX_PC_imm, ID_EX_imm_out
);
        
    always @(posedge clk) begin
        if(!Control_Sig_Stall) begin
            ID_EX_RegWrite <= RegWrite;
            ID_EX_MemToReg <= MemToReg;
            ID_EX_MemRead <= MemRead;
            ID_EX_MemWrite <= MemWrite;
            ID_EX_ALUSrc <= ALUSrc;
            ID_EX_ALUOp <= ALUOp;
            ID_EX_RWSel <= RWSel;
            
            ID_EX_Control_Sig <= Control_Sig;
            ID_EX_Rs1 <= IF_ID_Rs1;
            ID_EX_Rs2 <= IF_ID_Rs2;
            ID_EX_Rd <= IF_ID_Rd;
            ID_EX_funct3 <= IF_ID_funct3;
            ID_EX_imm32 <= imm32;
            ID_EX_PC_Plus4 <= PC_Plus4;
            ID_EX_PC_imm <= PC_imm;
            ID_EX_imm_out <= imm_out;
        end
        else begin
            // Stall 발생 시 동작
        end
        
    end 
endmodule

//EXMEM PIPELINE REGISTER
module exmem_pipeline_register #(
    parameter Control_Width = 11
)(
    input clk,
    input reg ID_EX_RegWrite, ID_EX_MemToReg, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_RWSel
   
    
    input [4:0] ID_EX_Rd, // inst decode해서 나온 dest reg가 넘어온 것
    input [31:0] ALUResult,  // ALU output
    input [31:0] ID_EX_RData2,  // regfile의 output 중 2가 넘어온 것
    input [31:0] ID_EX_PC_Plus4, ID_EX_PC_imm, ID_EX_imm_out, // Branch unit에서 넘어온 것
    
    output reg EX_MEM_RegWrite, EX_MEM_MemToReg, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_RWSel,
    
    output reg [4:0] EX_MEM_Rd,
    output reg [31:0] EX_MEM_ALUResult,
    output reg [31:0] EX_MEM_RData2,
    output reg [31:0] EX_MEM_PC_Plus4, EX_MEM_PC_imm, EX_MEM_imm_out
);
        
    always @(posedge clk) begin
        
        EX_MEM_RegWrite <= ID_EX_RegWrite;
        EX_MEM_MemToReg <= ID_EX_MemToReg;
        EX_MEM_MemRead <= ID_EX_MemRead;
        EX_MEM_MemWrite <= ID_EX_MemWrite;
        EX_MEM_RWSel <= ID_EX_RWSel;
        
        EX_MEM_Rd <= ID_EX_Rd;
        EX_MEM_ALUResult <= ALUResult;
        EX_MEM_RData2 <= ID_EX_RData2;
        EX_MEM_PC_Plus4 <= ID_EX_PC_Plus4;
        EX_MEM_PC_imm <= ID_EX_PC_imm;
        EX_MEM_imm_out <= ID_EX_imm_out;
    end 
endmodule

//MEMWB PIPELINE REGISTER
module memwb_pipeline_register #(
    parameter Control_Width = 11
)(
    input clk,
    input EX_MEM_RegWrite, EX_MEM_MemToReg, EX_MEM_RWSel,
    input [4:0] EX_MEM_Rd,  // inst decode해서 나온 dest reg가 넘어온 것
    input [31:0] EX_MEM_PC_Plus4, EX_MEM_PC_imm, EX_MEM_imm_out,
    input [31:0] EX_MEM_ALUResult,
    input [31:0] RData, // data memory에서 읽은 데이터
    output MEM_WB_RegWrite, MEM_WB_MemToReg, MEM_WB_RWSel,
    output reg [4:0] MEM_WB_Rd,
    output reg [31:0] MEM_WB_PC_Plus4, MEM_WB_PC_imm, MEM_WB_imm_out,
    output reg [31:0] MEM_WB_ALUResult,
    output reg [31:0] MEM_WB_RData
);
        
    always @(posedge clk) begin
        MEM_WB_RegWrite <= EX_MEM_RegWrite;
        MEM_WB_MemToReg <= EX_MEM_MemToReg;
        MEM_WB_RWSel <= EX_MEM_RWSel
        
        MEM_WB_Rd <= EX_MEM_Rd;
        MEM_WB_PC_Plus4 <= EX_MEM_PC_Plus4;
        MEM_WB_PC_imm <= EX_MEM_PC_imm;
        MEM_WB_imm_out <= EX_MEM_imm_out;
        MEM_WB_ALUResult <= EX_MEM_ALUResult;
        MEM_WB_RData <= RData;
    end 
    
endmodule
