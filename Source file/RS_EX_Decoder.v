
module RS_EX_decoder(
    input clk,              // ?겢?윮 ?떊?샇
    input reset,            // 由ъ뀑 ?떊?샇

    input [6:0] in_opcode,  // 7-bit, ?뿰?궛 肄붾뱶
    input [31:0] in_operand1,  // 32-bit, 泥? 踰덉㎏ ?뵾?뿰?궛?옄
    input [31:0] in_operand2,  // 32-bit, ?몢 踰덉㎏ ?뵾?뿰?궛?옄
    input [2:0] in_func3,   // 3-bit, 遺?媛??쟻 ?뿰?궛 ?젙蹂?
    input [6:0] in_funct7,  // 7-bit, 遺?媛??쟻 ?뿰?궛 ?젙蹂? (funct7 異붽?)
    input [31:0] in_pc,     // 32-bit, ?봽濡쒓렇?옩 移댁슫?꽣
        
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
    
    input [7:0] rd_phy_reg, // 8-bit, 臾쇰━?쟻 ?젅吏??뒪?꽣 二쇱냼
    input [7:0] Operand1_phy,  
    input [7:0] Operand2_phy,
    input [1:0] valid,
    input [31:0] immediate,
    input [31:0] inst_num,

    output reg [31:0] add_alu_operand1,  // Add ALU濡? 蹂대궪 泥? 踰덉㎏ ?뵾?뿰?궛?옄
    output reg [31:0] add_alu_operand2,  // Add ALU濡? 蹂대궪 ?몢 踰덉㎏ ?뵾?뿰?궛?옄
    output reg [2:0] add_alu_func3,      // Add ALU濡? 蹂대궪 func3
    output reg [31:0] add_alu_pc,        // Add ALU濡? 蹂대궪 ?봽濡쒓렇?옩 移댁슫?꽣

    output reg out_add_MemToReg,   
    output reg out_add_MemRead,
    output reg out_add_MemWrite,   
    output reg [3:0] out_add_ALUOP,
    output reg out_add_ALUSrc1,      
    output reg out_add_ALUSrc2,      
    output reg out_add_Jump,      
    output reg out_add_Branch,      // Add ALU濡? 蹂대궪 ?젣?뼱 ?떊?샇

    output reg [7:0] add_rd_phy_reg,     // Add ALU濡? 蹂대궪 臾쇰━?쟻 ?젅吏??뒪?꽣 二쇱냼
    output reg add_rs_on,
    output reg [7:0] out_add_Operand1_phy,
    output reg [7:0] out_add_Operand2_phy,
    output reg [1:0] out_add_valid,
    output reg [31:0] out_add_immediate,
    output reg [31:0] out_add_inst_num,
    
    output reg [31:0] mul_alu_operand1,  // Mul ALU濡? 蹂대궪 泥? 踰덉㎏ ?뵾?뿰?궛?옄
    output reg [31:0] mul_alu_operand2,  // Mul ALU濡? 蹂대궪 ?몢 踰덉㎏ ?뵾?뿰?궛?옄
    output reg [2:0] mul_alu_func3,      // Mul ALU濡? 蹂대궪 func3
    output reg [31:0] mul_alu_pc,        // Mul ALU濡? 蹂대궪 ?봽濡쒓렇?옩 移댁슫?꽣

    output reg out_mul_MemToReg,   
    output reg out_mul_MemRead,
    output reg out_mul_MemWrite,   
    output reg [3:0] out_mul_ALUOP,
    output reg out_mul_ALUSrc1,      
    output reg out_mul_ALUSrc2,      
    output reg out_mul_Jump,      
    output reg out_mul_Branch,      // Add ALU濡? 蹂대궪 ?젣?뼱 ?떊?샇     
    
    output reg [7:0] mul_rd_phy_reg,     // Mul ALU濡? 蹂대궪 臾쇰━?쟻 ?젅吏??뒪?꽣 二쇱냼
    output reg mul_rs_on,
    output reg [7:0] out_mul_Operand1_phy,
    output reg [7:0] out_mul_Operand2_phy,
    output reg [1:0] out_mul_valid,
    output reg [31:0] out_mul_immediate,
    output reg [31:0] out_mul_inst_num,
    
    output reg [31:0] div_alu_operand1,  // Div ALU濡? 蹂대궪 泥? 踰덉㎏ ?뵾?뿰?궛?옄
    output reg [31:0] div_alu_operand2,  // Div ALU濡? 蹂대궪 ?몢 踰덉㎏ ?뵾?뿰?궛?옄
    output reg [2:0] div_alu_func3,      // Div ALU濡? 蹂대궪 func3
    output reg [31:0] div_alu_pc,        // Div ALU濡? 蹂대궪 ?봽濡쒓렇?옩 移댁슫?꽣

    output reg out_div_MemToReg,   
    output reg out_div_MemRead,
    output reg out_div_MemWrite,   
    output reg [3:0] out_div_ALUOP,
    output reg out_div_ALUSrc1,      
    output reg out_div_ALUSrc2,      
    output reg out_div_Jump,      
    output reg out_div_Branch,     

    output reg [7:0] div_rd_phy_reg,      // Div ALU濡? 蹂대궪 臾쇰━?쟻 ?젅吏??뒪?꽣 二쇱냼
    output reg div_rs_on,
    output reg [7:0] out_div_Operand1_phy,
    output reg [7:0] out_div_Operand2_phy,
    output reg [1:0] out_div_valid,
    output reg [31:0] out_div_immediate,
    output reg [31:0] out_div_inst_num,
    output reg RS_alu_IF_ID_taken,
    output reg RS_alu_IF_ID_hit
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // 紐⑤뱺 異쒕젰?쓣 由ъ뀑
        add_alu_operand1 <= 0;
        add_alu_operand2 <= 0;
        add_alu_func3 <= 0;
        add_alu_pc <= 0;

        add_rd_phy_reg <= 0;
        out_add_Operand1_phy <= 0;
        out_add_Operand2_phy <= 0;
        out_add_valid <= 0;
        out_add_inst_num<=0;
        
        mul_alu_operand1 <= 0;
        mul_alu_operand2 <= 0;
        mul_alu_func3 <= 0;
        mul_alu_pc <= 0;


        mul_rd_phy_reg <= 0;
        out_mul_Operand1_phy <= 0;
        out_mul_Operand2_phy <= 0;
        out_mul_valid <= 0;
        out_mul_inst_num<=0;

        div_alu_operand1 <= 0;
        div_alu_operand2 <= 0;
        div_alu_func3 <= 0;
        div_alu_pc <= 0;

        div_rd_phy_reg <= 0;
        out_div_Operand1_phy <= 0;
        out_div_Operand2_phy <= 0;
        out_div_valid <= 0;
        add_rs_on <= 0;
        mul_rs_on <= 0;
        div_rs_on <= 0;

        out_add_MemToReg <= 0;   
        out_add_MemRead <= 0;   
        out_add_MemWrite <= 0;      
        out_add_ALUOP <= 0;   
        out_add_ALUSrc1 <= 0;
        out_add_ALUSrc2 <= 0;      
        out_add_Jump <= 0;      
        out_add_Branch <= 0;  

        out_mul_MemToReg <= 0;   
        out_mul_MemRead <= 0;   
        out_mul_MemWrite <= 0;      
        out_mul_ALUOP <= 0;   
        out_mul_ALUSrc1 <= 0;
        out_mul_ALUSrc2 <= 0;      
        out_mul_Jump <= 0;      
        out_mul_Branch <= 0;  

        out_div_MemToReg <= 0;   
        out_div_MemRead <= 0;   
        out_div_MemWrite <= 0;      
        out_div_ALUOP <= 0;   
        out_div_ALUSrc1 <= 0;
        out_div_ALUSrc2 <= 0;      
        out_div_Jump <= 0;      
        out_div_Branch <= 0; 
        out_div_inst_num <= 0; 

        RS_alu_IF_ID_taken <= 0;
        RS_alu_IF_ID_hit <= 0;
    end
end

always @(*) begin
    case (in_opcode)
         7'b0000000: begin
                            add_rs_on = 0;
                            mul_rs_on = 0;
                            div_rs_on = 0;
        end
        7'b0110011: begin // R-type 紐낅졊?뼱
            case (in_funct7)
                7'b0000001: begin
                    // MUL, DIV, REM 紐낅졊?뼱 泥섎━
                    case (in_func3)
                        3'b000: begin // MUL
                            mul_alu_operand1= in_operand1;
                            mul_alu_operand2 = in_operand2;
                            mul_alu_func3 = in_func3;
                            mul_alu_pc = in_pc;

                            mul_rd_phy_reg = rd_phy_reg;
                            add_rs_on = 0;
                            mul_rs_on = 1;
                            div_rs_on = 0;
                            out_mul_Operand1_phy = Operand1_phy;  
                            out_mul_Operand2_phy  = Operand2_phy;
                            out_mul_valid = valid;
                            out_mul_immediate = immediate;
                            out_mul_MemToReg = MemToReg;   
                            out_mul_MemRead = MemRead;   
                            out_mul_MemWrite = MemWrite;      
                            out_mul_ALUOP = ALUOP;   
                            out_mul_ALUSrc1 = ALUSrc1;
                            out_mul_ALUSrc2 = ALUSrc2;      
                            out_mul_Jump = Jump;      
                            out_mul_Branch = Branch;
                            out_mul_inst_num = inst_num;
                        end
                        3'b100: begin // DIV
                            div_alu_operand1 = in_operand1;
                            div_alu_operand2 = in_operand2;
                            div_alu_func3 = in_func3;
                            div_alu_pc = in_pc;

                            div_rd_phy_reg= rd_phy_reg;
                            add_rs_on = 0;
                            mul_rs_on = 0;
                            div_rs_on = 1;
                            out_div_Operand1_phy = Operand1_phy;  
                            out_div_Operand2_phy = Operand2_phy;
                            out_div_valid = valid;
                            out_div_immediate = immediate;
                            out_div_MemToReg = MemToReg;   
                            out_div_MemRead = MemRead;   
                            out_div_MemWrite = MemWrite;      
                            out_div_ALUOP = ALUOP;   
                            out_div_ALUSrc1 = ALUSrc1;
                            out_div_ALUSrc2 = ALUSrc2;      
                            out_div_Jump = Jump;      
                            out_div_Branch = Branch;
                            out_div_inst_num = inst_num;
                        end
                        3'b110: begin // REM
                            div_alu_operand1 = in_operand1;
                            div_alu_operand2 = in_operand2;
                            div_alu_func3 = in_func3;
                            div_alu_pc = in_pc;

                            div_rd_phy_reg = rd_phy_reg;
                            add_rs_on = 0;
                            mul_rs_on = 0;
                            div_rs_on = 1;
                            out_div_Operand1_phy = Operand1_phy;  
                            out_div_Operand2_phy = Operand2_phy;
                            out_div_valid = valid;
                            out_div_immediate = immediate;
                            out_div_MemToReg = MemToReg;   
                            out_div_MemRead = MemRead;   
                            out_div_MemWrite = MemWrite;      
                            out_div_ALUOP = ALUOP;   
                            out_div_ALUSrc1 = ALUSrc1;
                            out_div_ALUSrc2 = ALUSrc2;      
                            out_div_Jump = Jump;      
                            out_div_Branch = Branch;
                            out_div_inst_num = inst_num;
                        end
                        default: begin
                            // ?떎瑜? R-type 紐낅졊?뼱?뒗 ADD ALU濡? 蹂대궡湲?
                            add_alu_operand1 = in_operand1;
                            add_alu_operand2 = in_operand2;
                            add_alu_func3 = in_func3;
                            add_alu_pc = in_pc;

                            add_rd_phy_reg = rd_phy_reg;
                            add_rs_on = 1;
                            mul_rs_on = 0;
                            div_rs_on = 0;
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
                            out_add_Jump = Jump;      
                            out_add_Branch = Branch;
                            out_add_inst_num = inst_num;
                             RS_alu_IF_ID_taken = 0;
                            RS_alu_IF_ID_hit = 0;    
                        end
                    endcase
                end
                default: begin
                    // ?떎瑜? R-type 紐낅졊?뼱?뒗 ADD ALU濡? 蹂대궡湲?
                    add_alu_operand1 = in_operand1;
                    add_alu_operand2 = in_operand2;
                    add_alu_func3 = in_func3;
                    add_alu_pc = in_pc;

                    add_rd_phy_reg <= rd_phy_reg;
                    add_rs_on = 1;
                    mul_rs_on = 0;
                    div_rs_on = 0;
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
                    out_add_Jump = Jump;      
                    out_add_Branch = Branch;
                    out_add_inst_num = inst_num;
                             RS_alu_IF_ID_taken = 0;
                            RS_alu_IF_ID_hit = 0;    
                end
            endcase
        end
        default: begin
            // 湲곕낯?쟻?쑝濡? 紐⑤뱺 紐낅졊?뼱瑜? ADD ALU濡? 蹂대깂
            add_alu_operand1 = in_operand1;
            add_alu_operand2 = in_operand2;
            add_alu_func3 = in_func3;
            add_alu_pc = in_pc;

            add_rd_phy_reg = rd_phy_reg;
            add_rs_on = 1;
            mul_rs_on = 0;
            div_rs_on = 0;
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
            out_add_Jump = Jump;      
            out_add_Branch = Branch;
            out_add_inst_num = inst_num;
                            if (in_opcode == 7'b1101111 || in_opcode == 7'b1100111 || in_opcode == 7'b1100011) begin
                                    RS_alu_IF_ID_taken = IF_ID_taken;
                                     RS_alu_IF_ID_hit = IF_ID_hit;
                            end else begin
                                     RS_alu_IF_ID_taken = 1'b0;
                                     RS_alu_IF_ID_hit = 1'b0;
                            end
        end
    endcase
end

endmodule
