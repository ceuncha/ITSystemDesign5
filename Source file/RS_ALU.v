module priority_encoder (
    input wire [63:0] ready, // 64비트 ready 신호
    input wire [6:0] head,
    output reg [63:0] Y // 64비트 Y 출력
);

always @(*) begin
    // 우선순위 인코더 논리
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
    else Y = 64'b0; // 모든 조건에 해당하지 않으면 0으로 설정
end
endmodule

module RS_ALU (
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
    output reg [182:0] result_out,
);
    
    // Internal storage for reservation station entries
    reg [31:0] inst_nums[0:63];
    reg [31:0] PCs [0:63];
    reg [7:0] Rds [0:63];
    reg [63:0] MemToRegs;
    reg [63:0] MemReads;
    reg [63:0] MemWrites;
    reg [3:0] ALUOPs [0:63];
    reg [63:0] ALUSrc1s;
    reg [63:0] ALUSrc2s;
    reg [63:0] Jumps;
    reg [63:0] Branchs;
    reg [2:0] funct3s [0:63];
    reg [31:0] immediates [0:63];
    reg [7:0] operand1s [0:63];
    reg [7:0] operand2s [0:63];
    reg [31:0] operand1_datas [0:63];  // operand1 data
    reg [31:0] operand2_datas [0:63]; // operand2 data
    reg [63:0] valid_entries1;  // operand1?씠 valid?븳吏?
    reg [63:0] valid_entries2; // operand2媛? valid?븳吏?
    reg [182:0] result [0:63];
    reg [6:0] tail;
    reg [6:0] heads;
    reg [63:0] readys;
    wire [63:0] Y;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tail <= 0;
            heads <=0;
            for (i = 0; i < 64; i = i + 1) begin
                inst_nums[i] <=0;
                PCs[i] <= 0;
                Rds[i] <= 0;
                result[i] <= 0;
                readys[i] <= 0;
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
                valid_entries1[i] <= 1'b0; // 由ъ뀑 ?떆 珥덇린媛믪쑝濡? 蹂듭썝
                valid_entries2[i] <= 1'b0; // 由ъ뀑 ?떆 珥덇린媛믪쑝濡? 蹂듭썝
            end
        end else if (start) begin
            if (operand1 == ALU_result_dest) begin  // ALU?뿉?꽌 operand1?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
            end else if (operand2 == ALU_result_dest) begin  // ALU?뿉?꽌 operand2?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
             end else if (operand1 == MUL_result_dest) begin  // MUL?뿉?꽌 operand1?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
             end else if (operand2 == MUL_result_dest) begin  // MUL?뿉?꽌 operand2?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
              end else if (operand1 == DIV_result_dest) begin  // DIV?뿉?꽌 operand1?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
              end else if (operand2 == DIV_result_dest) begin  // DIV?뿉?꽌 operand2?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
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
             end else if ( operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin
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
            if (valid_entries1[i] && valid_entries2[i] && !MemReads[i]) begin
                readys[i] = 1;
                result[i] = {inst_nums[i],1'b1, PCs[i], Rds[i], MemToRegs[i], MemReads[i], MemWrites[i], ALUOPs[i], ALUSrc1s[i], ALUSrc2s[i], Jumps[i], Branchs[i], funct3s[i],immediates[i], operand1_datas[i], operand2_datas[i]};
            end else if (valid_entries1[i] && valid_entries2[i] && MemReads[i]) begin
                readys[i] = 1;
                result[i] = {inst_nums[i],1'b0, PCs[i], Rds[i], MemToRegs[i], MemReads[i], MemWrites[i], ALUOPs[i], ALUSrc1s[i], ALUSrc2s[i], Jumps[i], Branchs[i], funct3s[i],immediates[i], operand1_datas[i], operand2_datas[i]};
            end
        end
    end

    priority_encoder encoder (
        .ready(readys),
        .head(heads),
        .Y(Y)
    );


always @(posedge clk or posedge reset) begin
    if (reset) begin
        result_out <= 0;
        heads <= 0;
    end else begin
        case (Y)
            64'b0000000000000000000000000000000000000000000000000000000000000001: begin
                result_out <= result[0];
                readys[0] <= 0;
                valid_entries1[0] <= 0;
                valid_entries2[0] <= 0;
                heads <= (heads + 1) % 64;
           
            end
            64'b0000000000000000000000000000000000000000000000000000000000000010: begin
                result_out <= result[1];
                readys[1] <= 0;
                valid_entries1[1] <= 0;
                valid_entries2[1] <= 0;
                heads <= (heads + 1) % 64;
            
            end
            64'b0000000000000000000000000000000000000000000000000000000000000100: begin
                result_out <= result[2];
                readys[2] <= 0;
                valid_entries1[2] <= 0;
                valid_entries2[2] <= 0;
                heads <= (heads + 1) % 64;
          
            end
            64'b0000000000000000000000000000000000000000000000000000000000001000: begin
                result_out <= result[3];
                readys[3] <= 0;
                valid_entries1[3] <= 0;
                valid_entries2[3] <= 0;
                heads <= (heads + 1) % 64;
            
            end
            64'b0000000000000000000000000000000000000000000000000000000000010000: begin
                result_out <= result[4];
                readys[4] <= 0;
                valid_entries1[4] <= 0;
                valid_entries2[4] <= 0;
                heads <= (heads + 1) % 64;
          
            end
            64'b0000000000000000000000000000000000000000000000000000000000100000: begin
                result_out <= result[5];
                readys[5] <= 0;
                valid_entries1[5] <= 0;
                valid_entries2[5] <= 0;
                heads <= (heads + 1) % 64;
            
            end
            64'b0000000000000000000000000000000000000000000000000000000001000000: begin
                result_out <= result[6];
                readys[6] <= 0;
                valid_entries1[6] <= 0;
                valid_entries2[6] <= 0;
                heads <= (heads + 1) % 64;
          
            end
            64'b0000000000000000000000000000000000000000000000000000000010000000: begin
                result_out <= result[7];
                readys[7] <= 0;
                valid_entries1[7] <= 0;
                valid_entries2[7] <= 0;
                heads <= (heads + 1) % 64;
           
            end
            64'b0000000000000000000000000000000000000000000000000000000100000000: begin
                result_out <= result[8];
                readys[8] <= 0;
                valid_entries1[8] <= 0;
                valid_entries2[8] <= 0;
                heads <= (heads + 1) % 64;
              
            end
            64'b0000000000000000000000000000000000000000000000000000001000000000: begin
                result_out <= result[9];
                readys[9] <= 0;
                valid_entries1[9] <= 0;
                valid_entries2[9] <= 0;
                heads <= (heads + 1) % 64;
            
            end
            64'b0000000000000000000000000000000000000000000000000000010000000000: begin
                result_out <= result[10];
                readys[10] <= 0;
                valid_entries1[10] <= 0;
                valid_entries2[10] <= 0;
                heads <= (heads + 1) % 64;
             
            end
            64'b0000000000000000000000000000000000000000000000000000100000000000: begin
                result_out <= result[11];
                readys[11] <= 0;
                valid_entries1[11] <= 0;
                valid_entries2[11] <= 0;
                heads <= (heads + 1) % 64;
              
            end
            64'b0000000000000000000000000000000000000000000000000001000000000000: begin
                result_out <= result[12];
                readys[12] <= 0;
                valid_entries1[12] <= 0;
                valid_entries2[12] <= 0;
                heads <= (heads + 1) % 64;
            
            end
            64'b0000000000000000000000000000000000000000000000000010000000000000: begin
                result_out <= result[13];
                readys[13] <= 0;
                valid_entries1[13] <= 0;
                valid_entries2[13] <= 0;
                heads <= (heads + 1) % 64;
           
            end
            64'b0000000000000000000000000000000000000000000000000100000000000000: begin
                result_out <= result[14];
                readys[14] <= 0;
                valid_entries1[14] <= 0;
                valid_entries2[14] <= 0;
                heads <= (heads + 1) % 64;
          
            end
            64'b0000000000000000000000000000000000000000000000001000000000000000: begin
                result_out <= result[15];
                readys[15] <= 0;
                valid_entries1[15] <= 0;
                valid_entries2[15] <= 0;
                heads <= (heads + 1) % 64;
            
            end
            64'b0000000000000000000000000000000000000000000000010000000000000000: begin
                result_out <= result[16];
                readys[16] <= 0;
                valid_entries1[16] <= 0;
                valid_entries2[16] <= 0;
                heads <= (heads + 1) % 64;
               
            end
            64'b0000000000000000000000000000000000000000000000100000000000000000: begin
                result_out <= result[17];
                readys[17] <= 0;
                valid_entries1[17] <= 0;
                valid_entries2[17] <= 0;
                heads <= (heads + 1) % 64;
            
            end
            64'b0000000000000000000000000000000000000000000001000000000000000000: begin
                result_out <= result[18];
                readys[18] <= 0;
                valid_entries1[18] <= 0;
                valid_entries2[18] <= 0;
                heads <= (heads + 1) % 64;
              
            end
            64'b0000000000000000000000000000000000000000000010000000000000000000: begin
                result_out <= result[19];
                readys[19] <= 0;
                valid_entries1[19] <= 0;
                valid_entries2[19] <= 0;
                heads <= (heads + 1) % 64;
             
            end
            64'b0000000000000000000000000000000000000000000100000000000000000000: begin
                result_out <= result[20];
                readys[20] <= 0;
                valid_entries1[20] <= 0;
                valid_entries2[20] <= 0;
                heads <= (heads + 1) % 64;
              
            end
            64'b0000000000000000000000000000000000000000001000000000000000000000: begin
                result_out <= result[21];
                readys[21] <= 0;
                valid_entries1[21] <= 0;
                valid_entries2[21] <= 0;
                heads <= (heads + 1) % 64;
               
            end
            64'b0000000000000000000000000000000000000000010000000000000000000000: begin
                result_out <= result[22];
                readys[22] <= 0;
                valid_entries1[22] <= 0;
                valid_entries2[22] <= 0;
                heads <= (heads + 1) % 64;
              
            end                
            64'b0000000000000000000000000000000000000000100000000000000000000000: begin
                result_out <= result[23];
                readys[23] <= 0;
                valid_entries1[23] <= 0;
                valid_entries2[23] <= 0;
                heads <= (heads + 1) % 64;
             
            end                
            64'b0000000000000000000000000000000000000001000000000000000000000000: begin
                result_out <= result[24];
                readys[24] <= 0;
                valid_entries1[24] <= 0;
                valid_entries2[24] <= 0;
                heads <= (heads + 1) % 64;
             
            end                
            64'b0000000000000000000000000000000000000010000000000000000000000000: begin
                result_out <= result[25];
                readys[25] <= 0;
                valid_entries1[25] <= 0;
                valid_entries2[25] <= 0;
                heads <= (heads + 1) % 64;
             
            end                
            64'b0000000000000000000000000000000000000100000000000000000000000000: begin
                result_out <= result[26];
                readys[26] <= 0;
                valid_entries1[26] <= 0;
                valid_entries2[26] <= 0;
                heads <= (heads + 1) % 64;
            
            end                
            64'b0000000000000000000000000000000000001000000000000000000000000000: begin
                result_out <= result[27];
                readys[27] <= 0;
                valid_entries1[27] <= 0;
                valid_entries2[27] <= 0;
                heads <= (heads + 1) % 64;
              
            end                
            64'b0000000000000000000000000000000000010000000000000000000000000000: begin
                result_out <= result[28];
                readys[28] <= 0;
                valid_entries1[28] <= 0;
                valid_entries2[28] <= 0;
                heads <= (heads + 1) % 64;
              
            end                
            64'b0000000000000000000000000000000000100000000000000000000000000000: begin
                result_out <= result[29];
                readys[29] <= 0;
                valid_entries1[29] <= 0;
                valid_entries2[29] <= 0;
                heads <= (heads + 1) % 64;
              
            end                
            64'b0000000000000000000000000000000001000000000000000000000000000000: begin
                result_out <= result[30];
                readys[30] <= 0;
                valid_entries1[30] <= 0;
                valid_entries2[30] <= 0;
                heads <= (heads + 1) % 64;
            
            end                
            64'b0000000000000000000000000000000010000000000000000000000000000000: begin
                result_out <= result[31];
                readys[31] <= 0;
                valid_entries1[31] <= 0;
                valid_entries2[31] <= 0;
                heads <= (heads + 1) % 64;
            
            end                                                                              
            64'b0000000000000000000000000000000100000000000000000000000000000000: begin
                result_out <= result[32];
                readys[32] <= 0;
                valid_entries1[32] <= 0;
                valid_entries2[32] <= 0;
                heads <= (heads + 1) % 64;
        
            end
            64'b0000000000000000000000000000001000000000000000000000000000000000: begin
                result_out <= result[33];
                readys[33] <= 0;
                valid_entries1[33] <= 0;
                valid_entries2[33] <= 0;
                heads <= (heads + 1) % 64;
              
            end
            64'b0000000000000000000000000000010000000000000000000000000000000000: begin
                result_out <= result[34];
                readys[34] <= 0;
                valid_entries1[34] <= 0;
                valid_entries2[34] <= 0;
                heads <= (heads + 1) % 64;
           
            end
            64'b0000000000000000000000000000100000000000000000000000000000000000: begin
                result_out <= result[35];
                readys[35] <= 0;
                valid_entries1[35] <= 0;
                valid_entries2[35] <= 0;
                heads <= (heads + 1) % 64;
            
            end
            64'b0000000000000000000000000001000000000000000000000000000000000000: begin
                result_out <= result[36];
                readys[36] <= 0;
                valid_entries1[36] <= 0;
                valid_entries2[36] <= 0;
                heads <= (heads + 1) % 64;
             
            end
            64'b0000000000000000000000000010000000000000000000000000000000000000: begin
                result_out <= result[37];
                readys[37] <= 0;
                valid_entries1[37] <= 0;
                valid_entries2[37] <= 0;
                heads <= (heads + 1) % 64;
              
            end
            64'b0000000000000000000000000100000000000000000000000000000000000000: begin
                result_out <= result[38];
                readys[38] <= 0;
                valid_entries1[38] <= 0;
                valid_entries2[38] <= 0;
                heads <= (heads + 1) % 64;
              
            end
            64'b0000000000000000000000001000000000000000000000000000000000000000: begin
                result_out <= result[39];
                readys[39] <= 0;
                valid_entries1[39] <= 0;
                valid_entries2[39] <= 0;
                heads <= (heads + 1) % 64;
             
            end
            64'b0000000000000000000000010000000000000000000000000000000000000000: begin
                result_out <= result[40];
                readys[40] <= 0;
                valid_entries1[40] <= 0;
                valid_entries2[40] <= 0;
                heads <= (heads + 1) % 64;
           
            end
            64'b0000000000000000000000100000000000000000000000000000000000000000: begin
                result_out <= result[41];
                readys[41] <= 0;
                valid_entries1[41] <= 0;
                valid_entries2[41] <= 0;
                heads <= (heads + 1) % 64;
            
            end
            64'b0000000000000000000001000000000000000000000000000000000000000000: begin
                result_out <= result[42];
                readys[42] <= 0;
                valid_entries1[42] <= 0;
                valid_entries2[42] <= 0;
                heads <= (heads + 1) % 64;
              
            end
            64'b0000000000000000000010000000000000000000000000000000000000000000: begin
                result_out <= result[43];
                readys[43] <= 0;
                valid_entries1[43] <= 0;
                valid_entries2[43] <= 0;
                heads <= (heads + 1) % 64;
          
            end
            64'b0000000000000000000100000000000000000000000000000000000000000000: begin
                result_out <= result[44];
                readys[44] <= 0;
                valid_entries1[44] <= 0;
                valid_entries2[44] <= 0;
                heads <= (heads + 1) % 64;
          
            end
            64'b0000000000000000001000000000000000000000000000000000000000000000: begin
                result_out <= result[45];
                readys[45] <= 0;
                valid_entries1[45] <= 0;
                valid_entries2[45] <= 0;
                heads <= (heads + 1) % 64;
      
            end
            64'b0000000000000000010000000000000000000000000000000000000000000000: begin
                result_out <= result[46];
                readys[46] <= 0;
                valid_entries1[46] <= 0;
                valid_entries2[46] <= 0;
                heads <= (heads + 1) % 64;
     
            end
            64'b0000000000000000100000000000000000000000000000000000000000000000: begin
                result_out <= result[47];
                readys[47] <= 0;
                valid_entries1[47] <= 0;
                valid_entries2[47] <= 0;
                heads <= (heads + 1) % 64;
           
            end
            64'b0000000000000001000000000000000000000000000000000000000000000000: begin
                result_out <= result[48];
                readys[48] <= 0;
                valid_entries1[48] <= 0;
                valid_entries2[48] <= 0;
                heads <= (heads + 1) % 64;
            
            end
            64'b0000000000000010000000000000000000000000000000000000000000000000: begin
                result_out <= result[49];
                readys[49] <= 0;
                valid_entries1[49] <= 0;
                valid_entries2[49] <= 0;
                heads <= (heads + 1) % 64;
              
            end
            64'b0000000000000100000000000000000000000000000000000000000000000000: begin
                result_out <= result[50];
                readys[50] <= 0;
                valid_entries1[50] <= 0;
                valid_entries2[50] <= 0;
                heads <= (heads + 1) % 64;
               
            end
            64'b0000000000001000000000000000000000000000000000000000000000000000: begin
                result_out <= result[51];
                readys[51] <= 0;
                valid_entries1[51] <= 0;
                valid_entries2[51] <= 0;
                heads <= (heads + 1) % 64;
              
            end                
            64'b0000000000010000000000000000000000000000000000000000000000000000: begin
                result_out <= result[52];
                readys[52] <= 0;
                valid_entries1[52] <= 0;
                valid_entries2[52] <= 0;
                heads <= (heads + 1) % 64;
               
            end                
            64'b0000000000100000000000000000000000000000000000000000000000000000: begin
                result_out <= result[53];
                readys[53] <= 0;
                valid_entries1[53] <= 0;
                valid_entries2[53] <= 0;
                heads <= (heads + 1) % 64;
              
            end                
            64'b0000000001000000000000000000000000000000000000000000000000000000: begin
                result_out <= result[54];
                readys[54] <= 0;
                valid_entries1[54] <= 0;
                valid_entries2[54] <= 0;
                heads <= (heads + 1) % 64;
                
            end                
            64'b0000000010000000000000000000000000000000000000000000000000000000: begin
                result_out <= result[55];
                readys[55] <= 0;
                valid_entries1[55] <= 0;
                valid_entries2[55] <= 0;
                heads <= (heads + 1) % 64;
            
            end                
            64'b0000000100000000000000000000000000000000000000000000000000000000: begin
                result_out <= result[56];
                readys[56] <= 0;
                valid_entries1[56] <= 0;
                valid_entries2[56] <= 0;
                heads <= (heads + 1) % 64;
               
            end                
            64'b0000001000000000000000000000000000000000000000000000000000000000: begin
                result_out <= result[57];
                readys[57] <= 0;
                valid_entries1[57] <= 0;
                valid_entries2[57] <= 0;
                heads <= (heads + 1) % 64;
                
            end                
            64'b0000010000000000000000000000000000000000000000000000000000000000: begin
                result_out <= result[58];
                readys[58] <= 0;
                valid_entries1[58] <= 0;
                valid_entries2[58] <= 0;
                heads <= (heads + 1) % 64;
                
            end                
            64'b0000100000000000000000000000000000000000000000000000000000000000: begin
                result_out <= result[59];
                readys[59] <= 0;
                valid_entries1[59] <= 0;
                valid_entries2[59] <= 0;
                heads <= (heads + 1) % 64;
              
            end                
            64'b0001000000000000000000000000000000000000000000000000000000000000: begin
                result_out <= result[60];
                readys[60] <= 0;
                valid_entries1[60] <= 0;
                valid_entries2[60] <= 0;
                heads <= (heads + 1) % 64;
              
            end                
            64'b0010000000000000000000000000000000000000000000000000000000000000: begin
                result_out <= result[61];
                readys[61] <= 0;
                valid_entries1[61] <= 0;
                valid_entries2[61] <= 0;
                heads <= (heads + 1) % 64;
               
            end                
            64'b0100000000000000000000000000000000000000000000000000000000000000: begin
                result_out <= result[62];
                readys[62] <= 0;
                valid_entries1[62] <= 0;
                valid_entries2[62] <= 0;
                heads <= (heads + 1) % 64;
                
            end  
            64'b1000000000000000000000000000000000000000000000000000000000000000: begin
                result_out <= result[63];
                readys[63] <= 0;
                valid_entries1[63] <= 0;
                valid_entries2[63] <= 0;
                heads <= (heads + 1) % 64;
                head <= (heads + 1) % 64;
            end                                                                              
            default: begin
                result_out <= 0;
                readys <= 0;
                heads <= (heads + 1) % 64;
               
            end
        endcase
    end
end

endmodule
