//IFID PIPELINE REGISTER
module ifid_pipeline_register (
    input clk,
    input reset,
    input [31:0] instOut,
    input [31:0] inst_num,
    input [31:0] PC,
    input IF_ID_Flush,
    input taken,
    output reg IF_ID_taken
    output reg [31:0] IF_ID_instOut,  
    output reg [31:0] IF_ID_inst_num,
    output reg [31:0] IF_ID_PC,
    output reg ROB_Flush
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // �뵳�딅�� ?�뻿?�깈揶�? ?�넞?苑�?�넅?由븝쭖? �룯�뜃由�?�넅
            IF_ID_instOut <= 32'b0;
            IF_ID_inst_num <= 32'b0;
            IF_ID_PC <= 32'b0;
            ROB_Flush <= 1'b0;

        end else if (IF_ID_Flush) begin
            IF_ID_instOut <= 32'b0;
            IF_ID_inst_num <= 32'b0;
            IF_ID_PC <= 32'b0;
            ROB_Flush <= 1'b1;
        end else begin
            // ?逾�?�쑎?�뻻揶�? ?釉�?�빍��? ?�뮞?�꽘?猷� ?釉�?�빜 ?釉� ?�젟?湲� ?猷�?�삂
            IF_ID_instOut <= instOut;
            IF_ID_inst_num <= inst_num;
            IF_ID_PC <= PC;
            ROB_Flush <= 1'b0;

        end
    end

endmodule


module exmem_pipeline_register (
    input clk,
    input reset,
    input ID_EX_MemToReg,
    input ID_EX_MemRead,
    input ID_EX_MemWrite,
    input [2:0] RS_EX_funt3,
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

    
    output reg EX_MEM_MemToReg,
    output reg Load_Done,
    output reg EX_MEM_MemWrite,
    output reg [2:0] EX_MEM_funct3,
    output reg [31:0] EX_MEM_Rdata2,
    output reg [31:0] EX_MEM_ALUResult,
    output reg [31:0] EX_MEM_alu_exec_PC,
    output reg EX_MEM_alu_exec_done,
    output reg [7:0] EX_MEM_alu_physical_address,
    output reg [31:0] mul_exec_value,
    output reg [31:0] mul_exec_PC,
    output reg mul_exec_done,
    output reg [31:0] div_exec_value,
    output reg [31:0] div_exec_PC,
    output reg div_exec_done 
);
        
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 由ъ뀑 ?떊?샇媛? ?솢?꽦?솕?릺硫? 珥덇린?솕
            EX_MEM_MemToReg <= 1'b0;
            Load_Done <= 1'b0;
            EX_MEM_MemWrite <= 1'b0;
            EX_MEM_funct3 <= 3'b000;
            EX_MEM_Rdata2 <= 32'b0;
            EX_MEM_ALUResult <= 32'b0;
            EX_MEM_alu_exec_PC <= 32'b0;
            EX_MEM_alu_exec_done <= 1'b0;
            EX_MEM_alu_physical_address <= 8'b00000000;
            mul_exec_value <= 32'b0;
            mul_exec_PC <= 32'b0;
            mul_exec_done <= 1'b0;
            div_exec_value <= 32'b0;
            div_exec_PC <= 32'b0;
            div_exec_done <= 1'b0; 
        end else begin
            // ?젙?긽 ?룞?옉
            EX_MEM_MemToReg <= ID_EX_MemToReg;
            Load_Done <= ID_EX_MemRead;
            EX_MEM_MemWrite <= ID_EX_MemWrite; 
            EX_MEM_funct3 <= RS_EX_funt3;
            EX_MEM_Rdata2 <= operand2_Phy_Data;
            EX_MEM_ALUResult <= RS_EX_ALUResult;
            EX_MEM_alu_exec_PC <= RS_EX_PC_ALU;
            EX_MEM_alu_exec_done <= ALU_done;
            EX_MEM_alu_physical_address <= RS_EX_alu_Physical_address;
            mul_exec_value <= Mul_Result;
            mul_exec_PC <= RS_EX_PC_Mul_out;
            mul_exec_done <= Mul_done_out;
            div_exec_value <= Div_Result;
            div_exec_PC <= RS_EX_PC_Div_out;
            div_exec_done <= Div_done_out;
        end
    end
endmodule
