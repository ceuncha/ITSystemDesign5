//IFID PIPELINE REGISTER
module ifid_pipeline_register (
    input clk,
    input IF_ID_Stall, IF_ID_Flush,
    input [31:0] instOut,
    input [31:0] PC,
    output reg [31:0] IF_ID_instOut,  
    output reg [31:0] IF_ID_PC
);
    
    always @(posedge clk) begin
        if(!(IF_ID_Stall || IF_ID_Flush)) begin
            IF_ID_instOut <= instOut;
            IF_ID_PC <= PC;
        end
        else begin           
            IF_ID_instOut <= 0;
            IF_ID_PC <= 0;
        end
    end
endmodule

//IDEX PIPELINE REGISTER
module idex_pipeline_register (
    input clk,
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
    input ID_EX_Flush,

    output reg ID_EX_RWsel,
    output reg [1:0] ID_EX_ALUSrc,
    output reg [3:0] ID_EX_ALUOp,
    output reg ID_EX_MemWrite,
    output reg ID_EX_MemRead,
    output reg ID_EX_MemToReg,
    output reg ID_EX_RegWrite,
    output reg [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd,
    output reg [2:0] ID_EX_funct3,
    output reg [31:0] ID_EX_RData1, ID_EX_RData2,
    output reg [31:0] ID_EX_imm32,
    output reg ID_EX_Jump,
    output reg ID_EX_Branch,
    output reg [31:0] ID_EX_PC
    );

    
    
    always @(posedge clk) begin
         if (ID_EX_Flush) begin
        // On a flush, reset the pipeline stage to NOP
        ID_EX_RWsel <= 1'b0;
        ID_EX_ALUSrc <= 2'b00;
        ID_EX_ALUOp <= 4'b0000;
        ID_EX_MemWrite <= 1'b0;
        ID_EX_MemRead <= 1'b0;
        ID_EX_MemToReg <= 1'b0;
        ID_EX_RegWrite <= 1'b0;
        ID_EX_Rs1 <= 5'b00000;
        ID_EX_Rs2 <= 5'b00000;
        ID_EX_Rd <= 5'b00000;
        ID_EX_funct3 <= 3'b000;
        ID_EX_RData1 <= 32'b0;
        ID_EX_RData2 <= 32'b0;
        ID_EX_imm32 <= 32'b0;
        ID_EX_Jump <= 1'b0;
        ID_EX_Branch <= 1'b0;
        ID_EX_PC <= 32'b0;
        end

        else if(!Control_Sig_Stall) begin
            ID_EX_RWsel <= RWsel;
            ID_EX_ALUSrc <= ALUSrc;
            ID_EX_ALUOp <= ALUOp;
            ID_EX_MemWrite <= MemWrite;
            ID_EX_MemRead <= MemRead;
            ID_EX_MemToReg <= MemToReg;
            ID_EX_RegWrite <= RegWrite;
            ID_EX_RData1 <= RData1;
            ID_EX_RData2 <= RData2;
            ID_EX_Rs1 <= IF_ID_Rs1;
            ID_EX_Rs2 <= IF_ID_Rs2;
            ID_EX_Rd <= IF_ID_Rd;
            ID_EX_funct3 <= IF_ID_funct3;
            ID_EX_imm32 <= imm32;
            ID_EX_Jump <= Jump;
            ID_EX_Branch <= Branch;
            ID_EX_PC <= IF_ID_PC;
        end
        else 
        begin
            // Stall 
        end
        
    end 
endmodule

//EXMEM PIPELINE REGISTER
module exmem_pipeline_register (
    input clk,
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
    
    output reg EX_MEM_RegWrite,
    output reg EX_MEM_MemToReg,
    output reg EX_MEM_MemRead,
    output reg EX_MEM_MemWrite,
    output reg EX_MEM_RWsel,
    output reg [2:0] EX_MEM_funct3,
    output reg [4:0] EX_MEM_Rd,
    output reg [31:0] EX_MEM_ALUResult,
    output reg [31:0] EX_MEM_RData2,
    output reg [31:0] EX_MEM_Rd_data
);
        
    always @(posedge clk) begin
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
endmodule

//MEMWB PIPELINE REGISTER
module memwb_pipeline_register (
    input clk,
    input EX_MEM_RegWrite,
    input EX_MEM_MemToReg,
    input EX_MEM_RWsel,
    input [4:0] EX_MEM_Rd,  // inst decode
    input [31:0] EX_MEM_Rd_data,
    input [31:0] EX_MEM_ALUResult,
    input [31:0] RData, // data memory
    output reg MEM_WB_RegWrite,
    output reg MEM_WB_MemToReg,
    output reg MEM_WB_RWsel,
    output reg [4:0] MEM_WB_Rd,
    output reg [31:0] MEM_WB_Rd_data,
    output reg [31:0] MEM_WB_ALUResult,
    output reg [31:0] MEM_WB_RData
);
        
    always @(posedge clk) begin
        MEM_WB_RegWrite <= EX_MEM_RegWrite;
        MEM_WB_MemToReg <= EX_MEM_MemToReg;
        MEM_WB_RWsel <= EX_MEM_RWsel;
        MEM_WB_Rd <= EX_MEM_Rd;
        MEM_WB_Rd_data <= EX_MEM_Rd_data;
        MEM_WB_ALUResult <= EX_MEM_ALUResult;
        MEM_WB_RData <= RData;
    end 
    
endmodule
