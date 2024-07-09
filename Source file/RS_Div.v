module RS_Div (
    input wire clk,
    input wire reset,
    input wire RS_div_start,
    input wire [31:0] RS_div_PC,
    input wire [7:0] RS_div_Rd,
    input wire [3:0] RS_div_ALUOP,
    input wire EX_MEM_MemRead,
    input wire [31:0] RData,
    input wire [7:0] EX_MEM_Physical_Address,
    input wire [7:0] RS_div_operand1,
    input wire [7:0] RS_div_operand2,
    input wire [31:0] RS_div_operand1_data,
    input wire [31:0] RS_div_operand2_data,
    input wire [1:0] RS_div_valid,
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
    output reg [108:0] result_out
);
    
    // Internal storage for reservation station entries
    reg [31:0] PCs [0:63];
    reg [7:0] Rds [0:63];
    reg [3:0] ALUOPs [0:63];
    reg [7:0] operand1s [0:63];
    reg [7:0] operand2s [0:63];
    reg [31:0] operand1_datas [0:63];  // operand1 data
    reg [31:0] operand2_datas [0:63]; // operand2 data
    reg [63:0] valid_entries1;  // operand1??뵠 valid?釉놂쭪?
    reg [63:0] valid_entries2; // operand2揶?? valid?釉놂쭪?
    reg [108:0] result [0:63];
    reg [5:0] tail;
    reg [63:0] readys;
    wire [63:0] Y;
    reg [6:0] head;
    integer i;
    reg RS_DIV_on[0:63];

   always @(posedge clk) begin
   
        if (reset) begin
            head <= 0;
            tail <= 0;
            for (i = 0; i < 64; i = i + 1) begin
                PCs[i] <= 0;
                Rds[i] <= 0;
                ALUOPs[i] <= 0;
                operand1s[i] <= 0;
                operand2s[i] <= 0;
                operand1_datas[i] <= 0;
                operand2_datas[i] <= 0;
                valid_entries1[i] <= 1'b0; // �뵳�딅�� ?�뻻 �룯�뜃由겼첎誘れ몵嚥�? 癰귣벊�뜚
                valid_entries2[i] <= 1'b0; // �뵳�딅�� ?�뻻 �룯�뜃由겼첎誘れ몵嚥�? 癰귣벊�뜚
                RS_DIV_on[i] <= 0;
            end
        end else if (RS_div_start) begin
            if (RS_div_operand1 == ALU_result_dest) begin  // ALU?肉�?苑� operand1?�벥 ?肉�?沅�?�뵠 ?嫄�?沅�?�뱽?釉�
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                ALUOPs[tail] <= RS_div_ALUOP;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= ALU_result;
                operand2_datas[tail] <= RS_div_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_div_valid[1];
                tail <= (tail + 1) % 64;
                RS_DIV_on[tail] <= 0;
            end else if (RS_div_operand2 == ALU_result_dest) begin  // ALU?肉�?苑� operand2?�벥 ?肉�?沅�?�뵠 ?嫄�?沅�?�뱽?釉�
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                ALUOPs[tail] <= RS_div_ALUOP;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RS_div_operand1_data;
                operand2_datas[tail] <= ALU_result;
                valid_entries1[tail] <= RS_div_valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;   
                RS_DIV_on[tail] <= 0;
             end else if (RS_div_operand1 == MUL_result_dest) begin  // MUL?肉�?苑� operand1?�벥 ?肉�?沅�?�뵠 ?嫄�?沅�?�뱽?釉�
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                ALUOPs[tail] <= RS_div_ALUOP;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= MUL_result;
                operand2_datas[tail] <= RS_div_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_div_valid[1];
                tail <= (tail + 1) % 64;
                 RS_DIV_on[tail] <= 0;
             end else if (RS_div_operand2 == MUL_result_dest) begin  // MUL?肉�?苑� operand2?�벥 ?肉�?沅�?�뵠 ?嫄�?沅�?�뱽?釉�
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                ALUOPs[tail] <= RS_div_ALUOP;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RS_div_operand1_data;
                operand2_datas[tail] <= MUL_result;
                valid_entries1[tail] <= RS_div_valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;
                 RS_DIV_on[tail] <= 0;
              end else if (RS_div_operand1 == DIV_result_dest) begin  // DIV?肉�?苑� operand1?�벥 ?肉�?沅�?�뵠 ?嫄�?沅�?�뱽?釉�
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                ALUOPs[tail] <= RS_div_ALUOP;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= DIV_result;
                operand2_datas[tail] <= RS_div_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_div_valid[1];
                tail <= (tail + 1) % 64;
                RS_DIV_on[tail] <= 0;
              end else if (RS_div_operand2 == DIV_result_dest) begin  // MUL?肉�?苑� operand2?�벥 ?肉�?沅�?�뵠 ?嫄�?沅�?�뱽?釉�
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                ALUOPs[tail] <= RS_div_ALUOP;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RS_div_operand1_data;
                operand2_datas[tail] <= DIV_result;
                valid_entries1[tail] <= RS_div_valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;
                RS_DIV_on[tail] <= 0;
             end else if ( RS_div_operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                ALUOPs[tail] <= RS_div_ALUOP;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RData;
                operand2_datas[tail] <= RS_div_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_div_valid[1] ; 
                tail <= (tail + 1) % 64;
                RS_DIV_on[tail] <= 0;
              end else if ( RS_div_operand2 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                ALUOPs[tail] <= RS_div_ALUOP;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RS_div_operand1_data;
                operand2_datas[tail] <= RData;
                valid_entries1[tail] <= RS_div_valid[0];
                valid_entries2[tail] <= 1 ; 
                tail <= (tail + 1) % 64;
                RS_DIV_on[tail] <= 0;
            end else begin
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                ALUOPs[tail] <= RS_div_ALUOP;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RS_div_operand1_data;
                operand2_datas[tail] <= RS_div_operand2_data ;
                valid_entries1[tail] <= RS_div_valid[0];
                valid_entries2[tail] <= RS_div_valid[1]; 
                tail <= (tail + 1) % 64;
                RS_DIV_on[tail] <= 0;
             end 
             end
            if (ALU_result_valid) begin
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
            if (MUL_result_valid) begin
                for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == MUL_result_dest) begin
                        operand1_datas[i] <= MUL_result;
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == MUL_result_dest) begin
                        operand2_datas[i] <= MUL_result;
                        valid_entries2[i] <= 1;
                    end
                end
            end
            if (DIV_result_valid) begin
                for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == DIV_result_dest) begin
                        operand1_datas[i] <= DIV_result;
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == DIV_result_dest) begin
                        operand2_datas[i] <= DIV_result;
                        valid_entries2[i] <= 1;
                    end
                end
            end
           if (EX_MEM_MemRead) begin
           for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == EX_MEM_Physical_Address) begin
                        operand1_datas[i] <= RData;
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == EX_MEM_Physical_Address) begin
                        operand2_datas[i] <= RData;
                        valid_entries2[i] <= 1;
                    end
                end     
            end
          if (Branch_result_valid) begin                //Branch의 결과가 들어왔을때, 기존에 RS에 들어있던 명령어들과 물리주소를 비교하여
                                                        //필요한 값들을 업데이트 시켜준다.
           for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == BR_Phy) begin
                        operand1_datas[i] <= PC_Return;
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == BR_Phy) begin
                        operand2_datas[i] <= PC_Return;
                        valid_entries2[i] <= 1;
                    end
                end     
            end
         
      

if (RS_DIV_on[head]) begin
    head <= (head+1)%64;
    RS_DIV_on[head] <= 0;     
end

if (valid_entries1[head] == 1 && valid_entries2[head] == 1) begin
    result_out = {1'b1, PCs[head], Rds[head], ALUOPs[head],  operand1_datas[head], operand2_datas[head]};
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
    result_out = {1'b1, PCs[(head + 1) % 64], Rds[(head + 1) % 64], ALUOPs[(head + 1) % 64], operand1_datas[(head + 1) % 64], operand2_datas[(head + 1) % 64]};
    readys[(head + 1) % 64] <= 0;
    operand1s[(head + 1) % 64] <= 0;
    operand2s[(head + 1) % 64] <= 0;
    operand1_datas[(head + 1) % 64] <= 0;
    operand2_datas[(head + 1) % 64] <= 0;
    valid_entries1[(head + 1) % 64] <= 0;
    valid_entries2[(head + 1) % 64] <= 0;
    RS_DIV_on[(head+1)%64] <= 1;
end
else if (valid_entries1[(head + 2) % 64] == 1 && valid_entries2[(head + 2) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 2) % 64], Rds[(head + 2) % 64], ALUOPs[(head + 2) % 64], operand1_datas[(head + 2) % 64], operand2_datas[(head + 2) % 64]};
    readys[(head + 2) % 64] <= 0;
    operand1s[(head + 2) % 64] <= 0;
    operand2s[(head + 2) % 64] <= 0;
    operand1_datas[(head + 2) % 64] <= 0;
    operand2_datas[(head + 2) % 64] <= 0;
    valid_entries1[(head + 2) % 64] <= 0;
    valid_entries2[(head + 2) % 64] <= 0;
    RS_DIV_on[(head+2)%64] <= 1;
end
else if (valid_entries1[(head + 3) % 64] == 1 && valid_entries2[(head + 3) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 3) % 64], Rds[(head + 3) % 64], ALUOPs[(head + 3) % 64], operand1_datas[(head + 3) % 64], operand2_datas[(head + 3) % 64]};
    readys[(head + 3) % 64] <= 0;
    operand1s[(head + 3) % 64] <= 0;
    operand2s[(head + 3) % 64] <= 0;
    operand1_datas[(head + 3) % 64] <= 0;
    operand2_datas[(head + 3) % 64] <= 0;
    valid_entries1[(head + 3) % 64] <= 0;
    valid_entries2[(head + 3) % 64] <= 0;
    RS_DIV_on[(head+3)%64] <= 1;
end
else if (valid_entries1[(head + 4) % 64] == 1 && valid_entries2[(head + 4) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 4) % 64], Rds[(head + 4) % 64], ALUOPs[(head + 4) % 64], operand1_datas[(head + 4) % 64], operand2_datas[(head + 4) % 64]};
    readys[(head + 4) % 64] <= 0;
    operand1s[(head + 4) % 64] <= 0;
    operand2s[(head + 4) % 64] <= 0;
    operand1_datas[(head + 4) % 64] <= 0;
    operand2_datas[(head + 4) % 64] <= 0;
    valid_entries1[(head + 4) % 64] <= 0;
    valid_entries2[(head + 4) % 64] <= 0;
    RS_DIV_on[(head+4)%64] <= 1;
end
else if (valid_entries1[(head + 5) % 64] == 1 && valid_entries2[(head + 5) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 5) % 64], Rds[(head + 5) % 64], ALUOPs[(head + 5) % 64], operand1_datas[(head + 5) % 64], operand2_datas[(head + 5) % 64]};
    readys[(head + 5) % 64] <= 0;
    operand1s[(head + 5) % 64] <= 0;
    operand2s[(head + 5) % 64] <= 0;
    operand1_datas[(head + 5) % 64] <= 0;
    operand2_datas[(head + 5) % 64] <= 0;
    valid_entries1[(head + 5) % 64] <= 0;
    valid_entries2[(head + 5) % 64] <= 0;
    RS_DIV_on[(head+5)%64] <= 1;
end
else if (valid_entries1[(head + 6) % 64] == 1 && valid_entries2[(head + 6) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 6) % 64], Rds[(head + 6) % 64], ALUOPs[(head + 6) % 64], operand1_datas[(head + 6) % 64], operand2_datas[(head + 6) % 64]};
    readys[(head + 6) % 64] <= 0;
    operand1s[(head + 6) % 64] <= 0;
    operand2s[(head + 6) % 64] <= 0;
    operand1_datas[(head + 6) % 64] <= 0;
    operand2_datas[(head + 6) % 64] <= 0;
    valid_entries1[(head + 6) % 64] <= 0;
    valid_entries2[(head + 6) % 64] <= 0;
    RS_DIV_on[(head + 6) % 64] <= 1;
end
else if (valid_entries1[(head + 7) % 64] == 1 && valid_entries2[(head + 7) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 7) % 64], Rds[(head + 7) % 64], ALUOPs[(head + 7) % 64], operand1_datas[(head + 7) % 64], operand2_datas[(head + 7) % 64]};
    readys[(head + 7) % 64] <= 0;
    operand1s[(head + 7) % 64] <= 0;
    operand2s[(head + 7) % 64] <= 0;
    operand1_datas[(head + 7) % 64] <= 0;
    operand2_datas[(head + 7) % 64] <= 0;
    valid_entries1[(head + 7) % 64] <= 0;
    valid_entries2[(head + 7) % 64] <= 0;
    RS_DIV_on[(head + 7) % 64] <= 1;
end
else if (valid_entries1[(head + 8) % 64] == 1 && valid_entries2[(head + 8) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 8) % 64], Rds[(head + 8) % 64], ALUOPs[(head + 8) % 64], operand1_datas[(head + 8) % 64], operand2_datas[(head + 8) % 64]};
    readys[(head + 8) % 64] <= 0;
    operand1s[(head + 8) % 64] <= 0;
    operand2s[(head + 8) % 64] <= 0;
    operand1_datas[(head + 8) % 64] <= 0;
    operand2_datas[(head + 8) % 64] <= 0;
    valid_entries1[(head + 8) % 64] <= 0;
    valid_entries2[(head + 8) % 64] <= 0;
    RS_DIV_on[(head + 8) % 64] <= 1;
end
else if (valid_entries1[(head + 9) % 64] == 1 && valid_entries2[(head + 9) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 9) % 64], Rds[(head + 9) % 64], ALUOPs[(head + 9) % 64], operand1_datas[(head + 9) % 64], operand2_datas[(head + 9) % 64]};
    readys[(head + 9) % 64] <= 0;
    operand1s[(head + 9) % 64] <= 0;
    operand2s[(head + 9) % 64] <= 0;
    operand1_datas[(head + 9) % 64] <= 0;
    operand2_datas[(head + 9) % 64] <= 0;
    valid_entries1[(head + 9) % 64] <= 0;
    valid_entries2[(head + 9) % 64] <= 0;
    RS_DIV_on[(head + 9) % 64] <= 1;
end
else if (valid_entries1[(head + 10) % 64] == 1 && valid_entries2[(head + 10) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 10) % 64], Rds[(head + 10) % 64], ALUOPs[(head + 10) % 64], operand1_datas[(head + 10) % 64], operand2_datas[(head + 10) % 64]};
    readys[(head + 10) % 64] <= 0;
    operand1s[(head + 10) % 64] <= 0;
    operand2s[(head + 10) % 64] <= 0;
    operand1_datas[(head + 10) % 64] <= 0;
    operand2_datas[(head + 10) % 64] <= 0;
    valid_entries1[(head + 10) % 64] <= 0;
    valid_entries2[(head + 10) % 64] <= 0;
    RS_DIV_on[(head + 10) % 64] <= 1;
end
else if (valid_entries1[(head + 11) % 64] == 1 && valid_entries2[(head + 11) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 11) % 64], Rds[(head + 11) % 64], ALUOPs[(head + 11) % 64], operand1_datas[(head + 11) % 64], operand2_datas[(head + 11) % 64]};
    readys[(head + 11) % 64] <= 0;
    operand1s[(head + 11) % 64] <= 0;
    operand2s[(head + 11) % 64] <= 0;
    operand1_datas[(head + 11) % 64] <= 0;
    operand2_datas[(head + 11) % 64] <= 0;
    valid_entries1[(head + 11) % 64] <= 0;
    valid_entries2[(head + 11) % 64] <= 0;
    RS_DIV_on[(head + 11) % 64] <= 1;
end
else if (valid_entries1[(head + 12) % 64] == 1 && valid_entries2[(head + 12) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 12) % 64], Rds[(head + 12) % 64], ALUOPs[(head + 12) % 64], operand1_datas[(head + 12) % 64], operand2_datas[(head + 12) % 64]};
    readys[(head + 12) % 64] <= 0;
    operand1s[(head + 12) % 64] <= 0;
    operand2s[(head + 12) % 64] <= 0;
    operand1_datas[(head + 12) % 64] <= 0;
    operand2_datas[(head + 12) % 64] <= 0;
    valid_entries1[(head + 12) % 64] <= 0;
    valid_entries2[(head + 12) % 64] <= 0;
    RS_DIV_on[(head + 12) % 64] <= 1;
end
else if (valid_entries1[(head + 13) % 64] == 1 && valid_entries2[(head + 13) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 13) % 64], Rds[(head + 13) % 64], ALUOPs[(head + 13) % 64], operand1_datas[(head + 13) % 64], operand2_datas[(head + 13) % 64]};
    readys[(head + 13) % 64] <= 0;
    operand1s[(head + 13) % 64] <= 0;
    operand2s[(head + 13) % 64] <= 0;
    operand1_datas[(head + 13) % 64] <= 0;
    operand2_datas[(head + 13) % 64] <= 0;
    valid_entries1[(head + 13) % 64] <= 0;
    valid_entries2[(head + 13) % 64] <= 0;
    RS_DIV_on[(head + 13) % 64] <= 1;
end
else if (valid_entries1[(head + 14) % 64] == 1 && valid_entries2[(head + 14) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 14) % 64], Rds[(head + 14) % 64], ALUOPs[(head + 14) % 64], operand1_datas[(head + 14) % 64], operand2_datas[(head + 14) % 64]};
    readys[(head + 14) % 64] <= 0;
    operand1s[(head + 14) % 64] <= 0;
    operand2s[(head + 14) % 64] <= 0;
    operand1_datas[(head + 14) % 64] <= 0;
    operand2_datas[(head + 14) % 64] <= 0;
    valid_entries1[(head + 14) % 64] <= 0;
    valid_entries2[(head + 14) % 64] <= 0;
    RS_DIV_on[(head + 14) % 64] <= 1;
end
else if (valid_entries1[(head + 15) % 64] == 1 && valid_entries2[(head + 15) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 15) % 64], Rds[(head + 15) % 64], ALUOPs[(head + 15) % 64], operand1_datas[(head + 15) % 64], operand2_datas[(head + 15) % 64]};
    readys[(head + 15) % 64] <= 0;
    operand1s[(head + 15) % 64] <= 0;
    operand2s[(head + 15) % 64] <= 0;
    operand1_datas[(head + 15) % 64] <= 0;
    operand2_datas[(head + 15) % 64] <= 0;
    valid_entries1[(head + 15) % 64] <= 0;
    valid_entries2[(head + 15) % 64] <= 0;
    RS_DIV_on[(head + 15) % 64] <= 1;
end
else if (valid_entries1[(head + 16) % 64] == 1 && valid_entries2[(head + 16) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 16) % 64], Rds[(head + 16) % 64], ALUOPs[(head + 16) % 64], operand1_datas[(head + 16) % 64], operand2_datas[(head + 16) % 64]};
    readys[(head + 16) % 64] <= 0;
    operand1s[(head + 16) % 64] <= 0;
    operand2s[(head + 16) % 64] <= 0;
    operand1_datas[(head + 16) % 64] <= 0;
    operand2_datas[(head + 16) % 64] <= 0;
    valid_entries1[(head + 16) % 64] <= 0;
    valid_entries2[(head + 16) % 64] <= 0;
    RS_DIV_on[(head + 16) % 64] <= 1;
end
else if (valid_entries1[(head + 17) % 64] == 1 && valid_entries2[(head + 17) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 17) % 64], Rds[(head + 17) % 64], ALUOPs[(head + 17) % 64], operand1_datas[(head + 17) % 64], operand2_datas[(head + 17) % 64]};
    readys[(head + 17) % 64] <= 0;
    operand1s[(head + 17) % 64] <= 0;
    operand2s[(head + 17) % 64] <= 0;
    operand1_datas[(head + 17) % 64] <= 0;
    operand2_datas[(head + 17) % 64] <= 0;
    valid_entries1[(head + 17) % 64] <= 0;
    valid_entries2[(head + 17) % 64] <= 0;
    RS_DIV_on[(head + 17) % 64] <= 1;
end
else if (valid_entries1[(head + 18) % 64] == 1 && valid_entries2[(head + 18) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 18) % 64], Rds[(head + 18) % 64], ALUOPs[(head + 18) % 64], operand1_datas[(head + 18) % 64], operand2_datas[(head + 18) % 64]};
    readys[(head + 18) % 64] <= 0;
    operand1s[(head + 18) % 64] <= 0;
    operand2s[(head + 18) % 64] <= 0;
    operand1_datas[(head + 18) % 64] <= 0;
    operand2_datas[(head + 18) % 64] <= 0;
    valid_entries1[(head + 18) % 64] <= 0;
    valid_entries2[(head + 18) % 64] <= 0;
    RS_DIV_on[(head + 18) % 64] <= 1;
end
else if (valid_entries1[(head + 19) % 64] == 1 && valid_entries2[(head + 19) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 19) % 64], Rds[(head + 19) % 64], ALUOPs[(head + 19) % 64], operand1_datas[(head + 19) % 64], operand2_datas[(head + 19) % 64]};
    readys[(head + 19) % 64] <= 0;
    operand1s[(head + 19) % 64] <= 0;
    operand2s[(head + 19) % 64] <= 0;
    operand1_datas[(head + 19) % 64] <= 0;
    operand2_datas[(head + 19) % 64] <= 0;
    valid_entries1[(head + 19) % 64] <= 0;
    valid_entries2[(head + 19) % 64] <= 0;
    RS_DIV_on[(head + 19) % 64] <= 1;
end
else if (valid_entries1[(head + 20) % 64] == 1 && valid_entries2[(head + 20) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 20) % 64], Rds[(head + 20) % 64], ALUOPs[(head + 20) % 64], operand1_datas[(head + 20) % 64], operand2_datas[(head + 20) % 64]};
    readys[(head + 20) % 64] <= 0;
    operand1s[(head + 20) % 64] <= 0;
    operand2s[(head + 20) % 64] <= 0;
    operand1_datas[(head + 20) % 64] <= 0;
    operand2_datas[(head + 20) % 64] <= 0;
    valid_entries1[(head + 20) % 64] <= 0;
    valid_entries2[(head + 20) % 64] <= 0;
    RS_DIV_on[(head + 20) % 64] <= 1;
end
else if (valid_entries1[(head + 21) % 64] == 1 && valid_entries2[(head + 21) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 21) % 64], Rds[(head + 21) % 64], ALUOPs[(head + 21) % 64], operand1_datas[(head + 21) % 64], operand2_datas[(head + 21) % 64]};
    readys[(head + 21) % 64] <= 0;
    operand1s[(head + 21) % 64] <= 0;
    operand2s[(head + 21) % 64] <= 0;
    operand1_datas[(head + 21) % 64] <= 0;
    operand2_datas[(head + 21) % 64] <= 0;
    valid_entries1[(head + 21) % 64] <= 0;
    valid_entries2[(head + 21) % 64] <= 0;
    RS_DIV_on[(head + 21) % 64] <= 1;
end
else if (valid_entries1[(head + 22) % 64] == 1 && valid_entries2[(head + 22) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 22) % 64], Rds[(head + 22) % 64], ALUOPs[(head + 22) % 64], operand1_datas[(head + 22) % 64], operand2_datas[(head + 22) % 64]};
    readys[(head + 22) % 64] <= 0;
    operand1s[(head + 22) % 64] <= 0;
    operand2s[(head + 22) % 64] <= 0;
    operand1_datas[(head + 22) % 64] <= 0;
    operand2_datas[(head + 22) % 64] <= 0;
    valid_entries1[(head + 22) % 64] <= 0;
    valid_entries2[(head + 22) % 64] <= 0;
    RS_DIV_on[(head + 22) % 64] <= 1;
end
else if (valid_entries1[(head + 23) % 64] == 1 && valid_entries2[(head + 23) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 23) % 64], Rds[(head + 23) % 64], ALUOPs[(head + 23) % 64], operand1_datas[(head + 23) % 64], operand2_datas[(head + 23) % 64]};
    readys[(head + 23) % 64] <= 0;
    operand1s[(head + 23) % 64] <= 0;
    operand2s[(head + 23) % 64] <= 0;
    operand1_datas[(head + 23) % 64] <= 0;
    operand2_datas[(head + 23) % 64] <= 0;
    valid_entries1[(head + 23) % 64] <= 0;
    valid_entries2[(head + 23) % 64] <= 0;
    RS_DIV_on[(head + 23) % 64] <= 1;
end
else if (valid_entries1[(head + 24) % 64] == 1 && valid_entries2[(head + 24) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 24) % 64], Rds[(head + 24) % 64], ALUOPs[(head + 24) % 64], operand1_datas[(head + 24) % 64], operand2_datas[(head + 24) % 64]};
    readys[(head + 24) % 64] <= 0;
    operand1s[(head + 24) % 64] <= 0;
    operand2s[(head + 24) % 64] <= 0;
    operand1_datas[(head + 24) % 64] <= 0;
    operand2_datas[(head + 24) % 64] <= 0;
    valid_entries1[(head + 24) % 64] <= 0;
    valid_entries2[(head + 24) % 64] <= 0;
    RS_DIV_on[(head + 24) % 64] <= 1;
end
else if (valid_entries1[(head + 25) % 64] == 1 && valid_entries2[(head + 25) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 25) % 64], Rds[(head + 25) % 64], ALUOPs[(head + 25) % 64], operand1_datas[(head + 25) % 64], operand2_datas[(head + 25) % 64]};
    readys[(head + 25) % 64] <= 0;
    operand1s[(head + 25) % 64] <= 0;
    operand2s[(head + 25) % 64] <= 0;
    operand1_datas[(head + 25) % 64] <= 0;
    operand2_datas[(head + 25) % 64] <= 0;
    valid_entries1[(head + 25) % 64] <= 0;
    valid_entries2[(head + 25) % 64] <= 0;
    RS_DIV_on[(head + 25) % 64] <= 1;
end
else if (valid_entries1[(head + 26) % 64] == 1 && valid_entries2[(head + 26) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 26) % 64], Rds[(head + 26) % 64], ALUOPs[(head + 26) % 64], operand1_datas[(head + 26) % 64], operand2_datas[(head + 26) % 64]};
    readys[(head + 26) % 64] <= 0;
    operand1s[(head + 26) % 64] <= 0;
    operand2s[(head + 26) % 64] <= 0;
    operand1_datas[(head + 26) % 64] <= 0;
    operand2_datas[(head + 26) % 64] <= 0;
    valid_entries1[(head + 26) % 64] <= 0;
    valid_entries2[(head + 26) % 64] <= 0;
    RS_DIV_on[(head + 26) % 64] <= 1;
end
else if (valid_entries1[(head + 27) % 64] == 1 && valid_entries2[(head + 27) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 27) % 64], Rds[(head + 27) % 64], ALUOPs[(head + 27) % 64], operand1_datas[(head + 27) % 64], operand2_datas[(head + 27) % 64]};
    readys[(head + 27) % 64] <= 0;
    operand1s[(head + 27) % 64] <= 0;
    operand2s[(head + 27) % 64] <= 0;
    operand1_datas[(head + 27) % 64] <= 0;
    operand2_datas[(head + 27) % 64] <= 0;
    valid_entries1[(head + 27) % 64] <= 0;
    valid_entries2[(head + 27) % 64] <= 0;
    RS_DIV_on[(head + 27) % 64] <= 1;
end
else if (valid_entries1[(head + 28) % 64] == 1 && valid_entries2[(head + 28) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 28) % 64], Rds[(head + 28) % 64], ALUOPs[(head + 28) % 64], operand1_datas[(head + 28) % 64], operand2_datas[(head + 28) % 64]};
    readys[(head + 28) % 64] <= 0;
    operand1s[(head + 28) % 64] <= 0;
    operand2s[(head + 28) % 64] <= 0;
    operand1_datas[(head + 28) % 64] <= 0;
    operand2_datas[(head + 28) % 64] <= 0;
    valid_entries1[(head + 28) % 64] <= 0;
    valid_entries2[(head + 28) % 64] <= 0;
    RS_DIV_on[(head + 28) % 64] <= 1;
end
else if (valid_entries1[(head + 29) % 64] == 1 && valid_entries2[(head + 29) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 29) % 64], Rds[(head + 29) % 64], ALUOPs[(head + 29) % 64], operand1_datas[(head + 29) % 64], operand2_datas[(head + 29) % 64]};
    readys[(head + 29) % 64] <= 0;
    operand1s[(head + 29) % 64] <= 0;
    operand2s[(head + 29) % 64] <= 0;
    operand1_datas[(head + 29) % 64] <= 0;
    operand2_datas[(head + 29) % 64] <= 0;
    valid_entries1[(head + 29) % 64] <= 0;
    valid_entries2[(head + 29) % 64] <= 0;
    RS_DIV_on[(head + 29) % 64] <= 1;
end
else if (valid_entries1[(head + 30) % 64] == 1 && valid_entries2[(head + 30) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 30) % 64], Rds[(head + 30) % 64], ALUOPs[(head + 30) % 64], operand1_datas[(head + 30) % 64], operand2_datas[(head + 30) % 64]};
    readys[(head + 30) % 64] <= 0;
    operand1s[(head + 30) % 64] <= 0;
    operand2s[(head + 30) % 64] <= 0;
    operand1_datas[(head + 30) % 64] <= 0;
    operand2_datas[(head + 30) % 64] <= 0;
    valid_entries1[(head + 30) % 64] <= 0;
    valid_entries2[(head + 30) % 64] <= 0;
    RS_DIV_on[(head + 30) % 64] <= 1;
end
else if (valid_entries1[(head + 31) % 64] == 1 && valid_entries2[(head + 31) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 31) % 64], Rds[(head + 31) % 64], ALUOPs[(head + 31) % 64], operand1_datas[(head + 31) % 64], operand2_datas[(head + 31) % 64]};
    readys[(head + 31) % 64] <= 0;
    operand1s[(head + 31) % 64] <= 0;
    operand2s[(head + 31) % 64] <= 0;
    operand1_datas[(head + 31) % 64] <= 0;
    operand2_datas[(head + 31) % 64] <= 0;
    valid_entries1[(head + 31) % 64] <= 0;
    valid_entries2[(head + 31) % 64] <= 0;
    RS_DIV_on[(head + 31) % 64] <= 1;
end
else if (valid_entries1[(head + 32) % 64] == 1 && valid_entries2[(head + 32) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 32) % 64], Rds[(head + 32) % 64], ALUOPs[(head + 32) % 64], operand1_datas[(head + 32) % 64], operand2_datas[(head + 32) % 64]};
    readys[(head + 32) % 64] <= 0;
    operand1s[(head + 32) % 64] <= 0;
    operand2s[(head + 32) % 64] <= 0;
    operand1_datas[(head + 32) % 64] <= 0;
    operand2_datas[(head + 32) % 64] <= 0;
    valid_entries1[(head + 32) % 64] <= 0;
    valid_entries2[(head + 32) % 64] <= 0;
    RS_DIV_on[(head + 32) % 64] <= 1;
end
else if (valid_entries1[(head + 33) % 64] == 1 && valid_entries2[(head + 33) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 33) % 64], Rds[(head + 33) % 64], ALUOPs[(head + 33) % 64], operand1_datas[(head + 33) % 64], operand2_datas[(head + 33) % 64]};
    readys[(head + 33) % 64] <= 0;
    operand1s[(head + 33) % 64] <= 0;
    operand2s[(head + 33) % 64] <= 0;
    operand1_datas[(head + 33) % 64] <= 0;
    operand2_datas[(head + 33) % 64] <= 0;
    valid_entries1[(head + 33) % 64] <= 0;
    valid_entries2[(head + 33) % 64] <= 0;
    RS_DIV_on[(head + 33) % 64] <= 1;
end
else if (valid_entries1[(head + 34) % 64] == 1 && valid_entries2[(head + 34) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 34) % 64], Rds[(head + 34) % 64], ALUOPs[(head + 34) % 64], operand1_datas[(head + 34) % 64], operand2_datas[(head + 34) % 64]};
    readys[(head + 34) % 64] <= 0;
    operand1s[(head + 34) % 64] <= 0;
    operand2s[(head + 34) % 64] <= 0;
    operand1_datas[(head + 34) % 64] <= 0;
    operand2_datas[(head + 34) % 64] <= 0;
    valid_entries1[(head + 34) % 64] <= 0;
    valid_entries2[(head + 34) % 64] <= 0;
    RS_DIV_on[(head + 34) % 64] <= 1;
end
else if (valid_entries1[(head + 35) % 64] == 1 && valid_entries2[(head + 35) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 35) % 64], Rds[(head + 35) % 64], ALUOPs[(head + 35) % 64], operand1_datas[(head + 35) % 64], operand2_datas[(head + 35) % 64]};
    readys[(head + 35) % 64] <= 0;
    operand1s[(head + 35) % 64] <= 0;
    operand2s[(head + 35) % 64] <= 0;
    operand1_datas[(head + 35) % 64] <= 0;
    operand2_datas[(head + 35) % 64] <= 0;
    valid_entries1[(head + 35) % 64] <= 0;
    valid_entries2[(head + 35) % 64] <= 0;
    RS_DIV_on[(head + 35) % 64] <= 1;
end
else if (valid_entries1[(head + 36) % 64] == 1 && valid_entries2[(head + 36) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 36) % 64], Rds[(head + 36) % 64], ALUOPs[(head + 36) % 64], operand1_datas[(head + 36) % 64], operand2_datas[(head + 36) % 64]};
    readys[(head + 36) % 64] <= 0;
    operand1s[(head + 36) % 64] <= 0;
    operand2s[(head + 36) % 64] <= 0;
    operand1_datas[(head + 36) % 64] <= 0;
    operand2_datas[(head + 36) % 64] <= 0;
    valid_entries1[(head + 36) % 64] <= 0;
    valid_entries2[(head + 36) % 64] <= 0;
    RS_DIV_on[(head + 36) % 64] <= 1;
end
else if (valid_entries1[(head + 37) % 64] == 1 && valid_entries2[(head + 37) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 37) % 64], Rds[(head + 37) % 64], ALUOPs[(head + 37) % 64], operand1_datas[(head + 37) % 64], operand2_datas[(head + 37) % 64]};
    readys[(head + 37) % 64] <= 0;
    operand1s[(head + 37) % 64] <= 0;
    operand2s[(head + 37) % 64] <= 0;
    operand1_datas[(head + 37) % 64] <= 0;
    operand2_datas[(head + 37) % 64] <= 0;
    valid_entries1[(head + 37) % 64] <= 0;
    valid_entries2[(head + 37) % 64] <= 0;
    RS_DIV_on[(head + 37) % 64] <= 1;
end
else if (valid_entries1[(head + 38) % 64] == 1 && valid_entries2[(head + 38) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 38) % 64], Rds[(head + 38) % 64], ALUOPs[(head + 38) % 64], operand1_datas[(head + 38) % 64], operand2_datas[(head + 38) % 64]};
    readys[(head + 38) % 64] <= 0;
    operand1s[(head + 38) % 64] <= 0;
    operand2s[(head + 38) % 64] <= 0;
    operand1_datas[(head + 38) % 64] <= 0;
    operand2_datas[(head + 38) % 64] <= 0;
    valid_entries1[(head + 38) % 64] <= 0;
    valid_entries2[(head + 38) % 64] <= 0;
    RS_DIV_on[(head + 38) % 64] <= 1;
end
else if (valid_entries1[(head + 39) % 64] == 1 && valid_entries2[(head + 39) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 39) % 64], Rds[(head + 39) % 64], ALUOPs[(head + 39) % 64], operand1_datas[(head + 39) % 64], operand2_datas[(head + 39) % 64]};
    readys[(head + 39) % 64] <= 0;
    operand1s[(head + 39) % 64] <= 0;
    operand2s[(head + 39) % 64] <= 0;
    operand1_datas[(head + 39) % 64] <= 0;
    operand2_datas[(head + 39) % 64] <= 0;
    valid_entries1[(head + 39) % 64] <= 0;
    valid_entries2[(head + 39) % 64] <= 0;
    RS_DIV_on[(head + 39) % 64] <= 1;
end
else if (valid_entries1[(head + 40) % 64] == 1 && valid_entries2[(head + 40) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 40) % 64], Rds[(head + 40) % 64], ALUOPs[(head + 40) % 64], operand1_datas[(head + 40) % 64], operand2_datas[(head + 40) % 64]};
    readys[(head + 40) % 64] <= 0;
    operand1s[(head + 40) % 64] <= 0;
    operand2s[(head + 40) % 64] <= 0;
    operand1_datas[(head + 40) % 64] <= 0;
    operand2_datas[(head + 40) % 64] <= 0;
    valid_entries1[(head + 40) % 64] <= 0;
    valid_entries2[(head + 40) % 64] <= 0;
    RS_DIV_on[(head + 40) % 64] <= 1;
end
else if (valid_entries1[(head + 41) % 64] == 1 && valid_entries2[(head + 41) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 41) % 64], Rds[(head + 41) % 64], ALUOPs[(head + 41) % 64], operand1_datas[(head + 41) % 64], operand2_datas[(head + 41) % 64]};
    readys[(head + 41) % 64] <= 0;
    operand1s[(head + 41) % 64] <= 0;
    operand2s[(head + 41) % 64] <= 0;
    operand1_datas[(head + 41) % 64] <= 0;
    operand2_datas[(head + 41) % 64] <= 0;
    valid_entries1[(head + 41) % 64] <= 0;
    valid_entries2[(head + 41) % 64] <= 0;
    RS_DIV_on[(head + 41) % 64] <= 1;
end
else if (valid_entries1[(head + 42) % 64] == 1 && valid_entries2[(head + 42) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 42) % 64], Rds[(head + 42) % 64], ALUOPs[(head + 42) % 64], operand1_datas[(head + 42) % 64], operand2_datas[(head + 42) % 64]};
    readys[(head + 42) % 64] <= 0;
    operand1s[(head + 42) % 64] <= 0;
    operand2s[(head + 42) % 64] <= 0;
    operand1_datas[(head + 42) % 64] <= 0;
    operand2_datas[(head + 42) % 64] <= 0;
    valid_entries1[(head + 42) % 64] <= 0;
    valid_entries2[(head + 42) % 64] <= 0;
    RS_DIV_on[(head + 42) % 64] <= 1;
end
else if (valid_entries1[(head + 43) % 64] == 1 && valid_entries2[(head + 43) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 43) % 64], Rds[(head + 43) % 64], ALUOPs[(head + 43) % 64], operand1_datas[(head + 43) % 64], operand2_datas[(head + 43) % 64]};
    readys[(head + 43) % 64] <= 0;
    operand1s[(head + 43) % 64] <= 0;
    operand2s[(head + 43) % 64] <= 0;
    operand1_datas[(head + 43) % 64] <= 0;
    operand2_datas[(head + 43) % 64] <= 0;
    valid_entries1[(head + 43) % 64] <= 0;
    valid_entries2[(head + 43) % 64] <= 0;
    RS_DIV_on[(head + 43) % 64] <= 1;
end
else if (valid_entries1[(head + 44) % 64] == 1 && valid_entries2[(head + 44) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 44) % 64], Rds[(head + 44) % 64], ALUOPs[(head + 44) % 64], operand1_datas[(head + 44) % 64], operand2_datas[(head + 44) % 64]};
    readys[(head + 44) % 64] <= 0;
    operand1s[(head + 44) % 64] <= 0;
    operand2s[(head + 44) % 64] <= 0;
    operand1_datas[(head + 44) % 64] <= 0;
    operand2_datas[(head + 44) % 64] <= 0;
    valid_entries1[(head + 44) % 64] <= 0;
    valid_entries2[(head + 44) % 64] <= 0;
    RS_DIV_on[(head + 44) % 64] <= 1;
end
else if (valid_entries1[(head + 45) % 64] == 1 && valid_entries2[(head + 45) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 45) % 64], Rds[(head + 45) % 64], ALUOPs[(head + 45) % 64], operand1_datas[(head + 45) % 64], operand2_datas[(head + 45) % 64]};
    readys[(head + 45) % 64] <= 0;
    operand1s[(head + 45) % 64] <= 0;
    operand2s[(head + 45) % 64] <= 0;
    operand1_datas[(head + 45) % 64] <= 0;
    operand2_datas[(head + 45) % 64] <= 0;
    valid_entries1[(head + 45) % 64] <= 0;
    valid_entries2[(head + 45) % 64] <= 0;
    RS_DIV_on[(head + 45) % 64] <= 1;
end
else if (valid_entries1[(head + 46) % 64] == 1 && valid_entries2[(head + 46) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 46) % 64], Rds[(head + 46) % 64], ALUOPs[(head + 46) % 64], operand1_datas[(head + 46) % 64], operand2_datas[(head + 46) % 64]};
    readys[(head + 46) % 64] <= 0;
    operand1s[(head + 46) % 64] <= 0;
    operand2s[(head + 46) % 64] <= 0;
    operand1_datas[(head + 46) % 64] <= 0;
    operand2_datas[(head + 46) % 64] <= 0;
    valid_entries1[(head + 46) % 64] <= 0;
    valid_entries2[(head + 46) % 64] <= 0;
    RS_DIV_on[(head + 46) % 64] <= 1;
end
else if (valid_entries1[(head + 47) % 64] == 1 && valid_entries2[(head + 47) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 47) % 64], Rds[(head + 47) % 64], ALUOPs[(head + 47) % 64], operand1_datas[(head + 47) % 64], operand2_datas[(head + 47) % 64]};
    readys[(head + 47) % 64] <= 0;
    operand1s[(head + 47) % 64] <= 0;
    operand2s[(head + 47) % 64] <= 0;
    operand1_datas[(head + 47) % 64] <= 0;
    operand2_datas[(head + 47) % 64] <= 0;
    valid_entries1[(head + 47) % 64] <= 0;
    valid_entries2[(head + 47) % 64] <= 0;
    RS_DIV_on[(head + 47) % 64] <= 1;
end
else if (valid_entries1[(head + 48) % 64] == 1 && valid_entries2[(head + 48) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 48) % 64], Rds[(head + 48) % 64], ALUOPs[(head + 48) % 64], operand1_datas[(head + 48) % 64], operand2_datas[(head + 48) % 64]};
    readys[(head + 48) % 64] <= 0;
    operand1s[(head + 48) % 64] <= 0;
    operand2s[(head + 48) % 64] <= 0;
    operand1_datas[(head + 48) % 64] <= 0;
    operand2_datas[(head + 48) % 64] <= 0;
    valid_entries1[(head + 48) % 64] <= 0;
    valid_entries2[(head + 48) % 64] <= 0;
    RS_DIV_on[(head + 48) % 64] <= 1;
end
else if (valid_entries1[(head + 49) % 64] == 1 && valid_entries2[(head + 49) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 49) % 64], Rds[(head + 49) % 64], ALUOPs[(head + 49) % 64], operand1_datas[(head + 49) % 64], operand2_datas[(head + 49) % 64]};
    readys[(head + 49) % 64] <= 0;
    operand1s[(head + 49) % 64] <= 0;
    operand2s[(head + 49) % 64] <= 0;
    operand1_datas[(head + 49) % 64] <= 0;
    operand2_datas[(head + 49) % 64] <= 0;
    valid_entries1[(head + 49) % 64] <= 0;
    valid_entries2[(head + 49) % 64] <= 0;
    RS_DIV_on[(head + 49) % 64] <= 1;
end
else if (valid_entries1[(head + 50) % 64] == 1 && valid_entries2[(head + 50) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 50) % 64], Rds[(head + 50) % 64], ALUOPs[(head + 50) % 64], operand1_datas[(head + 50) % 64], operand2_datas[(head + 50) % 64]};
    readys[(head + 50) % 64] <= 0;
    operand1s[(head + 50) % 64] <= 0;
    operand2s[(head + 50) % 64] <= 0;
    operand1_datas[(head + 50) % 64] <= 0;
    operand2_datas[(head + 50) % 64] <= 0;
    valid_entries1[(head + 50) % 64] <= 0;
    valid_entries2[(head + 50) % 64] <= 0;
    RS_DIV_on[(head + 50) % 64] <= 1;
end
else if (valid_entries1[(head + 51) % 64] == 1 && valid_entries2[(head + 51) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 51) % 64], Rds[(head + 51) % 64], ALUOPs[(head + 51) % 64], operand1_datas[(head + 51) % 64], operand2_datas[(head + 51) % 64]};
    readys[(head + 51) % 64] <= 0;
    operand1s[(head + 51) % 64] <= 0;
    operand2s[(head + 51) % 64] <= 0;
    operand1_datas[(head + 51) % 64] <= 0;
    operand2_datas[(head + 51) % 64] <= 0;
    valid_entries1[(head + 51) % 64] <= 0;
    valid_entries2[(head + 51) % 64] <= 0;
    RS_DIV_on[(head + 51) % 64] <= 1;
end
else if (valid_entries1[(head + 52) % 64] == 1 && valid_entries2[(head + 52) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 52) % 64], Rds[(head + 52) % 64], ALUOPs[(head + 52) % 64], operand1_datas[(head + 52) % 64], operand2_datas[(head + 52) % 64]};
    readys[(head + 52) % 64] <= 0;
    operand1s[(head + 52) % 64] <= 0;
    operand2s[(head + 52) % 64] <= 0;
    operand1_datas[(head + 52) % 64] <= 0;
    operand2_datas[(head + 52) % 64] <= 0;
    valid_entries1[(head + 52) % 64] <= 0;
    valid_entries2[(head + 52) % 64] <= 0;
    RS_DIV_on[(head + 52) % 64] <= 1;
end
else if (valid_entries1[(head + 53) % 64] == 1 && valid_entries2[(head + 53) % 64] == 1) begin
  result_out = {1'b1, PCs[(head + 53) % 64], Rds[(head + 53) % 64], ALUOPs[(head + 53) % 64], operand1_datas[(head + 53) % 64], operand2_datas[(head + 53) % 64]};
    readys[(head + 53) % 64] <= 0;
    operand1s[(head + 53) % 64] <= 0;
    operand2s[(head + 53) % 64] <= 0;
    operand1_datas[(head + 53) % 64] <= 0;
    operand2_datas[(head + 53) % 64] <= 0;
    valid_entries1[(head + 53) % 64] <= 0;
    valid_entries2[(head + 53) % 64] <= 0;
    RS_DIV_on[(head + 53) % 64] <= 1;
end
else if (valid_entries1[(head + 54) % 64] == 1 && valid_entries2[(head + 54) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 54) % 64], Rds[(head + 54) % 64], ALUOPs[(head + 54) % 64], operand1_datas[(head + 54) % 64], operand2_datas[(head + 54) % 64]};
    readys[(head + 54) % 64] <= 0;
    operand1s[(head + 54) % 64] <= 0;
    operand2s[(head + 54) % 64] <= 0;
    operand1_datas[(head + 54) % 64] <= 0;
    operand2_datas[(head + 54) % 64] <= 0;
    valid_entries1[(head + 54) % 64] <= 0;
    valid_entries2[(head + 54) % 64] <= 0;
    RS_DIV_on[(head + 54) % 64] <= 1;
end
else if (valid_entries1[(head + 55) % 64] == 1 && valid_entries2[(head + 55) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 55) % 64], Rds[(head + 55) % 64], ALUOPs[(head + 55) % 64], operand1_datas[(head + 55) % 64], operand2_datas[(head + 55) % 64]};
    readys[(head + 55) % 64] <= 0;
    operand1s[(head + 55) % 64] <= 0;
    operand2s[(head + 55) % 64] <= 0;
    operand1_datas[(head + 55) % 64] <= 0;
    operand2_datas[(head + 55) % 64] <= 0;
    valid_entries1[(head + 55) % 64] <= 0;
    valid_entries2[(head + 55) % 64] <= 0;
    RS_DIV_on[(head + 55) % 64] <= 1;
end
else if (valid_entries1[(head + 56) % 64] == 1 && valid_entries2[(head + 56) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 56) % 64], Rds[(head + 56) % 64], ALUOPs[(head + 56) % 64], operand1_datas[(head + 56) % 64], operand2_datas[(head + 56) % 64]};
    readys[(head + 56) % 64] <= 0;
    operand1s[(head + 56) % 64] <= 0;
    operand2s[(head + 56) % 64] <= 0;
    operand1_datas[(head + 56) % 64] <= 0;
    operand2_datas[(head + 56) % 64] <= 0;
    valid_entries1[(head + 56) % 64] <= 0;
    valid_entries2[(head + 56) % 64] <= 0;
    RS_DIV_on[(head + 56) % 64] <= 1;
end
else if (valid_entries1[(head + 57) % 64] == 1 && valid_entries2[(head + 57) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 57) % 64], Rds[(head + 57) % 64], ALUOPs[(head + 57) % 64], operand1_datas[(head + 57) % 64], operand2_datas[(head + 57) % 64]};
    readys[(head + 57) % 64] <= 0;
    operand1s[(head + 57) % 64] <= 0;
    operand2s[(head + 57) % 64] <= 0;
    operand1_datas[(head + 57) % 64] <= 0;
    operand2_datas[(head + 57) % 64] <= 0;
    valid_entries1[(head + 57) % 64] <= 0;
    valid_entries2[(head + 57) % 64] <= 0;
    RS_DIV_on[(head + 57) % 64] <= 1;
end
else if (valid_entries1[(head + 58) % 64] == 1 && valid_entries2[(head + 58) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 58) % 64], Rds[(head + 58) % 64], ALUOPs[(head + 58) % 64], operand1_datas[(head + 58) % 64], operand2_datas[(head + 58) % 64]};
    readys[(head + 58) % 64] <= 0;
    operand1s[(head + 58) % 64] <= 0;
    operand2s[(head + 58) % 64] <= 0;
    operand1_datas[(head + 58) % 64] <= 0;
    operand2_datas[(head + 58) % 64] <= 0;
    valid_entries1[(head + 58) % 64] <= 0;
    valid_entries2[(head + 58) % 64] <= 0;
    RS_DIV_on[(head + 58) % 64] <= 1;
end
else if (valid_entries1[(head + 59) % 64] == 1 && valid_entries2[(head + 59) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 59) % 64], Rds[(head + 59) % 64], ALUOPs[(head + 59) % 64], operand1_datas[(head + 59) % 64], operand2_datas[(head + 59) % 64]};
    readys[(head + 59) % 64] <= 0;
    operand1s[(head + 59) % 64] <= 0;
    operand2s[(head + 59) % 64] <= 0;
    operand1_datas[(head + 59) % 64] <= 0;
    operand2_datas[(head + 59) % 64] <= 0;
    valid_entries1[(head + 59) % 64] <= 0;
    valid_entries2[(head + 59) % 64] <= 0;
    RS_DIV_on[(head + 59) % 64] <= 1;
end
else if (valid_entries1[(head + 60) % 64] == 1 && valid_entries2[(head + 60) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 60) % 64], Rds[(head + 60) % 64], ALUOPs[(head + 60) % 64], operand1_datas[(head + 60) % 64], operand2_datas[(head + 60) % 64]};
    readys[(head + 60) % 64] <= 0;
    operand1s[(head + 60) % 64] <= 0;
    operand2s[(head + 60) % 64] <= 0;
    operand1_datas[(head + 60) % 64] <= 0;
    operand2_datas[(head + 60) % 64] <= 0;
    valid_entries1[(head + 60) % 64] <= 0;
    valid_entries2[(head + 60) % 64] <= 0;
    RS_DIV_on[(head + 60) % 64] <= 1;
end
else if (valid_entries1[(head + 61) % 64] == 1 && valid_entries2[(head + 61) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 61) % 64], Rds[(head + 61) % 64], ALUOPs[(head + 61) % 64], operand1_datas[(head + 61) % 64], operand2_datas[(head + 61) % 64]};
    readys[(head + 61) % 64] <= 0;
    operand1s[(head + 61) % 64] <= 0;
    operand2s[(head + 61) % 64] <= 0;
    operand1_datas[(head + 61) % 64] <= 0;
    operand2_datas[(head + 61) % 64] <= 0;
    valid_entries1[(head + 61) % 64] <= 0;
    valid_entries2[(head + 61) % 64] <= 0;
    RS_DIV_on[(head + 61) % 64] <= 1;
end
else if (valid_entries1[(head + 62) % 64] == 1 && valid_entries2[(head + 62) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 62) % 64], Rds[(head + 62) % 64], ALUOPs[(head + 62) % 64], operand1_datas[(head + 62) % 64], operand2_datas[(head + 62) % 64]};
    readys[(head + 62) % 64] <= 0;
    operand1s[(head + 62) % 64] <= 0;
    operand2s[(head + 62) % 64] <= 0;
    operand1_datas[(head + 62) % 64] <= 0;
    operand2_datas[(head + 62) % 64] <= 0;
    valid_entries1[(head + 62) % 64] <= 0;
    valid_entries2[(head + 62) % 64] <= 0;
    RS_DIV_on[(head + 62) % 64] <= 1;
end
else if (valid_entries1[(head + 63) % 64] == 1 && valid_entries2[(head + 63) % 64] == 1) begin
    result_out = {1'b1, PCs[(head + 63) % 64], Rds[(head + 63) % 64], ALUOPs[(head + 63) % 64], operand1_datas[(head + 63) % 64], operand2_datas[(head + 63) % 64]};
    readys[(head + 63) % 64] <= 0;
    operand1s[(head + 63) % 64] <= 0;
    operand2s[(head + 63) % 64] <= 0;
    operand1_datas[(head + 63) % 64] <= 0;
    operand2_datas[(head + 63) % 64] <= 0;
    valid_entries1[(head + 63) % 64] <= 0;
    valid_entries2[(head + 63) % 64] <= 0;
    RS_DIV_on[(head + 63) % 64] <= 1;
end
else begin
    result_out = 0;
end
end
endmodule
