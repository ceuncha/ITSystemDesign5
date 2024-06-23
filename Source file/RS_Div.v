module priority_encoder (
    input wire [63:0] ready, // 64鍮꾪듃 ready ?떊?샇
    input wire [6:0] head,
    output reg [63:0] Y // 64鍮꾪듃 Y 異쒕젰
);

always @(*) begin
    // ?슦?꽑?닚?쐞 ?씤肄붾뜑 ?끉由?
    if (ready[(head+0)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000000001;
    else if (ready[(head+1)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000000010;
    else if (ready[(head+2)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000000100;
    else if (ready[(head+3)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000001000;
    else if (ready[(head+4)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000010000;
    else if (ready[(head+5)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000100000;
    else if (ready[(head+6)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000001000000;
    else if (ready[(head+7)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000010000000;
    else if (ready[(head+8)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000100000000;
    else if (ready[(head+9)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000001000000000;
    else if (ready[(head+10)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000010000000000;
    else if (ready[(head+11)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000100000000000;
    else if (ready[(head+12)%64]) Y = 64'b0000000000000000000000000000000000000000000000000001000000000000;
    else if (ready[(head+13)%64]) Y = 64'b0000000000000000000000000000000000000000000000000010000000000000;
    else if (ready[(head+14)%64]) Y = 64'b0000000000000000000000000000000000000000000000000100000000000000;
    else if (ready[(head+15)%64]) Y = 64'b0000000000000000000000000000000000000000000000001000000000000000;
    else if (ready[(head+16)%64]) Y = 64'b0000000000000000000000000000000000000000000000010000000000000000;
    else if (ready[(head+17)%64]) Y = 64'b0000000000000000000000000000000000000000000000100000000000000000;
    else if (ready[(head+18)%64]) Y = 64'b0000000000000000000000000000000000000000000001000000000000000000;
    else if (ready[(head+19)%64]) Y = 64'b0000000000000000000000000000000000000000000010000000000000000000;
    else if (ready[(head+20)%64]) Y = 64'b0000000000000000000000000000000000000000000100000000000000000000;
    else if (ready[(head+21)%64]) Y = 64'b0000000000000000000000000000000000000000001000000000000000000000;
    else if (ready[(head+22)%64]) Y = 64'b0000000000000000000000000000000000000000010000000000000000000000;
    else if (ready[(head+23)%64]) Y = 64'b0000000000000000000000000000000000000000100000000000000000000000;
    else if (ready[(head+24)%64]) Y = 64'b0000000000000000000000000000000000000001000000000000000000000000;
    else if (ready[(head+25)%64]) Y = 64'b0000000000000000000000000000000000000010000000000000000000000000;
    else if (ready[(head+26)%64]) Y = 64'b0000000000000000000000000000000000000100000000000000000000000000;
    else if (ready[(head+27)%64]) Y = 64'b0000000000000000000000000000000000001000000000000000000000000000;
    else if (ready[(head+28)%64]) Y = 64'b0000000000000000000000000000000000010000000000000000000000000000;
    else if (ready[(head+29)%64]) Y = 64'b0000000000000000000000000000000000100000000000000000000000000000;
    else if (ready[(head+30)%64]) Y = 64'b0000000000000000000000000000000001000000000000000000000000000000;
    else if (ready[(head+31)%64]) Y = 64'b0000000000000000000000000000000010000000000000000000000000000000;
    else if (ready[(head+33)%64]) Y = 64'b0000000000000000000000000000001000000000000000000000000000000000;
    else if (ready[(head+34)%64]) Y = 64'b0000000000000000000000000000010000000000000000000000000000000000;
    else if (ready[(head+35)%64]) Y = 64'b0000000000000000000000000000100000000000000000000000000000000000;
    else if (ready[(head+36)%64]) Y = 64'b0000000000000000000000000001000000000000000000000000000000000000;
    else if (ready[(head+37)%64]) Y = 64'b0000000000000000000000000010000000000000000000000000000000000000;
    else if (ready[(head+38)%64]) Y = 64'b0000000000000000000000000100000000000000000000000000000000000000;
    else if (ready[(head+39)%64]) Y = 64'b0000000000000000000000001000000000000000000000000000000000000000;
    else if (ready[(head+40)%64]) Y = 64'b0000000000000000000000010000000000000000000000000000000000000000;
    else if (ready[(head+41)%64]) Y = 64'b0000000000000000000000100000000000000000000000000000000000000000;
    else if (ready[(head+42)%64]) Y = 64'b0000000000000000000001000000000000000000000000000000000000000000;
    else if (ready[(head+43)%64]) Y = 64'b0000000000000000000010000000000000000000000000000000000000000000;
    else if (ready[(head+44)%64]) Y = 64'b0000000000000000000100000000000000000000000000000000000000000000;
    else if (ready[(head+45)%64]) Y = 64'b0000000000000000001000000000000000000000000000000000000000000000;
    else if (ready[(head+46)%64]) Y = 64'b0000000000000000010000000000000000000000000000000000000000000000;
    else if (ready[(head+47)%64]) Y = 64'b0000000000000000100000000000000000000000000000000000000000000000;
    else if (ready[(head+48)%64]) Y = 64'b0000000000000001000000000000000000000000000000000000000000000000;
    else if (ready[(head+49)%64]) Y = 64'b0000000000000010000000000000000000000000000000000000000000000000;
    else if (ready[(head+50)%64]) Y = 64'b0000000000000100000000000000000000000000000000000000000000000000;
    else if (ready[(head+51)%64]) Y = 64'b0000000000001000000000000000000000000000000000000000000000000000;
    else if (ready[(head+52)%64]) Y = 64'b0000000000010000000000000000000000000000000000000000000000000000;
    else if (ready[(head+53)%64]) Y = 64'b0000000000100000000000000000000000000000000000000000000000000000;
    else if (ready[(head+54)%64]) Y = 64'b0000000001000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+55)%64]) Y = 64'b0000000010000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+56)%64]) Y = 64'b0000000100000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+57)%64]) Y = 64'b0000001000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+58)%64]) Y = 64'b0000010000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+59)%64]) Y = 64'b0000100000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+60)%64]) Y = 64'b0001000000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+61)%64]) Y = 64'b0010000000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+62)%64]) Y = 64'b0100000000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+63)%64]) Y = 64'b1000000000000000000000000000000000000000000000000000000000000000;
    else Y = 64'b0; // 紐⑤뱺 議곌굔?뿉 ?빐?떦?븯吏? ?븡?쑝硫? 0?쑝濡? ?꽕?젙
end
endmodule

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
    reg [63:0] valid_entries1;  // operand1?씠 valid?븳吏?
    reg [63:0] valid_entries2; // operand2媛? valid?븳吏?
    reg [108:0] result [0:63];
    reg [5:0] tail;
    reg [63:0] readys;
    wire [63:0] Y;
    reg [6:0] head;
    integer i;
    reg RS_DIV_on[0:63];

    always @(posedge clk ) begin
        if (reset) begin
            tail <= 0;
            for (i = 0; i < 64; i = i + 1) begin
                PCs[i] <= 0;
                Rds[i] <= 0;
                ALUOPs[i] <= 0;
                operand1s[i] <= 0;
                operand2s[i] <= 0;
                operand1_datas[i] <= 0;
                operand2_datas[i] <= 0;
                valid_entries1[i] <= 1'b0; // 由ъ뀑 ?떆 珥덇린媛믪쑝濡? 蹂듭썝
                valid_entries2[i] <= 1'b0; // 由ъ뀑 ?떆 珥덇린媛믪쑝濡? 蹂듭썝
                RS_DIV_on[i] <= 0;
            end
        end else if (RS_div_start) begin
            if (RS_div_operand1 == ALU_result_dest) begin  // ALU?뿉?꽌 operand1?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
            end else if (RS_div_operand2 == ALU_result_dest) begin  // ALU?뿉?꽌 operand2?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
             end else if (RS_div_operand1 == MUL_result_dest) begin  // MUL?뿉?꽌 operand1?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
             end else if (RS_div_operand2 == MUL_result_dest) begin  // MUL?뿉?꽌 operand2?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
              end else if (RS_div_operand1 == DIV_result_dest) begin  // DIV?뿉?꽌 operand1?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
              end else if (RS_div_operand2 == DIV_result_dest) begin  // MUL?뿉?꽌 operand2?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
         end
      
    


    always @(*) begin
        for (i = 0; i < 64; i = i + 1) begin
            if (valid_entries1[i] && valid_entries2[i]) begin
                readys[i] = 1;
                RS_DIV_on[i] <= 1;
                result[i] = {1'b1, PCs[i], Rds[i], ALUOPs[i],operand1_datas[i], operand2_datas[i]};
            end
        end
    end
    priority_encoder encoder (
        .ready(readys),
        .head(head),
        .Y(Y)
    );


always @(posedge clk ) begin
    if (reset) begin
        result_out <= 0;
        head <= 0;
    end else begin
        if (RS_DIV_on[head]) begin
      head <= (head+1)%64;
            RS_DIV_on[head] <=0;     
      end
        case (Y)
    64'b0000000000000000000000000000000000000000000000000000000000000001: begin
        result_out <= result[(head+0)%64];
        readys[(head+0)%64] <= 0;
        operand1s[(head+0)%64] <= 0;
        operand2s[(head+0)%64] <= 0;
        operand1_datas[(head+0)%64] <= 0;
        operand2_datas[(head+0)%64] <= 0;
        valid_entries1[(head+0)%64] <= 0;
        valid_entries2[(head+0)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000000000010: begin
        result_out <= result[(head+1)%64];
        readys[(head+1)%64] <= 0;
        operand1s[(head+1)%64] <= 0;
        operand2s[(head+1)%64] <= 0;
        operand1_datas[(head+1)%64] <= 0;
        operand2_datas[(head+1)%64] <= 0;
        valid_entries1[(head+1)%64] <= 0;
        valid_entries2[(head+1)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000000000100: begin
        result_out <= result[(head+2)%64];
        readys[(head+2)%64] <= 0;
        operand1s[(head+2)%64] <= 0;
        operand2s[(head+2)%64] <= 0;
        operand1_datas[(head+2)%64] <= 0;
        operand2_datas[(head+2)%64] <= 0;
        valid_entries1[(head+2)%64] <= 0;
        valid_entries2[(head+2)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000000001000: begin
        result_out <= result[(head+3)%64];
        readys[(head+3)%64] <= 0;
        operand1s[(head+3)%64] <= 0;
        operand2s[(head+3)%64] <= 0;
        operand1_datas[(head+3)%64] <= 0;
        operand2_datas[(head+3)%64] <= 0;
        valid_entries1[(head+3)%64] <= 0;
        valid_entries2[(head+3)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000000010000: begin
        result_out <= result[(head+4)%64];
        readys[(head+4)%64] <= 0;
        operand1s[(head+4)%64] <= 0;
        operand2s[(head+4)%64] <= 0;
        operand1_datas[(head+4)%64] <= 0;
        operand2_datas[(head+4)%64] <= 0;
        valid_entries1[(head+4)%64] <= 0;
        valid_entries2[(head+4)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000000100000: begin
        result_out <= result[(head+5)%64];
        readys[(head+5)%64] <= 0;
        operand1s[(head+5)%64] <= 0;
        operand2s[(head+5)%64] <= 0;
        operand1_datas[(head+5)%64] <= 0;
        operand2_datas[(head+5)%64] <= 0;
        valid_entries1[(head+5)%64] <= 0;
        valid_entries2[(head+5)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000001000000: begin
        result_out <= result[(head+6)%64];
        readys[(head+6)%64] <= 0;
        operand1s[(head+6)%64] <= 0;
        operand2s[(head+6)%64] <= 0;
        operand1_datas[(head+6)%64] <= 0;
        operand2_datas[(head+6)%64] <= 0;
        valid_entries1[(head+6)%64] <= 0;
        valid_entries2[(head+6)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000010000000: begin
        result_out <= result[(head+7)%64];
        readys[(head+7)%64] <= 0;
        operand1s[(head+7)%64] <= 0;
        operand2s[(head+7)%64] <= 0;
        operand1_datas[(head+7)%64] <= 0;
        operand2_datas[(head+7)%64] <= 0;
        valid_entries1[(head+7)%64] <= 0;
        valid_entries2[(head+7)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000100000000: begin
        result_out <= result[(head+8)%64];
        readys[(head+8)%64] <= 0;
        operand1s[(head+8)%64] <= 0;
        operand2s[(head+8)%64] <= 0;
        operand1_datas[(head+8)%64] <= 0;
        operand2_datas[(head+8)%64] <= 0;
        valid_entries1[(head+8)%64] <= 0;
        valid_entries2[(head+8)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000001000000000: begin
        result_out <= result[(head+9)%64];
        readys[(head+9)%64] <= 0;
        operand1s[(head+9)%64] <= 0;
        operand2s[(head+9)%64] <= 0;
        operand1_datas[(head+9)%64] <= 0;
        operand2_datas[(head+9)%64] <= 0;
        valid_entries1[(head+9)%64] <= 0;
        valid_entries2[(head+9)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000010000000000: begin
        result_out <= result[(head+10)%64];
        readys[(head+10)%64] <= 0;
        operand1s[(head+10)%64] <= 0;
        operand2s[(head+10)%64] <= 0;
        operand1_datas[(head+10)%64] <= 0;
        operand2_datas[(head+10)%64] <= 0;
        valid_entries1[(head+10)%64] <= 0;
        valid_entries2[(head+10)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000100000000000: begin
        result_out <= result[(head+11)%64];
        readys[(head+11)%64] <= 0;
        operand1s[(head+11)%64] <= 0;
        operand2s[(head+11)%64] <= 0;
        operand1_datas[(head+11)%64] <= 0;
        operand2_datas[(head+11)%64] <= 0;
        valid_entries1[(head+11)%64] <= 0;
        valid_entries2[(head+11)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000001000000000000: begin
        result_out <= result[(head+12)%64];
        readys[(head+12)%64] <= 0;
        operand1s[(head+12)%64] <= 0;
        operand2s[(head+12)%64] <= 0;
        operand1_datas[(head+12)%64] <= 0;
        operand2_datas[(head+12)%64] <= 0;
        valid_entries1[(head+12)%64] <= 0;
        valid_entries2[(head+12)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000010000000000000: begin
        result_out <= result[(head+13)%64];
        readys[(head+13)%64] <= 0;
        operand1s[(head+13)%64] <= 0;
        operand2s[(head+13)%64] <= 0;
        operand1_datas[(head+13)%64] <= 0;
        operand2_datas[(head+13)%64] <= 0;
        valid_entries1[(head+13)%64] <= 0;
        valid_entries2[(head+13)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000100000000000000: begin
        result_out <= result[(head+14)%64];
        readys[(head+14)%64] <= 0;
        operand1s[(head+14)%64] <= 0;
        operand2s[(head+14)%64] <= 0;
        operand1_datas[(head+14)%64] <= 0;
        operand2_datas[(head+14)%64] <= 0;
        valid_entries1[(head+14)%64] <= 0;
        valid_entries2[(head+14)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000001000000000000000: begin
        result_out <= result[(head+15)%64];
        readys[(head+15)%64] <= 0;
        operand1s[(head+15)%64] <= 0;
        operand2s[(head+15)%64] <= 0;
        operand1_datas[(head+15)%64] <= 0;
        operand2_datas[(head+15)%64] <= 0;
        valid_entries1[(head+15)%64] <= 0;
        valid_entries2[(head+15)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000010000000000000000: begin
        result_out <= result[(head+16)%64];
        readys[(head+16)%64] <= 0;
        operand1s[(head+16)%64] <= 0;
        operand2s[(head+16)%64] <= 0;
        operand1_datas[(head+16)%64] <= 0;
        operand2_datas[(head+16)%64] <= 0;
        valid_entries1[(head+16)%64] <= 0;
        valid_entries2[(head+16)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000100000000000000000: begin
        result_out <= result[(head+17)%64];
        readys[(head+17)%64] <= 0;
        operand1s[(head+17)%64] <= 0;
        operand2s[(head+17)%64] <= 0;
        operand1_datas[(head+17)%64] <= 0;
        operand2_datas[(head+17)%64] <= 0;
        valid_entries1[(head+17)%64] <= 0;
        valid_entries2[(head+17)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000001000000000000000000: begin
        result_out <= result[(head+18)%64];
        readys[(head+18)%64] <= 0;
        operand1s[(head+18)%64] <= 0;
        operand2s[(head+18)%64] <= 0;
        operand1_datas[(head+18)%64] <= 0;
        operand2_datas[(head+18)%64] <= 0;
        valid_entries1[(head+18)%64] <= 0;
        valid_entries2[(head+18)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000010000000000000000000: begin
        result_out <= result[(head+19)%64];
        readys[(head+19)%64] <= 0;
        operand1s[(head+19)%64] <= 0;
        operand2s[(head+19)%64] <= 0;
        operand1_datas[(head+19)%64] <= 0;
        operand2_datas[(head+19)%64] <= 0;
        valid_entries1[(head+19)%64] <= 0;
        valid_entries2[(head+19)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000100000000000000000000: begin
        result_out <= result[(head+20)%64];
        readys[(head+20)%64] <= 0;
        operand1s[(head+20)%64] <= 0;
        operand2s[(head+20)%64] <= 0;
        operand1_datas[(head+20)%64] <= 0;
        operand2_datas[(head+20)%64] <= 0;
        valid_entries1[(head+20)%64] <= 0;
        valid_entries2[(head+20)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000001000000000000000000000: begin
        result_out <= result[(head+21)%64];
        readys[(head+21)%64] <= 0;
        operand1s[(head+21)%64] <= 0;
        operand2s[(head+21)%64] <= 0;
        operand1_datas[(head+21)%64] <= 0;
        operand2_datas[(head+21)%64] <= 0;
        valid_entries1[(head+21)%64] <= 0;
        valid_entries2[(head+21)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000010000000000000000000000: begin
        result_out <= result[(head+22)%64];
        readys[(head+22)%64] <= 0;
        operand1s[(head+22)%64] <= 0;
        operand2s[(head+22)%64] <= 0;
        operand1_datas[(head+22)%64] <= 0;
        operand2_datas[(head+22)%64] <= 0;
        valid_entries1[(head+22)%64] <= 0;
        valid_entries2[(head+22)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000100000000000000000000000: begin
        result_out <= result[(head+23)%64];
        readys[(head+23)%64] <= 0;
        operand1s[(head+23)%64] <= 0;
        operand2s[(head+23)%64] <= 0;
        operand1_datas[(head+23)%64] <= 0;
        operand2_datas[(head+23)%64] <= 0;
        valid_entries1[(head+23)%64] <= 0;
        valid_entries2[(head+23)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000001000000000000000000000000: begin
        result_out <= result[(head+24)%64];
        readys[(head+24)%64] <= 0;
        operand1s[(head+24)%64] <= 0;
        operand2s[(head+24)%64] <= 0;
        operand1_datas[(head+24)%64] <= 0;
        operand2_datas[(head+24)%64] <= 0;
        valid_entries1[(head+24)%64] <= 0;
        valid_entries2[(head+24)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000010000000000000000000000000: begin
        result_out <= result[(head+25)%64];
        readys[(head+25)%64] <= 0;
        operand1s[(head+25)%64] <= 0;
        operand2s[(head+25)%64] <= 0;
        operand1_datas[(head+25)%64] <= 0;
        operand2_datas[(head+25)%64] <= 0;
        valid_entries1[(head+25)%64] <= 0;
        valid_entries2[(head+25)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000100000000000000000000000000: begin
        result_out <= result[(head+26)%64];
        readys[(head+26)%64] <= 0;
        operand1s[(head+26)%64] <= 0;
        operand2s[(head+26)%64] <= 0;
        operand1_datas[(head+26)%64] <= 0;
        operand2_datas[(head+26)%64] <= 0;
        valid_entries1[(head+26)%64] <= 0;
        valid_entries2[(head+26)%64] <= 0;
    end
    64'b0000000000000000000000000000000000001000000000000000000000000000: begin
        result_out <= result[(head+27)%64];
        readys[(head+27)%64] <= 0;
        operand1s[(head+27)%64] <= 0;
        operand2s[(head+27)%64] <= 0;
        operand1_datas[(head+27)%64] <= 0;
        operand2_datas[(head+27)%64] <= 0;
        valid_entries1[(head+27)%64] <= 0;
        valid_entries2[(head+27)%64] <= 0;
    end
    64'b0000000000000000000000000000000000010000000000000000000000000000: begin
        result_out <= result[(head+28)%64];
        readys[(head+28)%64] <= 0;
        operand1s[(head+28)%64] <= 0;
        operand2s[(head+28)%64] <= 0;
        operand1_datas[(head+28)%64] <= 0;
        operand2_datas[(head+28)%64] <= 0;
        valid_entries1[(head+28)%64] <= 0;
        valid_entries2[(head+28)%64] <= 0;
    end
    64'b0000000000000000000000000000000000100000000000000000000000000000: begin
        result_out <= result[(head+29)%64];
        readys[(head+29)%64] <= 0;
        operand1s[(head+29)%64] <= 0;
        operand2s[(head+29)%64] <= 0;
        operand1_datas[(head+29)%64] <= 0;
        operand2_datas[(head+29)%64] <= 0;
        valid_entries1[(head+29)%64] <= 0;
        valid_entries2[(head+29)%64] <= 0;
    end
    64'b0000000000000000000000000000000001000000000000000000000000000000: begin
        result_out <= result[(head+30)%64];
        readys[(head+30)%64] <= 0;
        operand1s[(head+30)%64] <= 0;
        operand2s[(head+30)%64] <= 0;
        operand1_datas[(head+30)%64] <= 0;
        operand2_datas[(head+30)%64] <= 0;
        valid_entries1[(head+30)%64] <= 0;
        valid_entries2[(head+30)%64] <= 0;
    end
    64'b0000000000000000000000000000000010000000000000000000000000000000: begin
        result_out <= result[(head+31)%64];
        readys[(head+31)%64] <= 0;
        operand1s[(head+31)%64] <= 0;
        operand2s[(head+31)%64] <= 0;
        operand1_datas[(head+31)%64] <= 0;
        operand2_datas[(head+31)%64] <= 0;
        valid_entries1[(head+31)%64] <= 0;
        valid_entries2[(head+31)%64] <= 0;
    end
    64'b0000000000000000000000000000000100000000000000000000000000000000: begin
        result_out <= result[(head+32)%64];
        readys[(head+32)%64] <= 0;
        operand1s[(head+32)%64] <= 0;
        operand2s[(head+32)%64] <= 0;
        operand1_datas[(head+32)%64] <= 0;
        operand2_datas[(head+32)%64] <= 0;
        valid_entries1[(head+32)%64] <= 0;
        valid_entries2[(head+32)%64] <= 0;
    end
    64'b0000000000000000000000000000001000000000000000000000000000000000: begin
        result_out <= result[(head+33)%64];
        readys[(head+33)%64] <= 0;
        operand1s[(head+33)%64] <= 0;
        operand2s[(head+33)%64] <= 0;
        operand1_datas[(head+33)%64] <= 0;
        operand2_datas[(head+33)%64] <= 0;
        valid_entries1[(head+33)%64] <= 0;
        valid_entries2[(head+33)%64] <= 0;
    end
    64'b0000000000000000000000000000010000000000000000000000000000000000: begin
        result_out <= result[(head+34)%64];
        readys[(head+34)%64] <= 0;
        operand1s[(head+34)%64] <= 0;
        operand2s[(head+34)%64] <= 0;
        operand1_datas[(head+34)%64] <= 0;
        operand2_datas[(head+34)%64] <= 0;
        valid_entries1[(head+34)%64] <= 0;
        valid_entries2[(head+34)%64] <= 0;
    end
    64'b0000000000000000000000000000100000000000000000000000000000000000: begin
        result_out <= result[(head+35)%64];
        readys[(head+35)%64] <= 0;
        operand1s[(head+35)%64] <= 0;
        operand2s[(head+35)%64] <= 0;
        operand1_datas[(head+35)%64] <= 0;
        operand2_datas[(head+35)%64] <= 0;
        valid_entries1[(head+35)%64] <= 0;
        valid_entries2[(head+35)%64] <= 0;
    end
    64'b0000000000000000000000000001000000000000000000000000000000000000: begin
        result_out <= result[(head+36)%64];
        readys[(head+36)%64] <= 0;
        operand1s[(head+36)%64] <= 0;
        operand2s[(head+36)%64] <= 0;
        operand1_datas[(head+36)%64] <= 0;
        operand2_datas[(head+36)%64] <= 0;
        valid_entries1[(head+36)%64] <= 0;
        valid_entries2[(head+36)%64] <= 0;
    end
    64'b0000000000000000000000000010000000000000000000000000000000000000: begin
        result_out <= result[(head+37)%64];
        readys[(head+37)%64] <= 0;
        operand1s[(head+37)%64] <= 0;
        operand2s[(head+37)%64] <= 0;
        operand1_datas[(head+37)%64] <= 0;
        operand2_datas[(head+37)%64] <= 0;
        valid_entries1[(head+37)%64] <= 0;
        valid_entries2[(head+37)%64] <= 0;
    end
    64'b0000000000000000000000000100000000000000000000000000000000000000: begin
        result_out <= result[(head+38)%64];
        readys[(head+38)%64] <= 0;
        operand1s[(head+38)%64] <= 0;
        operand2s[(head+38)%64] <= 0;
        operand1_datas[(head+38)%64] <= 0;
        operand2_datas[(head+38)%64] <= 0;
        valid_entries1[(head+38)%64] <= 0;
        valid_entries2[(head+38)%64] <= 0;
    end
    64'b0000000000000000000000001000000000000000000000000000000000000000: begin
        result_out <= result[(head+39)%64];
        readys[(head+39)%64] <= 0;
        operand1s[(head+39)%64] <= 0;
        operand2s[(head+39)%64] <= 0;
        operand1_datas[(head+39)%64] <= 0;
        operand2_datas[(head+39)%64] <= 0;
        valid_entries1[(head+39)%64] <= 0;
        valid_entries2[(head+39)%64] <= 0;
    end
    64'b0000000000000000000000010000000000000000000000000000000000000000: begin
        result_out <= result[(head+40)%64];
        readys[(head+40)%64] <= 0;
        operand1s[(head+40)%64] <= 0;
        operand2s[(head+40)%64] <= 0;
        operand1_datas[(head+40)%64] <= 0;
        operand2_datas[(head+40)%64] <= 0;
        valid_entries1[(head+40)%64] <= 0;
        valid_entries2[(head+40)%64] <= 0;
    end
    64'b0000000000000000000000100000000000000000000000000000000000000000: begin
        result_out <= result[(head+41)%64];
        readys[(head+41)%64] <= 0;
        operand1s[(head+41)%64] <= 0;
        operand2s[(head+41)%64] <= 0;
        operand1_datas[(head+41)%64] <= 0;
        operand2_datas[(head+41)%64] <= 0;
        valid_entries1[(head+41)%64] <= 0;
        valid_entries2[(head+41)%64] <= 0;
    end
    64'b0000000000000000000001000000000000000000000000000000000000000000: begin
        result_out <= result[(head+42)%64];
        readys[(head+42)%64] <= 0;
        operand1s[(head+42)%64] <= 0;
        operand2s[(head+42)%64] <= 0;
        operand1_datas[(head+42)%64] <= 0;
        operand2_datas[(head+42)%64] <= 0;
        valid_entries1[(head+42)%64] <= 0;
        valid_entries2[(head+42)%64] <= 0;
    end
    64'b0000000000000000000010000000000000000000000000000000000000000000: begin
        result_out <= result[(head+43)%64];
        readys[(head+43)%64] <= 0;
        operand1s[(head+43)%64] <= 0;
        operand2s[(head+43)%64] <= 0;
        operand1_datas[(head+43)%64] <= 0;
        operand2_datas[(head+43)%64] <= 0;
        valid_entries1[(head+43)%64] <= 0;
        valid_entries2[(head+43)%64] <= 0;
    end
    64'b0000000000000000000100000000000000000000000000000000000000000000: begin
        result_out <= result[(head+44)%64];
        readys[(head+44)%64] <= 0;
        operand1s[(head+44)%64] <= 0;
        operand2s[(head+44)%64] <= 0;
        operand1_datas[(head+44)%64] <= 0;
        operand2_datas[(head+44)%64] <= 0;
        valid_entries1[(head+44)%64] <= 0;
        valid_entries2[(head+44)%64] <= 0;
    end
    64'b0000000000000000001000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+45)%64];
        readys[(head+45)%64] <= 0;
        operand1s[(head+45)%64] <= 0;
        operand2s[(head+45)%64] <= 0;
        operand1_datas[(head+45)%64] <= 0;
        operand2_datas[(head+45)%64] <= 0;
        valid_entries1[(head+45)%64] <= 0;
        valid_entries2[(head+45)%64] <= 0;
    end
    64'b0000000000000000010000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+46)%64];
        readys[(head+46)%64] <= 0;
        operand1s[(head+46)%64] <= 0;
        operand2s[(head+46)%64] <= 0;
        operand1_datas[(head+46)%64] <= 0;
        operand2_datas[(head+46)%64] <= 0;
        valid_entries1[(head+46)%64] <= 0;
        valid_entries2[(head+46)%64] <= 0;
    end
    64'b0000000000000000100000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+47)%64];
        readys[(head+47)%64] <= 0;
        operand1s[(head+47)%64] <= 0;
        operand2s[(head+47)%64] <= 0;
        operand1_datas[(head+47)%64] <= 0;
        operand2_datas[(head+47)%64] <= 0;
        valid_entries1[(head+47)%64] <= 0;
        valid_entries2[(head+47)%64] <= 0;
    end
    64'b0000000000000001000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+48)%64];
        readys[(head+48)%64] <= 0;
        operand1s[(head+48)%64] <= 0;
        operand2s[(head+48)%64] <= 0;
        operand1_datas[(head+48)%64] <= 0;
        operand2_datas[(head+48)%64] <= 0;
        valid_entries1[(head+48)%64] <= 0;
        valid_entries2[(head+48)%64] <= 0;
    end
    64'b0000000000000010000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+49)%64];
        readys[(head+49)%64] <= 0;
        operand1s[(head+49)%64] <= 0;
        operand2s[(head+49)%64] <= 0;
        operand1_datas[(head+49)%64] <= 0;
        operand2_datas[(head+49)%64] <= 0;
        valid_entries1[(head+49)%64] <= 0;
        valid_entries2[(head+49)%64] <= 0;
    end
    64'b0000000000000100000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+50)%64];
        readys[(head+50)%64] <= 0;
        operand1s[(head+50)%64] <= 0;
        operand2s[(head+50)%64] <= 0;
        operand1_datas[(head+50)%64] <= 0;
        operand2_datas[(head+50)%64] <= 0;
        valid_entries1[(head+50)%64] <= 0;
        valid_entries2[(head+50)%64] <= 0;
    end
    64'b0000000000001000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+51)%64];
        readys[(head+51)%64] <= 0;
        operand1s[(head+51)%64] <= 0;
        operand2s[(head+51)%64] <= 0;
        operand1_datas[(head+51)%64] <= 0;
        operand2_datas[(head+51)%64] <= 0;
        valid_entries1[(head+51)%64] <= 0;
        valid_entries2[(head+51)%64] <= 0;
    end
    64'b0000000000010000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+52)%64];
        readys[(head+52)%64] <= 0;
        operand1s[(head+52)%64] <= 0;
        operand2s[(head+52)%64] <= 0;
        operand1_datas[(head+52)%64] <= 0;
        operand2_datas[(head+52)%64] <= 0;
        valid_entries1[(head+52)%64] <= 0;
        valid_entries2[(head+52)%64] <= 0;
    end
    64'b0000000000100000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+53)%64];
        readys[(head+53)%64] <= 0;
        operand1s[(head+53)%64] <= 0;
        operand2s[(head+53)%64] <= 0;
        operand1_datas[(head+53)%64] <= 0;
        operand2_datas[(head+53)%64] <= 0;
        valid_entries1[(head+53)%64] <= 0;
        valid_entries2[(head+53)%64] <= 0;
    end
    64'b0000000001000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+54)%64];
        readys[(head+54)%64] <= 0;
        operand1s[(head+54)%64] <= 0;
        operand2s[(head+54)%64] <= 0;
        operand1_datas[(head+54)%64] <= 0;
        operand2_datas[(head+54)%64] <= 0;
        valid_entries1[(head+54)%64] <= 0;
        valid_entries2[(head+54)%64] <= 0;
    end
    64'b0000000010000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+55)%64];
        readys[(head+55)%64] <= 0;
        operand1s[(head+55)%64] <= 0;
        operand2s[(head+55)%64] <= 0;
        operand1_datas[(head+55)%64] <= 0;
        operand2_datas[(head+55)%64] <= 0;
        valid_entries1[(head+55)%64] <= 0;
        valid_entries2[(head+55)%64] <= 0;
    end
    64'b0000000100000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+56)%64];
        readys[(head+56)%64] <= 0;
        operand1s[(head+56)%64] <= 0;
        operand2s[(head+56)%64] <= 0;
        operand1_datas[(head+56)%64] <= 0;
        operand2_datas[(head+56)%64] <= 0;
        valid_entries1[(head+56)%64] <= 0;
        valid_entries2[(head+56)%64] <= 0;
    end
    64'b0000001000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+57)%64];
        readys[(head+57)%64] <= 0;
        operand1s[(head+57)%64] <= 0;
        operand2s[(head+57)%64] <= 0;
        operand1_datas[(head+57)%64] <= 0;
        operand2_datas[(head+57)%64] <= 0;
        valid_entries1[(head+57)%64] <= 0;
        valid_entries2[(head+57)%64] <= 0;
    end
    64'b0000010000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+58)%64];
        readys[(head+58)%64] <= 0;
        operand1s[(head+58)%64] <= 0;
        operand2s[(head+58)%64] <= 0;
        operand1_datas[(head+58)%64] <= 0;
        operand2_datas[(head+58)%64] <= 0;
        valid_entries1[(head+58)%64] <= 0;
        valid_entries2[(head+58)%64] <= 0;
    end
    64'b0000100000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+59)%64];
        readys[(head+59)%64] <= 0;
        operand1s[(head+59)%64] <= 0;
        operand2s[(head+59)%64] <= 0;
        operand1_datas[(head+59)%64] <= 0;
        operand2_datas[(head+59)%64] <= 0;
        valid_entries1[(head+59)%64] <= 0;
        valid_entries2[(head+59)%64] <= 0;
    end
    64'b0001000000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+60)%64];
        readys[(head+60)%64] <= 0;
        operand1s[(head+60)%64] <= 0;
        operand2s[(head+60)%64] <= 0;
        operand1_datas[(head+60)%64] <= 0;
        operand2_datas[(head+60)%64] <= 0;
        valid_entries1[(head+60)%64] <= 0;
        valid_entries2[(head+60)%64] <= 0;
    end
    64'b0010000000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+61)%64];
        readys[(head+61)%64] <= 0;
        operand1s[(head+61)%64] <= 0;
        operand2s[(head+61)%64] <= 0;
        operand1_datas[(head+61)%64] <= 0;
        operand2_datas[(head+61)%64] <= 0;
        valid_entries1[(head+61)%64] <= 0;
        valid_entries2[(head+61)%64] <= 0;
    end
    64'b0100000000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+62)%64];
        readys[(head+62)%64] <= 0;
        operand1s[(head+62)%64] <= 0;
        operand2s[(head+62)%64] <= 0;
        operand1_datas[(head+62)%64] <= 0;
        operand2_datas[(head+62)%64] <= 0;
        valid_entries1[(head+62)%64] <= 0;
        valid_entries2[(head+62)%64] <= 0;
    end
    64'b1000000000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+63)%64];
        readys[(head+63)%64] <= 0;
        operand1s[(head+63)%64] <= 0;
        operand2s[(head+63)%64] <= 0;
        operand1_datas[(head+63)%64] <= 0;
        operand2_datas[(head+63)%64] <= 0;
        valid_entries1[(head+63)%64] <= 0;
        valid_entries2[(head+63)%64] <= 0;
    end                                                                       
            default: begin
                result_out <= 0;
                readys <= 0;
               
            end
        endcase
    end
end

endmodule
