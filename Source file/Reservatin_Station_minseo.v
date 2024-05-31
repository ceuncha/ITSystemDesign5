module priority_encoder (
    input wire [15:0] ready, // 16비트 ready 신호
    output reg [15:0] Y // 16비트 Y 출력
);

    always @(*) begin
        // 우선순위 인코더 논리
        if (ready[0]) Y = 16'b0000000000000001;
        else if (ready[1]) Y = 16'b0000000000000010;
        else if (ready[2]) Y = 16'b0000000000000100;
        else if (ready[3]) Y = 16'b0000000000001000;
        else if (ready[4]) Y = 16'b0000000000010000;
        else if (ready[5]) Y = 16'b0000000000100000;
        else if (ready[6]) Y = 16'b0000000001000000;
        else if (ready[7]) Y = 16'b0000000010000000;
        else if (ready[8]) Y = 16'b0000000100000000;
        else if (ready[9]) Y = 16'b0000001000000000;
        else if (ready[10]) Y = 16'b0000010000000000;
        else if (ready[11]) Y = 16'b0000100000000000;
        else if (ready[12]) Y = 16'b0001000000000000;
        else if (ready[13]) Y = 16'b0010000000000000;
        else if (ready[14]) Y = 16'b0100000000000000;
        else if (ready[15]) Y = 16'b1000000000000000;
        else Y = 16'b0; // 모든 조건에 해당하지 않으면 0으로 설정
    end
endmodule

module Reservation_station (
    input wire clk,
    input wire reset,
    input wire [6:0] opcode,
    input wire [31:0] PC,
    input wire [6:0] Rd,
    input wire MemRead,
    input wire EX_MEM_MemRead,
    input wire [31:0] RData,
    input wire [6:0] EX_MEM_Physical_Address,
    input wire [6:0] operand1,
    input wire [6:0] operand2,
    input wire [31:0] operand1_data,
    input wire [31:0] operand2_data,
    input wire [1:0] valid,
    input wire [31:0] ALU_result,
    input wire [6:0] ALU_result_dest,
    input wire ALU_result_valid,
    output reg [124:0] result_out
);
    
    // Internal storage for reservation station entries
    reg [6:0] opcodes [15:0];
    reg [31:0] PCs [15:0];
    reg [6:0] Rds [15:0];
    reg [15:0] MemReads;
    reg [6:0] operand1s [15:0];
    reg [6:0] operand2s [15:0];
    reg [31:0] operand1_datas [15:0];  // operand1 data
    reg [31:0] operand2_datas [15:0]; // operand2 data
    reg [15:0] valid_entries1;  // operand1이 valid한지
    reg [15:0] valid_entries2; // operand2가 valid한지
    reg [124:0] result [15:0];
    reg [3:0] tail;
    reg [15:0] readys;
    wire [15:0] Y;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tail <= 0;
            for (i = 0; i < 16; i = i + 1) begin
                valid_entries1[i] <= 1'b0; // 리셋 시 초기값으로 복원
                valid_entries2[i] <= 1'b0; // 리셋 시 초기값으로 복원
            end
        end else begin
            if (operand1 == ALU_result_dest) begin  // ALU에서 operand1의 연산이 끝났을때
                opcodes[tail] <= opcode;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= ALU_result;
                operand2_datas[tail] <= operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1];
                tail <= (tail + 1) % 16;
            end else if (operand2 == ALU_result_dest) begin  // ALU에서 operand2의 연산이 끝났을때
                opcodes[tail] <= opcode;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= ALU_result;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 16;
             end else if ( operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin
                opcodes[tail] <= opcode;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= RData;
                operand2_datas[tail] <= operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1] ; 
                tail <= (tail + 1) % 16;
              end else if ( operand2 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin
                opcodes[tail] <= opcode;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= RData;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1 ; 
                tail <= (tail + 1) % 16;
            end else begin
               opcodes[tail] <= opcode;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= operand1_data ;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= valid[1]; 
                tail <= (tail + 1) % 16;
             end 
            if (ALU_result_valid) begin
                for (i = 0; i < 16; i = i + 1) begin
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
           if (EX_MEM_MemRead) begin
           for (i = 0; i < 16; i = i + 1) begin
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
        for (i = 0; i < 16; i = i + 1) begin
            if (valid_entries1[i] && valid_entries2[i] && !MemReads[i]) begin
                readys[i] = 1;
                result[i] = {1'b1,opcodes[i], PCs[i], Rds[i], operand1s[i], operand2s[i], operand1_datas[i], operand2_datas[i]};
            end else if (valid_entries1[i] && valid_entries2[i] && MemReads[i]) begin
                readys[i] = 1;
                result[i] = {1'b0,opcodes[i], PCs[i], Rds[i], operand1s[i], operand2s[i], operand1_datas[i], operand2_datas[i]};
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
                16'b0000000000000001: begin
                    result_out <= result[0];
                    valid_entries1[0] <= 0;
                    valid_entries2[0] <= 0;
                end
                16'b0000000000000010: begin
                    result_out <= result[1];
                    valid_entries1[1] <= 0;
                    valid_entries2[1] <= 0;
                end
                16'b0000000000000100: begin
                    result_out <= result[2];
                    valid_entries1[2] <= 0;
                    valid_entries2[2] <= 0;
                end
                16'b0000000000001000: begin
                    result_out <= result[3];
                    valid_entries1[3] <= 0;
                    valid_entries2[3] <= 0;
                end
                16'b0000000000010000: begin
                    result_out <= result[4];
                    valid_entries1[4] <= 0;
                    valid_entries2[4] <= 0;
                end
                16'b0000000000100000: begin
                    result_out <= result[5];
                    valid_entries1[5] <= 0;
                    valid_entries2[5] <= 0;
                end
                16'b0000000001000000: begin
                    result_out <= result[6];
                    valid_entries1[6] <= 0;
                    valid_entries2[6] <= 0;
                end
                16'b0000000010000000: begin
                    result_out <= result[7];
                    valid_entries1[7] <= 0;
                    valid_entries2[7] <= 0;
                end
                16'b0000000100000000: begin
                    result_out <= result[8];
                    valid_entries1[8] <= 0;
                    valid_entries2[8] <= 0;
                end
                16'b0000001000000000: begin
                    result_out <= result[9];
                    valid_entries1[9] <= 0;
                    valid_entries2[9] <= 0;
                end
                16'b0000010000000000: begin
                    result_out <= result[10];
                    valid_entries1[10] <= 0;
                    valid_entries2[10] <= 0;
                end
                16'b0000100000000000: begin
                    result_out <= result[11];
                    valid_entries1[11] <= 0;
                    valid_entries2[11] <= 0;
                end
                16'b0001000000000000: begin
                    result_out <= result[12];
                    valid_entries1[12] <= 0;
                    valid_entries2[12] <= 0;
                end
                16'b0010000000000000: begin
                    result_out <= result[13];
                    valid_entries1[13] <= 0;
                    valid_entries2[13] <= 0;
                end
                16'b0100000000000000: begin
                    result_out <= result[14];
                    valid_entries1[14] <= 0;
                    valid_entries2[14] <= 0;
                end
                16'b1000000000000000: begin
                    result_out <= result[15];
                    valid_entries1[15] <= 0;
                    valid_entries2[15] <= 0;
                end
                default: result_out <= 0;
            endcase
        end
    end
endmodule
