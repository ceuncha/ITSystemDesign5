
module RS_EX_decoder(
    input clk,              // ?寃�?�쑏 ?�뻿?�깈
    input reset,            // �뵳�딅�� ?�뻿?�깈

    input [6:0] in_opcode,  // 7-bit, ?肉�?沅� �굜遺얜굡
    input [31:0] in_operand1,  // 32-bit, 力�? 甕곕뜆�럮 ?逾�?肉�?沅�?�쁽
    input [31:0] in_operand2,  // 32-bit, ?紐� 甕곕뜆�럮 ?逾�?肉�?沅�?�쁽
    input [2:0] in_func3,   // 3-bit, �겫?揶�??�읅 ?肉�?沅� ?�젟癰�?
    input [6:0] in_funct7,  // 7-bit, �겫?揶�??�읅 ?肉�?沅� ?�젟癰�? (funct7 �빊遺�?)
    input [31:0] in_pc,     // 32-bit, ?遊썸에�뮄�젃?�삪 燁삳똻�뒲?苑�
        
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
    
    input [7:0] rd_phy_reg, // 8-bit, �눧�눖�봺?�읅 ?�쟿�릯??�뮞?苑� 雅뚯눘�꺖
    input [7:0] Operand1_phy,  
    input [7:0] Operand2_phy,
    input [1:0] valid,
    input [31:0] immediate,
    input [31:0] inst_num,

    output reg [31:0] add_alu_operand1,  // Add ALU嚥�? 癰귣�沅� 力�? 甕곕뜆�럮 ?逾�?肉�?沅�?�쁽
    output reg [31:0] add_alu_operand2,  // Add ALU嚥�? 癰귣�沅� ?紐� 甕곕뜆�럮 ?逾�?肉�?沅�?�쁽
    output reg [2:0] add_alu_func3,      // Add ALU嚥�? 癰귣�沅� func3
    output reg [31:0] add_alu_pc,        // Add ALU嚥�? 癰귣�沅� ?遊썸에�뮄�젃?�삪 燁삳똻�뒲?苑�

    output reg out_add_MemToReg,   
    output reg out_add_MemRead,
    output reg out_add_MemWrite,   
    output reg [3:0] out_add_ALUOP,
    output reg out_add_ALUSrc1,      
    output reg out_add_ALUSrc2,      
   
 

    output reg [7:0] add_rd_phy_reg,     // Add ALU嚥�? 癰귣�沅� �눧�눖�봺?�읅 ?�쟿�릯??�뮞?苑� 雅뚯눘�꺖
    output reg add_rs_on,
    output reg [7:0] out_add_Operand1_phy,
    output reg [7:0] out_add_Operand2_phy,
    output reg [1:0] out_add_valid,
    output reg [31:0] out_add_immediate,
    output reg [31:0] out_add_inst_num,
    
    output reg [31:0] mul_alu_operand1,  // Mul ALU嚥�? 癰귣�沅� 力�? 甕곕뜆�럮 ?逾�?肉�?沅�?�쁽
    output reg [31:0] mul_alu_operand2,  // Mul ALU嚥�? 癰귣�沅� ?紐� 甕곕뜆�럮 ?逾�?肉�?沅�?�쁽
    output reg [2:0] mul_alu_func3,      // Mul ALU嚥�? 癰귣�沅� func3
    output reg [31:0] mul_alu_pc,        // Mul ALU嚥�? 癰귣�沅� ?遊썸에�뮄�젃?�삪 燁삳똻�뒲?苑�

  
    output reg [3:0] out_mul_ALUOP,
      
   
    
    output reg [7:0] mul_rd_phy_reg,     // Mul ALU嚥�? 癰귣�沅� �눧�눖�봺?�읅 ?�쟿�릯??�뮞?苑� 雅뚯눘�꺖
    output reg mul_rs_on,
    output reg [7:0] out_mul_Operand1_phy,
    output reg [7:0] out_mul_Operand2_phy,
    output reg [1:0] out_mul_valid,
    output reg [31:0] out_mul_immediate,
    output reg [31:0] out_mul_inst_num,
    
    output reg [31:0] div_alu_operand1,  // Div ALU嚥�? 癰귣�沅� 力�? 甕곕뜆�럮 ?逾�?肉�?沅�?�쁽
    output reg [31:0] div_alu_operand2,  // Div ALU嚥�? 癰귣�沅� ?紐� 甕곕뜆�럮 ?逾�?肉�?沅�?�쁽
    output reg [2:0] div_alu_func3,      // Div ALU嚥�? 癰귣�沅� func3
    output reg [31:0] div_alu_pc,        // Div ALU嚥�? 癰귣�沅� ?遊썸에�뮄�젃?�삪 燁삳똻�뒲?苑�

   
    output reg [3:0] out_div_ALUOP,
     

    output reg [7:0] div_rd_phy_reg,      // Div ALU嚥�? 癰귣�沅� �눧�눖�봺?�읅 ?�쟿�릯??�뮞?苑� 雅뚯눘�꺖
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

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // 榮먥뫀諭� �빊�뮆�젾?�뱽 �뵳�딅��
        add_alu_operand1 = 0;
        add_alu_operand2 = 0;
        add_alu_func3 = 0;
        add_alu_pc = 0;

        add_rd_phy_reg = 0;
        out_add_Operand1_phy = 0;
        out_add_Operand2_phy = 0;
        out_add_valid = 0;
        out_add_inst_num =0;
        
        mul_alu_operand1 = 0;
        mul_alu_operand2 = 0;
        mul_alu_func3 = 0;
        mul_alu_pc = 0;


        mul_rd_phy_reg = 0;
        out_mul_Operand1_phy = 0;
        out_mul_Operand2_phy = 0;
        out_mul_valid = 0;
        out_mul_inst_num =0;

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
    end
end

always @(*) begin
    case (in_opcode)
         7'b0000000: begin
                            add_rs_on = 0;
                            mul_rs_on = 0;
                            div_rs_on = 0;
                            RS_br_start = 0;                            
        end
        7'b0110011: begin // R-type 榮먮굝議�?堉�
            case (in_funct7)
                7'b0000001: begin
                    // MUL, DIV, REM 榮먮굝議�?堉� 力μ꼶�봺
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
                            RS_br_start = 0;
                            out_mul_Operand1_phy = Operand1_phy;  
                            out_mul_Operand2_phy  = Operand2_phy;
                            out_mul_valid = valid;
                            out_mul_immediate = immediate;
     
   
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
                            RS_br_start = 0;
                            out_div_Operand1_phy = Operand1_phy;  
                            out_div_Operand2_phy = Operand2_phy;
                            out_div_valid = valid;
                            out_div_immediate = immediate;
                            out_div_ALUOP = ALUOP; 
                             

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
                            RS_br_start = 0;
                            out_div_Operand1_phy = Operand1_phy;  
                            out_div_Operand2_phy = Operand2_phy;
                            out_div_valid = valid;
                            out_div_immediate = immediate;
                            out_div_ALUOP = ALUOP; 


                            out_div_inst_num = inst_num;
                        end
                        default: begin
                            // ?�뼄�몴? R-type 榮먮굝議�?堉�?�뮉 ADD ALU嚥�? 癰귣�沅→묾?
                            add_alu_operand1 = in_operand1;
                            add_alu_operand2 = in_operand2;
                            add_alu_func3 = in_func3;
                            add_alu_pc = in_pc;

                            add_rd_phy_reg = rd_phy_reg;
                            add_rs_on = 1;
                            mul_rs_on = 0;
                            div_rs_on = 0;
                            RS_br_start = 0;
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
                    endcase
                end
                default: begin
                    // ?�뼄�몴? R-type 榮먮굝議�?堉�?�뮉 ADD ALU嚥�? 癰귣�沅→묾?
                    add_alu_operand1 = in_operand1;
                    add_alu_operand2 = in_operand2;
                    add_alu_func3 = in_func3;
                    add_alu_pc = in_pc;

                    add_rd_phy_reg <= rd_phy_reg;
                    add_rs_on = 1;
                    mul_rs_on = 0;
                    div_rs_on = 0;
                    RS_br_start = 0;
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
            endcase
        end
        default: begin
        if (in_opcode == 7'b1101111 || in_opcode == 7'b1100111 || in_opcode == 7'b1100011) begin
            RS_br_operand1 = in_operand1;
            RS_br_operand2 = in_operand2;
            RS_br_func3 = in_func3;
            RS_br_PC = in_pc;

            RS_br_phy_reg = rd_phy_reg;

            add_rs_on = 0;
            mul_rs_on = 0;
            div_rs_on = 0;
            RS_br_start = 1;

            RS_br_operand1_phy = Operand1_phy;
            RS_br_operand2_phy = Operand2_phy;
            RS_br_valid = valid;     
            RS_br_Jump = Jump;      
            RS_br_Branch = Branch;
            RS_br_inst_num = inst_num;
            RS_br_IF_ID_taken = IF_ID_taken;
            RS_br_IF_ID_hit = IF_ID_hit; 

            end else begin
    

            
            add_alu_operand1 = in_operand1;
            add_alu_operand2 = in_operand2;
            add_alu_func3 = in_func3;
            add_alu_pc = in_pc;

            add_rd_phy_reg = rd_phy_reg;
            add_rs_on = 1;
            mul_rs_on = 0;
            div_rs_on = 0;
            RS_br_start = 0;
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
    endcase
end

endmodule
