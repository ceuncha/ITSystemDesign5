 module RS_ALU (                                             //筌뤿굝議�?堉� forwarding, 餓�?�뜮袁⑤쭆 筌뤿굝議�?堉깁겫??苑� ?沅↑퉪��沅▽틠�눖�뮉 ?肉�?釉�?諭�?�뱽 ?�땾?六�.
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] RS_alu_inst_num,
    input wire [31:0] PC,
    input wire [7:0] Rd,
    input wire MemToReg,
    input wire MemRead,
    input wire MemWrite,
    input wire [3:0] ALUOP,
    input wire ALUSrc1,
    input wire ALUSrc2,
    input wire Jump,
    input wire Branch,
    input wire [2:0] funct3,
    input wire [31:0] immediate,
    input wire EX_MEM_MemRead,
    input wire [31:0] RData,
    input wire [7:0] EX_MEM_Physical_Address,
    input wire [7:0] operand1,
    input wire [7:0] operand2,
    input wire [31:0] operand1_data,
    input wire [31:0] operand2_data,
    input wire [1:0] valid,
    input wire [31:0] ALU_result,
    input wire [7:0] ALU_result_dest,
    input wire ALU_result_valid,
    input wire [31:0] MUL_result,
    input wire [7:0] MUL_result_dest,
    input wire MUL_result_valid,
    input wire [31:0] DIV_result,
    input wire [7:0] DIV_result_dest,
    input wire DIV_result_valid,
    input wire Branch_result_valid,
    input wire [31:0]PC_Return,
    input wire [7:0] BR_Phy,

  
  output reg [182:0] result_out
    
);
    
    // Internal storage for reservation station entries
   (* keep = "true" *) reg [31:0] inst_nums[0:63];
   (* keep = "true" *) reg [31:0] PCs [0:63];
    (* keep = "true" *) reg [7:0] Rds [0:63];
   (* keep = "true" *) reg [63:0] MemToRegs;
   (* keep = "true" *) reg [63:0] MemReads;
   (* keep = "true" *) reg [63:0] MemWrites;
   (* keep = "true" *) reg [3:0] ALUOPs [0:63];
   (* keep = "true" *) reg [63:0] ALUSrc1s;
   (* keep = "true" *) reg [63:0] ALUSrc2s;
   (* keep = "true" *) reg [63:0] Jumps;
   (* keep = "true" *) reg [63:0] Branchs;
   (* keep = "true" *) reg [2:0] funct3s [0:63];
   (* keep = "true" *) reg [31:0] immediates [0:63];
   (* keep = "true" *) reg [7:0] operand1s [0:63];
   (* keep = "true" *) reg [7:0] operand2s [0:63];
   (* keep = "true" *) reg [31:0] operand1_datas [0:63];  // operand1 data
   (* keep = "true" *) reg [31:0] operand2_datas [0:63]; // operand2 data
   (* keep = "true" *) reg [63:0] valid_entries1;  // operand1??逾� valid?�뇡�냲彛�?
   (* keep = "true" *) reg [63:0] valid_entries2; // operand2�뤆?? valid?�뇡�냲彛�?
   (* keep = "true" *) reg [182:0] result [0:63];
   (* keep = "true" *) reg [6:0] tail;
   (* keep = "true" *) reg [6:0] head;
   (* keep = "true" *) reg [63:0] readys;
    wire [63:0] Y;
   (* keep = "true" *) integer i, j, k, l, m;
   (* keep = "true" *) reg RS_ALU_on[0:63];

    always @(posedge clk) begin    //�뵳�딅��?�뻿?�깈嚥�? �룯�뜃由�?�넅 ?�뻻�녹뮇夷�
        if (reset) begin
            tail <= 0;
            head <=0;
            for (i = 0; i < 64; i = i + 1) begin
                inst_nums[i] <=0;
                PCs[i] <= 0;
                Rds[i] <= 0;
                MemToRegs[i] <= 0;
                MemReads[i] <= 0;
                MemWrites[i] <= 0;
                ALUOPs[i] <= 0;
                ALUSrc1s[i] <= 0;
                ALUSrc2s[i] <= 0;
                Jumps[i] <= 0;
                Branchs[i] <= 0;
                funct3s[i] <= 0;
                immediates[i] <=0;
                operand1s[i] <= 0;
                operand2s[i] <= 0;
                operand1_datas[i] <= 0;
                operand2_datas[i] <= 0;
                valid_entries1[i] <= 1'b0; 
                valid_entries2[i] <= 1'b0; 
             
            end
        end else begin
        if (start) begin

            
   
            if (operand1 == ALU_result_dest) begin  // 筌뤿굝議�?堉긷첎? 筌ｌ꼷�벉 ?諭�?堉�?�넅?�뱽?釉�, alu?�벥 野껉퀗�궢?? 筌뤿굝議�?堉�?�벥 operand �눧�눖�봺雅뚯눘�꺖�몴? �뜮袁㏉꺍?釉�?肉� 
                                                    // ?毓�?�쑓?�뵠?�뱜揶�? ?釉�?�뒄?�뻻 ?�땾?六�?鍮먧빳??�뼄.
                inst_nums[tail] <= RS_alu_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
                ALUSrc1s[tail] <= ALUSrc1;
                ALUSrc2s[tail] <= ALUSrc2;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= ALU_result;
                operand2_datas[tail] <= operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1];
                tail <= (tail + 1) % 64;
                RS_ALU_on[tail] <=0;
            end else if (operand2 == ALU_result_dest) begin 
                inst_nums[tail] <= RS_alu_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
                ALUSrc1s[tail] <= ALUSrc1;
                ALUSrc2s[tail] <= ALUSrc2;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= ALU_result;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;  
                 RS_ALU_on[tail] <=0; 
             end else if (operand1 == MUL_result_dest) begin  // 筌뤿굝議�?堉긷첎? 筌ｌ꼷�벉 ?諭�?堉�?�넅?�뱽?釉�, mul?�벥 野껉퀗�궢?? 筌뤿굝議�?堉�?�벥 operand �눧�눖�봺雅뚯눘�꺖�몴? �뜮袁㏉꺍?釉�?肉� 
                                                              // ?毓�?�쑓?�뵠?�뱜揶�? ?釉�?�뒄?�뻻 ?�땾?六�?鍮먧빳??�뼄.
                inst_nums[tail] <= RS_alu_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
                ALUSrc1s[tail] <= ALUSrc1;
                ALUSrc2s[tail] <= ALUSrc2;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= MUL_result;
                operand2_datas[tail] <= operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1];
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
             end else if (operand2 == MUL_result_dest) begin  
                inst_nums[tail] <= RS_alu_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
                ALUSrc1s[tail] <= ALUSrc1;
                ALUSrc2s[tail] <= ALUSrc2;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= MUL_result;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
              end else if (operand1 == DIV_result_dest) begin  // 筌뤿굝議�?堉긷첎? 筌ｌ꼷�벉 ?諭�?堉�?�넅?�뱽?釉�, div?�벥 野껉퀗�궢?? 筌뤿굝議�?堉�?�벥 operand �눧�눖�봺雅뚯눘�꺖�몴? �뜮袁㏉꺍?釉�?肉� 
                                                              // ?毓�?�쑓?�뵠?�뱜揶�? ?釉�?�뒄?�뻻 ?�땾?六�?鍮먧빳??�뼄.
                 inst_nums[tail] <= RS_alu_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
                ALUSrc1s[tail] <= ALUSrc1;
                ALUSrc2s[tail] <= ALUSrc2;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= DIV_result;
                operand2_datas[tail] <= operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1];
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
              end else if (operand2 == DIV_result_dest) begin  
                inst_nums[tail] <= RS_alu_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
                ALUSrc1s[tail] <= ALUSrc1;
                ALUSrc2s[tail] <= ALUSrc2;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= DIV_result; 
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
             end else if ( operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin     
                                                                // 筌뤿굝議�?堉긷첎? 筌ｌ꼷�벉 ?諭�?堉�?�넅?�뱽?釉�, load?�벥 野껉퀗�궢?? 筌뤿굝議�?堉�?�벥 operand �눧�눖�봺雅뚯눘�꺖�몴? �뜮袁㏉꺍?釉�?肉� 
                                                              // ?毓�?�쑓?�뵠?�뱜揶�? ?釉�?�뒄?�뻻 ?�땾?六�?鍮먧빳??�뼄.
                inst_nums[tail] <= RS_alu_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
                ALUSrc1s[tail] <= ALUSrc1;
                ALUSrc2s[tail] <= ALUSrc2;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= RData;
                operand2_datas[tail] <= operand2_data; 
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1] ; 
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
              end else if ( operand2 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin
                inst_nums[tail] <= RS_alu_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
                ALUSrc1s[tail] <= ALUSrc1;
                ALUSrc2s[tail] <= ALUSrc2;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= RData;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1 ; 
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
              end else if(operand1 == BR_Phy) begin
                inst_nums[tail] <= RS_alu_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
                ALUSrc1s[tail] <= ALUSrc1;
                ALUSrc2s[tail] <= ALUSrc2;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= PC_Return;
                operand2_datas[tail] <= operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1];
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
              end else if(operand2 == BR_Phy) begin
                inst_nums[tail] <= RS_alu_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
                ALUSrc1s[tail] <= ALUSrc1;
                ALUSrc2s[tail] <= ALUSrc2;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= PC_Return;
                operand2_datas[tail] <= operand2_data;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1;
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;                   
              
            end else begin
                inst_nums[tail] <= RS_alu_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
                ALUSrc1s[tail] <= ALUSrc1;
                ALUSrc2s[tail] <= ALUSrc2;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= operand2_data;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= valid[1]; 
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
             end 
             end
            
            
           
            if (ALU_result_valid) begin                 //alu?�벥 野껉퀗�궢揶�? ?諭�?堉�?�넅?�뱽?釉�, 疫꿸퀣��?肉� RS?肉� ?諭�?堉�?�뿳?�쐲 筌뤿굝議�?堉�?諭얏��? �눧�눖�봺雅뚯눘�꺖�몴? �뜮袁㏉꺍?釉�?肉�
                                                        //?釉�?�뒄?釉� 揶쏅�⑸굶?�뱽 ?毓�?�쑓?�뵠?�뱜 ?�뻻�녹뮇??�뼄.
                for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == ALU_result_dest) begin
                        operand1_datas[i] <= ALU_result;
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == ALU_result_dest) begin
                        operand2_datas[i] <= ALU_result;
                        valid_entries2[i] <= 1;
                    end
                end
            end
            if (MUL_result_valid) begin                     //mul?�벥 野껉퀗�궢揶�? ?諭�?堉�?�넅?�뱽?釉�, 疫꿸퀣��?肉� RS?肉� ?諭�?堉�?�뿳?�쐲 筌뤿굝議�?堉�?諭얏��? �눧�눖�봺雅뚯눘�꺖�몴? �뜮袁㏉꺍?釉�?肉�
                                                        //?釉�?�뒄?釉� 揶쏅�⑸굶?�뱽 ?毓�?�쑓?�뵠?�뱜 ?�뻻�녹뮇??�뼄.
                for (j = 0; j < 64; j = j + 1) begin
                    if (!valid_entries1[j] && operand1s[j] == MUL_result_dest) begin
                        operand1_datas[j] <= MUL_result;
                        valid_entries1[j] <= 1;
                    end
                    if (!valid_entries2[j] && operand2s[j] == MUL_result_dest) begin
                        operand2_datas[j] <= MUL_result;
                        valid_entries2[j] <= 1;
                    end
                end
            end
            if (DIV_result_valid) begin         //div?�벥 野껉퀗�궢揶�? ?諭�?堉�?�넅?�뱽?釉�, 疫꿸퀣��?肉� RS?肉� ?諭�?堉�?�뿳?�쐲 筌뤿굝議�?堉�?諭얏��? �눧�눖�봺雅뚯눘�꺖�몴? �뜮袁㏉꺍?釉�?肉�
                                                        //?釉�?�뒄?釉� 揶쏅�⑸굶?�뱽 ?毓�?�쑓?�뵠?�뱜 ?�뻻�녹뮇??�뼄.
                for (k = 0; k < 64; k = k + 1) begin
                    if (!valid_entries1[k] && operand1s[k] == DIV_result_dest) begin
                        operand1_datas[k] <= DIV_result;
                        valid_entries1[k] <= 1;
                    end
                    if (!valid_entries2[k] && operand2s[k] == DIV_result_dest) begin
                        operand2_datas[k] <= DIV_result;
                        valid_entries2[k] <= 1;
                    end
                end
            end
           if (EX_MEM_MemRead) begin                //load?�벥 野껉퀗�궢揶�? ?諭�?堉�?�넅?�뱽?釉�, 疫꿸퀣��?肉� RS?肉� ?諭�?堉�?�뿳?�쐲 筌뤿굝議�?堉�?諭얏��? �눧�눖�봺雅뚯눘�꺖�몴? �뜮袁㏉꺍?釉�?肉�
                                                        //?釉�?�뒄?釉� 揶쏅�⑸굶?�뱽 ?毓�?�쑓?�뵠?�뱜 ?�뻻�녹뮇??�뼄.
           for (l = 0; l < 64; l = l + 1) begin
                    if (!valid_entries1[l] && operand1s[l] == EX_MEM_Physical_Address) begin
                        operand1_datas[l] <= RData;
                        valid_entries1[l] <= 1;
                    end
                    if (!valid_entries2[l] && operand2s[l] == EX_MEM_Physical_Address) begin
                        operand2_datas[l] <= RData;
                        valid_entries2[l] <= 1;
                    end
                end     
            end
                     if (Branch_result_valid) begin                //Branch?�벥 野껉퀗�궢揶�? ?諭�?堉�?�넅?�뱽?釉�, 疫꿸퀣��?肉� RS?肉� ?諭�?堉�?�뿳?�쐲 筌뤿굝議�?堉�?諭얏��? �눧�눖�봺雅뚯눘�꺖�몴? �뜮袁㏉꺍?釉�?肉�
                                                        //?釉�?�뒄?釉� 揶쏅�⑸굶?�뱽 ?毓�?�쑓?�뵠?�뱜 ?�뻻�녹뮇??�뼄.
           for (m = 0; m < 64; m = m + 1) begin
                    if (!valid_entries1[m] && operand1s[m] == BR_Phy) begin
                        operand1_datas[m] <= PC_Return;
                        valid_entries1[m] <= 1;
                    end
                    if (!valid_entries2[m] && operand2s[m] == BR_Phy) begin
                        operand2_datas[m] <= PC_Return;
                        valid_entries2[m] <= 1;
                    end
                end     
            end
         end
 
      if (RS_ALU_on[head]) begin
        head <= (head+1)%64;
        RS_ALU_on[head] <=0;     
      end
 
 if (valid_entries1[head] == 1 && valid_entries2[head] == 1) begin
        if (!MemReads[head]) begin
            result_out <= {inst_nums[head], 1'b1, PCs[head], Rds[head], MemToRegs[head], MemReads[head], MemWrites[head], ALUOPs[head], ALUSrc1s[head], ALUSrc2s[head], Jumps[head], Branchs[head], funct3s[head], immediates[head], operand1_datas[head], operand2_datas[head]};
        end else begin
            result_out <= {inst_nums[head], 1'b0, PCs[head], Rds[head], MemToRegs[head], MemReads[head], MemWrites[head], ALUOPs[head], ALUSrc1s[head], ALUSrc2s[head], Jumps[head], Branchs[head], funct3s[head], immediates[head], operand1_datas[head], operand2_datas[head]};
        end
        readys[head] <= 0;
        operand1s[head] <= 0;
        operand2s[head] <= 0;
        operand1_datas[head] <= 0;
        operand2_datas[head] <= 0;
        valid_entries1[head] <= 0;
        valid_entries2[head] <= 0;
        head <= (head+1)%64;
    
    end
    else if (valid_entries1[(head + 1) % 64] == 1 && valid_entries2[(head + 1) % 64] == 1) begin
        if (!MemReads[(head + 1) % 64]) begin
            result_out <= {inst_nums[(head + 1) % 64], 1'b1, PCs[(head + 1) % 64], Rds[(head + 1) % 64], MemToRegs[(head + 1) % 64], MemReads[(head + 1) % 64], MemWrites[(head + 1) % 64], ALUOPs[(head + 1) % 64], ALUSrc1s[(head + 1) % 64], ALUSrc2s[(head + 1) % 64], Jumps[(head + 1) % 64], Branchs[(head + 1) % 64], funct3s[(head + 1) % 64], immediates[(head + 1) % 64], operand1_datas[(head + 1) % 64], operand2_datas[(head + 1) % 64]};
        end else begin
            result_out <= {inst_nums[(head + 1) % 64], 1'b0, PCs[(head + 1) % 64], Rds[(head + 1) % 64], MemToRegs[(head + 1) % 64], MemReads[(head + 1) % 64], MemWrites[(head + 1) % 64], ALUOPs[(head + 1) % 64], ALUSrc1s[(head + 1) % 64], ALUSrc2s[(head + 1) % 64], Jumps[(head + 1) % 64], Branchs[(head + 1) % 64], funct3s[(head + 1) % 64], immediates[(head + 1) % 64], operand1_datas[(head + 1) % 64], operand2_datas[(head + 1) % 64]};
        end
        readys[(head + 1) % 64] <= 0;
        operand1s[(head + 1) % 64] <= 0;
        operand2s[(head + 1) % 64] <= 0;
        operand1_datas[(head + 1) % 64] <= 0;
        operand2_datas[(head + 1) % 64] <= 0;
        valid_entries1[(head + 1) % 64] <= 0;
        valid_entries2[(head + 1) % 64] <= 0;
        RS_ALU_on[(head+1)%64] <=1;
    end
    else if (valid_entries1[(head + 2) % 64] == 1 && valid_entries2[(head + 2) % 64] == 1) begin
        if (!MemReads[(head + 2) % 64]) begin
            result_out <= {inst_nums[(head + 2) % 64], 1'b1, PCs[(head + 2) % 64], Rds[(head + 2) % 64], MemToRegs[(head + 2) % 64], MemReads[(head + 2) % 64], MemWrites[(head + 2) % 64], ALUOPs[(head + 2) % 64], ALUSrc1s[(head + 2) % 64], ALUSrc2s[(head + 2) % 64], Jumps[(head + 2) % 64], Branchs[(head + 2) % 64], funct3s[(head + 2) % 64], immediates[(head + 2) % 64], operand1_datas[(head + 2) % 64], operand2_datas[(head + 2) % 64]};
        end else begin
            result_out <= {inst_nums[(head + 2) % 64], 1'b0, PCs[(head + 2) % 64], Rds[(head + 2) % 64], MemToRegs[(head + 2) % 64], MemReads[(head + 2) % 64], MemWrites[(head + 2) % 64], ALUOPs[(head + 2) % 64], ALUSrc1s[(head + 2) % 64], ALUSrc2s[(head + 2) % 64], Jumps[(head + 2) % 64], Branchs[(head + 2) % 64], funct3s[(head + 2) % 64], immediates[(head + 2) % 64], operand1_datas[(head + 2) % 64], operand2_datas[(head + 2) % 64]};
        end
        readys[(head + 2) % 64] <= 0;
        operand1s[(head + 2) % 64] <= 0;
        operand2s[(head + 2) % 64] <= 0;
        operand1_datas[(head + 2) % 64] <= 0;
        operand2_datas[(head + 2) % 64] <= 0;
        valid_entries1[(head + 2) % 64] <= 0;
        valid_entries2[(head + 2) % 64] <= 0;
        RS_ALU_on[(head+2)%64] <=1;
    end
    else if (valid_entries1[(head + 3) % 64] == 1 && valid_entries2[(head + 3) % 64] == 1) begin
        if (!MemReads[(head + 3) % 64]) begin
            result_out <= {inst_nums[(head + 3) % 64], 1'b1, PCs[(head + 3) % 64], Rds[(head + 3) % 64], MemToRegs[(head + 3) % 64], MemReads[(head + 3) % 64], MemWrites[(head + 3) % 64], ALUOPs[(head + 3) % 64], ALUSrc1s[(head + 3) % 64], ALUSrc2s[(head + 3) % 64], Jumps[(head + 3) % 64], Branchs[(head + 3) % 64], funct3s[(head + 3) % 64], immediates[(head + 3) % 64], operand1_datas[(head + 3) % 64], operand2_datas[(head + 3) % 64]};
        end else begin
            result_out <= {inst_nums[(head + 3) % 64], 1'b0, PCs[(head + 3) % 64], Rds[(head + 3) % 64], MemToRegs[(head + 3) % 64], MemReads[(head + 3) % 64], MemWrites[(head + 3) % 64], ALUOPs[(head + 3) % 64], ALUSrc1s[(head + 3) % 64], ALUSrc2s[(head + 3) % 64], Jumps[(head + 3) % 64], Branchs[(head + 3) % 64], funct3s[(head + 3) % 64], immediates[(head + 3) % 64], operand1_datas[(head + 3) % 64], operand2_datas[(head + 3) % 64]};
        end
        readys[(head + 3) % 64] <= 0;
        operand1s[(head + 3) % 64] <= 0;
        operand2s[(head + 3) % 64] <= 0;
        operand1_datas[(head + 3) % 64] <= 0;
        operand2_datas[(head + 3) % 64] <= 0;
        valid_entries1[(head + 3) % 64] <= 0;
        valid_entries2[(head + 3) % 64] <= 0;
        RS_ALU_on[(head+3)%64] <=1;
    end
  
    else if (valid_entries1[(head + 4) % 64] == 1 && valid_entries2[(head + 4) % 64] == 1) begin
        if (!MemReads[(head + 4) % 64]) begin
            result_out <= {inst_nums[(head + 4) % 64], 1'b1, PCs[(head + 4) % 64], Rds[(head + 4) % 64], MemToRegs[(head + 4) % 64], MemReads[(head + 4) % 64], MemWrites[(head + 4) % 64], ALUOPs[(head + 4) % 64], ALUSrc1s[(head + 4) % 64], ALUSrc2s[(head + 4) % 64], Jumps[(head + 4) % 64], Branchs[(head + 4) % 64], funct3s[(head + 4) % 64], immediates[(head + 4) % 64], operand1_datas[(head + 4) % 64], operand2_datas[(head + 4) % 64]};
        end else begin
            result_out <= {inst_nums[(head + 4) % 64], 1'b0, PCs[(head + 4) % 64], Rds[(head + 4) % 64], MemToRegs[(head + 4) % 64], MemReads[(head + 4) % 64], MemWrites[(head + 4) % 64], ALUOPs[(head + 4) % 64], ALUSrc1s[(head + 4) % 64], ALUSrc2s[(head + 4) % 64], Jumps[(head + 4) % 64], Branchs[(head + 4) % 64], funct3s[(head + 4) % 64], immediates[(head + 4) % 64], operand1_datas[(head + 4) % 64], operand2_datas[(head + 4) % 64]};
        end
        readys[(head + 4) % 64] <= 0;
        operand1s[(head + 4) % 64] <= 0;
        operand2s[(head + 4) % 64] <= 0;
        operand1_datas[(head + 4) % 64] <= 0;
        operand2_datas[(head + 4) % 64] <= 0;
        valid_entries1[(head + 4) % 64] <= 0;
        valid_entries2[(head + 4) % 64] <= 0;
        RS_ALU_on[(head+4)%64] <=1;
    end

    else if (valid_entries1[(head + 5) % 64] == 1 && valid_entries2[(head + 5) % 64] == 1) begin
        if (!MemReads[(head + 5) % 64]) begin
            result_out <= {inst_nums[(head + 5) % 64], 1'b1, PCs[(head + 5) % 64], Rds[(head + 5) % 64], MemToRegs[(head + 5) % 64], MemReads[(head + 5) % 64], MemWrites[(head + 5) % 64], ALUOPs[(head + 5) % 64], ALUSrc1s[(head + 5) % 64], ALUSrc2s[(head + 5) % 64], Jumps[(head + 5) % 64], Branchs[(head + 5) % 64], funct3s[(head + 5) % 64], immediates[(head + 5) % 64], operand1_datas[(head + 5) % 64], operand2_datas[(head + 5) % 64]};
        end else begin
            result_out <= {inst_nums[(head + 5) % 64], 1'b0, PCs[(head + 5) % 64], Rds[(head + 5) % 64], MemToRegs[(head + 5) % 64], MemReads[(head + 5) % 64], MemWrites[(head + 5) % 64], ALUOPs[(head + 5) % 64], ALUSrc1s[(head + 5) % 64], ALUSrc2s[(head + 5) % 64], Jumps[(head + 5) % 64], Branchs[(head + 5) % 64], funct3s[(head + 5) % 64], immediates[(head + 5) % 64], operand1_datas[(head + 5) % 64], operand2_datas[(head + 5) % 64]};
        end
        readys[(head + 5) % 64] <= 0;
        operand1s[(head + 5) % 64] <= 0;
        operand2s[(head + 5) % 64] <= 0;
        operand1_datas[(head + 5) % 64] <= 0;
        operand2_datas[(head + 5) % 64] <= 0;
        valid_entries1[(head + 5) % 64] <= 0;
        valid_entries2[(head + 5) % 64] <= 0;
        RS_ALU_on[(head+5)%64] <=1;
    end
    else if (valid_entries1[(head + 6) % 64] == 1 && valid_entries2[(head + 6) % 64] == 1) begin
        if (!MemReads[(head + 6) % 64]) begin
            result_out <= {inst_nums[(head + 6) % 64], 1'b1, PCs[(head + 6) % 64], Rds[(head + 6) % 64], MemToRegs[(head + 6) % 64], MemReads[(head + 6) % 64], MemWrites[(head + 6) % 64], ALUOPs[(head + 6) % 64], ALUSrc1s[(head + 6) % 64], ALUSrc2s[(head + 6) % 64], Jumps[(head + 6) % 64], Branchs[(head + 6) % 64], funct3s[(head + 6) % 64], immediates[(head + 6) % 64], operand1_datas[(head + 6) % 64], operand2_datas[(head + 6) % 64]};
        end else begin
            result_out <= {inst_nums[(head + 6) % 64], 1'b0, PCs[(head + 6) % 64], Rds[(head + 6) % 64], MemToRegs[(head + 6) % 64], MemReads[(head + 6) % 64], MemWrites[(head + 6) % 64], ALUOPs[(head + 6) % 64], ALUSrc1s[(head + 6) % 64], ALUSrc2s[(head + 6) % 64], Jumps[(head + 6) % 64], Branchs[(head + 6) % 64], funct3s[(head + 6) % 64], immediates[(head + 6) % 64], operand1_datas[(head + 6) % 64], operand2_datas[(head + 6) % 64]};
        end
        readys[(head + 6) % 64] <= 0;
        operand1s[(head + 6) % 64] <= 0;
        operand2s[(head + 6) % 64] <= 0;
        operand1_datas[(head + 6) % 64] <= 0;
        operand2_datas[(head + 6) % 64] <= 0;
        valid_entries1[(head + 6) % 64] <= 0;
        valid_entries2[(head + 6) % 64] <= 0;
        RS_ALU_on[(head+6)%64] <=1;
    end
    else if (valid_entries1[(head + 7) % 64] == 1 && valid_entries2[(head + 7) % 64] == 1) begin
        if (!MemReads[(head + 7) % 64]) begin
            result_out <= {inst_nums[(head + 7) % 64], 1'b1, PCs[(head + 7) % 64], Rds[(head + 7) % 64], MemToRegs[(head + 7) % 64], MemReads[(head + 7) % 64], MemWrites[(head + 7) % 64], ALUOPs[(head + 7) % 64], ALUSrc1s[(head + 7) % 64], ALUSrc2s[(head + 7) % 64], Jumps[(head + 7) % 64], Branchs[(head + 7) % 64], funct3s[(head + 7) % 64], immediates[(head + 7) % 64], operand1_datas[(head + 7) % 64], operand2_datas[(head + 7) % 64]};
        end else begin
            result_out <= {inst_nums[(head + 7) % 64], 1'b0, PCs[(head + 7) % 64], Rds[(head + 7) % 64], MemToRegs[(head + 7) % 64], MemReads[(head + 7) % 64], MemWrites[(head + 7) % 64], ALUOPs[(head + 7) % 64], ALUSrc1s[(head + 7) % 64], ALUSrc2s[(head + 7) % 64], Jumps[(head + 7) % 64], Branchs[(head + 7) % 64], funct3s[(head + 7) % 64], immediates[(head + 7) % 64], operand1_datas[(head + 7) % 64], operand2_datas[(head + 7) % 64]};
        end
        readys[(head + 7) % 64] <= 0;
        operand1s[(head + 7) % 64] <= 0;
        operand2s[(head + 7) % 64] <= 0;
        operand1_datas[(head + 7) % 64] <= 0;
        operand2_datas[(head + 7) % 64] <= 0;
        valid_entries1[(head + 7) % 64] <= 0;
        valid_entries2[(head + 7) % 64] <= 0;
        RS_ALU_on[(head+7)%64] <=1;
    end
    else if (valid_entries1[(head + 8) % 64] == 1 && valid_entries2[(head + 8) % 64] == 1) begin
    if (!MemReads[(head + 8) % 64]) begin
        result_out <= {inst_nums[(head + 8) % 64], 1'b1, PCs[(head + 8) % 64], Rds[(head + 8) % 64], MemToRegs[(head + 8) % 64], MemReads[(head + 8) % 64], MemWrites[(head + 8) % 64], ALUOPs[(head + 8) % 64], ALUSrc1s[(head + 8) % 64], ALUSrc2s[(head + 8) % 64], Jumps[(head + 8) % 64], Branchs[(head + 8) % 64], funct3s[(head + 8) % 64], immediates[(head + 8) % 64], operand1_datas[(head + 8) % 64], operand2_datas[(head + 8) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 8) % 64], 1'b0, PCs[(head + 8) % 64], Rds[(head + 8) % 64], MemToRegs[(head + 8) % 64], MemReads[(head + 8) % 64], MemWrites[(head + 8) % 64], ALUOPs[(head + 8) % 64], ALUSrc1s[(head + 8) % 64], ALUSrc2s[(head + 8) % 64], Jumps[(head + 8) % 64], Branchs[(head + 8) % 64], funct3s[(head + 8) % 64], immediates[(head + 8) % 64], operand1_datas[(head + 8) % 64], operand2_datas[(head + 8) % 64]};
    end
    readys[(head + 8) % 64] <= 0;
    operand1s[(head + 8) % 64] <= 0;
    operand2s[(head + 8) % 64] <= 0;
    operand1_datas[(head + 8) % 64] <= 0;
    operand2_datas[(head + 8) % 64] <= 0;
    valid_entries1[(head + 8) % 64] <= 0;
    valid_entries2[(head + 8) % 64] <= 0;
    RS_ALU_on[(head+8)%64] <=1;
end
else if (valid_entries1[(head + 9) % 64] == 1 && valid_entries2[(head + 9) % 64] == 1) begin
    if (!MemReads[(head + 9) % 64]) begin
        result_out <= {inst_nums[(head + 9) % 64], 1'b1, PCs[(head + 9) % 64], Rds[(head + 9) % 64], MemToRegs[(head + 9) % 64], MemReads[(head + 9) % 64], MemWrites[(head + 9) % 64], ALUOPs[(head + 9) % 64], ALUSrc1s[(head + 9) % 64], ALUSrc2s[(head + 9) % 64], Jumps[(head + 9) % 64], Branchs[(head + 9) % 64], funct3s[(head + 9) % 64], immediates[(head + 9) % 64], operand1_datas[(head + 9) % 64], operand2_datas[(head + 9) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 9) % 64], 1'b0, PCs[(head + 9) % 64], Rds[(head + 9) % 64], MemToRegs[(head + 9) % 64], MemReads[(head + 9) % 64], MemWrites[(head + 9) % 64], ALUOPs[(head + 9) % 64], ALUSrc1s[(head + 9) % 64], ALUSrc2s[(head + 9) % 64], Jumps[(head + 9) % 64], Branchs[(head + 9) % 64], funct3s[(head + 9) % 64], immediates[(head + 9) % 64], operand1_datas[(head + 9) % 64], operand2_datas[(head + 9) % 64]};
    end
    readys[(head + 9) % 64] <= 0;
    operand1s[(head + 9) % 64] <= 0;
    operand2s[(head + 9) % 64] <= 0;
    operand1_datas[(head + 9) % 64] <= 0;
    operand2_datas[(head + 9) % 64] <= 0;
    valid_entries1[(head + 9) % 64] <= 0;
    valid_entries2[(head + 9) % 64] <= 0;
    RS_ALU_on[(head+9)%64] <=1;
end
else if (valid_entries1[(head + 10) % 64] == 1 && valid_entries2[(head + 10) % 64] == 1) begin
    if (!MemReads[(head + 10) % 64]) begin
        result_out <= {inst_nums[(head + 10) % 64], 1'b1, PCs[(head + 10) % 64], Rds[(head + 10) % 64], MemToRegs[(head + 10) % 64], MemReads[(head + 10) % 64], MemWrites[(head + 10) % 64], ALUOPs[(head + 10) % 64], ALUSrc1s[(head + 10) % 64], ALUSrc2s[(head + 10) % 64], Jumps[(head + 10) % 64], Branchs[(head + 10) % 64], funct3s[(head + 10) % 64], immediates[(head + 10) % 64], operand1_datas[(head + 10) % 64], operand2_datas[(head + 10) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 10) % 64], 1'b0, PCs[(head + 10) % 64], Rds[(head + 10) % 64], MemToRegs[(head + 10) % 64], MemReads[(head + 10) % 64], MemWrites[(head + 10) % 64], ALUOPs[(head + 10) % 64], ALUSrc1s[(head + 10) % 64], ALUSrc2s[(head + 10) % 64], Jumps[(head + 10) % 64], Branchs[(head + 10) % 64], funct3s[(head + 10) % 64], immediates[(head + 10) % 64], operand1_datas[(head + 10) % 64], operand2_datas[(head + 10) % 64]};
    end
    readys[(head + 10) % 64] <= 0;
    operand1s[(head + 10) % 64] <= 0;
    operand2s[(head + 10) % 64] <= 0;
    operand1_datas[(head + 10) % 64] <= 0;
    operand2_datas[(head + 10) % 64] <= 0;
    valid_entries1[(head + 10) % 64] <= 0;
    valid_entries2[(head + 10) % 64] <= 0;
    RS_ALU_on[(head+10)%64] <=1;
end
else if (valid_entries1[(head + 11) % 64] == 1 && valid_entries2[(head + 11) % 64] == 1) begin
    if (!MemReads[(head + 11) % 64]) begin
        result_out <= {inst_nums[(head + 11) % 64], 1'b1, PCs[(head + 11) % 64], Rds[(head + 11) % 64], MemToRegs[(head + 11) % 64], MemReads[(head + 11) % 64], MemWrites[(head + 11) % 64], ALUOPs[(head + 11) % 64], ALUSrc1s[(head + 11) % 64], ALUSrc2s[(head + 11) % 64], Jumps[(head + 11) % 64], Branchs[(head + 11) % 64], funct3s[(head + 11) % 64], immediates[(head + 11) % 64], operand1_datas[(head + 11) % 64], operand2_datas[(head + 11) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 11) % 64], 1'b0, PCs[(head + 11) % 64], Rds[(head + 11) % 64], MemToRegs[(head + 11) % 64], MemReads[(head + 11) % 64], MemWrites[(head + 11) % 64], ALUOPs[(head + 11) % 64], ALUSrc1s[(head + 11) % 64], ALUSrc2s[(head + 11) % 64], Jumps[(head + 11) % 64], Branchs[(head + 11) % 64], funct3s[(head + 11) % 64], immediates[(head + 11) % 64], operand1_datas[(head + 11) % 64], operand2_datas[(head + 11) % 64]};
    end
    readys[(head + 11) % 64] <= 0;
    operand1s[(head + 11) % 64] <= 0;
    operand2s[(head + 11) % 64] <= 0;
    operand1_datas[(head + 11) % 64] <= 0;
    operand2_datas[(head + 11) % 64] <= 0;
    valid_entries1[(head + 11) % 64] <= 0;
    valid_entries2[(head + 11) % 64] <= 0;
    RS_ALU_on[(head+11)%64] <=1;
end
else if (valid_entries1[(head + 12) % 64] == 1 && valid_entries2[(head + 12) % 64] == 1) begin
    if (!MemReads[(head + 12) % 64]) begin
        result_out <= {inst_nums[(head + 12) % 64], 1'b1, PCs[(head + 12) % 64], Rds[(head + 12) % 64], MemToRegs[(head + 12) % 64], MemReads[(head + 12) % 64], MemWrites[(head + 12) % 64], ALUOPs[(head + 12) % 64], ALUSrc1s[(head + 12) % 64], ALUSrc2s[(head + 12) % 64], Jumps[(head + 12) % 64], Branchs[(head + 12) % 64], funct3s[(head + 12) % 64], immediates[(head + 12) % 64], operand1_datas[(head + 12) % 64], operand2_datas[(head + 12) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 12) % 64], 1'b0, PCs[(head + 12) % 64], Rds[(head + 12) % 64], MemToRegs[(head + 12) % 64], MemReads[(head + 12) % 64], MemWrites[(head + 12) % 64], ALUOPs[(head + 12) % 64], ALUSrc1s[(head + 12) % 64], ALUSrc2s[(head + 12) % 64], Jumps[(head + 12) % 64], Branchs[(head + 12) % 64], funct3s[(head + 12) % 64], immediates[(head + 12) % 64], operand1_datas[(head + 12) % 64], operand2_datas[(head + 12) % 64]};
    end
    readys[(head + 12) % 64] <= 0;
    operand1s[(head + 12) % 64] <= 0;
    operand2s[(head + 12) % 64] <= 0;
    operand1_datas[(head + 12) % 64] <= 0;
    operand2_datas[(head + 12) % 64] <= 0;
    valid_entries1[(head + 12) % 64] <= 0;
    valid_entries2[(head + 12) % 64] <= 0;
    RS_ALU_on[(head + 12) % 64] <= 1;
end
else if (valid_entries1[(head + 13) % 64] == 1 && valid_entries2[(head + 13) % 64] == 1) begin
    if (!MemReads[(head + 13) % 64]) begin
        result_out <= {inst_nums[(head + 13) % 64], 1'b1, PCs[(head + 13) % 64], Rds[(head + 13) % 64], MemToRegs[(head + 13) % 64], MemReads[(head + 13) % 64], MemWrites[(head + 13) % 64], ALUOPs[(head + 13) % 64], ALUSrc1s[(head + 13) % 64], ALUSrc2s[(head + 13) % 64], Jumps[(head + 13) % 64], Branchs[(head + 13) % 64], funct3s[(head + 13) % 64], immediates[(head + 13) % 64], operand1_datas[(head + 13) % 64], operand2_datas[(head + 13) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 13) % 64], 1'b0, PCs[(head + 13) % 64], Rds[(head + 13) % 64], MemToRegs[(head + 13) % 64], MemReads[(head + 13) % 64], MemWrites[(head + 13) % 64], ALUOPs[(head + 13) % 64], ALUSrc1s[(head + 13) % 64], ALUSrc2s[(head + 13) % 64], Jumps[(head + 13) % 64], Branchs[(head + 13) % 64], funct3s[(head + 13) % 64], immediates[(head + 13) % 64], operand1_datas[(head + 13) % 64], operand2_datas[(head + 13) % 64]};
    end
    readys[(head + 13) % 64] <= 0;
    operand1s[(head + 13) % 64] <= 0;
    operand2s[(head + 13) % 64] <= 0;
    operand1_datas[(head + 13) % 64] <= 0;
    operand2_datas[(head + 13) % 64] <= 0;
    valid_entries1[(head + 13) % 64] <= 0;
    valid_entries2[(head + 13) % 64] <= 0;
    RS_ALU_on[(head + 13) % 64] <= 1;
end
else if (valid_entries1[(head + 14) % 64] == 1 && valid_entries2[(head + 14) % 64] == 1) begin
    if (!MemReads[(head + 14) % 64]) begin
        result_out <= {inst_nums[(head + 14) % 64], 1'b1, PCs[(head + 14) % 64], Rds[(head + 14) % 64], MemToRegs[(head + 14) % 64], MemReads[(head + 14) % 64], MemWrites[(head + 14) % 64], ALUOPs[(head + 14) % 64], ALUSrc1s[(head + 14) % 64], ALUSrc2s[(head + 14) % 64], Jumps[(head + 14) % 64], Branchs[(head + 14) % 64], funct3s[(head + 14) % 64], immediates[(head + 14) % 64], operand1_datas[(head + 14) % 64], operand2_datas[(head + 14) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 14) % 64], 1'b0, PCs[(head + 14) % 64], Rds[(head + 14) % 64], MemToRegs[(head + 14) % 64], MemReads[(head + 14) % 64], MemWrites[(head + 14) % 64], ALUOPs[(head + 14) % 64], ALUSrc1s[(head + 14) % 64], ALUSrc2s[(head + 14) % 64], Jumps[(head + 14) % 64], Branchs[(head + 14) % 64], funct3s[(head + 14) % 64], immediates[(head + 14) % 64], operand1_datas[(head + 14) % 64], operand2_datas[(head + 14) % 64]};
    end
    readys[(head + 14) % 64] <= 0;
    operand1s[(head + 14) % 64] <= 0;
    operand2s[(head + 14) % 64] <= 0;
    operand1_datas[(head + 14) % 64] <= 0;
    operand2_datas[(head + 14) % 64] <= 0;
    valid_entries1[(head + 14) % 64] <= 0;
    valid_entries2[(head + 14) % 64] <= 0;
    RS_ALU_on[(head + 14) % 64] <= 1;
end
else if (valid_entries1[(head + 15) % 64] == 1 && valid_entries2[(head + 15) % 64] == 1) begin
    if (!MemReads[(head + 15) % 64]) begin
        result_out <= {inst_nums[(head + 15) % 64], 1'b1, PCs[(head + 15) % 64], Rds[(head + 15) % 64], MemToRegs[(head + 15) % 64], MemReads[(head + 15) % 64], MemWrites[(head + 15) % 64], ALUOPs[(head + 15) % 64], ALUSrc1s[(head + 15) % 64], ALUSrc2s[(head + 15) % 64], Jumps[(head + 15) % 64], Branchs[(head + 15) % 64], funct3s[(head + 15) % 64], immediates[(head + 15) % 64], operand1_datas[(head + 15) % 64], operand2_datas[(head + 15) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 15) % 64], 1'b0, PCs[(head + 15) % 64], Rds[(head + 15) % 64], MemToRegs[(head + 15) % 64], MemReads[(head + 15) % 64], MemWrites[(head + 15) % 64], ALUOPs[(head + 15) % 64], ALUSrc1s[(head + 15) % 64], ALUSrc2s[(head + 15) % 64], Jumps[(head + 15) % 64], Branchs[(head + 15) % 64], funct3s[(head + 15) % 64], immediates[(head + 15) % 64], operand1_datas[(head + 15) % 64], operand2_datas[(head + 15) % 64]};
    end
    readys[(head + 15) % 64] <= 0;
    operand1s[(head + 15) % 64] <= 0;
    operand2s[(head + 15) % 64] <= 0;
    operand1_datas[(head + 15) % 64] <= 0;
    operand2_datas[(head + 15) % 64] <= 0;
    valid_entries1[(head + 15) % 64] <= 0;
    valid_entries2[(head + 15) % 64] <= 0;
    RS_ALU_on[(head + 15) % 64] <= 1;
end
else if (valid_entries1[(head + 16) % 64] == 1 && valid_entries2[(head + 16) % 64] == 1) begin
    if (!MemReads[(head + 16) % 64]) begin
        result_out <= {inst_nums[(head + 16) % 64], 1'b1, PCs[(head + 16) % 64], Rds[(head + 16) % 64], MemToRegs[(head + 16) % 64], MemReads[(head + 16) % 64], MemWrites[(head + 16) % 64], ALUOPs[(head + 16) % 64], ALUSrc1s[(head + 16) % 64], ALUSrc2s[(head + 16) % 64], Jumps[(head + 16) % 64], Branchs[(head + 16) % 64], funct3s[(head + 16) % 64], immediates[(head + 16) % 64], operand1_datas[(head + 16) % 64], operand2_datas[(head + 16) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 16) % 64], 1'b0, PCs[(head + 16) % 64], Rds[(head + 16) % 64], MemToRegs[(head + 16) % 64], MemReads[(head + 16) % 64], MemWrites[(head + 16) % 64], ALUOPs[(head + 16) % 64], ALUSrc1s[(head + 16) % 64], ALUSrc2s[(head + 16) % 64], Jumps[(head + 16) % 64], Branchs[(head + 16) % 64], funct3s[(head + 16) % 64], immediates[(head + 16) % 64], operand1_datas[(head + 16) % 64], operand2_datas[(head + 16) % 64]};
    end
    readys[(head + 16) % 64] <= 0;
    operand1s[(head + 16) % 64] <= 0;
    operand2s[(head + 16) % 64] <= 0;
    operand1_datas[(head + 16) % 64] <= 0;
    operand2_datas[(head + 16) % 64] <= 0;
    valid_entries1[(head + 16) % 64] <= 0;
    valid_entries2[(head + 16) % 64] <= 0;
    RS_ALU_on[(head + 16) % 64] <= 1;
end
else if (valid_entries1[(head + 17) % 64] == 1 && valid_entries2[(head + 17) % 64] == 1) begin
    if (!MemReads[(head + 17) % 64]) begin
        result_out <= {inst_nums[(head + 17) % 64], 1'b1, PCs[(head + 17) % 64], Rds[(head + 17) % 64], MemToRegs[(head + 17) % 64], MemReads[(head + 17) % 64], MemWrites[(head + 17) % 64], ALUOPs[(head + 17) % 64], ALUSrc1s[(head + 17) % 64], ALUSrc2s[(head + 17) % 64], Jumps[(head + 17) % 64], Branchs[(head + 17) % 64], funct3s[(head + 17) % 64], immediates[(head + 17) % 64], operand1_datas[(head + 17) % 64], operand2_datas[(head + 17) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 17) % 64], 1'b0, PCs[(head + 17) % 64], Rds[(head + 17) % 64], MemToRegs[(head + 17) % 64], MemReads[(head + 17) % 64], MemWrites[(head + 17) % 64], ALUOPs[(head + 17) % 64], ALUSrc1s[(head + 17) % 64], ALUSrc2s[(head + 17) % 64], Jumps[(head + 17) % 64], Branchs[(head + 17) % 64], funct3s[(head + 17) % 64], immediates[(head + 17) % 64], operand1_datas[(head + 17) % 64], operand2_datas[(head + 17) % 64]};
    end
    readys[(head + 17) % 64] <= 0;
    operand1s[(head + 17) % 64] <= 0;
    operand2s[(head + 17) % 64] <= 0;
    operand1_datas[(head + 17) % 64] <= 0;
    operand2_datas[(head + 17) % 64] <= 0;
    valid_entries1[(head + 17) % 64] <= 0;
    valid_entries2[(head + 17) % 64] <= 0;
    RS_ALU_on[(head + 17) % 64] <= 1;
end
else if (valid_entries1[(head + 18) % 64] == 1 && valid_entries2[(head + 18) % 64] == 1) begin
    if (!MemReads[(head + 18) % 64]) begin
        result_out <= {inst_nums[(head + 18) % 64], 1'b1, PCs[(head + 18) % 64], Rds[(head + 18) % 64], MemToRegs[(head + 18) % 64], MemReads[(head + 18) % 64], MemWrites[(head + 18) % 64], ALUOPs[(head + 18) % 64], ALUSrc1s[(head + 18) % 64], ALUSrc2s[(head + 18) % 64], Jumps[(head + 18) % 64], Branchs[(head + 18) % 64], funct3s[(head + 18) % 64], immediates[(head + 18) % 64], operand1_datas[(head + 18) % 64], operand2_datas[(head + 18) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 18) % 64], 1'b0, PCs[(head + 18) % 64], Rds[(head + 18) % 64], MemToRegs[(head + 18) % 64], MemReads[(head + 18) % 64], MemWrites[(head + 18) % 64], ALUOPs[(head + 18) % 64], ALUSrc1s[(head + 18) % 64], ALUSrc2s[(head + 18) % 64], Jumps[(head + 18) % 64], Branchs[(head + 18) % 64], funct3s[(head + 18) % 64], immediates[(head + 18) % 64], operand1_datas[(head + 18) % 64], operand2_datas[(head + 18) % 64]};
    end
    readys[(head + 18) % 64] <= 0;
    operand1s[(head + 18) % 64] <= 0;
    operand2s[(head + 18) % 64] <= 0;
    operand1_datas[(head + 18) % 64] <= 0;
    operand2_datas[(head + 18) % 64] <= 0;
    valid_entries1[(head + 18) % 64] <= 0;
    valid_entries2[(head + 18) % 64] <= 0;
    RS_ALU_on[(head + 18) % 64] <= 1;
end
else if (valid_entries1[(head + 19) % 64] == 1 && valid_entries2[(head + 19) % 64] == 1) begin
    if (!MemReads[(head + 19) % 64]) begin
        result_out <= {inst_nums[(head + 19) % 64], 1'b1, PCs[(head + 19) % 64], Rds[(head + 19) % 64], MemToRegs[(head + 19) % 64], MemReads[(head + 19) % 64], MemWrites[(head + 19) % 64], ALUOPs[(head + 19) % 64], ALUSrc1s[(head + 19) % 64], ALUSrc2s[(head + 19) % 64], Jumps[(head + 19) % 64], Branchs[(head + 19) % 64], funct3s[(head + 19) % 64], immediates[(head + 19) % 64], operand1_datas[(head + 19) % 64], operand2_datas[(head + 19) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 19) % 64], 1'b0, PCs[(head + 19) % 64], Rds[(head + 19) % 64], MemToRegs[(head + 19) % 64], MemReads[(head + 19) % 64], MemWrites[(head + 19) % 64], ALUOPs[(head + 19) % 64], ALUSrc1s[(head + 19) % 64], ALUSrc2s[(head + 19) % 64], Jumps[(head + 19) % 64], Branchs[(head + 19) % 64], funct3s[(head + 19) % 64], immediates[(head + 19) % 64], operand1_datas[(head + 19) % 64], operand2_datas[(head + 19) % 64]};
    end
    readys[(head + 19) % 64] <= 0;
    operand1s[(head + 19) % 64] <= 0;
    operand2s[(head + 19) % 64] <= 0;
    operand1_datas[(head + 19) % 64] <= 0;
    operand2_datas[(head + 19) % 64] <= 0;
    valid_entries1[(head + 19) % 64] <= 0;
    valid_entries2[(head + 19) % 64] <= 0;
    RS_ALU_on[(head + 19) % 64] <= 1;
end
else if (valid_entries1[(head + 20) % 64] == 1 && valid_entries2[(head + 20) % 64] == 1) begin
    if (!MemReads[(head + 20) % 64]) begin
        result_out <= {inst_nums[(head + 20) % 64], 1'b1, PCs[(head + 20) % 64], Rds[(head + 20) % 64], MemToRegs[(head + 20) % 64], MemReads[(head + 20) % 64], MemWrites[(head + 20) % 64], ALUOPs[(head + 20) % 64], ALUSrc1s[(head + 20) % 64], ALUSrc2s[(head + 20) % 64], Jumps[(head + 20) % 64], Branchs[(head + 20) % 64], funct3s[(head + 20) % 64], immediates[(head + 20) % 64], operand1_datas[(head + 20) % 64], operand2_datas[(head + 20) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 20) % 64], 1'b0, PCs[(head + 20) % 64], Rds[(head + 20) % 64], MemToRegs[(head + 20) % 64], MemReads[(head + 20) % 64], MemWrites[(head + 20) % 64], ALUOPs[(head + 20) % 64], ALUSrc1s[(head + 20) % 64], ALUSrc2s[(head + 20) % 64], Jumps[(head + 20) % 64], Branchs[(head + 20) % 64], funct3s[(head + 20) % 64], immediates[(head + 20) % 64], operand1_datas[(head + 20) % 64], operand2_datas[(head + 20) % 64]};
    end
    readys[(head + 20) % 64] <= 0;
    operand1s[(head + 20) % 64] <= 0;
    operand2s[(head + 20) % 64] <= 0;
    operand1_datas[(head + 20) % 64] <= 0;
    operand2_datas[(head + 20) % 64] <= 0;
    valid_entries1[(head + 20) % 64] <= 0;
    valid_entries2[(head + 20) % 64] <= 0;
    RS_ALU_on[(head + 20) % 64] <= 1;
end
else if (valid_entries1[(head + 21) % 64] == 1 && valid_entries2[(head + 21) % 64] == 1) begin
    if (!MemReads[(head + 21) % 64]) begin
        result_out <= {inst_nums[(head + 21) % 64], 1'b1, PCs[(head + 21) % 64], Rds[(head + 21) % 64], MemToRegs[(head + 21) % 64], MemReads[(head + 21) % 64], MemWrites[(head + 21) % 64], ALUOPs[(head + 21) % 64], ALUSrc1s[(head + 21) % 64], ALUSrc2s[(head + 21) % 64], Jumps[(head + 21) % 64], Branchs[(head + 21) % 64], funct3s[(head + 21) % 64], immediates[(head + 21) % 64], operand1_datas[(head + 21) % 64], operand2_datas[(head + 21) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 21) % 64], 1'b0, PCs[(head + 21) % 64], Rds[(head + 21) % 64], MemToRegs[(head + 21) % 64], MemReads[(head + 21) % 64], MemWrites[(head + 21) % 64], ALUOPs[(head + 21) % 64], ALUSrc1s[(head + 21) % 64], ALUSrc2s[(head + 21) % 64], Jumps[(head + 21) % 64], Branchs[(head + 21) % 64], funct3s[(head + 21) % 64], immediates[(head + 21) % 64], operand1_datas[(head + 21) % 64], operand2_datas[(head + 21) % 64]};
    end
    readys[(head + 21) % 64] <= 0;
    operand1s[(head + 21) % 64] <= 0;
    operand2s[(head + 21) % 64] <= 0;
    operand1_datas[(head + 21) % 64] <= 0;
    operand2_datas[(head + 21) % 64] <= 0;
    valid_entries1[(head + 21) % 64] <= 0;
    valid_entries2[(head + 21) % 64] <= 0;
      RS_ALU_on[(head + 21) % 64] <= 1;
end
else if (valid_entries1[(head + 22) % 64] == 1 && valid_entries2[(head + 22) % 64] == 1) begin
    if (!MemReads[(head + 22) % 64]) begin
        result_out <= {inst_nums[(head + 22) % 64], 1'b1, PCs[(head + 22) % 64], Rds[(head + 22) % 64], MemToRegs[(head + 22) % 64], MemReads[(head + 22) % 64], MemWrites[(head + 22) % 64], ALUOPs[(head + 22) % 64], ALUSrc1s[(head + 22) % 64], ALUSrc2s[(head + 22) % 64], Jumps[(head + 22) % 64], Branchs[(head + 22) % 64], funct3s[(head + 22) % 64], immediates[(head + 22) % 64], operand1_datas[(head + 22) % 64], operand2_datas[(head + 22) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 22) % 64], 1'b0, PCs[(head + 22) % 64], Rds[(head + 22) % 64], MemToRegs[(head + 22) % 64], MemReads[(head + 22) % 64], MemWrites[(head + 22) % 64], ALUOPs[(head + 22) % 64], ALUSrc1s[(head + 22) % 64], ALUSrc2s[(head + 22) % 64], Jumps[(head + 22) % 64], Branchs[(head + 22) % 64], funct3s[(head + 22) % 64], immediates[(head + 22) % 64], operand1_datas[(head + 22) % 64], operand2_datas[(head + 22) % 64]};
    end
    readys[(head + 22) % 64] <= 0;
    operand1s[(head + 22) % 64] <= 0;
    operand2s[(head + 22) % 64] <= 0;
    operand1_datas[(head + 22) % 64] <= 0;
    operand2_datas[(head + 22) % 64] <= 0;
    valid_entries1[(head + 22) % 64] <= 0;
    valid_entries2[(head + 22) % 64] <= 0;
       RS_ALU_on[(head + 22) % 64] <= 1;
end
else if (valid_entries1[(head + 23) % 64] == 1 && valid_entries2[(head + 23) % 64] == 1) begin
    if (!MemReads[(head + 23) % 64]) begin
        result_out <= {inst_nums[(head + 23) % 64], 1'b1, PCs[(head + 23) % 64], Rds[(head + 23) % 64], MemToRegs[(head + 23) % 64], MemReads[(head + 23) % 64], MemWrites[(head + 23) % 64], ALUOPs[(head + 23) % 64], ALUSrc1s[(head + 23) % 64], ALUSrc2s[(head + 23) % 64], Jumps[(head + 23) % 64], Branchs[(head + 23) % 64], funct3s[(head + 23) % 64], immediates[(head + 23) % 64], operand1_datas[(head + 23) % 64], operand2_datas[(head + 23) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 23) % 64], 1'b0, PCs[(head + 23) % 64], Rds[(head + 23) % 64], MemToRegs[(head + 23) % 64], MemReads[(head + 23) % 64], MemWrites[(head + 23) % 64], ALUOPs[(head + 23) % 64], ALUSrc1s[(head + 23) % 64], ALUSrc2s[(head + 23) % 64], Jumps[(head + 23) % 64], Branchs[(head + 23) % 64], funct3s[(head + 23) % 64], immediates[(head + 23) % 64], operand1_datas[(head + 23) % 64], operand2_datas[(head + 23) % 64]};
    end
    readys[(head + 23) % 64] <= 0;
    operand1s[(head + 23) % 64] <= 0;
    operand2s[(head + 23) % 64] <= 0;
    operand1_datas[(head + 23) % 64] <= 0;
    operand2_datas[(head + 23) % 64] <= 0;
    valid_entries1[(head + 23) % 64] <= 0;
    valid_entries2[(head + 23) % 64] <= 0;
       RS_ALU_on[(head + 23) % 64] <= 1;
end
else if (valid_entries1[(head + 24) % 64] == 1 && valid_entries2[(head + 24) % 64] == 1) begin
    if (!MemReads[(head + 24) % 64]) begin
        result_out <= {inst_nums[(head + 24) % 64], 1'b1, PCs[(head + 24) % 64], Rds[(head + 24) % 64], MemToRegs[(head + 24) % 64], MemReads[(head + 24) % 64], MemWrites[(head + 24) % 64], ALUOPs[(head + 24) % 64], ALUSrc1s[(head + 24) % 64], ALUSrc2s[(head + 24) % 64], Jumps[(head + 24) % 64], Branchs[(head + 24) % 64], funct3s[(head + 24) % 64], immediates[(head + 24) % 64], operand1_datas[(head + 24) % 64], operand2_datas[(head + 24) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 24) % 64], 1'b0, PCs[(head + 24) % 64], Rds[(head + 24) % 64], MemToRegs[(head + 24) % 64], MemReads[(head + 24) % 64], MemWrites[(head + 24) % 64], ALUOPs[(head + 24) % 64], ALUSrc1s[(head + 24) % 64], ALUSrc2s[(head + 24) % 64], Jumps[(head + 24) % 64], Branchs[(head + 24) % 64], funct3s[(head + 24) % 64], immediates[(head + 24) % 64], operand1_datas[(head + 24) % 64], operand2_datas[(head + 24) % 64]};
    end
    readys[(head + 24) % 64] <= 0;
    operand1s[(head + 24) % 64] <= 0;
    operand2s[(head + 24) % 64] <= 0;
    operand1_datas[(head + 24) % 64] <= 0;
    operand2_datas[(head + 24) % 64] <= 0;
    valid_entries1[(head + 24) % 64] <= 0;
    valid_entries2[(head + 24) % 64] <= 0;
    RS_ALU_on[(head + 24) % 64] <= 1;
end
else if (valid_entries1[(head + 25) % 64] == 1 && valid_entries2[(head + 25) % 64] == 1) begin
    if (!MemReads[(head + 25) % 64]) begin
        result_out <= {inst_nums[(head + 25) % 64], 1'b1, PCs[(head + 25) % 64], Rds[(head + 25) % 64], MemToRegs[(head + 25) % 64], MemReads[(head + 25) % 64], MemWrites[(head + 25) % 64], ALUOPs[(head + 25) % 64], ALUSrc1s[(head + 25) % 64], ALUSrc2s[(head + 25) % 64], Jumps[(head + 25) % 64], Branchs[(head + 25) % 64], funct3s[(head + 25) % 64], immediates[(head + 25) % 64], operand1_datas[(head + 25) % 64], operand2_datas[(head + 25) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 25) % 64], 1'b0, PCs[(head + 25) % 64], Rds[(head + 25) % 64], MemToRegs[(head + 25) % 64], MemReads[(head + 25) % 64], MemWrites[(head + 25) % 64], ALUOPs[(head + 25) % 64], ALUSrc1s[(head + 25) % 64], ALUSrc2s[(head + 25) % 64], Jumps[(head + 25) % 64], Branchs[(head + 25) % 64], funct3s[(head + 25) % 64], immediates[(head + 25) % 64], operand1_datas[(head + 25) % 64], operand2_datas[(head + 25) % 64]};
    end
    readys[(head + 25) % 64] <= 0;
    operand1s[(head + 25) % 64] <= 0;
    operand2s[(head + 25) % 64] <= 0;
    operand1_datas[(head + 25) % 64] <= 0;
    operand2_datas[(head + 25) % 64] <= 0;
    valid_entries1[(head + 25) % 64] <= 0;
    valid_entries2[(head + 25) % 64] <= 0;
    RS_ALU_on[(head + 25) % 64] <= 1;
end
else if (valid_entries1[(head + 26) % 64] == 1 && valid_entries2[(head + 26) % 64] == 1) begin
    if (!MemReads[(head + 26) % 64]) begin
        result_out <= {inst_nums[(head + 26) % 64], 1'b1, PCs[(head + 26) % 64], Rds[(head + 26) % 64], MemToRegs[(head + 26) % 64], MemReads[(head + 26) % 64], MemWrites[(head + 26) % 64], ALUOPs[(head + 26) % 64], ALUSrc1s[(head + 26) % 64], ALUSrc2s[(head + 26) % 64], Jumps[(head + 26) % 64], Branchs[(head + 26) % 64], funct3s[(head + 26) % 64], immediates[(head + 26) % 64], operand1_datas[(head + 26) % 64], operand2_datas[(head + 26) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 26) % 64], 1'b0, PCs[(head + 26) % 64], Rds[(head + 26) % 64], MemToRegs[(head + 26) % 64], MemReads[(head + 26) % 64], MemWrites[(head + 26) % 64], ALUOPs[(head + 26) % 64], ALUSrc1s[(head + 26) % 64], ALUSrc2s[(head + 26) % 64], Jumps[(head + 26) % 64], Branchs[(head + 26) % 64], funct3s[(head + 26) % 64], immediates[(head + 26) % 64], operand1_datas[(head + 26) % 64], operand2_datas[(head + 26) % 64]};
    end
    readys[(head + 26) % 64] <= 0;
    operand1s[(head + 26) % 64] <= 0;
    operand2s[(head + 26) % 64] <= 0;
    operand1_datas[(head + 26) % 64] <= 0;
    operand2_datas[(head + 26) % 64] <= 0;
    valid_entries1[(head + 26) % 64] <= 0;
    valid_entries2[(head + 26) % 64] <= 0;
    RS_ALU_on[(head + 26) % 64] <= 1;
end
else if (valid_entries1[(head + 27) % 64] == 1 && valid_entries2[(head + 27) % 64] == 1) begin
    if (!MemReads[(head + 27) % 64]) begin
        result_out <= {inst_nums[(head + 27) % 64], 1'b1, PCs[(head + 27) % 64], Rds[(head + 27) % 64], MemToRegs[(head + 27) % 64], MemReads[(head + 27) % 64], MemWrites[(head + 27) % 64], ALUOPs[(head + 27) % 64], ALUSrc1s[(head + 27) % 64], ALUSrc2s[(head + 27) % 64], Jumps[(head + 27) % 64], Branchs[(head + 27) % 64], funct3s[(head + 27) % 64], immediates[(head + 27) % 64], operand1_datas[(head + 27) % 64], operand2_datas[(head + 27) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 27) % 64], 1'b0, PCs[(head + 27) % 64], Rds[(head + 27) % 64], MemToRegs[(head + 27) % 64], MemReads[(head + 27) % 64], MemWrites[(head + 27) % 64], ALUOPs[(head + 27) % 64], ALUSrc1s[(head + 27) % 64], ALUSrc2s[(head + 27) % 64], Jumps[(head + 27) % 64], Branchs[(head + 27) % 64], funct3s[(head + 27) % 64], immediates[(head + 27) % 64], operand1_datas[(head + 27) % 64], operand2_datas[(head + 27) % 64]};
    end
    readys[(head + 27) % 64] <= 0;
    operand1s[(head + 27) % 64] <= 0;
    operand2s[(head + 27) % 64] <= 0;
    operand1_datas[(head + 27) % 64] <= 0;
    operand2_datas[(head + 27) % 64] <= 0;
    valid_entries1[(head + 27) % 64] <= 0;
    valid_entries2[(head + 27) % 64] <= 0;
    RS_ALU_on[(head + 27) % 64] <= 1;
end
else if (valid_entries1[(head + 28) % 64] == 1 && valid_entries2[(head + 28) % 64] == 1) begin
    if (!MemReads[(head + 28) % 64]) begin
        result_out <= {inst_nums[(head + 28) % 64], 1'b1, PCs[(head + 28) % 64], Rds[(head + 28) % 64], MemToRegs[(head + 28) % 64], MemReads[(head + 28) % 64], MemWrites[(head + 28) % 64], ALUOPs[(head + 28) % 64], ALUSrc1s[(head + 28) % 64], ALUSrc2s[(head + 28) % 64], Jumps[(head + 28) % 64], Branchs[(head + 28) % 64], funct3s[(head + 28) % 64], immediates[(head + 28) % 64], operand1_datas[(head + 28) % 64], operand2_datas[(head + 28) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 28) % 64], 1'b0, PCs[(head + 28) % 64], Rds[(head + 28) % 64], MemToRegs[(head + 28) % 64], MemReads[(head + 28) % 64], MemWrites[(head + 28) % 64], ALUOPs[(head + 28) % 64], ALUSrc1s[(head + 28) % 64], ALUSrc2s[(head + 28) % 64], Jumps[(head + 28) % 64], Branchs[(head + 28) % 64], funct3s[(head + 28) % 64], immediates[(head + 28) % 64], operand1_datas[(head + 28) % 64], operand2_datas[(head + 28) % 64]};
    end
    readys[(head + 28) % 64] <= 0;
    operand1s[(head + 28) % 64] <= 0;
    operand2s[(head + 28) % 64] <= 0;
    operand1_datas[(head + 28) % 64] <= 0;
    operand2_datas[(head + 28) % 64] <= 0;
    valid_entries1[(head + 28) % 64] <= 0;
    valid_entries2[(head + 28) % 64] <= 0;
    RS_ALU_on[(head + 28) % 64] <= 1;
end
else if (valid_entries1[(head + 29) % 64] == 1 && valid_entries2[(head + 29) % 64] == 1) begin
    if (!MemReads[(head + 29) % 64]) begin
        result_out <= {inst_nums[(head + 29) % 64], 1'b1, PCs[(head + 29) % 64], Rds[(head + 29) % 64], MemToRegs[(head + 29) % 64], MemReads[(head + 29) % 64], MemWrites[(head + 29) % 64], ALUOPs[(head + 29) % 64], ALUSrc1s[(head + 29) % 64], ALUSrc2s[(head + 29) % 64], Jumps[(head + 29) % 64], Branchs[(head + 29) % 64], funct3s[(head + 29) % 64], immediates[(head + 29) % 64], operand1_datas[(head + 29) % 64], operand2_datas[(head + 29) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 29) % 64], 1'b0, PCs[(head + 29) % 64], Rds[(head + 29) % 64], MemToRegs[(head + 29) % 64], MemReads[(head + 29) % 64], MemWrites[(head + 29) % 64], ALUOPs[(head + 29) % 64], ALUSrc1s[(head + 29) % 64], ALUSrc2s[(head + 29) % 64], Jumps[(head + 29) % 64], Branchs[(head + 29) % 64], funct3s[(head + 29) % 64], immediates[(head + 29) % 64], operand1_datas[(head + 29) % 64], operand2_datas[(head + 29) % 64]};
    end
    readys[(head + 29) % 64] <= 0;
    operand1s[(head + 29) % 64] <= 0;
    operand2s[(head + 29) % 64] <= 0;
    operand1_datas[(head + 29) % 64] <= 0;
    operand2_datas[(head + 29) % 64] <= 0;
    valid_entries1[(head + 29) % 64] <= 0;
    valid_entries2[(head + 29) % 64] <= 0;
    RS_ALU_on[(head + 29) % 64] <= 1;
end
else if (valid_entries1[(head + 30) % 64] == 1 && valid_entries2[(head + 30) % 64] == 1) begin
    if (!MemReads[(head + 30) % 64]) begin
        result_out <= {inst_nums[(head + 30) % 64], 1'b1, PCs[(head + 30) % 64], Rds[(head + 30) % 64], MemToRegs[(head + 30) % 64], MemReads[(head + 30) % 64], MemWrites[(head + 30) % 64], ALUOPs[(head + 30) % 64], ALUSrc1s[(head + 30) % 64], ALUSrc2s[(head + 30) % 64], Jumps[(head + 30) % 64], Branchs[(head + 30) % 64], funct3s[(head + 30) % 64], immediates[(head + 30) % 64], operand1_datas[(head + 30) % 64], operand2_datas[(head + 30) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 30) % 64], 1'b0, PCs[(head + 30) % 64], Rds[(head + 30) % 64], MemToRegs[(head + 30) % 64], MemReads[(head + 30) % 64], MemWrites[(head + 30) % 64], ALUOPs[(head + 30) % 64], ALUSrc1s[(head + 30) % 64], ALUSrc2s[(head + 30) % 64], Jumps[(head + 30) % 64], Branchs[(head + 30) % 64], funct3s[(head + 30) % 64], immediates[(head + 30) % 64], operand1_datas[(head + 30) % 64], operand2_datas[(head + 30) % 64]};
    end
    readys[(head + 30) % 64] <= 0;
    operand1s[(head + 30) % 64] <= 0;
    operand2s[(head + 30) % 64] <= 0;
    operand1_datas[(head + 30) % 64] <= 0;
    operand2_datas[(head + 30) % 64] <= 0;
    valid_entries1[(head + 30) % 64] <= 0;
    valid_entries2[(head + 30) % 64] <= 0;
    RS_ALU_on[(head + 30) % 64] <= 1;
end
else if (valid_entries1[(head + 31) % 64] == 1 && valid_entries2[(head + 31) % 64] == 1) begin
    if (!MemReads[(head + 31) % 64]) begin
        result_out <= {inst_nums[(head + 31) % 64], 1'b1, PCs[(head + 31) % 64], Rds[(head + 31) % 64], MemToRegs[(head + 31) % 64], MemReads[(head + 31) % 64], MemWrites[(head + 31) % 64], ALUOPs[(head + 31) % 64], ALUSrc1s[(head + 31) % 64], ALUSrc2s[(head + 31) % 64], Jumps[(head + 31) % 64], Branchs[(head + 31) % 64], funct3s[(head + 31) % 64], immediates[(head + 31) % 64], operand1_datas[(head + 31) % 64], operand2_datas[(head + 31) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 31) % 64], 1'b0, PCs[(head + 31) % 64], Rds[(head + 31) % 64], MemToRegs[(head + 31) % 64], MemReads[(head + 31) % 64], MemWrites[(head + 31) % 64], ALUOPs[(head + 31) % 64], ALUSrc1s[(head + 31) % 64], ALUSrc2s[(head + 31) % 64], Jumps[(head + 31) % 64], Branchs[(head + 31) % 64], funct3s[(head + 31) % 64], immediates[(head + 31) % 64], operand1_datas[(head + 31) % 64], operand2_datas[(head + 31) % 64]};
    end
    readys[(head + 31) % 64] <= 0;
    operand1s[(head + 31) % 64] <= 0;
    operand2s[(head + 31) % 64] <= 0;
    operand1_datas[(head + 31) % 64] <= 0;
    operand2_datas[(head + 31) % 64] <= 0;
    valid_entries1[(head + 31) % 64] <= 0;
    valid_entries2[(head + 31) % 64] <= 0;
    RS_ALU_on[(head + 31) % 64] <= 1;
end
else if (valid_entries1[(head + 32) % 64] == 1 && valid_entries2[(head + 32) % 64] == 1) begin
    if (!MemReads[(head + 32) % 64]) begin
        result_out <= {inst_nums[(head + 32) % 64], 1'b1, PCs[(head + 32) % 64], Rds[(head + 32) % 64], MemToRegs[(head + 32) % 64], MemReads[(head + 32) % 64], MemWrites[(head + 32) % 64], ALUOPs[(head + 32) % 64], ALUSrc1s[(head + 32) % 64], ALUSrc2s[(head + 32) % 64], Jumps[(head + 32) % 64], Branchs[(head + 32) % 64], funct3s[(head + 32) % 64], immediates[(head + 32) % 64], operand1_datas[(head + 32) % 64], operand2_datas[(head + 32) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 32) % 64], 1'b0, PCs[(head + 32) % 64], Rds[(head + 32) % 64], MemToRegs[(head + 32) % 64], MemReads[(head + 32) % 64], MemWrites[(head + 32) % 64], ALUOPs[(head + 32) % 64], ALUSrc1s[(head + 32) % 64], ALUSrc2s[(head + 32) % 64], Jumps[(head + 32) % 64], Branchs[(head + 32) % 64], funct3s[(head + 32) % 64], immediates[(head + 32) % 64], operand1_datas[(head + 32) % 64], operand2_datas[(head + 32) % 64]};
    end
    readys[(head + 32) % 64] <= 0;
    operand1s[(head + 32) % 64] <= 0;
    operand2s[(head + 32) % 64] <= 0;
    operand1_datas[(head + 32) % 64] <= 0;
    operand2_datas[(head + 32) % 64] <= 0;
    valid_entries1[(head + 32) % 64] <= 0;
    valid_entries2[(head + 32) % 64] <= 0;
    RS_ALU_on[(head + 32) % 64] <= 1;
end
else if (valid_entries1[(head + 33) % 64] == 1 && valid_entries2[(head + 33) % 64] == 1) begin
    if (!MemReads[(head + 33) % 64]) begin
        result_out <= {inst_nums[(head + 33) % 64], 1'b1, PCs[(head + 33) % 64], Rds[(head + 33) % 64], MemToRegs[(head + 33) % 64], MemReads[(head + 33) % 64], MemWrites[(head + 33) % 64], ALUOPs[(head + 33) % 64], ALUSrc1s[(head + 33) % 64], ALUSrc2s[(head + 33) % 64], Jumps[(head + 33) % 64], Branchs[(head + 33) % 64], funct3s[(head + 33) % 64], immediates[(head + 33) % 64], operand1_datas[(head + 33) % 64], operand2_datas[(head + 33) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 33) % 64], 1'b0, PCs[(head + 33) % 64], Rds[(head + 33) % 64], MemToRegs[(head + 33) % 64], MemReads[(head + 33) % 64], MemWrites[(head + 33) % 64], ALUOPs[(head + 33) % 64], ALUSrc1s[(head + 33) % 64], ALUSrc2s[(head + 33) % 64], Jumps[(head + 33) % 64], Branchs[(head + 33) % 64], funct3s[(head + 33) % 64], immediates[(head + 33) % 64], operand1_datas[(head + 33) % 64], operand2_datas[(head + 33) % 64]};
    end
    readys[(head + 33) % 64] <= 0;
    operand1s[(head + 33) % 64] <= 0;
    operand2s[(head + 33) % 64] <= 0;
    operand1_datas[(head + 33) % 64] <= 0;
    operand2_datas[(head + 33) % 64] <= 0;
    valid_entries1[(head + 33) % 64] <= 0;
    valid_entries2[(head + 33) % 64] <= 0;
    RS_ALU_on[(head + 33) % 64] <= 1;
end
else if (valid_entries1[(head + 34) % 64] == 1 && valid_entries2[(head + 34) % 64] == 1) begin
    if (!MemReads[(head + 34) % 64]) begin
        result_out <= {inst_nums[(head + 34) % 64], 1'b1, PCs[(head + 34) % 64], Rds[(head + 34) % 64], MemToRegs[(head + 34) % 64], MemReads[(head + 34) % 64], MemWrites[(head + 34) % 64], ALUOPs[(head + 34) % 64], ALUSrc1s[(head + 34) % 64], ALUSrc2s[(head + 34) % 64], Jumps[(head + 34) % 64], Branchs[(head + 34) % 64], funct3s[(head + 34) % 64], immediates[(head + 34) % 64], operand1_datas[(head + 34) % 64], operand2_datas[(head + 34) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 34) % 64], 1'b0, PCs[(head + 34) % 64], Rds[(head + 34) % 64], MemToRegs[(head + 34) % 64], MemReads[(head + 34) % 64], MemWrites[(head + 34) % 64], ALUOPs[(head + 34) % 64], ALUSrc1s[(head + 34) % 64], ALUSrc2s[(head + 34) % 64], Jumps[(head + 34) % 64], Branchs[(head + 34) % 64], funct3s[(head + 34) % 64], immediates[(head + 34) % 64], operand1_datas[(head + 34) % 64], operand2_datas[(head + 34) % 64]};
    end
    readys[(head + 34) % 64] <= 0;
    operand1s[(head + 34) % 64] <= 0;
    operand2s[(head + 34) % 64] <= 0;
    operand1_datas[(head + 34) % 64] <= 0;
    operand2_datas[(head + 34) % 64] <= 0;
    valid_entries1[(head + 34) % 64] <= 0;
    valid_entries2[(head + 34) % 64] <= 0;
    RS_ALU_on[(head + 34) % 64] <= 1;
end
else if (valid_entries1[(head + 35) % 64] == 1 && valid_entries2[(head + 35) % 64] == 1) begin
    if (!MemReads[(head + 35) % 64]) begin
        result_out <= {inst_nums[(head + 35) % 64], 1'b1, PCs[(head + 35) % 64], Rds[(head + 35) % 64], MemToRegs[(head + 35) % 64], MemReads[(head + 35) % 64], MemWrites[(head + 35) % 64], ALUOPs[(head + 35) % 64], ALUSrc1s[(head + 35) % 64], ALUSrc2s[(head + 35) % 64], Jumps[(head + 35) % 64], Branchs[(head + 35) % 64], funct3s[(head + 35) % 64], immediates[(head + 35) % 64], operand1_datas[(head + 35) % 64], operand2_datas[(head + 35) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 35) % 64], 1'b0, PCs[(head + 35) % 64], Rds[(head + 35) % 64], MemToRegs[(head + 35) % 64], MemReads[(head + 35) % 64], MemWrites[(head + 35) % 64], ALUOPs[(head + 35) % 64], ALUSrc1s[(head + 35) % 64], ALUSrc2s[(head + 35) % 64], Jumps[(head + 35) % 64], Branchs[(head + 35) % 64], funct3s[(head + 35) % 64], immediates[(head + 35) % 64], operand1_datas[(head + 35) % 64], operand2_datas[(head + 35) % 64]};
    end
    readys[(head + 35) % 64] <= 0;
    operand1s[(head + 35) % 64] <= 0;
    operand2s[(head + 35) % 64] <= 0;
    operand1_datas[(head + 35) % 64] <= 0;
    operand2_datas[(head + 35) % 64] <= 0;
    valid_entries1[(head + 35) % 64] <= 0;
    valid_entries2[(head + 35) % 64] <= 0;
    RS_ALU_on[(head + 35) % 64] <= 1;
end
else if (valid_entries1[(head + 36) % 64] == 1 && valid_entries2[(head + 36) % 64] == 1) begin
    if (!MemReads[(head + 36) % 64]) begin
        result_out <= {inst_nums[(head + 36) % 64], 1'b1, PCs[(head + 36) % 64], Rds[(head + 36) % 64], MemToRegs[(head + 36) % 64], MemReads[(head + 36) % 64], MemWrites[(head + 36) % 64], ALUOPs[(head + 36) % 64], ALUSrc1s[(head + 36) % 64], ALUSrc2s[(head + 36) % 64], Jumps[(head + 36) % 64], Branchs[(head + 36) % 64], funct3s[(head + 36) % 64], immediates[(head + 36) % 64], operand1_datas[(head + 36) % 64], operand2_datas[(head + 36) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 36) % 64], 1'b0, PCs[(head + 36) % 64], Rds[(head + 36) % 64], MemToRegs[(head + 36) % 64], MemReads[(head + 36) % 64], MemWrites[(head + 36) % 64], ALUOPs[(head + 36) % 64], ALUSrc1s[(head + 36) % 64], ALUSrc2s[(head + 36) % 64], Jumps[(head + 36) % 64], Branchs[(head + 36) % 64], funct3s[(head + 36) % 64], immediates[(head + 36) % 64], operand1_datas[(head + 36) % 64], operand2_datas[(head + 36) % 64]};
    end
    readys[(head + 36) % 64] <= 0;
    operand1s[(head + 36) % 64] <= 0;
    operand2s[(head + 36) % 64] <= 0;
    operand1_datas[(head + 36) % 64] <= 0;
    operand2_datas[(head + 36) % 64] <= 0;
    valid_entries1[(head + 36) % 64] <= 0;
    valid_entries2[(head + 36) % 64] <= 0;
    RS_ALU_on[(head + 36) % 64] <= 1;
end
else if (valid_entries1[(head + 37) % 64] == 1 && valid_entries2[(head + 37) % 64] == 1) begin
    if (!MemReads[(head + 37) % 64]) begin
        result_out <= {inst_nums[(head + 37) % 64], 1'b1, PCs[(head + 37) % 64], Rds[(head + 37) % 64], MemToRegs[(head + 37) % 64], MemReads[(head + 37) % 64], MemWrites[(head + 37) % 64], ALUOPs[(head + 37) % 64], ALUSrc1s[(head + 37) % 64], ALUSrc2s[(head + 37) % 64], Jumps[(head + 37) % 64], Branchs[(head + 37) % 64], funct3s[(head + 37) % 64], immediates[(head + 37) % 64], operand1_datas[(head + 37) % 64], operand2_datas[(head + 37) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 37) % 64], 1'b0, PCs[(head + 37) % 64], Rds[(head + 37) % 64], MemToRegs[(head + 37) % 64], MemReads[(head + 37) % 64], MemWrites[(head + 37) % 64], ALUOPs[(head + 37) % 64], ALUSrc1s[(head + 37) % 64], ALUSrc2s[(head + 37) % 64], Jumps[(head + 37) % 64], Branchs[(head + 37) % 64], funct3s[(head + 37) % 64], immediates[(head + 37) % 64], operand1_datas[(head + 37) % 64], operand2_datas[(head + 37) % 64]};
    end
    readys[(head + 37) % 64] <= 0;
    operand1s[(head + 37) % 64] <= 0;
    operand2s[(head + 37) % 64] <= 0;
    operand1_datas[(head + 37) % 64] <= 0;
    operand2_datas[(head + 37) % 64] <= 0;
    valid_entries1[(head + 37) % 64] <= 0;
    valid_entries2[(head + 37) % 64] <= 0;
    RS_ALU_on[(head + 37) % 64] <= 1;
end
else if (valid_entries1[(head + 38) % 64] == 1 && valid_entries2[(head + 38) % 64] == 1) begin
    if (!MemReads[(head + 38) % 64]) begin
        result_out <= {inst_nums[(head + 38) % 64], 1'b1, PCs[(head + 38) % 64], Rds[(head + 38) % 64], MemToRegs[(head + 38) % 64], MemReads[(head + 38) % 64], MemWrites[(head + 38) % 64], ALUOPs[(head + 38) % 64], ALUSrc1s[(head + 38) % 64], ALUSrc2s[(head + 38) % 64], Jumps[(head + 38) % 64], Branchs[(head + 38) % 64], funct3s[(head + 38) % 64], immediates[(head + 38) % 64], operand1_datas[(head + 38) % 64], operand2_datas[(head + 38) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 38) % 64], 1'b0, PCs[(head + 38) % 64], Rds[(head + 38) % 64], MemToRegs[(head + 38) % 64], MemReads[(head + 38) % 64], MemWrites[(head + 38) % 64], ALUOPs[(head + 38) % 64], ALUSrc1s[(head + 38) % 64], ALUSrc2s[(head + 38) % 64], Jumps[(head + 38) % 64], Branchs[(head + 38) % 64], funct3s[(head + 38) % 64], immediates[(head + 38) % 64], operand1_datas[(head + 38) % 64], operand2_datas[(head + 38) % 64]};
    end
    readys[(head + 38) % 64] <= 0;
    operand1s[(head + 38) % 64] <= 0;
    operand2s[(head + 38) % 64] <= 0;
    operand1_datas[(head + 38) % 64] <= 0;
    operand2_datas[(head + 38) % 64] <= 0;
    valid_entries1[(head + 38) % 64] <= 0;
    valid_entries2[(head + 38) % 64] <= 0;
    RS_ALU_on[(head + 38) % 64] <= 1;
end
else if (valid_entries1[(head + 39) % 64] == 1 && valid_entries2[(head + 39) % 64] == 1) begin
    if (!MemReads[(head + 39) % 64]) begin
        result_out <= {inst_nums[(head + 39) % 64], 1'b1, PCs[(head + 39) % 64], Rds[(head + 39) % 64], MemToRegs[(head + 39) % 64], MemReads[(head + 39) % 64], MemWrites[(head + 39) % 64], ALUOPs[(head + 39) % 64], ALUSrc1s[(head + 39) % 64], ALUSrc2s[(head + 39) % 64], Jumps[(head + 39) % 64], Branchs[(head + 39) % 64], funct3s[(head + 39) % 64], immediates[(head + 39) % 64], operand1_datas[(head + 39) % 64], operand2_datas[(head + 39) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 39) % 64], 1'b0, PCs[(head + 39) % 64], Rds[(head + 39) % 64], MemToRegs[(head + 39) % 64], MemReads[(head + 39) % 64], MemWrites[(head + 39) % 64], ALUOPs[(head + 39) % 64], ALUSrc1s[(head + 39) % 64], ALUSrc2s[(head + 39) % 64], Jumps[(head + 39) % 64], Branchs[(head + 39) % 64], funct3s[(head + 39) % 64], immediates[(head + 39) % 64], operand1_datas[(head + 39) % 64], operand2_datas[(head + 39) % 64]};
    end
    readys[(head + 39) % 64] <= 0;
    operand1s[(head + 39) % 64] <= 0;
    operand2s[(head + 39) % 64] <= 0;
    operand1_datas[(head + 39) % 64] <= 0;
    operand2_datas[(head + 39) % 64] <= 0;
    valid_entries1[(head + 39) % 64] <= 0;
    valid_entries2[(head + 39) % 64] <= 0;
    RS_ALU_on[(head + 39) % 64] <= 1;
end
else if (valid_entries1[(head + 40) % 64] == 1 && valid_entries2[(head + 40) % 64] == 1) begin
    if (!MemReads[(head + 40) % 64]) begin
        result_out <= {inst_nums[(head + 40) % 64], 1'b1, PCs[(head + 40) % 64], Rds[(head + 40) % 64], MemToRegs[(head + 40) % 64], MemReads[(head + 40) % 64], MemWrites[(head + 40) % 64], ALUOPs[(head + 40) % 64], ALUSrc1s[(head + 40) % 64], ALUSrc2s[(head + 40) % 64], Jumps[(head + 40) % 64], Branchs[(head + 40) % 64], funct3s[(head + 40) % 64], immediates[(head + 40) % 64], operand1_datas[(head + 40) % 64], operand2_datas[(head + 40) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 40) % 64], 1'b0, PCs[(head + 40) % 64], Rds[(head + 40) % 64], MemToRegs[(head + 40) % 64], MemReads[(head + 40) % 64], MemWrites[(head + 40) % 64], ALUOPs[(head + 40) % 64], ALUSrc1s[(head + 40) % 64], ALUSrc2s[(head + 40) % 64], Jumps[(head + 40) % 64], Branchs[(head + 40) % 64], funct3s[(head + 40) % 64], immediates[(head + 40) % 64], operand1_datas[(head + 40) % 64], operand2_datas[(head + 40) % 64]};
    end
    readys[(head + 40) % 64] <= 0;
    operand1s[(head + 40) % 64] <= 0;
    operand2s[(head + 40) % 64] <= 0;
    operand1_datas[(head + 40) % 64] <= 0;
    operand2_datas[(head + 40) % 64] <= 0;
    valid_entries1[(head + 40) % 64] <= 0;
    valid_entries2[(head + 40) % 64] <= 0;
    RS_ALU_on[(head + 40) % 64] <= 1;
end
else if (valid_entries1[(head + 41) % 64] == 1 && valid_entries2[(head + 41) % 64] == 1) begin
    if (!MemReads[(head + 41) % 64]) begin
        result_out <= {inst_nums[(head + 41) % 64], 1'b1, PCs[(head + 41) % 64], Rds[(head + 41) % 64], MemToRegs[(head + 41) % 64], MemReads[(head + 41) % 64], MemWrites[(head + 41) % 64], ALUOPs[(head + 41) % 64], ALUSrc1s[(head + 41) % 64], ALUSrc2s[(head + 41) % 64], Jumps[(head + 41) % 64], Branchs[(head + 41) % 64], funct3s[(head + 41) % 64], immediates[(head + 41) % 64], operand1_datas[(head + 41) % 64], operand2_datas[(head + 41) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 41) % 64], 1'b0, PCs[(head + 41) % 64], Rds[(head + 41) % 64], MemToRegs[(head + 41) % 64], MemReads[(head + 41) % 64], MemWrites[(head + 41) % 64], ALUOPs[(head + 41) % 64], ALUSrc1s[(head + 41) % 64], ALUSrc2s[(head + 41) % 64], Jumps[(head + 41) % 64], Branchs[(head + 41) % 64], funct3s[(head + 41) % 64], immediates[(head + 41) % 64], operand1_datas[(head + 41) % 64], operand2_datas[(head + 41) % 64]};
    end
    readys[(head + 41) % 64] <= 0;
    operand1s[(head + 41) % 64] <= 0;
    operand2s[(head + 41) % 64] <= 0;
    operand1_datas[(head + 41) % 64] <= 0;
    operand2_datas[(head + 41) % 64] <= 0;
    valid_entries1[(head + 41) % 64] <= 0;
    valid_entries2[(head + 41) % 64] <= 0;
    RS_ALU_on[(head + 41) % 64] <= 1;
end
else if (valid_entries1[(head + 42) % 64] == 1 && valid_entries2[(head + 42) % 64] == 1) begin
    if (!MemReads[(head + 42) % 64]) begin
        result_out <= {inst_nums[(head + 42) % 64], 1'b1, PCs[(head + 42) % 64], Rds[(head + 42) % 64], MemToRegs[(head + 42) % 64], MemReads[(head + 42) % 64], MemWrites[(head + 42) % 64], ALUOPs[(head + 42) % 64], ALUSrc1s[(head + 42) % 64], ALUSrc2s[(head + 42) % 64], Jumps[(head + 42) % 64], Branchs[(head + 42) % 64], funct3s[(head + 42) % 64], immediates[(head + 42) % 64], operand1_datas[(head + 42) % 64], operand2_datas[(head + 42) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 42) % 64], 1'b0, PCs[(head + 42) % 64], Rds[(head + 42) % 64], MemToRegs[(head + 42) % 64], MemReads[(head + 42) % 64], MemWrites[(head + 42) % 64], ALUOPs[(head + 42) % 64], ALUSrc1s[(head + 42) % 64], ALUSrc2s[(head + 42) % 64], Jumps[(head + 42) % 64], Branchs[(head + 42) % 64], funct3s[(head + 42) % 64], immediates[(head + 42) % 64], operand1_datas[(head + 42) % 64], operand2_datas[(head + 42) % 64]};
    end
    readys[(head + 42) % 64] <= 0;
    operand1s[(head + 42) % 64] <= 0;
    operand2s[(head + 42) % 64] <= 0;
    operand1_datas[(head + 42) % 64] <= 0;
    operand2_datas[(head + 42) % 64] <= 0;
    valid_entries1[(head + 42) % 64] <= 0;
    valid_entries2[(head + 42) % 64] <= 0;
    RS_ALU_on[(head + 42) % 64] <= 1;
end
else if (valid_entries1[(head + 43) % 64] == 1 && valid_entries2[(head + 43) % 64] == 1) begin
    if (!MemReads[(head + 43) % 64]) begin
        result_out <= {inst_nums[(head + 43) % 64], 1'b1, PCs[(head + 43) % 64], Rds[(head + 43) % 64], MemToRegs[(head + 43) % 64], MemReads[(head + 43) % 64], MemWrites[(head + 43) % 64], ALUOPs[(head + 43) % 64], ALUSrc1s[(head + 43) % 64], ALUSrc2s[(head + 43) % 64], Jumps[(head + 43) % 64], Branchs[(head + 43) % 64], funct3s[(head + 43) % 64], immediates[(head + 43) % 64], operand1_datas[(head + 43) % 64], operand2_datas[(head + 43) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 43) % 64], 1'b0, PCs[(head + 43) % 64], Rds[(head + 43) % 64], MemToRegs[(head + 43) % 64], MemReads[(head + 43) % 64], MemWrites[(head + 43) % 64], ALUOPs[(head + 43) % 64], ALUSrc1s[(head + 43) % 64], ALUSrc2s[(head + 43) % 64], Jumps[(head + 43) % 64], Branchs[(head + 43) % 64], funct3s[(head + 43) % 64], immediates[(head + 43) % 64], operand1_datas[(head + 43) % 64], operand2_datas[(head + 43) % 64]};
    end
    readys[(head + 43) % 64] <= 0;
    operand1s[(head + 43) % 64] <= 0;
    operand2s[(head + 43) % 64] <= 0;
    operand1_datas[(head + 43) % 64] <= 0;
    operand2_datas[(head + 43) % 64] <= 0;
    valid_entries1[(head + 43) % 64] <= 0;
    valid_entries2[(head + 43) % 64] <= 0;
     RS_ALU_on[(head + 43) % 64] <= 1;
end
else if (valid_entries1[(head + 44) % 64] == 1 && valid_entries2[(head + 44) % 64] == 1) begin
    if (!MemReads[(head + 44) % 64]) begin
        result_out <= {inst_nums[(head + 44) % 64], 1'b1, PCs[(head + 44) % 64], Rds[(head + 44) % 64], MemToRegs[(head + 44) % 64], MemReads[(head + 44) % 64], MemWrites[(head + 44) % 64], ALUOPs[(head + 44) % 64], ALUSrc1s[(head + 44) % 64], ALUSrc2s[(head + 44) % 64], Jumps[(head + 44) % 64], Branchs[(head + 44) % 64], funct3s[(head + 44) % 64], immediates[(head + 44) % 64], operand1_datas[(head + 44) % 64], operand2_datas[(head + 44) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 44) % 64], 1'b0, PCs[(head + 44) % 64], Rds[(head + 44) % 64], MemToRegs[(head + 44) % 64], MemReads[(head + 44) % 64], MemWrites[(head + 44) % 64], ALUOPs[(head + 44) % 64], ALUSrc1s[(head + 44) % 64], ALUSrc2s[(head + 44) % 64], Jumps[(head + 44) % 64], Branchs[(head + 44) % 64], funct3s[(head + 44) % 64], immediates[(head + 44) % 64], operand1_datas[(head + 44) % 64], operand2_datas[(head + 44) % 64]};
    end
    readys[(head + 44) % 64] <= 0;
    operand1s[(head + 44) % 64] <= 0;
    operand2s[(head + 44) % 64] <= 0;
    operand1_datas[(head + 44) % 64] <= 0;
    operand2_datas[(head + 44) % 64] <= 0;
    valid_entries1[(head + 44) % 64] <= 0;
    valid_entries2[(head + 44) % 64] <= 0;
         RS_ALU_on[(head + 44) % 64] <= 1;
end
else if (valid_entries1[(head + 45) % 64] == 1 && valid_entries2[(head + 45) % 64] == 1) begin
    if (!MemReads[(head + 45) % 64]) begin
        result_out <= {inst_nums[(head + 45) % 64], 1'b1, PCs[(head + 45) % 64], Rds[(head + 45) % 64], MemToRegs[(head + 45) % 64], MemReads[(head + 45) % 64], MemWrites[(head + 45) % 64], ALUOPs[(head + 45) % 64], ALUSrc1s[(head + 45) % 64], ALUSrc2s[(head + 45) % 64], Jumps[(head + 45) % 64], Branchs[(head + 45) % 64], funct3s[(head + 45) % 64], immediates[(head + 45) % 64], operand1_datas[(head + 45) % 64], operand2_datas[(head + 45) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 45) % 64], 1'b0, PCs[(head + 45) % 64], Rds[(head + 45) % 64], MemToRegs[(head + 45) % 64], MemReads[(head + 45) % 64], MemWrites[(head + 45) % 64], ALUOPs[(head + 45) % 64], ALUSrc1s[(head + 45) % 64], ALUSrc2s[(head + 45) % 64], Jumps[(head + 45) % 64], Branchs[(head + 45) % 64], funct3s[(head + 45) % 64], immediates[(head + 45) % 64], operand1_datas[(head + 45) % 64], operand2_datas[(head + 45) % 64]};
    end
    readys[(head + 45) % 64] <= 0;
    operand1s[(head + 45) % 64] <= 0;
    operand2s[(head + 45) % 64] <= 0;
    operand1_datas[(head + 45) % 64] <= 0;
    operand2_datas[(head + 45) % 64] <= 0;
    valid_entries1[(head + 45) % 64] <= 0;
    valid_entries2[(head + 45) % 64] <= 0;
         RS_ALU_on[(head + 45) % 64] <= 1;
end
else if (valid_entries1[(head + 46) % 64] == 1 && valid_entries2[(head + 46) % 64] == 1) begin
    if (!MemReads[(head + 46) % 64]) begin
        result_out <= {inst_nums[(head + 46) % 64], 1'b1, PCs[(head + 46) % 64], Rds[(head + 46) % 64], MemToRegs[(head + 46) % 64], MemReads[(head + 46) % 64], MemWrites[(head + 46) % 64], ALUOPs[(head + 46) % 64], ALUSrc1s[(head + 46) % 64], ALUSrc2s[(head + 46) % 64], Jumps[(head + 46) % 64], Branchs[(head + 46) % 64], funct3s[(head + 46) % 64], immediates[(head + 46) % 64], operand1_datas[(head + 46) % 64], operand2_datas[(head + 46) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 46) % 64], 1'b0, PCs[(head + 46) % 64], Rds[(head + 46) % 64], MemToRegs[(head + 46) % 64], MemReads[(head + 46) % 64], MemWrites[(head + 46) % 64], ALUOPs[(head + 46) % 64], ALUSrc1s[(head + 46) % 64], ALUSrc2s[(head + 46) % 64], Jumps[(head + 46) % 64], Branchs[(head + 46) % 64], funct3s[(head + 46) % 64], immediates[(head + 46) % 64], operand1_datas[(head + 46) % 64], operand2_datas[(head + 46) % 64]};
    end
    readys[(head + 46) % 64] <= 0;
    operand1s[(head + 46) % 64] <= 0;
    operand2s[(head + 46) % 64] <= 0;
    operand1_datas[(head + 46) % 64] <= 0;
    operand2_datas[(head + 46) % 64] <= 0;
    valid_entries1[(head + 46) % 64] <= 0;
    valid_entries2[(head + 46) % 64] <= 0;
         RS_ALU_on[(head + 46) % 64] <= 1;
end
else if (valid_entries1[(head + 47) % 64] == 1 && valid_entries2[(head + 47) % 64] == 1) begin
    if (!MemReads[(head + 47) % 64]) begin
        result_out <= {inst_nums[(head + 47) % 64], 1'b1, PCs[(head + 47) % 64], Rds[(head + 47) % 64], MemToRegs[(head + 47) % 64], MemReads[(head + 47) % 64], MemWrites[(head + 47) % 64], ALUOPs[(head + 47) % 64], ALUSrc1s[(head + 47) % 64], ALUSrc2s[(head + 47) % 64], Jumps[(head + 47) % 64], Branchs[(head + 47) % 64], funct3s[(head + 47) % 64], immediates[(head + 47) % 64], operand1_datas[(head + 47) % 64], operand2_datas[(head + 47) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 47) % 64], 1'b0, PCs[(head + 47) % 64], Rds[(head + 47) % 64], MemToRegs[(head + 47) % 64], MemReads[(head + 47) % 64], MemWrites[(head + 47) % 64], ALUOPs[(head + 47) % 64], ALUSrc1s[(head + 47) % 64], ALUSrc2s[(head + 47) % 64], Jumps[(head + 47) % 64], Branchs[(head + 47) % 64], funct3s[(head + 47) % 64], immediates[(head + 47) % 64], operand1_datas[(head + 47) % 64], operand2_datas[(head + 47) % 64]};
    end
    readys[(head + 47) % 64] <= 0;
    operand1s[(head + 47) % 64] <= 0;
    operand2s[(head + 47) % 64] <= 0;
    operand1_datas[(head + 47) % 64] <= 0;
    operand2_datas[(head + 47) % 64] <= 0;
    valid_entries1[(head + 47) % 64] <= 0;
    valid_entries2[(head + 47) % 64] <= 0;
         RS_ALU_on[(head + 47) % 64] <= 1;
end
else if (valid_entries1[(head + 48) % 64] == 1 && valid_entries2[(head + 48) % 64] == 1) begin
    if (!MemReads[(head + 48) % 64]) begin
        result_out <= {inst_nums[(head + 48) % 64], 1'b1, PCs[(head + 48) % 64], Rds[(head + 48) % 64], MemToRegs[(head + 48) % 64], MemReads[(head + 48) % 64], MemWrites[(head + 48) % 64], ALUOPs[(head + 48) % 64], ALUSrc1s[(head + 48) % 64], ALUSrc2s[(head + 48) % 64], Jumps[(head + 48) % 64], Branchs[(head + 48) % 64], funct3s[(head + 48) % 64], immediates[(head + 48) % 64], operand1_datas[(head + 48) % 64], operand2_datas[(head + 48) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 48) % 64], 1'b0, PCs[(head + 48) % 64], Rds[(head + 48) % 64], MemToRegs[(head + 48) % 64], MemReads[(head + 48) % 64], MemWrites[(head + 48) % 64], ALUOPs[(head + 48) % 64], ALUSrc1s[(head + 48) % 64], ALUSrc2s[(head + 48) % 64], Jumps[(head + 48) % 64], Branchs[(head + 48) % 64], funct3s[(head + 48) % 64], immediates[(head + 48) % 64], operand1_datas[(head + 48) % 64], operand2_datas[(head + 48) % 64]};
    end
    readys[(head + 48) % 64] <= 0;
    operand1s[(head + 48) % 64] <= 0;
    operand2s[(head + 48) % 64] <= 0;
    operand1_datas[(head + 48) % 64] <= 0;
    operand2_datas[(head + 48) % 64] <= 0;
    valid_entries1[(head + 48) % 64] <= 0;
    valid_entries2[(head + 48) % 64] <= 0;
         RS_ALU_on[(head + 48) % 64] <= 1;
end
else if (valid_entries1[(head + 49) % 64] == 1 && valid_entries2[(head + 49) % 64] == 1) begin
    if (!MemReads[(head + 49) % 64]) begin
        result_out <= {inst_nums[(head + 49) % 64], 1'b1, PCs[(head + 49) % 64], Rds[(head + 49) % 64], MemToRegs[(head + 49) % 64], MemReads[(head + 49) % 64], MemWrites[(head + 49) % 64], ALUOPs[(head + 49) % 64], ALUSrc1s[(head + 49) % 64], ALUSrc2s[(head + 49) % 64], Jumps[(head + 49) % 64], Branchs[(head + 49) % 64], funct3s[(head + 49) % 64], immediates[(head + 49) % 64], operand1_datas[(head + 49) % 64], operand2_datas[(head + 49) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 49) % 64], 1'b0, PCs[(head + 49) % 64], Rds[(head + 49) % 64], MemToRegs[(head + 49) % 64], MemReads[(head + 49) % 64], MemWrites[(head + 49) % 64], ALUOPs[(head + 49) % 64], ALUSrc1s[(head + 49) % 64], ALUSrc2s[(head + 49) % 64], Jumps[(head + 49) % 64], Branchs[(head + 49) % 64], funct3s[(head + 49) % 64], immediates[(head + 49) % 64], operand1_datas[(head + 49) % 64], operand2_datas[(head + 49) % 64]};
    end
    readys[(head + 49) % 64] <= 0;
    operand1s[(head + 49) % 64] <= 0;
    operand2s[(head + 49) % 64] <= 0;
    operand1_datas[(head + 49) % 64] <= 0;
    operand2_datas[(head + 49) % 64] <= 0;
    valid_entries1[(head + 49) % 64] <= 0;
    valid_entries2[(head + 49) % 64] <= 0;
         RS_ALU_on[(head + 49) % 64] <= 1;
end
else if (valid_entries1[(head + 50) % 64] == 1 && valid_entries2[(head + 50) % 64] == 1) begin
    if (!MemReads[(head + 50) % 64]) begin
        result_out <= {inst_nums[(head + 50) % 64], 1'b1, PCs[(head + 50) % 64], Rds[(head + 50) % 64], MemToRegs[(head + 50) % 64], MemReads[(head + 50) % 64], MemWrites[(head + 50) % 64], ALUOPs[(head + 50) % 64], ALUSrc1s[(head + 50) % 64], ALUSrc2s[(head + 50) % 64], Jumps[(head + 50) % 64], Branchs[(head + 50) % 64], funct3s[(head + 50) % 64], immediates[(head + 50) % 64], operand1_datas[(head + 50) % 64], operand2_datas[(head + 50) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 50) % 64], 1'b0, PCs[(head + 50) % 64], Rds[(head + 50) % 64], MemToRegs[(head + 50) % 64], MemReads[(head + 50) % 64], MemWrites[(head + 50) % 64], ALUOPs[(head + 50) % 64], ALUSrc1s[(head + 50) % 64], ALUSrc2s[(head + 50) % 64], Jumps[(head + 50) % 64], Branchs[(head + 50) % 64], funct3s[(head + 50) % 64], immediates[(head + 50) % 64], operand1_datas[(head + 50) % 64], operand2_datas[(head + 50) % 64]};
    end
    readys[(head + 50) % 64] <= 0;
    operand1s[(head + 50) % 64] <= 0;
    operand2s[(head + 50) % 64] <= 0;
    operand1_datas[(head + 50) % 64] <= 0;
    operand2_datas[(head + 50) % 64] <= 0;
    valid_entries1[(head + 50) % 64] <= 0;
    valid_entries2[(head + 50) % 64] <= 0;
         RS_ALU_on[(head + 50) % 64] <= 1;
end
else if (valid_entries1[(head + 51) % 64] == 1 && valid_entries2[(head + 51) % 64] == 1) begin
    if (!MemReads[(head + 51) % 64]) begin
        result_out <= {inst_nums[(head + 51) % 64], 1'b1, PCs[(head + 51) % 64], Rds[(head + 51) % 64], MemToRegs[(head + 51) % 64], MemReads[(head + 51) % 64], MemWrites[(head + 51) % 64], ALUOPs[(head + 51) % 64], ALUSrc1s[(head + 51) % 64], ALUSrc2s[(head + 51) % 64], Jumps[(head + 51) % 64], Branchs[(head + 51) % 64], funct3s[(head + 51) % 64], immediates[(head + 51) % 64], operand1_datas[(head + 51) % 64], operand2_datas[(head + 51) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 51) % 64], 1'b0, PCs[(head + 51) % 64], Rds[(head + 51) % 64], MemToRegs[(head + 51) % 64], MemReads[(head + 51) % 64], MemWrites[(head + 51) % 64], ALUOPs[(head + 51) % 64], ALUSrc1s[(head + 51) % 64], ALUSrc2s[(head + 51) % 64], Jumps[(head + 51) % 64], Branchs[(head + 51) % 64], funct3s[(head + 51) % 64], immediates[(head + 51) % 64], operand1_datas[(head + 51) % 64], operand2_datas[(head + 51) % 64]};
    end
    readys[(head + 51) % 64] <= 0;
    operand1s[(head + 51) % 64] <= 0;
    operand2s[(head + 51) % 64] <= 0;
    operand1_datas[(head + 51) % 64] <= 0;
    operand2_datas[(head + 51) % 64] <= 0;
    valid_entries1[(head + 51) % 64] <= 0;
    valid_entries2[(head + 51) % 64] <= 0;
         RS_ALU_on[(head + 51) % 64] <= 1;
end
else if (valid_entries1[(head + 52) % 64] == 1 && valid_entries2[(head + 52) % 64] == 1) begin
    if (!MemReads[(head + 52) % 64]) begin
        result_out <= {inst_nums[(head + 52) % 64], 1'b1, PCs[(head + 52) % 64], Rds[(head + 52) % 64], MemToRegs[(head + 52) % 64], MemReads[(head + 52) % 64], MemWrites[(head + 52) % 64], ALUOPs[(head + 52) % 64], ALUSrc1s[(head + 52) % 64], ALUSrc2s[(head + 52) % 64], Jumps[(head + 52) % 64], Branchs[(head + 52) % 64], funct3s[(head + 52) % 64], immediates[(head + 52) % 64], operand1_datas[(head + 52) % 64], operand2_datas[(head + 52) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 52) % 64], 1'b0, PCs[(head + 52) % 64], Rds[(head + 52) % 64], MemToRegs[(head + 52) % 64], MemReads[(head + 52) % 64], MemWrites[(head + 52) % 64], ALUOPs[(head + 52) % 64], ALUSrc1s[(head + 52) % 64], ALUSrc2s[(head + 52) % 64], Jumps[(head + 52) % 64], Branchs[(head + 52) % 64], funct3s[(head + 52) % 64], immediates[(head + 52) % 64], operand1_datas[(head + 52) % 64], operand2_datas[(head + 52) % 64]};
    end
    readys[(head + 52) % 64] <= 0;
    operand1s[(head + 52) % 64] <= 0;
    operand2s[(head + 52) % 64] <= 0;
    operand1_datas[(head + 52) % 64] <= 0;
    operand2_datas[(head + 52) % 64] <= 0;
    valid_entries1[(head + 52) % 64] <= 0;
    valid_entries2[(head + 52) % 64] <= 0;
         RS_ALU_on[(head + 52) % 64] <= 1;
end
else if (valid_entries1[(head + 53) % 64] == 1 && valid_entries2[(head + 53) % 64] == 1) begin
    if (!MemReads[(head + 53) % 64]) begin
        result_out <= {inst_nums[(head + 53) % 64], 1'b1, PCs[(head + 53) % 64], Rds[(head + 53) % 64], MemToRegs[(head + 53) % 64], MemReads[(head + 53) % 64], MemWrites[(head + 53) % 64], ALUOPs[(head + 53) % 64], ALUSrc1s[(head + 53) % 64], ALUSrc2s[(head + 53) % 64], Jumps[(head + 53) % 64], Branchs[(head + 53) % 64], funct3s[(head + 53) % 64], immediates[(head + 53) % 64], operand1_datas[(head + 53) % 64], operand2_datas[(head + 53) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 53) % 64], 1'b0, PCs[(head + 53) % 64], Rds[(head + 53) % 64], MemToRegs[(head + 53) % 64], MemReads[(head + 53) % 64], MemWrites[(head + 53) % 64], ALUOPs[(head + 53) % 64], ALUSrc1s[(head + 53) % 64], ALUSrc2s[(head + 53) % 64], Jumps[(head + 53) % 64], Branchs[(head + 53) % 64], funct3s[(head + 53) % 64], immediates[(head + 53) % 64], operand1_datas[(head + 53) % 64], operand2_datas[(head + 53) % 64]};
    end
    readys[(head + 53) % 64] <= 0;
    operand1s[(head + 53) % 64] <= 0;
    operand2s[(head + 53) % 64] <= 0;
    operand1_datas[(head + 53) % 64] <= 0;
    operand2_datas[(head + 53) % 64] <= 0;
    valid_entries1[(head + 53) % 64] <= 0;
    valid_entries2[(head + 53) % 64] <= 0;
         RS_ALU_on[(head + 53) % 64] <= 1;
end
else if (valid_entries1[(head + 54) % 64] == 1 && valid_entries2[(head + 54) % 64] == 1) begin
    if (!MemReads[(head + 54) % 64]) begin
        result_out <= {inst_nums[(head + 54) % 64], 1'b1, PCs[(head + 54) % 64], Rds[(head + 54) % 64], MemToRegs[(head + 54) % 64], MemReads[(head + 54) % 64], MemWrites[(head + 54) % 64], ALUOPs[(head + 54) % 64], ALUSrc1s[(head + 54) % 64], ALUSrc2s[(head + 54) % 64], Jumps[(head + 54) % 64], Branchs[(head + 54) % 64], funct3s[(head + 54) % 64], immediates[(head + 54) % 64], operand1_datas[(head + 54) % 64], operand2_datas[(head + 54) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 54) % 64], 1'b0, PCs[(head + 54) % 64], Rds[(head + 54) % 64], MemToRegs[(head + 54) % 64], MemReads[(head + 54) % 64], MemWrites[(head + 54) % 64], ALUOPs[(head + 54) % 64], ALUSrc1s[(head + 54) % 64], ALUSrc2s[(head + 54) % 64], Jumps[(head + 54) % 64], Branchs[(head + 54) % 64], funct3s[(head + 54) % 64], immediates[(head + 54) % 64], operand1_datas[(head + 54) % 64], operand2_datas[(head + 54) % 64]};
    end
    readys[(head + 54) % 64] <= 0;
    operand1s[(head + 54) % 64] <= 0;
    operand2s[(head + 54) % 64] <= 0;
    operand1_datas[(head + 54) % 64] <= 0;
    operand2_datas[(head + 54) % 64] <= 0;
    valid_entries1[(head + 54) % 64] <= 0;
    valid_entries2[(head + 54) % 64] <= 0;
         RS_ALU_on[(head + 54) % 64] <= 1;
end
else if (valid_entries1[(head + 55) % 64] == 1 && valid_entries2[(head + 55) % 64] == 1) begin
    if (!MemReads[(head + 55) % 64]) begin
        result_out <= {inst_nums[(head + 55) % 64], 1'b1, PCs[(head + 55) % 64], Rds[(head + 55) % 64], MemToRegs[(head + 55) % 64], MemReads[(head + 55) % 64], MemWrites[(head + 55) % 64], ALUOPs[(head + 55) % 64], ALUSrc1s[(head + 55) % 64], ALUSrc2s[(head + 55) % 64], Jumps[(head + 55) % 64], Branchs[(head + 55) % 64], funct3s[(head + 55) % 64], immediates[(head + 55) % 64], operand1_datas[(head + 55) % 64], operand2_datas[(head + 55) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 55) % 64], 1'b0, PCs[(head + 55) % 64], Rds[(head + 55) % 64], MemToRegs[(head + 55) % 64], MemReads[(head + 55) % 64], MemWrites[(head + 55) % 64], ALUOPs[(head + 55) % 64], ALUSrc1s[(head + 55) % 64], ALUSrc2s[(head + 55) % 64], Jumps[(head + 55) % 64], Branchs[(head + 55) % 64], funct3s[(head + 55) % 64], immediates[(head + 55) % 64], operand1_datas[(head + 55) % 64], operand2_datas[(head + 55) % 64]};
    end
    readys[(head + 55) % 64] <= 0;
    operand1s[(head + 55) % 64] <= 0;
    operand2s[(head + 55) % 64] <= 0;
    operand1_datas[(head + 55) % 64] <= 0;
    operand2_datas[(head + 55) % 64] <= 0;
    valid_entries1[(head + 55) % 64] <= 0;
    valid_entries2[(head + 55) % 64] <= 0;
     RS_ALU_on[(head + 55) % 64] <= 1;
end
else if (valid_entries1[(head + 56) % 64] == 1 && valid_entries2[(head + 56) % 64] == 1) begin
    if (!MemReads[(head + 56) % 64]) begin
        result_out <= {inst_nums[(head + 56) % 64], 1'b1, PCs[(head + 56) % 64], Rds[(head + 56) % 64], MemToRegs[(head + 56) % 64], MemReads[(head + 56) % 64], MemWrites[(head + 56) % 64], ALUOPs[(head + 56) % 64], ALUSrc1s[(head + 56) % 64], ALUSrc2s[(head + 56) % 64], Jumps[(head + 56) % 64], Branchs[(head + 56) % 64], funct3s[(head + 56) % 64], immediates[(head + 56) % 64], operand1_datas[(head + 56) % 64], operand2_datas[(head + 56) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 56) % 64], 1'b0, PCs[(head + 56) % 64], Rds[(head + 56) % 64], MemToRegs[(head + 56) % 64], MemReads[(head + 56) % 64], MemWrites[(head + 56) % 64], ALUOPs[(head + 56) % 64], ALUSrc1s[(head + 56) % 64], ALUSrc2s[(head + 56) % 64], Jumps[(head + 56) % 64], Branchs[(head + 56) % 64], funct3s[(head + 56) % 64], immediates[(head + 56) % 64], operand1_datas[(head + 56) % 64], operand2_datas[(head + 56) % 64]};
    end
    readys[(head + 56) % 64] <= 0;
    operand1s[(head + 56) % 64] <= 0;
    operand2s[(head + 56) % 64] <= 0;
    operand1_datas[(head + 56) % 64] <= 0;
    operand2_datas[(head + 56) % 64] <= 0;
    valid_entries1[(head + 56) % 64] <= 0;
    valid_entries2[(head + 56) % 64] <= 0;
     RS_ALU_on[(head + 56) % 64] <= 1;
end
else if (valid_entries1[(head + 57) % 64] == 1 && valid_entries2[(head + 57) % 64] == 1) begin
    if (!MemReads[(head + 57) % 64]) begin
        result_out <= {inst_nums[(head + 57) % 64], 1'b1, PCs[(head + 57) % 64], Rds[(head + 57) % 64], MemToRegs[(head + 57) % 64], MemReads[(head + 57) % 64], MemWrites[(head + 57) % 64], ALUOPs[(head + 57) % 64], ALUSrc1s[(head + 57) % 64], ALUSrc2s[(head + 57) % 64], Jumps[(head + 57) % 64], Branchs[(head + 57) % 64], funct3s[(head + 57) % 64], immediates[(head + 57) % 64], operand1_datas[(head + 57) % 64], operand2_datas[(head + 57) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 57) % 64], 1'b0, PCs[(head + 57) % 64], Rds[(head + 57) % 64], MemToRegs[(head + 57) % 64], MemReads[(head + 57) % 64], MemWrites[(head + 57) % 64], ALUOPs[(head + 57) % 64], ALUSrc1s[(head + 57) % 64], ALUSrc2s[(head + 57) % 64], Jumps[(head + 57) % 64], Branchs[(head + 57) % 64], funct3s[(head + 57) % 64], immediates[(head + 57) % 64], operand1_datas[(head + 57) % 64], operand2_datas[(head + 57) % 64]};
    end
    readys[(head + 57) % 64] <= 0;
    operand1s[(head + 57) % 64] <= 0;
    operand2s[(head + 57) % 64] <= 0;
    operand1_datas[(head + 57) % 64] <= 0;
    operand2_datas[(head + 57) % 64] <= 0;
    valid_entries1[(head + 57) % 64] <= 0;
    valid_entries2[(head + 57) % 64] <= 0;
     RS_ALU_on[(head + 57) % 64] <= 1;
end
else if (valid_entries1[(head + 58) % 64] == 1 && valid_entries2[(head + 58) % 64] == 1) begin
    if (!MemReads[(head + 58) % 64]) begin
        result_out <= {inst_nums[(head + 58) % 64], 1'b1, PCs[(head + 58) % 64], Rds[(head + 58) % 64], MemToRegs[(head + 58) % 64], MemReads[(head + 58) % 64], MemWrites[(head + 58) % 64], ALUOPs[(head + 58) % 64], ALUSrc1s[(head + 58) % 64], ALUSrc2s[(head + 58) % 64], Jumps[(head + 58) % 64], Branchs[(head + 58) % 64], funct3s[(head + 58) % 64], immediates[(head + 58) % 64], operand1_datas[(head + 58) % 64], operand2_datas[(head + 58) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 58) % 64], 1'b0, PCs[(head + 58) % 64], Rds[(head + 58) % 64], MemToRegs[(head + 58) % 64], MemReads[(head + 58) % 64], MemWrites[(head + 58) % 64], ALUOPs[(head + 58) % 64], ALUSrc1s[(head + 58) % 64], ALUSrc2s[(head + 58) % 64], Jumps[(head + 58) % 64], Branchs[(head + 58) % 64], funct3s[(head + 58) % 64], immediates[(head + 58) % 64], operand1_datas[(head + 58) % 64], operand2_datas[(head + 58) % 64]};
    end
    readys[(head + 58) % 64] <= 0;
    operand1s[(head + 58) % 64] <= 0;
    operand2s[(head + 58) % 64] <= 0;
    operand1_datas[(head + 58) % 64] <= 0;
    operand2_datas[(head + 58) % 64] <= 0;
    valid_entries1[(head + 58) % 64] <= 0;
    valid_entries2[(head + 58) % 64] <= 0;
     RS_ALU_on[(head + 58) % 64] <= 1;
end
else if (valid_entries1[(head + 59) % 64] == 1 && valid_entries2[(head + 59) % 64] == 1) begin
    if (!MemReads[(head + 59) % 64]) begin
        result_out <= {inst_nums[(head + 59) % 64], 1'b1, PCs[(head + 59) % 64], Rds[(head + 59) % 64], MemToRegs[(head + 59) % 64], MemReads[(head + 59) % 64], MemWrites[(head + 59) % 64], ALUOPs[(head + 59) % 64], ALUSrc1s[(head + 59) % 64], ALUSrc2s[(head + 59) % 64], Jumps[(head + 59) % 64], Branchs[(head + 59) % 64], funct3s[(head + 59) % 64], immediates[(head + 59) % 64], operand1_datas[(head + 59) % 64], operand2_datas[(head + 59) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 59) % 64], 1'b0, PCs[(head + 59) % 64], Rds[(head + 59) % 64], MemToRegs[(head + 59) % 64], MemReads[(head + 59) % 64], MemWrites[(head + 59) % 64], ALUOPs[(head + 59) % 64], ALUSrc1s[(head + 59) % 64], ALUSrc2s[(head + 59) % 64], Jumps[(head + 59) % 64], Branchs[(head + 59) % 64], funct3s[(head + 59) % 64], immediates[(head + 59) % 64], operand1_datas[(head + 59) % 64], operand2_datas[(head + 59) % 64]};
    end
    readys[(head + 59) % 64] <= 0;
    operand1s[(head + 59) % 64] <= 0;
    operand2s[(head + 59) % 64] <= 0;
    operand1_datas[(head + 59) % 64] <= 0;
    operand2_datas[(head + 59) % 64] <= 0;
    valid_entries1[(head + 59) % 64] <= 0;
    valid_entries2[(head + 59) % 64] <= 0;
     RS_ALU_on[(head + 59) % 64] <= 1;
end
else if (valid_entries1[(head + 60) % 64] == 1 && valid_entries2[(head + 60) % 64] == 1) begin
    if (!MemReads[(head + 60) % 64]) begin
        result_out <= {inst_nums[(head + 60) % 64], 1'b1, PCs[(head + 60) % 64], Rds[(head + 60) % 64], MemToRegs[(head + 60) % 64], MemReads[(head + 60) % 64], MemWrites[(head + 60) % 64], ALUOPs[(head + 60) % 64], ALUSrc1s[(head + 60) % 64], ALUSrc2s[(head + 60) % 64], Jumps[(head + 60) % 64], Branchs[(head + 60) % 64], funct3s[(head + 60) % 64], immediates[(head + 60) % 64], operand1_datas[(head + 60) % 64], operand2_datas[(head + 60) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 60) % 64], 1'b0, PCs[(head + 60) % 64], Rds[(head + 60) % 64], MemToRegs[(head + 60) % 64], MemReads[(head + 60) % 64], MemWrites[(head + 60) % 64], ALUOPs[(head + 60) % 64], ALUSrc1s[(head + 60) % 64], ALUSrc2s[(head + 60) % 64], Jumps[(head + 60) % 64], Branchs[(head + 60) % 64], funct3s[(head + 60) % 64], immediates[(head + 60) % 64], operand1_datas[(head + 60) % 64], operand2_datas[(head + 60) % 64]};
    end
    readys[(head + 60) % 64] <= 0;
    operand1s[(head + 60) % 64] <= 0;
    operand2s[(head + 60) % 64] <= 0;
    operand1_datas[(head + 60) % 64] <= 0;
    operand2_datas[(head + 60) % 64] <= 0;
    valid_entries1[(head + 60) % 64] <= 0;
    valid_entries2[(head + 60) % 64] <= 0;
     RS_ALU_on[(head + 60) % 64] <= 1;
end
else if (valid_entries1[(head + 61) % 64] == 1 && valid_entries2[(head + 61) % 64] == 1) begin
    if (!MemReads[(head + 61) % 64]) begin
        result_out <= {inst_nums[(head + 61) % 64], 1'b1, PCs[(head + 61) % 64], Rds[(head + 61) % 64], MemToRegs[(head + 61) % 64], MemReads[(head + 61) % 64], MemWrites[(head + 61) % 64], ALUOPs[(head + 61) % 64], ALUSrc1s[(head + 61) % 64], ALUSrc2s[(head + 61) % 64], Jumps[(head + 61) % 64], Branchs[(head + 61) % 64], funct3s[(head + 61) % 64], immediates[(head + 61) % 64], operand1_datas[(head + 61) % 64], operand2_datas[(head + 61) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 61) % 64], 1'b0, PCs[(head + 61) % 64], Rds[(head + 61) % 64], MemToRegs[(head + 61) % 64], MemReads[(head + 61) % 64], MemWrites[(head + 61) % 64], ALUOPs[(head + 61) % 64], ALUSrc1s[(head + 61) % 64], ALUSrc2s[(head + 61) % 64], Jumps[(head + 61) % 64], Branchs[(head + 61) % 64], funct3s[(head + 61) % 64], immediates[(head + 61) % 64], operand1_datas[(head + 61) % 64], operand2_datas[(head + 61) % 64]};
    end
    readys[(head + 61) % 64] <= 0;
    operand1s[(head + 61) % 64] <= 0;
    operand2s[(head + 61) % 64] <= 0;
    operand1_datas[(head + 61) % 64] <= 0;
    operand2_datas[(head + 61) % 64] <= 0;
    valid_entries1[(head + 61) % 64] <= 0;
    valid_entries2[(head + 61) % 64] <= 0;
         RS_ALU_on[(head + 61) % 64] <= 1;
end
else if (valid_entries1[(head + 62) % 64] == 1 && valid_entries2[(head + 62) % 64] == 1) begin
    if (!MemReads[(head + 62) % 64]) begin
        result_out <= {inst_nums[(head + 62) % 64], 1'b1, PCs[(head + 62) % 64], Rds[(head + 62) % 64], MemToRegs[(head + 62) % 64], MemReads[(head + 62) % 64], MemWrites[(head + 62) % 64], ALUOPs[(head + 62) % 64], ALUSrc1s[(head + 62) % 64], ALUSrc2s[(head + 62) % 64], Jumps[(head + 62) % 64], Branchs[(head + 62) % 64], funct3s[(head + 62) % 64], immediates[(head + 62) % 64], operand1_datas[(head + 62) % 64], operand2_datas[(head + 62) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 62) % 64], 1'b0, PCs[(head + 62) % 64], Rds[(head + 62) % 64], MemToRegs[(head + 62) % 64], MemReads[(head + 62) % 64], MemWrites[(head + 62) % 64], ALUOPs[(head + 62) % 64], ALUSrc1s[(head + 62) % 64], ALUSrc2s[(head + 62) % 64], Jumps[(head + 62) % 64], Branchs[(head + 62) % 64], funct3s[(head + 62) % 64], immediates[(head + 62) % 64], operand1_datas[(head + 62) % 64], operand2_datas[(head + 62) % 64]};
    end
    readys[(head + 62) % 64] <= 0;
    operand1s[(head + 62) % 64] <= 0;
    operand2s[(head + 62) % 64] <= 0;
    operand1_datas[(head + 62) % 64] <= 0;
    operand2_datas[(head + 62) % 64] <= 0;
    valid_entries1[(head + 62) % 64] <= 0;
    valid_entries2[(head + 62) % 64] <= 0;
           RS_ALU_on[(head + 62) % 64] <= 1;
end
else if (valid_entries1[(head + 63) % 64] == 1 && valid_entries2[(head + 63) % 64] == 1) begin
    if (!MemReads[(head + 63) % 64]) begin
        result_out <= {inst_nums[(head + 63) % 64], 1'b1, PCs[(head + 63) % 64], Rds[(head + 63) % 64], MemToRegs[(head + 63) % 64], MemReads[(head + 63) % 64], MemWrites[(head + 63) % 64], ALUOPs[(head + 63) % 64], ALUSrc1s[(head + 63) % 64], ALUSrc2s[(head + 63) % 64], Jumps[(head + 63) % 64], Branchs[(head + 63) % 64], funct3s[(head + 63) % 64], immediates[(head + 63) % 64], operand1_datas[(head + 63) % 64], operand2_datas[(head + 63) % 64]};
    end else begin
        result_out <= {inst_nums[(head + 63) % 64], 1'b0, PCs[(head + 63) % 64], Rds[(head + 63) % 64], MemToRegs[(head + 63) % 64], MemReads[(head + 63) % 64], MemWrites[(head + 63) % 64], ALUOPs[(head + 63) % 64], ALUSrc1s[(head + 63) % 64], ALUSrc2s[(head + 63) % 64], Jumps[(head + 63) % 64], Branchs[(head + 63) % 64], funct3s[(head + 63) % 64], immediates[(head + 63) % 64], operand1_datas[(head + 63) % 64], operand2_datas[(head + 63) % 64]};
    end
    readys[(head + 63) % 64] <= 0;
    operand1s[(head + 63) % 64] <= 0;
    operand2s[(head + 63) % 64] <= 0;
    operand1_datas[(head + 63) % 64] <= 0;
    operand2_datas[(head + 63) % 64] <= 0;
    valid_entries1[(head + 63) % 64] <= 0;
    valid_entries2[(head + 63) % 64] <= 0;
           RS_ALU_on[(head + 63) % 64] <= 1;
end
else begin
    result_out <= 0;
end
end
 endmodule
