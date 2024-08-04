 module RS_LS (                                             //癲ル슢�뀖�뤃�빍?????�젂? forwarding, 濚�?????�몡�넭怨ｋ�壤�? 癲ル슢�뀖�뤃�빍?????�젂繹먭낫猿�???�빝? ?雅��겦�꼤?�룱??雅��겦堉�?�뻿??�땻?獒�? ??援�???�눀??�뛾????獄�? ???鍮�?嶺�??.
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] RS_alu_inst_num,
 
    input wire [7:0] Rd,
    input wire MemToReg,
    input wire MemRead,
    input wire MemWrite,
    input wire [3:0] ALUOP,
 
    input wire ALUSrc2,
    input wire [2:0] funct3,
    input wire [31:0] immediate,
    input wire EX_MEM_MemRead,
    input wire [7:0] EX_MEM_Physical_Address,
    input wire [7:0] operand1,
    input wire [7:0] operand2,
    input wire [1:0] valid,
    input wire [7:0] ALU_result_dest,
    input wire ALU_result_valid,
    input wire [7:0] MUL_result_dest,
    input wire MUL_result_valid,
    input wire [7:0] DIV_result_dest,
    input wire DIV_result_valid,
    input wire Branch_result_valid,
    input wire [7:0] BR_Phy,
  input wire P_Done,
  input wire [7:0] P_Phy,

  input wire CSR_done,
  input wire [7:0] CSR_phy,

  input wire exception_sig,
  input wire mret_sig,
  output reg [99:0] result_out
    
);
    
    // Internal storage for reservation station entries
   (* keep = "true" *) reg [31:0] inst_nums[0:63];
  
    (* keep = "true" *) reg [7:0] Rds [0:63];
   (* keep = "true" *) reg [63:0] MemToRegs;
   (* keep = "true" *) reg [63:0] MemReads;
   (* keep = "true" *) reg [63:0] MemWrites;
   (* keep = "true" *) reg [3:0] ALUOPs [0:63];

   (* keep = "true" *) reg [63:0] ALUSrc2s;
   (* keep = "true" *) reg [2:0] funct3s [0:63];
   (* keep = "true" *) reg [31:0] immediates [0:63];
   (* keep = "true" *) reg [7:0] operand1s [0:63];
   (* keep = "true" *) reg [7:0] operand2s [0:63];

   (* keep = "true" *) reg [63:0] valid_entries1;  // operand1????? valid???��??爰뗥＄???
   (* keep = "true" *) reg [63:0] valid_entries2; // operand2?筌�??? valid???��??爰뗥＄???

   (* keep = "true" *) reg [6:0] tail;
   (* keep = "true" *) reg [6:0] head;

  (* keep = "true" *) integer i, j, k, l, m, n,o;
   (* keep = "true" *) reg RS_ALU_on[0:63];


(* keep = "true" *)wire operand1_ALU_conflict = ((operand1 == ALU_result_dest)&&ALU_result_valid);
  (* keep = "true" *)wire operand1_MUL_conflict = ((operand1 == MUL_result_dest)&&MUL_result_valid);
  (* keep = "true" *)wire operand1_DIV_conflict = ((operand1 == DIV_result_dest)&&DIV_result_valid);
  (* keep = "true" *)wire operand1_MEM_conflict = ((operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead == 1));
  (* keep = "true" *)wire operand1_BR_conflict = ((operand1 == BR_Phy)&&Branch_result_valid);
  (* keep = "true" *)wire operand1_P_conflict = ((operand1 == P_Phy)&&P_Done);
  (* keep = "true" *)wire operand1_CSR_conflict = ((operand1 == CSR_phy)&&CSR_done);
  (* keep = "true" *)wire operand1_conflict = operand1_ALU_conflict || operand1_MUL_conflict || operand1_DIV_conflict || operand1_MEM_conflict || operand1_BR_conflict || operand1_P_conflict || operand1_CSR_conflict;

   (* keep = "true" *)wire operand2_ALU_conflict = ((operand2 == ALU_result_dest)&&ALU_result_valid);
  (* keep = "true" *)wire operand2_MUL_conflict = ((operand2 == MUL_result_dest)&&MUL_result_valid);
  (* keep = "true" *)wire operand2_DIV_conflict = ((operand2 == DIV_result_dest)&&DIV_result_valid);
  (* keep = "true" *)wire operand2_MEM_conflict = (operand2 == EX_MEM_Physical_Address && EX_MEM_MemRead == 1);
   (* keep = "true" *)wire operand2_BR_conflict = ((operand2 == BR_Phy)&&Branch_result_valid);
   (* keep = "true" *)wire operand2_P_conflict = ((operand2 == P_Phy)&&P_Done);
  (* keep = "true" *)wire operand2_CSR_conflict = ((operand2 == CSR_phy)&&CSR_done);
  (* keep = "true" *)wire operand2_conflict = operand2_ALU_conflict || operand2_MUL_conflict || operand2_DIV_conflict || operand2_MEM_conflict || operand2_BR_conflict || operand2_P_conflict || operand2_CSR_conflict;



    always @(posedge clk) begin    //?��???遊�????筌�???繹먮뛼�뒙?? ?�뙴???�맃?逾�????瑗� ??筌�???�걙獒뺣뎽�뀋?
     if (reset|exception_sig|mret_sig) begin
            tail <= 0;
            head <=0;
            for (i = 0; i < 64; i = i + 1) begin
                inst_nums[i] <=0;
            
                Rds[i] <= 0;
                MemToRegs[i] <= 0;
                MemReads[i] <= 0;
                MemWrites[i] <= 0;
                ALUOPs[i] <= 0;
             
                ALUSrc2s[i] <= 0;
                funct3s[i] <= 0;
                immediates[i] <=0;
                operand1s[i] <= 0;
                operand2s[i] <= 0;
                valid_entries1[i] <= 1'b0; 
                valid_entries2[i] <= 1'b0; 
                RS_ALU_on[i] <=0; 
            end
        end else begin
        if (start) begin

            
   
            if (operand1_conflict) begin  
                inst_nums[tail] <= RS_alu_inst_num;
               
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
               
                ALUSrc2s[tail] <= ALUSrc2;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1];
                tail <= (tail + 1) % 64;
                RS_ALU_on[tail] <=0;
            end else if (operand2_conflict) begin 
                inst_nums[tail] <= RS_alu_inst_num;
             
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
           
                ALUSrc2s[tail] <= ALUSrc2;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;  
                 RS_ALU_on[tail] <=0; 
               
            end else begin
                inst_nums[tail] <= RS_alu_inst_num;
             
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
           
                ALUSrc2s[tail] <= ALUSrc2;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= valid[1]; 
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
             end 

            if (operand1_conflict && operand2_conflict) begin 
                inst_nums[tail] <= RS_alu_inst_num;
             
                Rds[tail] <= Rd;
                MemToRegs[tail] <= MemToReg;
                MemReads[tail] <= MemRead;
                MemWrites[tail] <= MemWrite;
                ALUOPs[tail] <= ALUOP;
           
                ALUSrc2s[tail] <= ALUSrc2;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;  
                 RS_ALU_on[tail] <=0; 
               
            end

             end
            

           
            if (ALU_result_valid) begin                 //alu??甕�? ?�눇�뙼�맪???亦끸궗琉�?? ?�뛾????�젂????瑗�??獄�???�눀?, ?堉②퐛紐�??????援�? RS??援�? ?�뛾????�젂???�굢????留� 癲ル슢�뀖�뤃�빍?????�젂??�뛾??堉�??? ??�떛??�땻?�걡釉낆뜏?�뒩?�땾?�댆??筌�?? ??�몡�넭怨λ즸�댆???�눀???援�?
                                                        //??�눀????萸�??�눀? ?琉�?猷�??維뽪뤃???獄�? ?癲�?????紐�??��???獄�? ??筌�???�걙獒�????�젆?.
                for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == ALU_result_dest) begin
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == ALU_result_dest) begin
                        valid_entries2[i] <= 1;
                    end
                end
            end
            if (MUL_result_valid) begin                     //mul??甕�? ?�눇�뙼�맪???亦끸궗琉�?? ?�뛾????�젂????瑗�??獄�???�눀?, ?堉②퐛紐�??????援�? RS??援�? ?�뛾????�젂???�굢????留� 癲ル슢�뀖�뤃�빍?????�젂??�뛾??堉�??? ??�떛??�땻?�걡釉낆뜏?�뒩?�땾?�댆??筌�?? ??�몡�넭怨λ즸�댆???�눀???援�?
                                                        //??�눀????萸�??�눀? ?琉�?猷�??維뽪뤃???獄�? ?癲�?????紐�??��???獄�? ??筌�???�걙獒�????�젆?.
                for (j = 0; j < 64; j = j + 1) begin
                    if (!valid_entries1[j] && operand1s[j] == MUL_result_dest) begin
                        valid_entries1[j] <= 1;
                    end
                    if (!valid_entries2[j] && operand2s[j] == MUL_result_dest) begin
                        valid_entries2[j] <= 1;
                    end
                end
            end
            if (DIV_result_valid) begin         //div??甕�? ?�눇�뙼�맪???亦끸궗琉�?? ?�뛾????�젂????瑗�??獄�???�눀?, ?堉②퐛紐�??????援�? RS??援�? ?�뛾????�젂???�굢????留� 癲ル슢�뀖�뤃�빍?????�젂??�뛾??堉�??? ??�떛??�땻?�걡釉낆뜏?�뒩?�땾?�댆??筌�?? ??�몡�넭怨λ즸�댆???�눀???援�?
                                                        //??�눀????萸�??�눀? ?琉�?猷�??維뽪뤃???獄�? ?癲�?????紐�??��???獄�? ??筌�???�걙獒�????�젆?.
                for (k = 0; k < 64; k = k + 1) begin
                    if (!valid_entries1[k] && operand1s[k] == DIV_result_dest) begin
                        valid_entries1[k] <= 1;
                    end
                    if (!valid_entries2[k] && operand2s[k] == DIV_result_dest) begin
                        valid_entries2[k] <= 1;
                    end
                end
            end
           if (EX_MEM_MemRead) begin                //load??甕�? ?�눇�뙼�맪???亦끸궗琉�?? ?�뛾????�젂????瑗�??獄�???�눀?, ?堉②퐛紐�??????援�? RS??援�? ?�뛾????�젂???�굢????留� 癲ル슢�뀖�뤃�빍?????�젂??�뛾??堉�??? ??�떛??�땻?�걡釉낆뜏?�뒩?�땾?�댆??筌�?? ??�몡�넭怨λ즸�댆???�눀???援�?
                                                        //??�눀????萸�??�눀? ?琉�?猷�??維뽪뤃???獄�? ?癲�?????紐�??��???獄�? ??筌�???�걙獒�????�젆?.
           for (l = 0; l < 64; l = l + 1) begin
                    if (!valid_entries1[l] && operand1s[l] == EX_MEM_Physical_Address) begin
                        valid_entries1[l] <= 1;
                    end
                    if (!valid_entries2[l] && operand2s[l] == EX_MEM_Physical_Address) begin
                        valid_entries2[l] <= 1;
                    end
                end     
            end
           if (Branch_result_valid) begin                //Branch??甕�? ?�눇�뙼�맪???亦끸궗琉�?? ?�뛾????�젂????瑗�??獄�???�눀?, ?堉②퐛紐�??????援�? RS??援�? ?�뛾????�젂???�굢????留� 癲ル슢�뀖�뤃�빍?????�젂??�뛾??堉�??? ??�떛??�땻?�걡釉낆뜏?�뒩?�땾?�댆??筌�?? ??�몡�넭怨λ즸�댆???�눀???援�?
                                                        //??�눀????萸�??�눀? ?琉�?猷�??維뽪뤃???獄�? ?癲�?????紐�??��???獄�? ??筌�???�걙獒�????�젆?.
           for (m = 0; m < 64; m = m + 1) begin
                    if (!valid_entries1[m] && operand1s[m] == BR_Phy) begin
                        valid_entries1[m] <= 1;
                    end
                    if (!valid_entries2[m] && operand2s[m] == BR_Phy) begin
                        valid_entries2[m] <= 1;
                    end
                end     
            end
         if (P_Done) begin                
          for (n = 0; n < 64; n = n + 1) begin
           if (!valid_entries1[n] && operand1s[n] == P_Phy) begin
            valid_entries1[n] <= 1;
           end
           if (!valid_entries2[n] && operand2s[n] == P_Phy) begin
             valid_entries2[n] <= 1;
           end
          end
         end
         
         if (CSR_done) begin                
          for (o = 0; o < 64; o = o + 1) begin
           if (!valid_entries1[o] && operand1s[o] == CSR_phy) begin
            valid_entries1[o] <= 1;
           end
           if (!valid_entries2[o] && operand2s[o] == CSR_phy) begin
            valid_entries2[o] <= 1;
           end
          end
         end

         end
 
      if (RS_ALU_on[head]) begin
        head <= (head+1)%64;
        RS_ALU_on[head] <=0;     
      end
 
 if (valid_entries1[head] == 1 && valid_entries2[head] == 1) begin
    result_out <= {operand2s[head], operand1s[head], inst_nums[head], 1'b1, Rds[head], MemToRegs[head], MemReads[head], MemWrites[head], ALUOPs[head], ALUSrc2s[head], funct3s[head], immediates[head]};
    operand1s[head] <= 0;
    operand2s[head] <= 0;
    valid_entries1[head] <= 0;
    valid_entries2[head] <= 0;
    head <= (head+1)%64;
end
else if (valid_entries1[(head + 1) % 64] == 1 && valid_entries2[(head + 1) % 64] == 1) begin
    result_out <= {operand2s[(head + 1) % 64], operand1s[(head + 1) % 64], inst_nums[(head + 1) % 64], 1'b1, Rds[(head + 1) % 64], MemToRegs[(head + 1) % 64], MemReads[(head + 1) % 64], MemWrites[(head + 1) % 64], ALUOPs[(head + 1) % 64], ALUSrc2s[(head + 1) % 64], funct3s[(head + 1) % 64], immediates[(head + 1) % 64]};
    operand1s[(head + 1) % 64] <= 0;
    operand2s[(head + 1) % 64] <= 0;
    valid_entries1[(head + 1) % 64] <= 0;
    valid_entries2[(head + 1) % 64] <= 0;
    RS_ALU_on[(head+1)%64] <= 1;
end
else if (valid_entries1[(head + 2) % 64] == 1 && valid_entries2[(head + 2) % 64] == 1) begin

        result_out <= {operand2s[(head + 2) % 64], operand1s[(head + 2) % 64], inst_nums[(head + 2) % 64], 1'b1, Rds[(head + 2) % 64], MemToRegs[(head + 2) % 64], MemReads[(head + 2) % 64], MemWrites[(head + 2) % 64], ALUOPs[(head + 2) % 64], ALUSrc2s[(head + 2) % 64], funct3s[(head + 2) % 64], immediates[(head + 2) % 64]};
  
    operand1s[(head + 2) % 64] <= 0;
    operand2s[(head + 2) % 64] <= 0;
    valid_entries1[(head + 2) % 64] <= 0;
    valid_entries2[(head + 2) % 64] <= 0;
    RS_ALU_on[(head+2)%64] <= 1;
end
else if (valid_entries1[(head + 3) % 64] == 1 && valid_entries2[(head + 3) % 64] == 1) begin

        result_out <= {operand2s[(head + 3) % 64], operand1s[(head + 3) % 64], inst_nums[(head + 3) % 64], 1'b1, Rds[(head + 3) % 64], MemToRegs[(head + 3) % 64], MemReads[(head + 3) % 64], MemWrites[(head + 3) % 64], ALUOPs[(head + 3) % 64], ALUSrc2s[(head + 3) % 64], funct3s[(head + 3) % 64], immediates[(head + 3) % 64]};
   
    operand1s[(head + 3) % 64] <= 0;
    operand2s[(head + 3) % 64] <= 0;
    valid_entries1[(head + 3) % 64] <= 0;
    valid_entries2[(head + 3) % 64] <= 0;
    RS_ALU_on[(head+3)%64] <= 1;
end
else if (valid_entries1[(head + 4) % 64] == 1 && valid_entries2[(head + 4) % 64] == 1) begin

        result_out <= {operand2s[(head + 4) % 64], operand1s[(head + 4) % 64], inst_nums[(head + 4) % 64], 1'b1, Rds[(head + 4) % 64], MemToRegs[(head + 4) % 64], MemReads[(head + 4) % 64], MemWrites[(head + 4) % 64], ALUOPs[(head + 4) % 64], ALUSrc2s[(head + 4) % 64], funct3s[(head + 4) % 64], immediates[(head + 4) % 64]};
    
    operand1s[(head + 4) % 64] <= 0;
    operand2s[(head + 4) % 64] <= 0;
    valid_entries1[(head + 4) % 64] <= 0;
    valid_entries2[(head + 4) % 64] <= 0;
    RS_ALU_on[(head+4)%64] <= 1;
end
else if (valid_entries1[(head + 5) % 64] == 1 && valid_entries2[(head + 5) % 64] == 1) begin
    
        result_out <= {operand2s[(head + 5) % 64], operand1s[(head + 5) % 64], inst_nums[(head + 5) % 64], 1'b1, Rds[(head + 5) % 64], MemToRegs[(head + 5) % 64], MemReads[(head + 5) % 64], MemWrites[(head + 5) % 64], ALUOPs[(head + 5) % 64], ALUSrc2s[(head + 5) % 64], funct3s[(head + 5) % 64], immediates[(head + 5) % 64]};
   
    operand1s[(head + 5) % 64] <= 0;
    operand2s[(head + 5) % 64] <= 0;
    valid_entries1[(head + 5) % 64] <= 0;
    valid_entries2[(head + 5) % 64] <= 0;
    RS_ALU_on[(head+5)%64] <= 1;
end
else if (valid_entries1[(head + 6) % 64] == 1 && valid_entries2[(head + 6) % 64] == 1) begin
   
        result_out <= {operand2s[(head + 6) % 64], operand1s[(head + 6) % 64], inst_nums[(head + 6) % 64], 1'b1, Rds[(head + 6) % 64], MemToRegs[(head + 6) % 64], MemReads[(head + 6) % 64], MemWrites[(head + 6) % 64], ALUOPs[(head + 6) % 64], ALUSrc2s[(head + 6) % 64], funct3s[(head + 6) % 64], immediates[(head + 6) % 64]};
   
    operand1s[(head + 6) % 64] <= 0;
    operand2s[(head + 6) % 64] <= 0;
    valid_entries1[(head + 6) % 64] <= 0;
    valid_entries2[(head + 6) % 64] <= 0;
    RS_ALU_on[(head+6)%64] <= 1;
end
else if (valid_entries1[(head + 7) % 64] == 1 && valid_entries2[(head + 7) % 64] == 1) begin
  
        result_out <= {operand2s[(head + 7) % 64], operand1s[(head + 7) % 64], inst_nums[(head + 7) % 64], 1'b1, Rds[(head + 7) % 64], MemToRegs[(head + 7) % 64], MemReads[(head + 7) % 64], MemWrites[(head + 7) % 64], ALUOPs[(head + 7) % 64], ALUSrc2s[(head + 7) % 64], funct3s[(head + 7) % 64], immediates[(head + 7) % 64]};
    
    operand1s[(head + 7) % 64] <= 0;
    operand2s[(head + 7) % 64] <= 0;
    valid_entries1[(head + 7) % 64] <= 0;
    valid_entries2[(head + 7) % 64] <= 0;
    RS_ALU_on[(head+7)%64] <= 1;
end
else if (valid_entries1[(head + 8) % 64] == 1 && valid_entries2[(head + 8) % 64] == 1) begin
   
        result_out <= {operand2s[(head + 8) % 64], operand1s[(head + 8) % 64], inst_nums[(head + 8) % 64], 1'b1, Rds[(head + 8) % 64], MemToRegs[(head + 8) % 64], MemReads[(head + 8) % 64], MemWrites[(head + 8) % 64], ALUOPs[(head + 8) % 64], ALUSrc2s[(head + 8) % 64], funct3s[(head + 8) % 64], immediates[(head + 8) % 64]};
   
    operand1s[(head + 8) % 64] <= 0;
    operand2s[(head + 8) % 64] <= 0;
    valid_entries1[(head + 8) % 64] <= 0;
    valid_entries2[(head + 8) % 64] <= 0;
    RS_ALU_on[(head+8)%64] <= 1;
end
else if (valid_entries1[(head + 9) % 64] == 1 && valid_entries2[(head + 9) % 64] == 1) begin
    
        result_out <= {operand2s[(head + 9) % 64], operand1s[(head + 9) % 64], inst_nums[(head + 9) % 64], 1'b1, Rds[(head + 9) % 64], MemToRegs[(head + 9) % 64], MemReads[(head + 9) % 64], MemWrites[(head + 9) % 64], ALUOPs[(head + 9) % 64], ALUSrc2s[(head + 9) % 64], funct3s[(head + 9) % 64], immediates[(head + 9) % 64]};
  
    operand1s[(head + 9) % 64] <= 0;
    operand2s[(head + 9) % 64] <= 0;
    valid_entries1[(head + 9) % 64] <= 0;
    valid_entries2[(head + 9) % 64] <= 0;
    RS_ALU_on[(head+9)%64] <= 1;
end
else if (valid_entries1[(head + 10) % 64] == 1 && valid_entries2[(head + 10) % 64] == 1) begin
    
        result_out <= {operand2s[(head + 10) % 64], operand1s[(head + 10) % 64], inst_nums[(head + 10) % 64], 1'b1, Rds[(head + 10) % 64], MemToRegs[(head + 10) % 64], MemReads[(head + 10) % 64], MemWrites[(head + 10) % 64], ALUOPs[(head + 10) % 64], ALUSrc2s[(head + 10) % 64], funct3s[(head + 10) % 64], immediates[(head + 10) % 64]};
    
    operand1s[(head + 10) % 64] <= 0;
    operand2s[(head + 10) % 64] <= 0;
    valid_entries1[(head + 10) % 64] <= 0;
    valid_entries2[(head + 10) % 64] <= 0;
    RS_ALU_on[(head+10)%64] <= 1;
end
else if (valid_entries1[(head + 11) % 64] == 1 && valid_entries2[(head + 11) % 64] == 1) begin
   
        result_out <= {operand2s[(head + 11) % 64], operand1s[(head + 11) % 64], inst_nums[(head + 11) % 64], 1'b1, Rds[(head + 11) % 64], MemToRegs[(head + 11) % 64], MemReads[(head + 11) % 64], MemWrites[(head + 11) % 64], ALUOPs[(head + 11) % 64], ALUSrc2s[(head + 11) % 64], funct3s[(head + 11) % 64], immediates[(head + 11) % 64]};
   
    operand1s[(head + 11) % 64] <= 0;
    operand2s[(head + 11) % 64] <= 0;
    valid_entries1[(head + 11) % 64] <= 0;
    valid_entries2[(head + 11) % 64] <= 0;
    RS_ALU_on[(head+11)%64] <= 1;
end
else if (valid_entries1[(head + 12) % 64] == 1 && valid_entries2[(head + 12) % 64] == 1) begin
    
        result_out <= {operand2s[(head + 12) % 64], operand1s[(head + 12) % 64], inst_nums[(head + 12) % 64], 1'b1, Rds[(head + 12) % 64], MemToRegs[(head + 12) % 64], MemReads[(head + 12) % 64], MemWrites[(head + 12) % 64], ALUOPs[(head + 12) % 64], ALUSrc2s[(head + 12) % 64], funct3s[(head + 12) % 64], immediates[(head + 12) % 64]};
    
    operand1s[(head + 12) % 64] <= 0;
    operand2s[(head + 12) % 64] <= 0;
    valid_entries1[(head + 12) % 64] <= 0;
    valid_entries2[(head + 12) % 64] <= 0;
    RS_ALU_on[(head+12)%64] <= 1;
end
else if (valid_entries1[(head + 13) % 64] == 1 && valid_entries2[(head + 13) % 64] == 1) begin
   
        result_out <= {operand2s[(head + 13) % 64], operand1s[(head + 13) % 64], inst_nums[(head + 13) % 64], 1'b1, Rds[(head + 13) % 64], MemToRegs[(head + 13) % 64], MemReads[(head + 13) % 64], MemWrites[(head + 13) % 64], ALUOPs[(head + 13) % 64], ALUSrc2s[(head + 13) % 64], funct3s[(head + 13) % 64], immediates[(head + 13) % 64]};
   
    operand1s[(head + 13) % 64] <= 0;
    operand2s[(head + 13) % 64] <= 0;
    valid_entries1[(head + 13) % 64] <= 0;
    valid_entries2[(head + 13) % 64] <= 0;
    RS_ALU_on[(head+13)%64] <= 1;
end
else if (valid_entries1[(head + 14) % 64] == 1 && valid_entries2[(head + 14) % 64] == 1) begin
    
        result_out <= {operand2s[(head + 14) % 64], operand1s[(head + 14) % 64], inst_nums[(head + 14) % 64], 1'b1, Rds[(head + 14) % 64], MemToRegs[(head + 14) % 64], MemReads[(head + 14) % 64], MemWrites[(head + 14) % 64], ALUOPs[(head + 14) % 64], ALUSrc2s[(head + 14) % 64], funct3s[(head + 14) % 64], immediates[(head + 14) % 64]};
   
    operand1s[(head + 14) % 64] <= 0;
    operand2s[(head + 14) % 64] <= 0;
    valid_entries1[(head + 14) % 64] <= 0;
    valid_entries2[(head + 14) % 64] <= 0;
    RS_ALU_on[(head+14)%64] <= 1;
end
else if (valid_entries1[(head + 15) % 64] == 1 && valid_entries2[(head + 15) % 64] == 1) begin
   
        result_out <= {operand2s[(head + 15) % 64], operand1s[(head + 15) % 64], inst_nums[(head + 15) % 64], 1'b1, Rds[(head + 15) % 64], MemToRegs[(head + 15) % 64], MemReads[(head + 15) % 64], MemWrites[(head + 15) % 64], ALUOPs[(head + 15) % 64], ALUSrc2s[(head + 15) % 64], funct3s[(head + 15) % 64], immediates[(head + 15) % 64]};
   
    operand1s[(head + 15) % 64] <= 0;
    operand2s[(head + 15) % 64] <= 0;
    valid_entries1[(head + 15) % 64] <= 0;
    valid_entries2[(head + 15) % 64] <= 0;
    RS_ALU_on[(head+15)%64] <= 1;
end
else if (valid_entries1[(head + 16) % 64] == 1 && valid_entries2[(head + 16) % 64] == 1) begin
    
        result_out <= {operand2s[(head + 16) % 64], operand1s[(head + 16) % 64], inst_nums[(head + 16) % 64], 1'b1, Rds[(head + 16) % 64], MemToRegs[(head + 16) % 64], MemReads[(head + 16) % 64], MemWrites[(head + 16) % 64], ALUOPs[(head + 16) % 64], ALUSrc2s[(head + 16) % 64], funct3s[(head + 16) % 64], immediates[(head + 16) % 64]};
    
    operand1s[(head + 16) % 64] <= 0;
    operand2s[(head + 16) % 64] <= 0;
    valid_entries1[(head + 16) % 64] <= 0;
    valid_entries2[(head + 16) % 64] <= 0;
    RS_ALU_on[(head+16)%64] <= 1;
end
else if (valid_entries1[(head + 17) % 64] == 1 && valid_entries2[(head + 17) % 64] == 1) begin
 
        result_out <= {operand2s[(head + 17) % 64], operand1s[(head + 17) % 64], inst_nums[(head + 17) % 64], 1'b1, Rds[(head + 17) % 64], MemToRegs[(head + 17) % 64], MemReads[(head + 17) % 64], MemWrites[(head + 17) % 64], ALUOPs[(head + 17) % 64], ALUSrc2s[(head + 17) % 64], funct3s[(head + 17) % 64], immediates[(head + 17) % 64]};
    
    operand1s[(head + 17) % 64] <= 0;
    operand2s[(head + 17) % 64] <= 0;
    valid_entries1[(head + 17) % 64] <= 0;
    valid_entries2[(head + 17) % 64] <= 0;
    RS_ALU_on[(head+17)%64] <= 1;
end
else if (valid_entries1[(head + 18) % 64] == 1 && valid_entries2[(head + 18) % 64] == 1) begin
   
        result_out <= {operand2s[(head + 18) % 64], operand1s[(head + 18) % 64], inst_nums[(head + 18) % 64], 1'b1, Rds[(head + 18) % 64], MemToRegs[(head + 18) % 64], MemReads[(head + 18) % 64], MemWrites[(head + 18) % 64], ALUOPs[(head + 18) % 64], ALUSrc2s[(head + 18) % 64], funct3s[(head + 18) % 64], immediates[(head + 18) % 64]};
    
    operand1s[(head + 18) % 64] <= 0;
    operand2s[(head + 18) % 64] <= 0;
    valid_entries1[(head + 18) % 64] <= 0;
    valid_entries2[(head + 18) % 64] <= 0;
    RS_ALU_on[(head+18)%64] <= 1;
end
else if (valid_entries1[(head + 19) % 64] == 1 && valid_entries2[(head + 19) % 64] == 1) begin
   
        result_out <= {operand2s[(head + 19) % 64], operand1s[(head + 19) % 64], inst_nums[(head + 19) % 64], 1'b1, Rds[(head + 19) % 64], MemToRegs[(head + 19) % 64], MemReads[(head + 19) % 64], MemWrites[(head + 19) % 64], ALUOPs[(head + 19) % 64], ALUSrc2s[(head + 19) % 64], funct3s[(head + 19) % 64], immediates[(head + 19) % 64]};
   
    operand1s[(head + 19) % 64] <= 0;
    operand2s[(head + 19) % 64] <= 0;
    valid_entries1[(head + 19) % 64] <= 0;
    valid_entries2[(head + 19) % 64] <= 0;
    RS_ALU_on[(head+19)%64] <= 1;
end
else if (valid_entries1[(head + 20) % 64] == 1 && valid_entries2[(head + 20) % 64] == 1) begin
  
        result_out <= {operand2s[(head + 20) % 64], operand1s[(head + 20) % 64], inst_nums[(head + 20) % 64], 1'b1, Rds[(head + 20) % 64], MemToRegs[(head + 20) % 64], MemReads[(head + 20) % 64], MemWrites[(head + 20) % 64], ALUOPs[(head + 20) % 64], ALUSrc2s[(head + 20) % 64], funct3s[(head + 20) % 64], immediates[(head + 20) % 64]};
    
    operand1s[(head + 20) % 64] <= 0;
    operand2s[(head + 20) % 64] <= 0;
    valid_entries1[(head + 20) % 64] <= 0;
    valid_entries2[(head + 20) % 64] <= 0;
    RS_ALU_on[(head+20)%64] <= 1;
end
else if (valid_entries1[(head + 21) % 64] == 1 && valid_entries2[(head + 21) % 64] == 1) begin
    
        result_out <= {operand2s[(head + 21) % 64], operand1s[(head + 21) % 64], inst_nums[(head + 21) % 64], 1'b1, Rds[(head + 21) % 64], MemToRegs[(head + 21) % 64], MemReads[(head + 21) % 64], MemWrites[(head + 21) % 64], ALUOPs[(head + 21) % 64], ALUSrc2s[(head + 21) % 64], funct3s[(head + 21) % 64], immediates[(head + 21) % 64]};
  
    operand1s[(head + 21) % 64] <= 0;
    operand2s[(head + 21) % 64] <= 0;
    valid_entries1[(head + 21) % 64] <= 0;
    valid_entries2[(head + 21) % 64] <= 0;
    RS_ALU_on[(head+21)%64] <= 1;
end
else if (valid_entries1[(head + 22) % 64] == 1 && valid_entries2[(head + 22) % 64] == 1) begin
   
        result_out <= {operand2s[(head + 22) % 64], operand1s[(head + 22) % 64], inst_nums[(head + 22) % 64], 1'b1, Rds[(head + 22) % 64], MemToRegs[(head + 22) % 64], MemReads[(head + 22) % 64], MemWrites[(head + 22) % 64], ALUOPs[(head + 22) % 64], ALUSrc2s[(head + 22) % 64], funct3s[(head + 22) % 64], immediates[(head + 22) % 64]};
   
    operand1s[(head + 22) % 64] <= 0;
    operand2s[(head + 22) % 64] <= 0;
    valid_entries1[(head + 22) % 64] <= 0;
    valid_entries2[(head + 22) % 64] <= 0;
    RS_ALU_on[(head+22)%64] <= 1;
end
else if (valid_entries1[(head + 23) % 64] == 1 && valid_entries2[(head + 23) % 64] == 1) begin
    
        result_out <= {operand2s[(head + 23) % 64], operand1s[(head + 23) % 64], inst_nums[(head + 23) % 64], 1'b1, Rds[(head + 23) % 64], MemToRegs[(head + 23) % 64], MemReads[(head + 23) % 64], MemWrites[(head + 23) % 64], ALUOPs[(head + 23) % 64], ALUSrc2s[(head + 23) % 64], funct3s[(head + 23) % 64], immediates[(head + 23) % 64]};
    
    operand1s[(head + 23) % 64] <= 0;
    operand2s[(head + 23) % 64] <= 0;
    valid_entries1[(head + 23) % 64] <= 0;
    valid_entries2[(head + 23) % 64] <= 0;
    RS_ALU_on[(head+23)%64] <= 1;
end
else if (valid_entries1[(head + 24) % 64] == 1 && valid_entries2[(head + 24) % 64] == 1) begin
    
        result_out <= {operand2s[(head + 24) % 64], operand1s[(head + 24) % 64], inst_nums[(head + 24) % 64], 1'b1, Rds[(head + 24) % 64], MemToRegs[(head + 24) % 64], MemReads[(head + 24) % 64], MemWrites[(head + 24) % 64], ALUOPs[(head + 24) % 64], ALUSrc2s[(head + 24) % 64], funct3s[(head + 24) % 64], immediates[(head + 24) % 64]};
   
    operand1s[(head + 24) % 64] <= 0;
    operand2s[(head + 24) % 64] <= 0;
    valid_entries1[(head + 24) % 64] <= 0;
    valid_entries2[(head + 24) % 64] <= 0;
    RS_ALU_on[(head+24)%64] <= 1;
end
else if (valid_entries1[(head + 25) % 64] == 1 && valid_entries2[(head + 25) % 64] == 1) begin
    
        result_out <= {operand2s[(head + 25) % 64], operand1s[(head + 25) % 64], inst_nums[(head + 25) % 64], 1'b1, Rds[(head + 25) % 64], MemToRegs[(head + 25) % 64], MemReads[(head + 25) % 64], MemWrites[(head + 25) % 64], ALUOPs[(head + 25) % 64], ALUSrc2s[(head + 25) % 64], funct3s[(head + 25) % 64], immediates[(head + 25) % 64]};
   
    operand1s[(head + 25) % 64] <= 0;
    operand2s[(head + 25) % 64] <= 0;
    valid_entries1[(head + 25) % 64] <= 0;
    valid_entries2[(head + 25) % 64] <= 0;
    RS_ALU_on[(head+25)%64] <= 1;
end
else if (valid_entries1[(head + 26) % 64] == 1 && valid_entries2[(head + 26) % 64] == 1) begin
  
        result_out <= {operand2s[(head + 26) % 64], operand1s[(head + 26) % 64], inst_nums[(head + 26) % 64], 1'b1, Rds[(head + 26) % 64], MemToRegs[(head + 26) % 64], MemReads[(head + 26) % 64], MemWrites[(head + 26) % 64], ALUOPs[(head + 26) % 64], ALUSrc2s[(head + 26) % 64], funct3s[(head + 26) % 64], immediates[(head + 26) % 64]};
   
    operand1s[(head + 26) % 64] <= 0;
    operand2s[(head + 26) % 64] <= 0;
    valid_entries1[(head + 26) % 64] <= 0;
    valid_entries2[(head + 26) % 64] <= 0;
    RS_ALU_on[(head+26)%64] <= 1;
end
else if (valid_entries1[(head + 27) % 64] == 1 && valid_entries2[(head + 27) % 64] == 1) begin
  
        result_out <= {operand2s[(head + 27) % 64], operand1s[(head + 27) % 64], inst_nums[(head + 27) % 64], 1'b1, Rds[(head + 27) % 64], MemToRegs[(head + 27) % 64], MemReads[(head + 27) % 64], MemWrites[(head + 27) % 64], ALUOPs[(head + 27) % 64], ALUSrc2s[(head + 27) % 64], funct3s[(head + 27) % 64], immediates[(head + 27) % 64]};
    
    operand1s[(head + 27) % 64] <= 0;
    operand2s[(head + 27) % 64] <= 0;
    valid_entries1[(head + 27) % 64] <= 0;
    valid_entries2[(head + 27) % 64] <= 0;
    RS_ALU_on[(head+27)%64] <= 1;
end
else if (valid_entries1[(head + 28) % 64] == 1 && valid_entries2[(head + 28) % 64] == 1) begin
   
        result_out <= {operand2s[(head + 28) % 64], operand1s[(head + 28) % 64], inst_nums[(head + 28) % 64], 1'b1, Rds[(head + 28) % 64], MemToRegs[(head + 28) % 64], MemReads[(head + 28) % 64], MemWrites[(head + 28) % 64], ALUOPs[(head + 28) % 64], ALUSrc2s[(head + 28) % 64], funct3s[(head + 28) % 64], immediates[(head + 28) % 64]};
    
    operand1s[(head + 28) % 64] <= 0;
    operand2s[(head + 28) % 64] <= 0;
    valid_entries1[(head + 28) % 64] <= 0;
    valid_entries2[(head + 28) % 64] <= 0;
    RS_ALU_on[(head+28)%64] <= 1;
end
else if (valid_entries1[(head + 29) % 64] == 1 && valid_entries2[(head + 29) % 64] == 1) begin
   
        result_out <= {operand2s[(head + 29) % 64], operand1s[(head + 29) % 64], inst_nums[(head + 29) % 64], 1'b1, Rds[(head + 29) % 64], MemToRegs[(head + 29) % 64], MemReads[(head + 29) % 64], MemWrites[(head + 29) % 64], ALUOPs[(head + 29) % 64], ALUSrc2s[(head + 29) % 64], funct3s[(head + 29) % 64], immediates[(head + 29) % 64]};
   
    operand1s[(head + 29) % 64] <= 0;
    operand2s[(head + 29) % 64] <= 0;
    valid_entries1[(head + 29) % 64] <= 0;
    valid_entries2[(head + 29) % 64] <= 0;
    RS_ALU_on[(head+29)%64] <= 1;
end
else if (valid_entries1[(head + 30) % 64] == 1 && valid_entries2[(head + 30) % 64] == 1) begin
    
        result_out <= {operand2s[(head + 30) % 64], operand1s[(head + 30) % 64], inst_nums[(head + 30) % 64], 1'b1, Rds[(head + 30) % 64], MemToRegs[(head + 30) % 64], MemReads[(head + 30) % 64], MemWrites[(head + 30) % 64], ALUOPs[(head + 30) % 64], ALUSrc2s[(head + 30) % 64], funct3s[(head + 30) % 64], immediates[(head + 30) % 64]};
   
    operand1s[(head + 30) % 64] <= 0;
    operand2s[(head + 30) % 64] <= 0;
    valid_entries1[(head + 30) % 64] <= 0;
    valid_entries2[(head + 30) % 64] <= 0;
    RS_ALU_on[(head+30)%64] <= 1;
end
else if (valid_entries1[(head + 31) % 64] == 1 && valid_entries2[(head + 31) % 64] == 1) begin
  
        result_out <= {operand2s[(head + 31) % 64], operand1s[(head + 31) % 64], inst_nums[(head + 31) % 64], 1'b1, Rds[(head + 31) % 64], MemToRegs[(head + 31) % 64], MemReads[(head + 31) % 64], MemWrites[(head + 31) % 64], ALUOPs[(head + 31) % 64], ALUSrc2s[(head + 31) % 64], funct3s[(head + 31) % 64], immediates[(head + 31) % 64]};

    operand1s[(head + 31) % 64] <= 0;
    operand2s[(head + 31) % 64] <= 0;
    valid_entries1[(head + 31) % 64] <= 0;
    valid_entries2[(head + 31) % 64] <= 0;
    RS_ALU_on[(head+31)%64] <= 1;
end
else begin
    result_out <= 0;
end



end
 endmodule
