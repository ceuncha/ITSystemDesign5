module RS_Mul (
    input wire clk,
    input wire reset,
    input wire RS_mul_start,
    input wire [31:0] RS_mul_PC,
    input wire [7:0] RS_mul_Rd,
    input wire EX_MEM_MemRead,
    input wire [7:0] EX_MEM_Physical_Address,
    input wire [7:0] RS_mul_operand1,
    input wire [7:0] RS_mul_operand2,
    input wire [1:0] RS_mul_valid,
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
    output reg [56:0] result_out
);

    // Internal storage for reservation station entries
   (* keep = "true" *) reg [31:0] PCs [0:63];
   (* keep = "true" *) reg [7:0] Rds [0:63];
   (* keep = "true" *) reg [3:0] ALUOPs [0:63];
   (* keep = "true" *) reg [7:0] operand1s [0:63];
   (* keep = "true" *) reg [7:0] operand2s [0:63];
   (* keep = "true" *) reg [63:0] valid_entries1;  // operand1??逾? valid??뇡?냲彛??
   (* keep = "true" *) reg [63:0] valid_entries2; // operand2?뤆?? valid??뇡?냲彛??
   (* keep = "true" *) reg [56:0] result [0:63];
   (* keep = "true" *) reg [5:0] tail;
   (* keep = "true" *) integer i;
   (* keep = "true" *) integer j;
   (* keep = "true" *) integer k;
   (* keep = "true" *) integer l;
   (* keep = "true" *) integer m;
   (* keep = "true" *) integer n;
    (* keep = "true" *) integer o;
   (* keep = "true" *) reg [6:0] head;
   (* keep = "true" *) reg RS_MUL_on[0:63];
   (* keep = "true" *)wire operand1_ALU_conflict = (operand1 == ALU_result_dest);
  (* keep = "true" *)wire operand1_MUL_conflict = (operand1 == MUL_result_dest);
  (* keep = "true" *)wire operand1_DIV_conflict = (operand1 == DIV_result_dest);
  (* keep = "true" *)wire operand1_MEM_conflict = (operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead == 1);
  (* keep = "true" *)wire operand1_BR_conflict = (operand1 == BR_Phy);
  (* keep = "true" *)wire operand1_P_conflict = (operand1 == P_Phy);
  (* keep = "true" *)wire operand1_CSR_conflict = (operand1 == CSR_Phy);
  (* keep = "true" *)wire operand1_conflict = operand1_ALU_conflict || operand1_MUL_conflict || operand1_DIV_conflict || operand1_MEM_conflict || operand1_BR_conflict || operand1_P_conflict || operand1_CSR_conflict;

   (* keep = "true" *)wire operand2_ALU_conflict = (operand2 == ALU_result_dest);
  (* keep = "true" *)wire operand2_MUL_conflict = (operand2 == MUL_result_dest);
  (* keep = "true" *)wire operand2_DIV_conflict = (operand2 == DIV_result_dest);
  (* keep = "true" *)wire operand2_MEM_conflict = (operand2 == EX_MEM_Physical_Address && EX_MEM_MemRead == 1);
   (* keep = "true" *)wire operand2_BR_conflict = (operand2 == BR_Phy);
   (* keep = "true" *)wire operand2_P_conflict = (operand2 == P_Phy);
  (* keep = "true" *)wire operand2_CSR_conflict = (operand2 == CSR_Phy);
  (* keep = "true" *)wire operand2_conflict = operand2_ALU_conflict || operand2_MUL_conflict || operand2_DIV_conflict || operand12_MEM_conflict || operand2_BR_conflict || operand2_P_conflict || operand2_CSR_conflict;

     always @(posedge clk ) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            for (i = 0; i < 64; i = i + 1) begin
                PCs[i] <= 0;
                Rds[i] <= 0;
                operand1s[i] <= 0;
                operand2s[i] <= 0;
                valid_entries1[i] <= 1'b0; // ?逾???봾?? ??六? ?猷???쐝?뵳寃쇱쾸沃섅굦紐드슖?? ?솻洹ｋ쾴??쐸
                valid_entries2[i] <= 1'b0; // ?逾???봾?? ??六? ?猷???쐝?뵳寃쇱쾸沃섅굦紐드슖?? ?솻洹ｋ쾴??쐸
                RS_MUL_on[i] <=0;
            end
        end else if (RS_mul_start) begin
            if ((operand1_conflict == 1'b1) && (operand1_conflict == 1'b0)) begin  // ALU??굢???땻? operand1??踰? ??굢??亦????逾? ?椰???亦????諭???뇡?
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_mul_valid[1];
                tail <= (tail + 1) % 64;
                 RS_MUL_on[tail] <=0;
            end else if ((operand1_conflict == 1'b0) && (operand1_conflict == 1'b1)) begin  // ALU??굢???땻? operand2??踰? ??굢??亦????逾? ?椰???亦????諭???뇡?
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                valid_entries1[tail] <= RS_mul_valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;  
                RS_MUL_on[tail] <=0; 
            end else if ((operand1_conflict == 1'b1) && (operand1_conflict == 1'b1)) begin  // MUL??굢???땻? operand1??踰? ??굢??亦????逾? ?椰???亦????諭???뇡?
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= 1;
                tail <= (tail + 1) % 64;
                RS_MUL_on[tail] <=0;
            end else begin
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                valid_entries1[tail] <= RS_mul_valid[0];
                valid_entries2[tail] <= RS_mul_valid[1]; 
                tail <= (tail + 1) % 64;
                RS_MUL_on[tail] <=0; 
             end 
             end
            if (ALU_result_valid) begin
                for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == ALU_result_dest) begin
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == ALU_result_dest) begin
                        valid_entries2[i] <= 1;
                    end
                end
            end
            if (MUL_result_valid) begin
                for (j = 0; j < 64; j = j + 1) begin
                    if (!valid_entries1[j] && operand1s[j] == MUL_result_dest) begin
                        valid_entries1[j] <= 1;
                    end
                    if (!valid_entries2[j] && operand2s[j] == MUL_result_dest) begin
                        valid_entries2[j] <= 1;
                    end
                end
            end
            if (DIV_result_valid) begin
                for (k = 0; k < 64; k = k + 1) begin
                    if (!valid_entries1[k] && operand1s[k] == DIV_result_dest) begin
                        valid_entries1[k] <= 1;
                    end
                    if (!valid_entries2[k] && operand2s[k] == DIV_result_dest) begin
                        valid_entries2[k] <= 1;
                    end
                end
            end
           if (EX_MEM_MemRead) begin
           for (l = 0; l < 64; l = l + 1) begin
                    if (!valid_entries1[l] && operand1s[l] == EX_MEM_Physical_Address) begin
                        valid_entries1[l] <= 1;
                    end
                    if (!valid_entries2[l] && operand2s[l] == EX_MEM_Physical_Address) begin
                        valid_entries2[l] <= 1;
                    end
                end     
            end
          if (Branch_result_valid) begin                //Branch?쓽 寃곌낵媛? ?뱾?뼱?솕?쓣?븣, 湲곗〈?뿉 RS?뿉 ?뱾?뼱?엳?뜕 紐낅졊?뼱?뱾怨? 臾쇰━二쇱냼瑜? 鍮꾧탳?븯?뿬
                                                        //?븘?슂?븳 媛믩뱾?쓣 ?뾽?뜲?씠?듃 ?떆耳쒖??떎.
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
                    if (!valid_entries1[l] && operand1s[l] == P_Phy) begin
                        valid_entries1[l] <= 1;
                    end
                    if (!valid_entries2[l] && operand2s[l] == P_Phy) begin
                        valid_entries2[l] <= 1;
                    end
                end     
            end

         if (CSR_Done) begin                 //alu?쓽 寃곌낵媛? ?뱾?뼱?솕?쓣?븣, 湲곗〈?뿉 RS?뿉 ?뱾?뼱?엳?뜕 紐낅졊?뼱?뱾怨? 臾쇰━二쇱냼瑜? 鍮꾧탳?븯?뿬
                                                        //?븘?슂?븳 媛믩뱾?쓣 ?뾽?뜲?씠?듃 ?떆耳쒖??떎.
                for (o = 0; o < 64; o = o + 1) begin
                    if (!valid_entries1[o] && operand1s[o] == CSR_Phy) begin
                        valid_entries1[o] <= 1;
                    end
                    if (!valid_entries2[o] && operand2s[o] == CSR_Phy) begin
                        valid_entries2[o] <= 1;
                    end
                end
            end
      



   if (RS_MUL_on[head]) begin
    head <= (head+1)%64;
    RS_MUL_on[head] <= 0;     
end

if (valid_entries1[head] == 1 && valid_entries2[head] == 1) begin
    result_out = {1'b1, PCs[head], Rds[head], operand1s[head], operand2s[head]};
    operand1s[head] <= 0;
    operand2s[head] <= 0;
    valid_entries1[head] <= 0;
    valid_entries2[head] <= 0;
    head <= (head+1)%64;
end
else if (valid_entries1[(head + 1) % 64] == 1 && valid_entries2[(head + 1) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 1) % 64], Rds[(head + 1) % 64], operand1s[(head + 1) % 64], operand2s[(head + 1) % 64]};
    operand1s[(head + 1) % 64] <= 0;
    operand2s[(head + 1) % 64] <= 0;
    valid_entries1[(head + 1) % 64] <= 0;
    valid_entries2[(head + 1) % 64] <= 0;
    RS_MUL_on[(head+1)%64] <= 1;
end
else if (valid_entries1[(head + 2) % 64] == 1 && valid_entries2[(head + 2) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 2) % 64], Rds[(head + 2) % 64], operand1s[(head + 2) % 64], operand2s[(head + 2) % 64]};
    operand1s[(head + 2) % 64] <= 0;
    operand2s[(head + 2) % 64] <= 0;
    valid_entries1[(head + 2) % 64] <= 0;
    valid_entries2[(head + 2) % 64] <= 0;
    RS_MUL_on[(head+2)%64] <= 1;
end
else if (valid_entries1[(head + 3) % 64] == 1 && valid_entries2[(head + 3) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 3) % 64], Rds[(head + 3) % 64], operand1s[(head + 3) % 64], operand2s[(head + 3) % 64]};
    operand1s[(head + 3) % 64] <= 0;
    operand2s[(head + 3) % 64] <= 0;
    valid_entries1[(head + 3) % 64] <= 0;
    valid_entries2[(head + 3) % 64] <= 0;
    RS_MUL_on[(head+3)%64] <= 1;
end
else if (valid_entries1[(head + 4) % 64] == 1 && valid_entries2[(head + 4) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 4) % 64], Rds[(head + 4) % 64], operand1s[(head + 4) % 64], operand2s[(head + 4) % 64]};
    operand1s[(head + 4) % 64] <= 0;
    operand2s[(head + 4) % 64] <= 0;
    valid_entries1[(head + 4) % 64] <= 0;
    valid_entries2[(head + 4) % 64] <= 0;
    RS_MUL_on[(head+4)%64] <= 1;
end
else if (valid_entries1[(head + 5) % 64] == 1 && valid_entries2[(head + 5) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 5) % 64], Rds[(head + 5) % 64], operand1s[(head + 5) % 64], operand2s[(head + 5) % 64]};
    operand1s[(head + 5) % 64] <= 0;
    operand2s[(head + 5) % 64] <= 0;
    valid_entries1[(head + 5) % 64] <= 0;
    valid_entries2[(head + 5) % 64] <= 0;
    RS_MUL_on[(head+5)%64] <= 1;
end
else if (valid_entries1[(head + 6) % 64] == 1 && valid_entries2[(head + 6) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 6) % 64], Rds[(head + 6) % 64], operand1s[(head + 6) % 64], operand2s[(head + 6) % 64]};
    operand1s[(head + 6) % 64] <= 0;
    operand2s[(head + 6) % 64] <= 0;
    valid_entries1[(head + 6) % 64] <= 0;
    valid_entries2[(head + 6) % 64] <= 0;
    RS_MUL_on[(head+6)%64] <= 1;
end
else if (valid_entries1[(head + 7) % 64] == 1 && valid_entries2[(head + 7) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 7) % 64], Rds[(head + 7) % 64], operand1s[(head + 7) % 64], operand2s[(head + 7) % 64]};
    operand1s[(head + 7) % 64] <= 0;
    operand2s[(head + 7) % 64] <= 0;
    valid_entries1[(head + 7) % 64] <= 0;
    valid_entries2[(head + 7) % 64] <= 0;
    RS_MUL_on[(head+7)%64] <= 1;
end
else if (valid_entries1[(head + 8) % 64] == 1 && valid_entries2[(head + 8) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 8) % 64], Rds[(head + 8) % 64], operand1s[(head + 8) % 64], operand2s[(head + 8) % 64]};
    operand1s[(head + 8) % 64] <= 0;
    operand2s[(head + 8) % 64] <= 0;
    valid_entries1[(head + 8) % 64] <= 0;
    valid_entries2[(head + 8) % 64] <= 0;
    RS_MUL_on[(head+8)%64] <= 1;
end
else if (valid_entries1[(head + 9) % 64] == 1 && valid_entries2[(head + 9) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 9) % 64], Rds[(head + 9) % 64], operand1s[(head + 9) % 64], operand2s[(head + 9) % 64]};
    operand1s[(head + 9) % 64] <= 0;
    operand2s[(head + 9) % 64] <= 0;
    valid_entries1[(head + 9) % 64] <= 0;
    valid_entries2[(head + 9) % 64] <= 0;
    RS_MUL_on[(head+9)%64] <= 1;
end
else if (valid_entries1[(head + 10) % 64] == 1 && valid_entries2[(head + 10) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 10) % 64], Rds[(head + 10) % 64], operand1s[(head + 10) % 64], operand2s[(head + 10) % 64]};
    operand1s[(head + 10) % 64] <= 0;
    operand2s[(head + 10) % 64] <= 0;
    valid_entries1[(head + 10) % 64] <= 0;
    valid_entries2[(head + 10) % 64] <= 0;
    RS_MUL_on[(head+10)%64] <= 1;
end
else if (valid_entries1[(head + 11) % 64] == 1 && valid_entries2[(head + 11) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 11) % 64], Rds[(head + 11) % 64], operand1s[(head + 11) % 64], operand2s[(head + 11) % 64]};
    operand1s[(head + 11) % 64] <= 0;
    operand2s[(head + 11) % 64] <= 0;
    valid_entries1[(head + 11) % 64] <= 0;
    valid_entries2[(head + 11) % 64] <= 0;
    RS_MUL_on[(head+11)%64] <= 1;
end
else if (valid_entries1[(head + 12) % 64] == 1 && valid_entries2[(head + 12) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 12) % 64], Rds[(head + 12) % 64], operand1s[(head + 12) % 64], operand2s[(head + 12) % 64]};
    operand1s[(head + 12) % 64] <= 0;
    operand2s[(head + 12) % 64] <= 0;
    valid_entries1[(head + 12) % 64] <= 0;
    valid_entries2[(head + 12) % 64] <= 0;
    RS_MUL_on[(head+12)%64] <= 1;
end
else if (valid_entries1[(head + 13) % 64] == 1 && valid_entries2[(head + 13) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 13) % 64], Rds[(head + 13) % 64], operand1s[(head + 13) % 64], operand2s[(head + 13) % 64]};
    operand1s[(head + 13) % 64] <= 0;
    operand2s[(head + 13) % 64] <= 0;
    valid_entries1[(head + 13) % 64] <= 0;
    valid_entries2[(head + 13) % 64] <= 0;
    RS_MUL_on[(head+13)%64] <= 1;
end
else if (valid_entries1[(head + 14) % 64] == 1 && valid_entries2[(head + 14) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 14) % 64], Rds[(head + 14) % 64], operand1s[(head + 14) % 64], operand2s[(head + 14) % 64]};
    operand1s[(head + 14) % 64] <= 0;
    operand2s[(head + 14) % 64] <= 0;
    valid_entries1[(head + 14) % 64] <= 0;
    valid_entries2[(head + 14) % 64] <= 0;
    RS_MUL_on[(head+14)%64] <= 1;
end
else if (valid_entries1[(head + 15) % 64] == 1 && valid_entries2[(head + 15) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 15) % 64], Rds[(head + 15) % 64], operand1s[(head + 15) % 64], operand2s[(head + 15) % 64]};
    operand1s[(head + 15) % 64] <= 0;
    operand2s[(head + 15) % 64] <= 0;
    valid_entries1[(head + 15) % 64] <= 0;
    valid_entries2[(head + 15) % 64] <= 0;
    RS_MUL_on[(head+15)%64] <= 1;
end
else if (valid_entries1[(head + 16) % 64] == 1 && valid_entries2[(head + 16) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 16) % 64], Rds[(head + 16) % 64], operand1s[(head + 16) % 64], operand2s[(head + 16) % 64]};
    operand1s[(head + 16) % 64] <= 0;
    operand2s[(head + 16) % 64] <= 0;
    valid_entries1[(head + 16) % 64] <= 0;
    valid_entries2[(head + 16) % 64] <= 0;
    RS_MUL_on[(head+16)%64] <= 1;
end
else if (valid_entries1[(head + 17) % 64] == 1 && valid_entries2[(head + 17) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 17) % 64], Rds[(head + 17) % 64], operand1s[(head + 17) % 64], operand2s[(head + 17) % 64]};
    operand1s[(head + 17) % 64] <= 0;
    operand2s[(head + 17) % 64] <= 0;
    valid_entries1[(head + 17) % 64] <= 0;
    valid_entries2[(head + 17) % 64] <= 0;
    RS_MUL_on[(head+17)%64] <= 1;
end
else if (valid_entries1[(head + 18) % 64] == 1 && valid_entries2[(head + 18) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 18) % 64], Rds[(head + 18) % 64], operand1s[(head + 18) % 64], operand2s[(head + 18) % 64]};
    operand1s[(head + 18) % 64] <= 0;
    operand2s[(head + 18) % 64] <= 0;
    valid_entries1[(head + 18) % 64] <= 0;
    valid_entries2[(head + 18) % 64] <= 0;
    RS_MUL_on[(head+18)%64] <= 1;
end
else if (valid_entries1[(head + 19) % 64] == 1 && valid_entries2[(head + 19) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 19) % 64], Rds[(head + 19) % 64], operand1s[(head + 19) % 64], operand2s[(head + 19) % 64]};
    operand1s[(head + 19) % 64] <= 0;
    operand2s[(head + 19) % 64] <= 0;
    valid_entries1[(head + 19) % 64] <= 0;
    valid_entries2[(head + 19) % 64] <= 0;
    RS_MUL_on[(head+19)%64] <= 1;
end
else if (valid_entries1[(head + 20) % 64] == 1 && valid_entries2[(head + 20) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 20) % 64], Rds[(head + 20) % 64], operand1s[(head + 20) % 64], operand2s[(head + 20) % 64]};
    operand1s[(head + 20) % 64] <= 0;
    operand2s[(head + 20) % 64] <= 0;
    valid_entries1[(head + 20) % 64] <= 0;
    valid_entries2[(head + 20) % 64] <= 0;
    RS_MUL_on[(head+20)%64] <= 1;
end
else if (valid_entries1[(head + 21) % 64] == 1 && valid_entries2[(head + 21) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 21) % 64], Rds[(head + 21) % 64], operand1s[(head + 21) % 64], operand2s[(head + 21) % 64]};
    operand1s[(head + 21) % 64] <= 0;
    operand2s[(head + 21) % 64] <= 0;
    valid_entries1[(head + 21) % 64] <= 0;
    valid_entries2[(head + 21) % 64] <= 0;
    RS_MUL_on[(head+21)%64] <= 1;
end
else if (valid_entries1[(head + 22) % 64] == 1 && valid_entries2[(head + 22) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 22) % 64], Rds[(head + 22) % 64], operand1s[(head + 22) % 64], operand2s[(head + 22) % 64]};
    operand1s[(head + 22) % 64] <= 0;
    operand2s[(head + 22) % 64] <= 0;
    valid_entries1[(head + 22) % 64] <= 0;
    valid_entries2[(head + 22) % 64] <= 0;
    RS_MUL_on[(head+22)%64] <= 1;
end
else if (valid_entries1[(head + 23) % 64] == 1 && valid_entries2[(head + 23) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 23) % 64], Rds[(head + 23) % 64], operand1s[(head + 23) % 64], operand2s[(head + 23) % 64]};
    operand1s[(head + 23) % 64] <= 0;
    operand2s[(head + 23) % 64] <= 0;
    valid_entries1[(head + 23) % 64] <= 0;
    valid_entries2[(head + 23) % 64] <= 0;
    RS_MUL_on[(head+23)%64] <= 1;
end
else if (valid_entries1[(head + 24) % 64] == 1 && valid_entries2[(head + 24) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 24) % 64], Rds[(head + 24) % 64], operand1s[(head + 24) % 64], operand2s[(head + 24) % 64]};
    operand1s[(head + 24) % 64] <= 0;
    operand2s[(head + 24) % 64] <= 0;
    valid_entries1[(head + 24) % 64] <= 0;
    valid_entries2[(head + 24) % 64] <= 0;
    RS_MUL_on[(head+24)%64] <= 1;
end
else if (valid_entries1[(head + 25) % 64] == 1 && valid_entries2[(head + 25) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 25) % 64], Rds[(head + 25) % 64], operand1s[(head + 25) % 64], operand2s[(head + 25) % 64]};
    operand1s[(head + 25) % 64] <= 0;
    operand2s[(head + 25) % 64] <= 0;
    valid_entries1[(head + 25) % 64] <= 0;
    valid_entries2[(head + 25) % 64] <= 0;
    RS_MUL_on[(head+25)%64] <= 1;
end
else if (valid_entries1[(head + 26) % 64] == 1 && valid_entries2[(head + 26) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 26) % 64], Rds[(head + 26) % 64], operand1s[(head + 26) % 64], operand2s[(head + 26) % 64]};
    operand1s[(head + 26) % 64] <= 0;
    operand2s[(head + 26) % 64] <= 0;
    valid_entries1[(head + 26) % 64] <= 0;
    valid_entries2[(head + 26) % 64] <= 0;
    RS_MUL_on[(head+26)%64] <= 1;
end
else if (valid_entries1[(head + 27) % 64] == 1 && valid_entries2[(head + 27) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 27) % 64], Rds[(head + 27) % 64], operand1s[(head + 27) % 64], operand2s[(head + 27) % 64]};
    operand1s[(head + 27) % 64] <= 0;
    operand2s[(head + 27) % 64] <= 0;
    valid_entries1[(head + 27) % 64] <= 0;
    valid_entries2[(head + 27) % 64] <= 0;
    RS_MUL_on[(head+27)%64] <= 1;
end
else if (valid_entries1[(head + 28) % 64] == 1 && valid_entries2[(head + 28) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 28) % 64], Rds[(head + 28) % 64], operand1s[(head + 28) % 64], operand2s[(head + 28) % 64]};
    operand1s[(head + 28) % 64] <= 0;
    operand2s[(head + 28) % 64] <= 0;
    valid_entries1[(head + 28) % 64] <= 0;
    valid_entries2[(head + 28) % 64] <= 0;
    RS_MUL_on[(head+28)%64] <= 1;
end
else if (valid_entries1[(head + 29) % 64] == 1 && valid_entries2[(head + 29) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 29) % 64], Rds[(head + 29) % 64], operand1s[(head + 29) % 64], operand2s[(head + 29) % 64]};
    operand1s[(head + 29) % 64] <= 0;
    operand2s[(head + 29) % 64] <= 0;
    valid_entries1[(head + 29) % 64] <= 0;
    valid_entries2[(head + 29) % 64] <= 0;
    RS_MUL_on[(head+29)%64] <= 1;
end
else if (valid_entries1[(head + 30) % 64] == 1 && valid_entries2[(head + 30) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 30) % 64], Rds[(head + 30) % 64], operand1s[(head + 30) % 64], operand2s[(head + 30) % 64]};
    operand1s[(head + 30) % 64] <= 0;
    operand2s[(head + 30) % 64] <= 0;
    valid_entries1[(head + 30) % 64] <= 0;
    valid_entries2[(head + 30) % 64] <= 0;
    RS_MUL_on[(head+30)%64] <= 1;
end
else if (valid_entries1[(head + 31) % 64] == 1 && valid_entries2[(head + 31) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 31) % 64], Rds[(head + 31) % 64], operand1s[(head + 31) % 64], operand2s[(head + 31) % 64]};
    operand1s[(head + 31) % 64] <= 0;
    operand2s[(head + 31) % 64] <= 0;
    valid_entries1[(head + 31) % 64] <= 0;
    valid_entries2[(head + 31) % 64] <= 0;
    RS_MUL_on[(head+31)%64] <= 1;
end

else begin
    result_out = 0;
end
end
endmodule
