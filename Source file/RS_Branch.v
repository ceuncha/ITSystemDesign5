module RS_Branch (                                             //榮먮굝議??堉? forwarding, 餓???뜮袁⑤쭆 榮먮굝議??堉깁겫??苑? ?沅↑퉪??沅▽틠?눖?뮉 ?肉??釉??諭???뱽 ??땾?六?.
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] RS_BR_inst_num,
    input wire [31:0] PC,
    input wire [7:0] Rd,
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
    input wire [31:0] PC_Return,
    input wire RS_BR_IF_ID_taken,
    input wire RS_BR_IF_ID_hit,
    input wire Predict_Result,
    
    input wire [7:0] BR_Phy,
    input wire BR_Done,
 
    output reg RS_BR_Branch,
    output reg RS_BR_Jump,
    output reg RS_BR_Hit,
    output reg RS_BR_taken,
    output reg [7:0] RS_BR_Phy,
    output reg [31:0] RS_BR_inst_num_output,
    output reg [2:0] RS_BR_funct3,
    output reg [31:0] immediate_BR,
    output reg [31:0] Operand1_BR,
    output reg [31:0] Operand2_BR,
    output reg [31:0] PC_BR
);
    
    // Internal storage for reservation station entries
    reg [31:0] inst_nums[0:63];
    reg [31:0] PCs [0:63];
    reg [7:0] Rds [0:63];
    reg [63:0] Jumps;
    reg [63:0] Branchs;
    reg [2:0] funct3s [0:63];
    reg [31:0] immediates [0:63];
    reg [7:0] operand1s [0:63];
    reg [7:0] operand2s [0:63];
    reg [31:0] operand1_datas [0:63];  // operand1 data
    reg [31:0] operand2_datas [0:63]; // operand2 data
    reg [63:0] valid_entries1;  // operand1??逾? valid??뇡?냲彛??
    reg [63:0] valid_entries2; // operand2?뤆?? valid??뇡?냲彛??
    reg [63:0] takens;
    reg [63:0] hits;
    reg [6:0] tail;
    reg [6:0] head;
    reg [63:0] readys;
    integer i;

    always @(posedge clk) begin    //?뵳?딅????뻿??깈嚥?? ?룯?뜃由???넅 ??뻻?녹뮇夷?
        if (reset) begin
            tail <= 0;
            head <=0;
            for (i = 0; i < 64; i = i + 1) begin
                inst_nums[i] <=0;
                PCs[i] <= 0;
                Rds[i] <= 0;
                readys[i] <= 0;
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
                RS_BR_Branch <= 0;
            RS_BR_Jump <= 0;
            RS_BR_Hit <= 0;
            RS_BR_taken <= 0;
            RS_BR_Phy <= 0;
            RS_BR_inst_num_output <=0;
            RS_BR_funct3 <= 0;
            immediate_BR <= 0;
            Operand1_BR <= 0;
            Operand2_BR <= 0;
            PC_BR <= 0;
            end
            end else if (Predict_Result) begin
            tail <= 0;
            head <=0;
            for (i = 0; i < 64; i = i + 1) begin
                inst_nums[i] <=0;
                PCs[i] <= 0;
                Rds[i] <= 0;
                readys[i] <= 0;
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
                RS_BR_Branch <= 0;
            RS_BR_Jump <= 0;
            RS_BR_Hit <= 0;
            RS_BR_taken <= 0;
            RS_BR_Phy <= 0;
            RS_BR_inst_num_output <=0;
            RS_BR_funct3 <= 0;
            immediate_BR <= 0;
            Operand1_BR <= 0;
            Operand2_BR <= 0;
            PC_BR <= 0;
            end
        end else if (start) begin
            if (operand1 == ALU_result_dest) begin  // 榮먮굝議??堉긷첎? 力μ꼷?벉 ?諭??堉???넅??뱽?釉?, alu??벥 野껉퀗?궢?? 榮먮굝議??堉???벥 operand ?눧?눖?봺雅뚯눘?꺖?몴? ?뜮袁㏉꺍?釉??肉? 
                                                    // ?毓???쑓??뵠??뱜揶?? ?釉???뒄??뻻 ??땾?六??鍮먧빳???뼄.
                inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= ALU_result;
                operand2_datas[tail] <= operand2_data;
                takens[tail] <= RS_BR_IF_ID_taken;
                hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1];
                tail <= (tail + 1) % 64;
            end else if (operand2 == ALU_result_dest) begin 
                inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= ALU_result;
                takens[tail] <= RS_BR_IF_ID_taken;
                hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                takens[i] <= RS_BR_IF_ID_taken;
                tail <= (tail + 1) % 64;  
             end else if (operand1 == MUL_result_dest) begin  // 榮먮굝議??堉긷첎? 力μ꼷?벉 ?諭??堉???넅??뱽?釉?, mul??벥 野껉퀗?궢?? 榮먮굝議??堉???벥 operand ?눧?눖?봺雅뚯눘?꺖?몴? ?뜮袁㏉꺍?釉??肉? 
                                                              // ?毓???쑓??뵠??뱜揶?? ?釉???뒄??뻻 ??땾?六??鍮먧빳???뼄.
                inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= MUL_result;
                operand2_datas[tail] <= operand2_data;
                 takens[tail] <= RS_BR_IF_ID_taken;
                 hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1];
                tail <= (tail + 1) % 64;
             end else if (operand2 == MUL_result_dest) begin  
                 inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= MUL_result;
                 takens[tail] <= RS_BR_IF_ID_taken;
                 hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;
              end else if (operand1 == DIV_result_dest) begin  // 榮먮굝議??堉긷첎? 力μ꼷?벉 ?諭??堉???넅??뱽?釉?, div??벥 野껉퀗?궢?? 榮먮굝議??堉???벥 operand ?눧?눖?봺雅뚯눘?꺖?몴? ?뜮袁㏉꺍?釉??肉? 
                                                              // ?毓???쑓??뵠??뱜揶?? ?釉???뒄??뻻 ??땾?六??鍮먧빳???뼄.
                  inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= DIV_result;
                operand2_datas[tail] <= operand2_data;
                  takens[tail] <= RS_BR_IF_ID_taken;
                  hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1];
                tail <= (tail + 1) % 64;
              end else if (operand2 == DIV_result_dest) begin  
                  inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= DIV_result; 
                  takens[tail] <= RS_BR_IF_ID_taken;
                  hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;
             end else if ( operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin     
                                                                // 榮먮굝議??堉긷첎? 力μ꼷?벉 ?諭??堉???넅??뱽?釉?, load??벥 野껉퀗?궢?? 榮먮굝議??堉???벥 operand ?눧?눖?봺雅뚯눘?꺖?몴? ?뜮袁㏉꺍?釉??肉? 
                                                              // ?毓???쑓??뵠??뱜揶?? ?釉???뒄??뻻 ??땾?六??鍮먧빳???뼄.
                 inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= RData;
                operand2_datas[tail] <= operand2_data; 
                 takens[tail] <= RS_BR_IF_ID_taken;
                 hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1] ; 
                tail <= (tail + 1) % 64;
              end else if ( operand2 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin
                  inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= RData;
                  takens[tail] <= RS_BR_IF_ID_taken;
                  hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1 ; 
                tail <= (tail + 1) % 64;
                end else if ( operand1 == BR_Phy) begin     
                                                                // 榮먮굝議??堉긷첎? 力μ꼷?벉 ?諭??堉???넅??뱽?釉?, load??벥 野껉퀗?궢?? 榮먮굝議??堉???벥 operand ?눧?눖?봺雅뚯눘?꺖?몴? ?뜮袁㏉꺍?釉??肉? 
                                                              // ?毓???쑓??뵠??뱜揶?? ?釉???뒄??뻻 ??땾?六??鍮먧빳???뼄.
                 inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= PC_Return;
                operand2_datas[tail] <= operand2_data; 
                 takens[tail] <= RS_BR_IF_ID_taken;
                 hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1] ; 
                tail <= (tail + 1) % 64;
              end else if ( operand2 == BR_Phy) begin
                  inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= PC_Return;
                  takens[tail] <= RS_BR_IF_ID_taken;
                  hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1 ; 
                tail <= (tail + 1) % 64;
            end else begin
                inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                operand1_datas[tail] <= operand1_data;
                operand2_datas[tail] <= operand2_data;
                takens[tail] <= RS_BR_IF_ID_taken;
                hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= valid[1]; 
                tail <= (tail + 1) % 64;
             end 
             end
            
           
            if (ALU_result_valid) begin                 //alu??벥 野껉퀗?궢揶?? ?諭??堉???넅??뱽?釉?, 疫꿸퀣???肉? RS?肉? ?諭??堉???뿳??쐲 榮먮굝議??堉??諭얏??? ?눧?눖?봺雅뚯눘?꺖?몴? ?뜮袁㏉꺍?釉??肉?
                                                        //?釉???뒄?釉? 揶쏅?⑸굶??뱽 ?毓???쑓??뵠??뱜 ??뻻?녹뮇???뼄.
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
            if (MUL_result_valid) begin                     //mul??벥 野껉퀗?궢揶?? ?諭??堉???넅??뱽?釉?, 疫꿸퀣???肉? RS?肉? ?諭??堉???뿳??쐲 榮먮굝議??堉??諭얏??? ?눧?눖?봺雅뚯눘?꺖?몴? ?뜮袁㏉꺍?釉??肉?
                                                        //?釉???뒄?釉? 揶쏅?⑸굶??뱽 ?毓???쑓??뵠??뱜 ??뻻?녹뮇???뼄.
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
            if (DIV_result_valid) begin         //div??벥 野껉퀗?궢揶?? ?諭??堉???넅??뱽?釉?, 疫꿸퀣???肉? RS?肉? ?諭??堉???뿳??쐲 榮먮굝議??堉??諭얏??? ?눧?눖?봺雅뚯눘?꺖?몴? ?뜮袁㏉꺍?釉??肉?
                                                        //?釉???뒄?釉? 揶쏅?⑸굶??뱽 ?毓???쑓??뵠??뱜 ??뻻?녹뮇???뼄.
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
           if (EX_MEM_MemRead) begin                //load??벥 野껉퀗?궢揶?? ?諭??堉???넅??뱽?釉?, 疫꿸퀣???肉? RS?肉? ?諭??堉???뿳??쐲 榮먮굝議??堉??諭얏??? ?눧?눖?봺雅뚯눘?꺖?몴? ?뜮袁㏉꺍?釉??肉?
                                                        //?釉???뒄?釉? 揶쏅?⑸굶??뱽 ?毓???쑓??뵠??뱜 ??뻻?녹뮇???뼄.
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
           if (BR_Done) begin                //load??벥 野껉퀗?궢揶?? ?諭??堉???넅??뱽?釉?, 疫꿸퀣???肉? RS?肉? ?諭??堉???뿳??쐲 榮먮굝議??堉??諭얏??? ?눧?눖?봺雅뚯눘?꺖?몴? ?뜮袁㏉꺍?釉??肉?
                                                        //?釉???뒄?釉? 揶쏅?⑸굶??뱽 ?毓???쑓??뵠??뱜 ??뻻?녹뮇???뼄.
           for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == BR_Phy) begin
                        operand1_datas[i] <= PC_Return;
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] ==  BR_Phy) begin
                        operand2_datas[i] <= PC_Return;
                        valid_entries2[i] <= 1;
                    end
                end     
            end
        if (valid_entries1[head] && valid_entries2[head]) begin       // Check if the entry is ready
            RS_BR_Branch <= Branchs [head];
            RS_BR_Jump <= Jumps[head];
            RS_BR_Hit <= hits[head];
            RS_BR_taken <= takens[head];
            RS_BR_Phy <= Rds[head];
            RS_BR_inst_num_output <= inst_nums[head];
            RS_BR_funct3 <= funct3s[head];
            immediate_BR <= immediates[head];
            Operand1_BR <= operand1_datas[head];
            Operand2_BR <= operand2_datas[head];
            PC_BR <= PCs[head];
            valid_entries1[head] <= 0;            // Clear the ready flag after consuming the entry
            valid_entries2[head] <= 0;
            operand1s[head] <= 0;
            operand2s[head] <= 0;
            operand1_datas[head] <= 0;
            operand2_datas[head] <= 0;
            head <= (head + 1) % 64;                 // Circular buffer handling
        end else  begin
        RS_BR_Branch <= 0;
            RS_BR_Jump <= 0;
            RS_BR_Hit <= 0;
            RS_BR_taken <= 0;
            RS_BR_Phy <= 0;
            RS_BR_inst_num_output <=0;
            RS_BR_funct3 <= 0;
            immediate_BR <= 0;
            Operand1_BR <= 0;
            Operand2_BR <= 0;
            PC_BR <= 0;
         end
end
    
endmodule
