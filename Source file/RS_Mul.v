module priority_encoder (
    input wire [31:0] ready, // 32비트 ready 신호
    output reg [31:0] Y // 32비트 Y 출력
);

    always @(*) begin
        // 우선순위 인코더 논리
        if (ready[0]) Y = 32'b000000000000000000000000000000001;
        else if (ready[1]) Y = 32'b000000000000000000000000000000010;
        else if (ready[2]) Y = 32'b000000000000000000000000000000100;
        else if (ready[3]) Y = 32'b000000000000000000000000000001000;
        else if (ready[4]) Y = 32'b000000000000000000000000000010000;
        else if (ready[5]) Y = 32'b000000000000000000000000000100000;
        else if (ready[6]) Y = 32'b000000000000000000000000001000000;
        else if (ready[7]) Y = 32'b000000000000000000000000010000000;
        else if (ready[8]) Y = 32'b000000000000000000000000100000000;
        else if (ready[9]) Y = 32'b000000000000000000000001000000000;
        else if (ready[10]) Y = 32'b00000000000000000000010000000000;
        else if (ready[11]) Y = 32'b00000000000000000000100000000000;
        else if (ready[12]) Y = 32'b00000000000000000001000000000000;
        else if (ready[13]) Y = 32'b00000000000000000010000000000000;
        else if (ready[14]) Y = 32'b00000000000000000100000000000000;
        else if (ready[15]) Y = 32'b00000000000000001000000000000000;
        else if (ready[16]) Y = 32'b00000000000000010000000000000000;
        else if (ready[17]) Y = 32'b00000000000000100000000000000000;
        else if (ready[18]) Y = 32'b00000000000001000000000000000000;
        else if (ready[19]) Y = 32'b00000000000010000000000000000000;
        else if (ready[20]) Y = 32'b00000000000100000000000000000000;
        else if (ready[21]) Y = 32'b00000000001000000000000000000000;
        else if (ready[22]) Y = 32'b00000000010000000000000000000000;
        else if (ready[23]) Y = 32'b00000000100000000000000000000000;
        else if (ready[24]) Y = 32'b00000001000000000000000000000000;
        else if (ready[25]) Y = 32'b00000010000000000000000000000000;
        else if (ready[26]) Y = 32'b00000100000000000000000000000000;
        else if (ready[27]) Y = 32'b00001000000000000000000000000000;
        else if (ready[28]) Y = 32'b00010000000000000000000000000000;
        else if (ready[29]) Y = 32'b00100000000000000000000000000000;
        else if (ready[30]) Y = 32'b01000000000000000000000000000000;
        else if (ready[31]) Y = 32'b10000000000000000000000000000000;
        else Y = 32'b0; // 모든 조건에 해당하지 않으면 0으로 설정
    end
endmodule

module RS_Mul (
    input wire clk,
    input wire reset,
    input wire RS_div_start,
    input wire [31:0] RS_div_PC,
    input wire [7:0] RS_div_Rd,
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
    output reg [104:0] result_out
);
    
    // Internal storage for reservation station entries
    reg [31:0] PCs [0:31];
    reg [7:0] Rds [0:31];
    reg [3:0] ALUOPs [0:31];
    reg [7:0] operand1s [0:31];
    reg [7:0] operand2s [0:31];
    reg [31:0] operand1_datas [0:31];  // operand1 data
    reg [31:0] operand2_datas [0:31]; // operand2 data
    reg [31:0] valid_entries1;  // operand1이 valid한지
    reg [31:0] valid_entries2; // operand2가 valid한지
    reg [104:0] result [0:31];
    reg [4:0] tail;
    reg [31:0] readys;
    wire [31:0] Y;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tail <= 0;
            for (i = 0; i < 32; i = i + 1) begin
                PCs[i] <= 0;
                Rds[i] <= 0;
                ALUOPs[i] <= 0;
                operand1s[i] <= 0;
                operand2s[i] <= 0;
                operand1_datas[i] <= 0;
                operand2_datas[i] <= 0;
                valid_entries1[i] <= 1'b0; // 리셋 시 초기값으로 복원
                valid_entries2[i] <= 1'b0; // 리셋 시 초기값으로 복원
            end
        end else if (RS_div_start) begin
            if (RS_div_operand1 == ALU_result_dest) begin  // ALU에서 operand1의 연산이 끝났을때
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= ALU_result;
                operand2_datas[tail] <= RS_div_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_div_valid[1];
                tail <= (tail + 1) % 16;
            end else if (RS_div_operand2 == ALU_result_dest) begin  // ALU에서 operand2의 연산이 끝났을때
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RS_div_operand1_data;
                operand2_datas[tail] <= ALU_result;
                valid_entries1[tail] <= RS_div_valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 16;   
             end else if (RS_div_operand1 == MUL_result_dest) begin  // MUL에서 operand1의 연산이 끝났을때
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= MUL_result;
                operand2_datas[tail] <= RS_div_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_div_valid[1];
                tail <= (tail + 1) % 16;
             end else if (RS_div_operand2 == MUL_result_dest) begin  // MUL에서 operand2의 연산이 끝났을때
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RS_div_operand1_data;
                operand2_datas[tail] <= MUL_result;
                valid_entries1[tail] <= RS_div_valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 16;
              end else if (RS_div_operand1 == DIV_result_dest) begin  // DIV에서 operand1의 연산이 끝났을때
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= DIV_result;
                operand2_datas[tail] <= RS_div_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_div_valid[1];
                tail <= (tail + 1) % 16;
              end else if (RS_div_operand2 == DIV_result_dest) begin  // MUL에서 operand2의 연산이 끝났을때
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RS_div_operand1_data;
                operand2_datas[tail] <= DIV_result;
                valid_entries1[tail] <= RS_div_valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 16;
             end else if ( RS_div_operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RData;
                operand2_datas[tail] <= RS_div_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_div_valid[1] ; 
                tail <= (tail + 1) % 16;
              end else if ( RS_div_operand2 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RS_div_operand1_data;
                operand2_datas[tail] <= RData;
                valid_entries1[tail] <= RS_div_valid[0];
                valid_entries2[tail] <= 1 ; 
                tail <= (tail + 1) % 16;
            end else begin
                PCs[tail] <= RS_div_PC;
                Rds[tail] <= RS_div_Rd;
                operand1s[tail] <= RS_div_operand1;
                operand2s[tail] <= RS_div_operand2;
                operand1_datas[tail] <= RS_div_operand1_data;
                operand2_datas[tail] <= RS_div_operand1_data ;
                valid_entries1[tail] <= RS_div_valid[0];
                valid_entries2[tail] <= RS_div_valid[1]; 
                tail <= (tail + 1) % 16;
             end 
            if (ALU_result_valid) begin
                for (i = 0; i < 32; i = i + 1) begin
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
                for (i = 0; i < 32; i = i + 1) begin
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
                for (i = 0; i < 32; i = i + 1) begin
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
           for (i = 0; i < 32; i = i + 1) begin
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
      end
    


    always @(*) begin
        for (i = 0; i < 32; i = i + 1) begin
            if (valid_entries1[i] && valid_entries2[i] ) begin
                readys[i] = 1;
                result[i] = {1'b1, PCs[i], Rds[i], operand1_datas[i], operand2_datas[i]};
            end
        end
    end

    priority_encoder encoder (
        .ready(readys),
        .Y(Y)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result_out <= 0;
        end else begin
            case (Y)
                32'b000000000000000000000000000000001: begin
                    result_out <= result[0];
                    valid_entries1[0] <= 0;
                    valid_entries2[0] <= 0;
                end
                32'b000000000000000000000000000000010: begin
                    result_out <= result[1];
                    valid_entries1[1] <= 0;
                    valid_entries2[1] <= 0;
                end
                32'b000000000000000000000000000000100: begin
                    result_out <= result[2];
                    valid_entries1[2] <= 0;
                    valid_entries2[2] <= 0;
                end
                32'b000000000000000000000000000001000: begin
                    result_out <= result[3];
                    valid_entries1[3] <= 0;
                    valid_entries2[3] <= 0;
                end
                32'b000000000000000000000000000010000: begin
                    result_out <= result[4];
                    valid_entries1[4] <= 0;
                    valid_entries2[4] <= 0;
                end
                32'b000000000000000000000000000100000: begin
                    result_out <= result[5];
                    valid_entries1[5] <= 0;
                    valid_entries2[5] <= 0;
                end
                32'b000000000000000000000000001000000: begin
                    result_out <= result[6];
                    valid_entries1[6] <= 0;
                    valid_entries2[6] <= 0;
                end
                32'b000000000000000000000000010000000: begin
                    result_out <= result[7];
                    valid_entries1[7] <= 0;
                    valid_entries2[7] <= 0;
                end
                32'b000000000000000000000000100000000: begin
                    result_out <= result[8];
                    valid_entries1[8] <= 0;
                    valid_entries2[8] <= 0;
                end
                32'b000000000000000000000001000000000: begin
                    result_out <= result[9];
                    valid_entries1[9] <= 0;
                    valid_entries2[9] <= 0;
                end
                32'b00000000000000000000010000000000: begin
                    result_out <= result[10];
                    valid_entries1[10] <= 0;
                    valid_entries2[10] <= 0;
                end
                32'b00000000000000000000100000000000: begin
                    result_out <= result[11];
                    valid_entries1[11] <= 0;
                    valid_entries2[11] <= 0;
                end
                32'b00000000000000000001000000000000: begin
                    result_out <= result[12];
                    valid_entries1[12] <= 0;
                    valid_entries2[12] <= 0;
                end
                32'b00000000000000000010000000000000: begin
                    result_out <= result[13];
                    valid_entries1[13] <= 0;
                    valid_entries2[13] <= 0;
                end
                32'b00000000000000000100000000000000: begin
                    result_out <= result[14];
                    valid_entries1[14] <= 0;
                    valid_entries2[14] <= 0;
                end
                32'b00000000000000001000000000000000: begin
                    result_out <= result[15];
                    valid_entries1[15] <= 0;
                    valid_entries2[15] <= 0;
                end
                32'b00000000000000010000000000000000: begin
                    result_out <= result[16];
                    valid_entries1[16] <= 0;
                    valid_entries2[16] <= 0;
                end
                32'b00000000000000100000000000000000: begin
                    result_out <= result[17];
                    valid_entries1[17] <= 0;
                    valid_entries2[17] <= 0;
                end
                32'b00000000000001000000000000000000: begin
                    result_out <= result[18];
                    valid_entries1[18] <= 0;
                    valid_entries2[18] <= 0;
                end
                32'b00000000000010000000000000000000: begin
                    result_out <= result[19];
                    valid_entries1[19] <= 0;
                    valid_entries2[19] <= 0;
                end
                32'b00000000000100000000000000000000: begin
                    result_out <= result[20];
                    valid_entries1[20] <= 0;
                    valid_entries2[20] <= 0;
                end
                32'b00000000001000000000000000000000: begin
                    result_out <= result[21];
                    valid_entries1[21] <= 0;
                    valid_entries2[21] <= 0;
                end                
                32'b00000000010000000000000000000000: begin
                    result_out <= result[22];
                    valid_entries1[22] <= 0;
                    valid_entries2[22] <= 0;
                end                
                32'b00000000100000000000000000000000: begin
                    result_out <= result[23];
                    valid_entries1[23] <= 0;
                    valid_entries2[23] <= 0;
                end                
                32'b00000001000000000000000000000000: begin
                    result_out <= result[24];
                    valid_entries1[24] <= 0;
                    valid_entries2[24] <= 0;
                end                
                32'b00000010000000000000000000000000: begin
                    result_out <= result[25];
                    valid_entries1[25] <= 0;
                    valid_entries2[25] <= 0;
                end                
                32'b00000100000000000000000000000000: begin
                    result_out <= result[26];
                    valid_entries1[26] <= 0;
                    valid_entries2[26] <= 0;
                end                
                32'b00001000000000000000000000000000: begin
                    result_out <= result[27];
                    valid_entries1[27] <= 0;
                    valid_entries2[27] <= 0;
                end                
                32'b00010000000000000000000000000000: begin
                    result_out <= result[28];
                    valid_entries1[28] <= 0;
                    valid_entries2[28] <= 0;
                end                
                32'b00100000000000000000000000000000: begin
                    result_out <= result[29];
                    valid_entries1[29] <= 0;
                    valid_entries2[29] <= 0;
                end                
                32'b01000000000000000000000000000000: begin
                    result_out <= result[30];
                    valid_entries1[30] <= 0;
                    valid_entries2[30] <= 0;
                end  
                32'b10000000000000000000000000000000: begin
                    result_out <= result[31];
                    valid_entries1[31] <= 0;
                    valid_entries2[31] <= 0;
                end                                                                              
                default: result_out <= 0;
            endcase
        end
    end
endmodule

