module RS_Div (
    input wire clk,
    input wire reset,
    input wire RS_div_start,
    input wire [31:0] RS_div_PC,
    input wire [7:0] RS_div_Rd,
    input wire [3:0] RS_div_ALUOP,
    input wire EX_MEM_MemRead,

    input wire [7:0] EX_MEM_Physical_Address,
    input wire [7:0] RS_div_operand1,
    input wire [7:0] RS_div_operand2,
    input wire [1:0] RS_div_valid,
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
    input wire CSR_Done,
    input wire [7:0] CSR_Phy,
    input wire exception_sig,
    input wire mret_sig,
    output reg [60:0] result_out
);
    parameter SIZE = 16;
    // Internal storage for reservation station entries
      (* keep = "true" *) reg [31:0] PCs [0:SIZE-1];
       (* keep = "true" *)reg [7:0] Rds [0:SIZE-1];
       (* keep = "true" *)reg [3:0] ALUOPs [0:SIZE-1];
      (* keep = "true" *) reg [7:0] operand1s [0:SIZE-1];
       (* keep = "true" *)reg [7:0] operand2s [0:SIZE-1];
      (* keep = "true" *)reg [SIZE-1:0] valid_entries1;  
      (* keep = "true" *) reg [SIZE-1:0] valid_entries2; 

      (* keep = "true" *) reg [3:0] current_block;
      (* keep = "true" *) reg [3:0] next_block;
     (* keep = "true" *) reg [3:0] out_block;
      (* keep = "true" *) integer i;
      (* keep = "true" *) integer j;
       (* keep = "true" *)integer k;
       (* keep = "true" *)integer l;
       (* keep = "true" *)integer m;
       (* keep = "true" *)integer n;
      (* keep = "true" *) integer o, p, q;
      (* keep = "true" *) reg RS_DIV_on[0:SIZE-1];
    
  (* keep = "true" *)wire operand1_ALU_conflict = ((RS_div_operand1 == ALU_result_dest)&&ALU_result_valid);
  (* keep = "true" *)wire operand1_MUL_conflict = ((RS_div_operand1 == MUL_result_dest)&&MUL_result_valid);
  (* keep = "true" *)wire operand1_DIV_conflict = ((RS_div_operand1 == DIV_result_dest)&&DIV_result_valid);
  (* keep = "true" *)wire operand1_MEM_conflict = ((RS_div_operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead == 1));
  (* keep = "true" *)wire operand1_BR_conflict = ((RS_div_operand1 == BR_Phy)&&Branch_result_valid);
  (* keep = "true" *)wire operand1_P_conflict = ((RS_div_operand1 == P_Phy)&&P_Done);
  (* keep = "true" *)wire operand1_CSR_conflict = ((RS_div_operand1 == CSR_Phy)&&CSR_Done);
  (* keep = "true" *)wire operand1_conflict = operand1_ALU_conflict || operand1_MUL_conflict || operand1_DIV_conflict || operand1_MEM_conflict || operand1_BR_conflict || operand1_P_conflict || operand1_CSR_conflict;

   (* keep = "true" *)wire operand2_ALU_conflict = ((RS_div_operand2 == ALU_result_dest)&&ALU_result_valid);
  (* keep = "true" *)wire operand2_MUL_conflict = ((RS_div_operand2 == MUL_result_dest)&&MUL_result_valid);
  (* keep = "true" *)wire operand2_DIV_conflict = ((RS_div_operand2 == DIV_result_dest)&&DIV_result_valid);
  (* keep = "true" *)wire operand2_MEM_conflict = (RS_div_operand2 == EX_MEM_Physical_Address && EX_MEM_MemRead == 1);
   (* keep = "true" *)wire operand2_BR_conflict = ((RS_div_operand2 == BR_Phy)&&Branch_result_valid);
   (* keep = "true" *)wire operand2_P_conflict = ((RS_div_operand2 == P_Phy)&&P_Done);
  (* keep = "true" *)wire operand2_CSR_conflict = ((RS_div_operand2 == CSR_Phy)&&CSR_Done);
  (* keep = "true" *)wire operand2_conflict = operand2_ALU_conflict || operand2_MUL_conflict || operand2_DIV_conflict || operand2_MEM_conflict || operand2_BR_conflict || operand2_P_conflict || operand2_CSR_conflict;

   always @(posedge clk) begin
   
       if (reset | exception_sig | mret_sig) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                PCs[i] <= 0;
                Rds[i] <= 0;
                ALUOPs[i] <= 0;
                operand1s[i] <= 0;
                operand2s[i] <= 0;
                valid_entries1[i] <= 1'b0; 
                valid_entries2[i] <= 1'b0; 
                RS_DIV_on[i] <= 0;
                current_block <= 0;
                next_block <= 1;
                out_block <= SIZE - 1;
            end
       end else begin
                    operand1s[out_block] <= 0;
                    operand2s[out_block] <= 0;
                    valid_entries1[out_block] <= 0;
                    valid_entries2[out_block] <= 0;
                    RS_DIV_on[out_block] <= 0;
         if (RS_div_start) begin
            if ((operand1_conflict == 1'b1) && (operand1_conflict == 1'b0)) begin  
                PCs[current_block] <= RS_div_PC;
                Rds[current_block] <= RS_div_Rd;
                ALUOPs[current_block] <= RS_div_ALUOP;
                operand1s[current_block] <= RS_div_operand1;
                operand2s[current_block] <= RS_div_operand2;
                valid_entries1[current_block] <= 1'b1;
                valid_entries2[current_block] <= RS_div_valid[1];
                RS_DIV_on[current_block] <= 1;
            end else if ((operand1_conflict == 1'b0) && (operand1_conflict == 1'b1)) begin  
                PCs[current_block] <= RS_div_PC;
                Rds[current_block] <= RS_div_Rd;
                ALUOPs[current_block] <= RS_div_ALUOP;
                operand1s[current_block] <= RS_div_operand1;
                operand2s[current_block] <= RS_div_operand2;
                valid_entries1[current_block] <= RS_div_valid[0];
                valid_entries2[current_block] <= 1'b1;
                RS_DIV_on[current_block] <= 1;
            end else if ((operand1_conflict == 1'b1) && (operand1_conflict == 1'b1)) begin  
                PCs[current_block] <= RS_div_PC;
                Rds[current_block] <= RS_div_Rd;
                ALUOPs[current_block] <= RS_div_ALUOP;
                operand1s[current_block] <= RS_div_operand1;
                operand2s[current_block] <= RS_div_operand2;
                valid_entries1[current_block] <= 1'b1;
                valid_entries2[current_block] <= 1'b1;
                RS_DIV_on[current_block] <= 1;
            end else begin
                PCs[current_block] <= RS_div_PC;
                Rds[current_block] <= RS_div_Rd;
                ALUOPs[current_block] <= RS_div_ALUOP;
                operand1s[current_block] <= RS_div_operand1;
                operand2s[current_block] <= RS_div_operand2;
                valid_entries1[current_block] <= RS_div_valid[0];
                valid_entries2[current_block] <= RS_div_valid[1]; 
                RS_DIV_on[current_block] <= 1;
             end 

                for (p = SIZE-1; p >= 0; p = p - 1) begin
                    if(!RS_DIV_on[p]) begin
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
         if (CSR_Done) begin                
          for (o = 0; o < SIZE; o = o + 1) begin
                 if (!valid_entries1[o] && operand1s[o] == CSR_Phy) begin
                        valid_entries1[o] <= 1;
                    end
                 if (!valid_entries2[o] && operand2s[o] == CSR_Phy) begin
                        valid_entries2[o] <= 1;
                    end
                end
            end
      
        result_out <= 0;


             for (q = SIZE-1; q >= 0; q = q - 1) begin
                 if ((valid_entries1[q] == 1 && valid_entries2[q] == 1)&&(q != out_block)) begin
                    result_out <= {1'b1, PCs[q], Rds[q], ALUOPs[q],  operand1s[q], operand2s[q]};
                    out_block <= q;
                end
            end
        end
   end
endmodule
