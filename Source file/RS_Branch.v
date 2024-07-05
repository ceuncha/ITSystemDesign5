module RS_Branch (                                             //명령어 forwarding, 준비된 명령어부터 내보내주는 역할들을 수행.
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

    input wire RS_alu_IF_ID_taken,
    input wire RS_alu_IF_ID_hit,
  
  output reg [184:0] result_out
    
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
    reg [184:0] result [0:63];
    reg [63:0] takens;
    reg [63:0] hits;
    reg [6:0] tail;
    reg [6:0] head;
    reg [63:0] readys;
    wire [63:0] Y;
    integer i;
    reg RS_ALU_on[0:63];

    always @(posedge clk or posedge reset) begin    //리셋신호로 초기화 시켜줌
        if (reset) begin
            tail <= 0;
            head <=0;
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
                valid_entries1[i] <= 1'b0; 
                valid_entries2[i] <= 1'b0; 
              takens[i] <= 1'b0;
              hits[i] <= 1'b0;
              RS_ALU_on[i] <=0;
            end
        end else if (start) begin

            
   
            if (operand1 == ALU_result_dest) begin  // 명령어가 처음 들어왔을때, alu의 결과와 명령어의 operand 물리주소를 비교하여 
                                                    // 업데이트가 필요시 수행해준다.
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
                takens[tail] <= RS_alu_IF_ID_taken;
                hits[tail] <= RS_alu_IF_ID_hit;
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
                takens[tail] <= RS_alu_IF_ID_taken;
                hits[tail] <= RS_alu_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                takens[i] <= RS_alu_IF_ID_taken;
                tail <= (tail + 1) % 64;  
                 RS_ALU_on[tail] <=0; 
             end else if (operand1 == MUL_result_dest) begin  // 명령어가 처음 들어왔을때, mul의 결과와 명령어의 operand 물리주소를 비교하여 
                                                              // 업데이트가 필요시 수행해준다.
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
                takens[tail] <= RS_alu_IF_ID_taken;
                hits[tail] <= RS_alu_IF_ID_hit;
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
                takens[tail] <= RS_alu_IF_ID_taken;
                hits[tail] <= RS_alu_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
              end else if (operand1 == DIV_result_dest) begin  // 명령어가 처음 들어왔을때, div의 결과와 명령어의 operand 물리주소를 비교하여 
                                                              // 업데이트가 필요시 수행해준다.
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
                takens[tail] <= RS_alu_IF_ID_taken;
                hits[tail] <= RS_alu_IF_ID_hit;
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
                takens[tail] <= RS_alu_IF_ID_taken;
                hits[tail] <= RS_alu_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
             end else if ( operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin     
                                                                // 명령어가 처음 들어왔을때, load의 결과와 명령어의 operand 물리주소를 비교하여 
                                                              // 업데이트가 필요시 수행해준다.
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
                takens[tail] <= RS_alu_IF_ID_taken;
                hits[tail] <= RS_alu_IF_ID_hit;
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
                takens[tail] <= RS_alu_IF_ID_taken;
                hits[tail] <= RS_alu_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1 ; 
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
                takens[tail] <= RS_alu_IF_ID_taken;
                hits[tail] <= RS_alu_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= valid[1]; 
                tail <= (tail + 1) % 64;
                 RS_ALU_on[tail] <=0;
             end 
             end
            
           
            if (ALU_result_valid) begin                 //alu의 결과가 들어왔을때, 기존에 RS에 들어있던 명령어들과 물리주소를 비교하여
                                                        //필요한 값들을 업데이트 시켜준다.
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
            if (MUL_result_valid) begin                     //mul의 결과가 들어왔을때, 기존에 RS에 들어있던 명령어들과 물리주소를 비교하여
                                                        //필요한 값들을 업데이트 시켜준다.
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
            if (DIV_result_valid) begin         //div의 결과가 들어왔을때, 기존에 RS에 들어있던 명령어들과 물리주소를 비교하여
                                                        //필요한 값들을 업데이트 시켜준다.
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
           if (EX_MEM_MemRead) begin                //load의 결과가 들어왔을때, 기존에 RS에 들어있던 명령어들과 물리주소를 비교하여
                                                        //필요한 값들을 업데이트 시켜준다.
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

    


    always @(*) begin           //수시로 operand valid 값을 확인하여 나갈 준비가 되면 대기를 시켜준다. (readys -> 1이 되면 priority encoder로 해당 정보를 보내주게 되고,
                                //priority encoder은 들어온 인풋들을 바탕으로 우선순위를 정해준다.
        for (i = 0; i < 64; i = i + 1) begin
            if (valid_entries1[i] && valid_entries2[i] && !MemReads[i]) begin
                readys[i] = 1;
                RS_ALU_on[i] =1;
              result[i] = {hits[i],takens[i], inst_nums[i],1'b1, PCs[i], Rds[i], MemToRegs[i], MemReads[i], MemWrites[i], ALUOPs[i], ALUSrc1s[i], ALUSrc2s[i], Jumps[i], Branchs[i], funct3s[i],immediates[i], operand1_datas[i], operand2_datas[i]};
            end else if (valid_entries1[i] && valid_entries2[i] && MemReads[i]) begin
                readys[i] = 1;
                RS_ALU_on[i] =1;
                result[i] = {hits[i], takens[i], inst_nums[i],1'b0, PCs[i], Rds[i], MemToRegs[i], MemReads[i], MemWrites[i], ALUOPs[i], ALUSrc1s[i], ALUSrc2s[i], Jumps[i], Branchs[i], funct3s[i],immediates[i], operand1_datas[i], operand2_datas[i]};
            end
        end
    end

    priority_encoder encoder (
        .ready(readys),
        .head(head),
        .Y(Y)
    );


endmodule
