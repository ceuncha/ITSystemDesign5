 module RS_LS (
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

 parameter SIZE = 32;
    
    // Internal storage for reservation station entries
  (* keep = "true" *) reg [31:0] inst_nums[0:SIZE-1];
  
    (* keep = "true" *) reg [7:0] Rds [0:SIZE-1];
   (* keep = "true" *) reg [SIZE-1:0] MemToRegs;
   (* keep = "true" *) reg [SIZE-1:0] MemReads;
   (* keep = "true" *) reg [SIZE-1:0] MemWrites;
   (* keep = "true" *) reg [3:0] ALUOPs [0:SIZE-1];

   (* keep = "true" *) reg [SIZE-1:0] ALUSrc2s;
   (* keep = "true" *) reg [2:0] funct3s [0:SIZE-1];
   (* keep = "true" *) reg [31:0] immediates [0:SIZE-1];
   (* keep = "true" *) reg [7:0] operand1s [0:SIZE-1];
   (* keep = "true" *) reg [7:0] operand2s [0:SIZE-1];

  (* keep = "true" *) reg valid_entries1 [0:SIZE-1];  
  (* keep = "true" *) reg valid_entries2 [0:SIZE-1]; 

   (* keep = "true" *) reg [4:0] current_block;
   (* keep = "true" *) reg [4:0] next_block;
    (* keep = "true" *) reg [4:0] out_block;

  (* keep = "true" *) integer i, j, k, l, m, n, o, p, q;
  (* keep = "true" *) reg RS_LS_on [0:SIZE-1];


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



    always @(posedge clk) begin    
     if (reset|exception_sig|mret_sig) begin
            for (i = 0; i < SIZE; i = i + 1) begin
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
                RS_LS_on[i] <=0; 
                current_block <= 0;
                next_block <= 1;
                out_block <= SIZE -1;
            end
        end else begin
        if (start) begin

                    operand1s[out_block] <= 0;
                    operand2s[out_block] <= 0;
                    valid_entries1[out_block] <= 0;
                    valid_entries2[out_block] <= 0;
                    RS_LS_on[out_block] <= 0;

            if (operand1_conflict && operand2_conflict) begin  
                inst_nums[current_block] <= RS_alu_inst_num;
               
                Rds[current_block] <= Rd;
                MemToRegs[current_block] <= MemToReg;
                MemReads[current_block] <= MemRead;
                MemWrites[current_block] <= MemWrite;
                ALUOPs[current_block] <= ALUOP;
               
                ALUSrc2s[current_block] <= ALUSrc2;
                funct3s[current_block] <= funct3;
                immediates[current_block] <= immediate;
                operand1s[current_block] <= operand1;
                operand2s[current_block] <= operand2;
                valid_entries1[current_block] <= 1;
                valid_entries2[current_block] <= 1;
                RS_LS_on[current_block] <=1;
            end else if (operand1_conflict) begin  
                inst_nums[current_block] <= RS_alu_inst_num;
               
                Rds[current_block] <= Rd;
                MemToRegs[current_block] <= MemToReg;
                MemReads[current_block] <= MemRead;
                MemWrites[current_block] <= MemWrite;
                ALUOPs[current_block] <= ALUOP;
               
                ALUSrc2s[current_block] <= ALUSrc2;
                funct3s[current_block] <= funct3;
                immediates[current_block] <= immediate;
                operand1s[current_block] <= operand1;
                operand2s[current_block] <= operand2;
                valid_entries1[current_block] <= 1;
                valid_entries2[current_block] <= valid[1];
                RS_LS_on[current_block] <=1;
            end else if (operand2_conflict) begin 
                inst_nums[current_block] <= RS_alu_inst_num;
               
                Rds[current_block] <= Rd;
                MemToRegs[current_block] <= MemToReg;
                MemReads[current_block] <= MemRead;
                MemWrites[current_block] <= MemWrite;
                ALUOPs[current_block] <= ALUOP;
               
                ALUSrc2s[current_block] <= ALUSrc2;
                funct3s[current_block] <= funct3;
                immediates[current_block] <= immediate;
                operand1s[current_block] <= operand1;
                operand2s[current_block] <= operand2;
                valid_entries1[current_block] <= valid[0];
                valid_entries2[current_block] <= 1;
                RS_LS_on[current_block] <=1;
               
            end else begin
                inst_nums[current_block] <= RS_alu_inst_num;
               
                Rds[current_block] <= Rd;
                MemToRegs[current_block] <= MemToReg;
                MemReads[current_block] <= MemRead;
                MemWrites[current_block] <= MemWrite;
                ALUOPs[current_block] <= ALUOP;
               
                ALUSrc2s[current_block] <= ALUSrc2;
                funct3s[current_block] <= funct3;
                immediates[current_block] <= immediate;
                operand1s[current_block] <= operand1;
                operand2s[current_block] <= operand2;
                valid_entries1[current_block] <= valid[0];
                valid_entries2[current_block] <= valid[1]; 
                RS_LS_on[current_block] <=1;
             end 

                for (p = SIZE-1; p >= 0; p = p - 1) begin
                 if(!RS_LS_on[p]) begin
                        if((p != current_block)&&(p != next_block)&&(p != out_block)) begin
                            next_block <= p;
                        end
                    end
                end
                current_block <= next_block;

             end
            

           
            if (ALU_result_valid) begin               
                for (i = 0; i < SIZE; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == ALU_result_dest) begin
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == ALU_result_dest) begin
                        valid_entries2[i] <= 1;
                    end
                end
            end
            if (MUL_result_valid) begin                   
                for (j = 0; j < SIZE; j = j + 1) begin
                    if (!valid_entries1[j] && operand1s[j] == MUL_result_dest) begin
                        valid_entries1[j] <= 1;
                    end
                    if (!valid_entries2[j] && operand2s[j] == MUL_result_dest) begin
                        valid_entries2[j] <= 1;
                    end
                end
            end
            if (DIV_result_valid) begin        
                for (k = 0; k < SIZE; k = k + 1) begin
                    if (!valid_entries1[k] && operand1s[k] == DIV_result_dest) begin
                        valid_entries1[k] <= 1;
                    end
                    if (!valid_entries2[k] && operand2s[k] == DIV_result_dest) begin
                        valid_entries2[k] <= 1;
                    end
                end
            end
           if (EX_MEM_MemRead) begin             
           for (l = 0; l < SIZE; l = l + 1) begin
                    if (!valid_entries1[l] && operand1s[l] == EX_MEM_Physical_Address) begin
                        valid_entries1[l] <= 1;
                    end
                    if (!valid_entries2[l] && operand2s[l] == EX_MEM_Physical_Address) begin
                        valid_entries2[l] <= 1;
                    end
                end     
            end
           if (Branch_result_valid) begin                
           for (m = 0; m < SIZE; m = m + 1) begin
                    if (!valid_entries1[m] && operand1s[m] == BR_Phy) begin
                        valid_entries1[m] <= 1;
                    end
                    if (!valid_entries2[m] && operand2s[m] == BR_Phy) begin
                        valid_entries2[m] <= 1;
                    end
                end     
            end
            if (P_Done) begin                
                for (n = 0; n < SIZE; n = n + 1) begin
                    if (!valid_entries1[n] && operand1s[n] == P_Phy) begin
                        valid_entries1[n] <= 1;
                    end
                    if (!valid_entries2[n] && operand2s[n] == P_Phy) begin
                        valid_entries2[n] <= 1;
                    end
                end
            end
         
            if (CSR_done) begin                
                for (o = 0; o < SIZE; o = o + 1) begin
                    if (!valid_entries1[o] && operand1s[o] == CSR_phy) begin
                        valid_entries1[o] <= 1;
                    end
                    if (!valid_entries2[o] && operand2s[o] == CSR_phy) begin
                        valid_entries2[o] <= 1;
                    end
                end
            end

         

           result_out <= 0;
            for (q = SIZE-1; q >= 0; q = q - 1) begin
                if ((valid_entries1[q] == 1 && valid_entries2[q] == 1)&&(q != out_block)) begin
                    result_out <= {operand2s[q], operand1s[q], inst_nums[q], 1'b1, Rds[q], MemToRegs[q], MemReads[q], MemWrites[q], ALUOPs[q], ALUSrc2s[q], funct3s[q], immediates[q]};
                    out_block <= q;
                end
            end


        end
    end
endmodule
