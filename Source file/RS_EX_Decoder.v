module RS_EX_decoder(
    input clk,              
    input reset,            

    input [6:0] in_opcode,  

    input [2:0] in_func3,   
    input [6:0] in_funct7,  
    input [31:0] in_pc,   

    input [31:0] csr_data_in,
    input [11:0] csr_addr_in,  
        
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
    
    input [7:0] rd_phy_reg, 
    input [7:0] Operand1_phy,  
    input [7:0] Operand2_phy,
    input [1:0] valid,
    input [31:0] immediate,
    input [31:0] inst_num,
    input [31:0] Operand1_data,
    input [31:0] Operand2_data,


      
    output reg [31:0] add_alu_pc,          
    output reg [3:0] out_add_ALUOP,
    output reg out_add_ALUSrc1,      
    output reg out_add_ALUSrc2,      
   
    output reg [7:0] add_rd_phy_reg,     
    output reg add_rs_on,
    output reg [7:0] out_add_Operand1_phy,
    output reg [7:0] out_add_Operand2_phy,
    output reg [1:0] out_add_valid,
    output reg [31:0] out_add_immediate,
    output reg [31:0] out_add_inst_num,

    
    output reg [31:0] pass_pc,           
    output reg [3:0] pass_ALUOP,
    output reg pass_ALUSrc1,      
    output reg pass_ALUSrc2,

    output reg [7:0] pass_rd_phy_reg,     
    output reg pass_rs_on,
    output reg [31:0] pass_Operand1,
    output reg [31:0] pass_Operand2,
    output reg [31:0] pass_immediate,
    output reg [31:0] pass_inst_num,
    
    output reg [2:0] LS_func3,      
        

    output reg LS_MemToReg,   
    output reg LS_MemRead,
    output reg LS_MemWrite,   
    output reg [3:0] LS_ALUOP,
          
    output reg LS_ALUSrc2,      
   
    output reg [7:0] LS_phy_reg,     
    output reg LS_on,
    output reg [7:0] LS_Operand1_phy,
    output reg [7:0] LS_Operand2_phy,
    output reg [1:0] LS_valid,
    output reg [31:0] LS_immediate,
    output reg [31:0] LS_inst_num,



    output reg [2:0] mul_alu_func3,     
    output reg [31:0] mul_alu_pc,       

    output reg [3:0] out_mul_ALUOP,
      
    output reg [7:0] mul_rd_phy_reg,     
    output reg mul_rs_on,
    output reg [7:0] out_mul_Operand1_phy,
    output reg [7:0] out_mul_Operand2_phy,
    output reg [1:0] out_mul_valid,
    output reg [31:0] out_mul_immediate,
    output reg [31:0] out_mul_inst_num,
    

    output reg [2:0] div_alu_func3,      
    output reg [31:0] div_alu_pc,        

    output reg [3:0] out_div_ALUOP,
     
    output reg [7:0] div_rd_phy_reg,      
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

    output reg [7:0] RS_br_operand1_phy,
    output reg [7:0] RS_br_operand2_phy,
    output reg [7:0] RS_br_phy_reg,
    output reg [1:0] RS_br_valid,
    output reg [31:0] RS_br_immediate,
    output reg [31:0] RS_br_inst_num,
    output reg [31:0] RS_br_PC,

    output reg csr_on, 
    output reg [31:0] CSR_data,
    output reg [7:0] CSR_operand1,
 
    output reg [3:0] CSR_aluop,
    output reg [7:0] CSR_rd_phy,
    output reg [1:0] CSR_valid,
    output reg [31:0] CSR_instnum,
    output reg [31:0] CSR_immediate,
    output reg CSR_ALUSrc2,
    output reg [11:0] CSR_addr

);

always @(*) begin
    if (reset) begin
        // ?젅吏??뒪?꽣 珥덇린?솕


        add_alu_pc = 0;

        add_rd_phy_reg = 0;
        out_add_Operand1_phy = 0;
        out_add_Operand2_phy = 0;
        out_add_valid = 0;
        out_add_inst_num = 0;
        

        mul_alu_func3 = 0;
        mul_alu_pc = 0;

        mul_rd_phy_reg = 0;
        out_mul_Operand1_phy = 0;
        out_mul_Operand2_phy = 0;
        out_mul_valid = 0;
        out_mul_inst_num = 0;


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
        csr_on = 0;

        out_add_ALUOP = 0;   
        out_add_ALUSrc1 = 0;
        out_add_ALUSrc2 = 0;      

        out_mul_ALUOP = 0;   
        out_div_ALUOP = 0;   
        out_div_inst_num = 0; 

        RS_br_IF_ID_taken = 0;
        RS_br_IF_ID_hit = 0; 

        pass_ALUOP = 0;
        pass_pc = 0;
        pass_ALUSrc1 = 0;
        pass_ALUSrc2 = 0;
        pass_rd_phy_reg = 0;
        pass_rs_on = 0;
        pass_Operand1 = 0;
        pass_Operand2 = 0;
        pass_immediate = 0;
        pass_inst_num = 0;

        LS_ALUOP = 0;
        LS_MemRead = 0;
        LS_func3=0;
     
        LS_MemToReg = 0;
        LS_MemWrite = 0;
   
        LS_ALUSrc2 = 0;
        LS_phy_reg = 0;
        LS_on = 0;
        LS_valid = 0;
        LS_Operand1_phy = 0;
        LS_Operand2_phy = 0;
        LS_immediate = 0;
        LS_inst_num = 0;

        CSR_data =0;
        CSR_operand1 = 0;
  
        CSR_aluop = 0;
        CSR_rd_phy = 0;
        CSR_valid = 0;
        CSR_instnum = 0;

    end else begin
        add_rs_on = 0;
        mul_rs_on = 0;
        div_rs_on = 0;
        RS_br_start = 0;
        pass_rs_on = 0;
        LS_on = 0;
        csr_on = 0;
        if (in_opcode == 7'b0000000) begin
            // NOP or unsupported instruction
        end else if (in_opcode == 7'b0110011) begin
            if (in_funct7 == 7'b0000001) begin
                if (in_func3 == 3'b000) begin
                    // MUL instruction

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
                    if(valid == 2'b11) begin

                        pass_pc = in_pc;

                        pass_rd_phy_reg = rd_phy_reg;
                        pass_rs_on = 1;
                        pass_Operand1 = Operand1_data;
                        pass_Operand2 = Operand2_data;

                        pass_immediate = immediate;     
                        pass_ALUOP = ALUOP;   
                        pass_ALUSrc1 = ALUSrc1;
                        pass_ALUSrc2 = ALUSrc2;      
                        pass_inst_num = inst_num;     

                    end else begin

                    add_alu_pc = in_pc;

                    add_rd_phy_reg = rd_phy_reg;
                    add_rs_on = 1;
                    out_add_Operand1_phy = Operand1_phy;
                    out_add_Operand2_phy = Operand2_phy;
                    out_add_valid = valid;
                    out_add_immediate = immediate;
 
                    out_add_ALUOP = ALUOP;   
                    out_add_ALUSrc1 = ALUSrc1;
                    out_add_ALUSrc2 = ALUSrc2;      
                    out_add_inst_num = inst_num;
                    end
                end
            end else begin
                // Default R-type to ADD ALU

                    if(valid == 2'b11) begin

                        pass_pc = in_pc;

                        pass_rd_phy_reg = rd_phy_reg;
                        pass_rs_on = 1;
                        pass_Operand1 = Operand1_data;
                        pass_Operand2 = Operand2_data;

                        pass_immediate = immediate;     
                        pass_ALUOP = ALUOP;   
                        pass_ALUSrc1 = ALUSrc1;
                        pass_ALUSrc2 = ALUSrc2;      
                        pass_inst_num = inst_num;     

                    end else begin


                add_alu_pc = in_pc;

                add_rd_phy_reg = rd_phy_reg;
                add_rs_on = 1;
                out_add_Operand1_phy = Operand1_phy;
                out_add_Operand2_phy = Operand2_phy;
                out_add_valid = valid;
                out_add_immediate = immediate;
   
                out_add_ALUOP = ALUOP;   
                out_add_ALUSrc1 = ALUSrc1;
                out_add_ALUSrc2 = ALUSrc2;      
                out_add_inst_num = inst_num;
                    end
            end
        end else if (in_opcode == 7'b1101111 || in_opcode == 7'b1100111 || in_opcode == 7'b1100011) begin
            // Branch and Jump instructions

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
        end else if (in_opcode == 7'b0000011 || in_opcode == 7'b0100011) begin  //load and store
            LS_func3 = in_func3;
            
            LS_phy_reg = rd_phy_reg;
            LS_on = 1;
            LS_Operand1_phy = Operand1_phy;
            LS_Operand2_phy = Operand2_phy;
            LS_valid = valid;
            LS_immediate = immediate;
            LS_MemToReg = MemToReg;   
            LS_MemRead = MemRead;   
            LS_MemWrite = MemWrite;      
            LS_ALUOP = ALUOP;   
           
            LS_ALUSrc2 = ALUSrc2;      
            LS_inst_num = inst_num;
        end else if(in_opcode == 7'b1110011) begin
                if(in_func3 == 0) begin
                    //do nothing
                
                end else begin
                    CSR_rd_phy = rd_phy_reg;
                    csr_on = 1;
                    CSR_operand1 = Operand1_phy;
                   
                    CSR_valid = valid;
                    CSR_immediate = immediate;     
                    CSR_aluop = ALUOP;   
                    CSR_instnum = inst_num;  
                    CSR_data = csr_data_in;
                    CSR_addr = csr_addr_in;
                    CSR_ALUSrc2 = ALUSrc2;
                end


        end else begin
            // Default to ADD ALU

                    if(valid == 2'b11) begin

                        pass_pc = in_pc;

                        pass_rd_phy_reg = rd_phy_reg;
                        pass_rs_on = 1;
                        pass_Operand1 = Operand1_data;
                        pass_Operand2 = Operand2_data;

                        pass_immediate = immediate;     
                        pass_ALUOP = ALUOP;   
                        pass_ALUSrc1 = ALUSrc1;
                        pass_ALUSrc2 = ALUSrc2;      
                        pass_inst_num = inst_num;     

                    end else begin

 
            add_alu_pc = in_pc;

            add_rd_phy_reg = rd_phy_reg;
            add_rs_on = 1;
            out_add_Operand1_phy = Operand1_phy;
            out_add_Operand2_phy = Operand2_phy;
            out_add_valid = valid;
            out_add_immediate = immediate;
 
            out_add_ALUOP = ALUOP;   
            out_add_ALUSrc1 = ALUSrc1;
            out_add_ALUSrc2 = ALUSrc2;      
            out_add_inst_num = inst_num;
                    end
        end
    end
end
endmodule
