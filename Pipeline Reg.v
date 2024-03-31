/*
파이프라인 내 요소는 IF_ID_ALUSrc 형태로 기술함
Control 신호는 아직 미완이라 하나로 뭉쳐 놓음
앞으로 할 일:
기능 추가될 때마다 꼼꼼히 유지보수
Control 신호를 베릴로그 헤더 파일 사용해서 협업해도 좋을듯. 예를 들면
`define PCSrc 0
`define Jump 1
`define ALUOp 4:2
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
module idex_pipeline_register #(
    parameter Control_Width = 11
    )(    
    input clk,
    input [Control_Width-1:0] Control_Sig,
    input [4:0] Rs1, Rs2, Rd,
    input [31:0] RData1, RData2,
    input [31:0] imm32,  // sign extend의 output
    input [31:0] If_ID_PC,
    input [2:0] funct3;
    output reg [Control_Width-1:0] ID_EX_Control_Sig,
    output reg [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd,
    output reg [31:0] ID_EX_RData1, ID_EX_RData2,
    output reg [31:0] ID_EX_imm32,
    output reg [31:0] ID_EX_PC.
    output reg [2:0] ID_EX_funct3;
);
        
    always @(posedge clk) begin
        ID_EX_Control_Sig <= Control_Sig;
        ID_EX_Rs1 <= Rs1;
        ID_EX_Rs2 <= Rs2;
        ID_EX_Rd <= Rd;
        ID_EX_imm32 <= imm32;
        ID_EX_PC <= IF_ID_PC;
        ID_EX_funct3 <= funct3;
    end 
endmodule

//EXMEM PIPELINE REGISTER
module exmem_pipeline_register (
    input clk,
    input [Control_Width-1:0] ID_EX_Control_Sig,
    input [4:0] ID_EX_Rd, // inst decode해서 나온 dest reg가 넘어온 것
    input [31:0] ALUResult,  // ALU output
    input [31:0] ID_EX_RData2,  // regfile의 output 중 2가 넘어온 것
    input [31:0] PC_Plus4,  // Jump 명령어 구현을 위해 필요
    output reg [Control_Width-1:0] EX_MEM_Control_Sig,
    output reg [4:0] EX_MEM_Rd,
    output reg [31:0] EX_MEM_ALUResult,
    output reg [31:0] EX_MEM_RData2,
    output reg [31:0] EX_MEM_PC_Plus4
);
        
    always @(posedge clk) begin
        EX_MEM_Control_Sig <= ID_EX_Control_Sig;
        EX_MEM_Rd <= ID_EX_Rd;
        EX_MEM_ALUResult <= ALUResult;
        EX_MEM_RData2 <= ID_EX_RData2;
        EX_MEM_PC_Plus4 <= PC_Plus4;
    end 
endmodule

//MEMWB PIPELINE REGISTER
module memwb_pipeline_register (
    input clk;
    input [Control_Width-1:0] EX_MEM_Control_Sig,
    input [4:0] EX_MEM_Rd;  // inst decode해서 나온 dest reg가 넘어온 것
    input [31:0] EX_MEM_PC_Plus4,
    input [31:0] RData; // data memory에서 읽은 데이터
    output reg [Control_Width-1:0] MEM_WB_Control_Sig,
    output reg [4:0] MEM_WB_Rd;
    output reg [31:0] MEM_WB_PC_Plus4
    output reg [31:0] MEM_WB_RData;
);
        
    always @(posedge clk) begin
        MEM_WB_Control_Sig <= EX_MEM_Control_Sig;
        MEM_WB_Rd <= EX_MEM_Rd;
        EX_MEM_PC_Plus4 <= MEM_WB_PC_Plus4;
        MEM_WB_RData <= RData;
    end 
    
endmodule
