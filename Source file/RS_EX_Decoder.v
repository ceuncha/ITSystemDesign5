module RS_EX_decoder(
    input clk,              // 클럭 신호
    input reset,            // 리셋 신호

    input [6:0] in_opcode,  // 7-bit, 명령어 오퍼코드
    input [31:0] in_operand1,  // 32-bit, 첫 번째 피연산자
    input [31:0] in_operand2,  // 32-bit, 두 번째 피연산자
    input [2:0] in_func3,   // 3-bit, 기능 필드
    input [6:0] in_funct7,  // 7-bit, 기능 필드 (funct7 필드)
    input [31:0] in_pc,     // 32-bit, 프로그램 카운터
        
    input wire MemToReg,   
    input wire MemRead,
    input wire MemWrite,   
    input wire [3:0] ALUOP,
    input wire ALUSrc1,      
    input wire ALUSrc2,      
    input wire Jump,      
    input wire Branch,
    input wire IF_ID_taken,
    input wire IF_ID_hit,
    
    input [7:0] rd_phy_reg, // 8-bit, 목적지 물리 레지스터
    input [7:0] Operand1_phy,  
    input [7:0] Operand2_phy,
    input [1:0] valid,
    input [31:0] immediate,
    input [31:0] inst_num,

    output reg [31:0] add_alu_operand1,  // Add ALU용 첫 번째 피연산자
    output reg [31:0] add_alu_operand2,  // Add ALU용 두 번째 피연산자
    output reg [2:0] add_alu_func3,      // Add ALU용 func3
    output reg [31:0] add_alu_pc,        // Add ALU용 프로그램 카운터

    output reg out_add_MemToReg,   
    output reg out_add_MemRead,
    output reg out_add_MemWrite,   
    output reg [3:0] out_add_ALUOP,
    output reg out_add_ALUSrc1,      
    output reg out_add_ALUSrc2,      
   
    output reg [7:0] add_rd_phy_reg,     // Add ALU용 목적지 물리 레지스터
    output reg add_rs_on,
    output reg [7:0] out_add_Operand1_phy,
    output reg [7:0] out_add_Operand2_phy,
    output reg [1:0] out_add_valid,
    output reg [31:0] out_add_immediate,
    output reg [31:0] out_add_inst_num,
    
    output reg [31:0] mul_alu_operand1,  // Mul ALU용 첫 번째 피연산자
    output reg [31:0] mul_alu_operand2,  // Mul ALU용 두 번째 피연산자
    output reg [2:0] mul_alu_func3,      // Mul ALU용 func3
    output reg [31:0] mul_alu_pc,        // Mul ALU용 프로그램 카운터

    output reg [3:0] out_mul_ALUOP,
      
    output reg [7:0] mul_rd_phy_reg,     // Mul ALU용 목적지 물리 레지스터
    output reg mul_rs_on,
    output reg [7:0] out_mul_Operand1_phy,
    output reg [7:0] out_mul_Operand2_phy,
    output reg [1:0] out_mul_valid,
    output reg [31:0] out_mul_immediate,
    output reg [31:0] out_mul_inst_num,
    
    output reg [31:0] div_alu_operand1,  // Div ALU용 첫 번째 피연산자
    output reg [31:0] div_alu_operand2,  // Div ALU용 두 번째 피연산자
    output reg [2:0] div_alu_func3,      // Div ALU용 func3
    output reg [31:0] div_alu_pc,        // Div ALU용 프로그램 카운터

    output reg [3:0] out_div_ALUOP,
     
    output reg [7:0] div_rd_phy_reg,      // Div ALU용 목적지 물리 레지스터
    output reg div_rs_on,
    output reg [7:0] out_div_Operand1_phy,
    output reg [7:0] out_div_Operand2_phy,
    output reg [1:0] out_div_valid,
    output reg [31:0] out_div_immediate,
    output reg [31:0] out_div_inst_num,
    output reg RS_alu_IF_ID_taken,
    output reg RS_alu_IF_ID_hit,

    output reg RS_br_Jump,
    output reg RS_br_Branch,  
    output reg RS_br_IF_ID_hit,
    output reg RS_br_IF_ID_taken,    
    output reg [2:0] RS_br_func3,
    output reg [7:0] br_rd_phy_reg,
    output reg RS_br_start,
    output reg [31:0] RS_br_operand1,
    output reg [31:0] RS_br_operand2,
    output reg [7:0] RS_br_operand1_phy,
    output reg [7:0] RS_br_operand2_phy,
    output reg [7:0] RS_br_phy_reg,
    output reg [1:0] RS_br_valid,
    output reg [31:0] RS_br_immediate,
    output reg [31:0] RS_br_inst_num,
    output reg [31:0] RS_br_PC
);

always @(*) begin
    if (reset) begin
        // 레지스터 초기화
        add_alu_operand1 = 0;
        add_alu_operand2 = 0;
        add_alu_func3 = 0;
        add_alu_pc = 0;

        add_rd_phy_reg = 0;
        out_add_Operand1_phy = 0;
        out_add_Operand2_phy = 0;
        out_add_valid = 0;
        out_add_inst_num = 0;
        
        mul_alu_operand1 = 0;
        mul_alu_operand2 = 0;
        mul_alu_func3 = 0;
        mul_alu_pc = 0;

        mul_rd_phy_reg = 0;
        out_mul_Operand1_phy = 0;
        out_mul_Operand2_phy = 0;
        out_mul_valid = 0;
        out_mul_inst_num = 0;

        div_alu_operand1 = 0;
        div_alu_operand2 = 0;
        div_alu_func3 = 0;
        div_alu_pc = 0;

        div_rd_phy_reg = 0;
        out_div_Operand1_phy = 0;
        out_div_Operand2_phy = 0;
        out_div_valid = 0;
        add_rs_on = 0;
        mul_rs_on = 0;
        div_rs_on = 0;
        RS_br_start = 0;

        out_add_MemToReg = 0;   
        out_add_MemRead = 0;   
        out_add_MemWrite = 0;      
        out_add_ALUOP = 0;   
        out_add_ALUSrc1 = 0;
        out_add_ALUSrc2 = 0;      

        out_mul_ALUOP = 0;   
        out_div_ALUOP = 0;   
        out_div_inst_num = 0; 

        RS_br_IF_ID_taken = 0;
        RS_br_IF_ID_hit = 0; 
    end else begin
        add_rs_on = 0;
        mul_rs_on = 0;
        div_rs_on = 0;
        RS_br_start = 0;

        if (in_opcode == 7'b0000000) begin
            // NOP or unsupported instruction
        end else if (in_opcode == 7'b0110011) begin
            if (in_funct7 == 7'b0000001) begin
                if (in_func3 == 3'b000) begin
                    // MUL instruction
                    mul_alu_operand1 = in_operand1;
                    mul_alu_operand2 = in_operand2;
                    mul_alu_func3 = in_func3;
                    mul_alu_pc = in_pc;

                    mul_rd_phy_reg = rd_phy_reg;
                    mul_rs_on = 1;
                    out_mul_Operand1_phy = Operand1_phy;
                    out_mul_Operand2_phy = Operand2_phy;
                    out_mul_valid = valid;
                    out_mul_immediate = immediate;
                    out_mul_inst_num = inst_num;
                end else if (in_func3 == 3'b100) begin
                    // DIV instruction
                    div_alu_operand1 = in_operand1;
                    div_alu_operand2 = in_operand2;
                    div_alu_func3 = in_func3;
                    div_alu_pc = in_pc;

                    div_rd_phy_reg = rd_phy_reg;
                    div_rs_on = 1;
                    out_div_Operand1_phy = Operand1_phy;
                    out_div_Operand2_phy = Operand2_phy;
                    out_div_valid = valid;
                    out_div_immediate = immediate;
                    out_div_ALUOP = ALUOP; 
                    out_div_inst_num = inst_num;
                end else if (in_func3 == 3'b110) begin
                    // REM instruction
                    div_alu_operand1 = in_operand1;
                    div_alu_operand2 = in_operand2;
                    div_alu_func3 = in_func3;
                    div_alu_pc = in_pc;

                    div_rd_phy_reg = rd_phy_reg;
                    div_rs_on = 1;
                    out_div_Operand1_phy = Operand1_phy;
                    out_div_Operand2_phy = Operand2_phy;
                    out_div_valid = valid;
                    out_div_immediate = immediate;
                    out_div_ALUOP = ALUOP; 
                    out_div_inst_num = inst_num;
                end else begin
                    // Default R-type to ADD ALU
                    add_alu_operand1 = in_operand1;
                    add_alu_operand2 = in_operand2;
                    add_alu_func3 = in_func3;
                    add_alu_pc = in_pc;

                    add_rd_phy_reg = rd_phy_reg;
                    add_rs_on = 1;
                    out_add_Operand1_phy = Operand1_phy;
                    out_add_Operand2_phy = Operand2_phy;
                    out_add_valid = valid;
                    out_add_immediate = immediate;
                    out_add_MemToReg = MemToReg;   
                    out_add_MemRead = MemRead;   
                    out_add_MemWrite = MemWrite;      
                    out_add_ALUOP = ALUOP;   
                    out_add_ALUSrc1 = ALUSrc1;
                    out_add_ALUSrc2 = ALUSrc2;      
                    out_add_inst_num = inst_num;
                end
            end else begin
                // Default R-type to ADD ALU
                add_alu_operand1 = in_operand1;
                add_alu_operand2 = in_operand2;
                add_alu_func3 = in_func3;
                add_alu_pc = in_pc;

                add_rd_phy_reg = rd_phy_reg;
                add_rs_on = 1;
                out_add_Operand1_phy = Operand1_phy;
                out_add_Operand2_phy = Operand2_phy;
                out_add_valid = valid;
                out_add_immediate = immediate;
                out_add_MemToReg = MemToReg;   
                out_add_MemRead = MemRead;   
                out_add_MemWrite = MemWrite;      
                out_add_ALUOP = ALUOP;   
                out_add_ALUSrc1 = ALUSrc1;
                out_add_ALUSrc2 = ALUSrc2;      
                out_add_inst_num = inst_num;
            end
        end else if (in_opcode == 7'b1101111 || in_opcode == 7'b1100111 || in_opcode == 7'b1100011) begin
            // Branch and Jump instructions
            RS_br_operand1 = in_operand1;
            RS_br_operand2 = in_operand2;
            RS_br_func3 = in_func3;
            RS_br_PC = in_pc;

            RS_br_phy_reg = rd_phy_reg;
            RS_br_start = 1;

            RS_br_operand1_phy = Operand1_phy;
            RS_br_operand2_phy = Operand2_phy;
            RS_br_valid = valid;     
            RS_br_Jump = Jump;      
            RS_br_Branch = Branch;
            RS_br_inst_num = inst_num;
            RS_br_IF_ID_taken = IF_ID_taken;
            RS_br_IF_ID_hit = IF_ID_hit; 
            RS_br_immediate = immediate;
            br_rd_phy_reg = rd_phy_reg;
        end else begin
            // Default to ADD ALU
            add_alu_operand1 = in_operand1;
            add_alu_operand2 = in_operand2;
            add_alu_func3 = in_func3;
            add_alu_pc = in_pc;

            add_rd_phy_reg = rd_phy_reg;
            add_rs_on = 1;
            out_add_Operand1_phy = Operand1_phy;
            out_add_Operand2_phy = Operand2_phy;
            out_add_valid = valid;
            out_add_immediate = immediate;
            out_add_MemToReg = MemToReg;   
            out_add_MemRead = MemRead;   
            out_add_MemWrite = MemWrite;      
            out_add_ALUOP = ALUOP;   
            out_add_ALUSrc1 = ALUSrc1;
            out_add_ALUSrc2 = ALUSrc2;      
            out_add_inst_num = inst_num;
        end
    end
end
endmodule
