module RS_Branch (                                             //嶺뚮ㅏ援앲�곤옙?�젆占� forwarding, 繞볩옙?占쎈쑏熬곣뫀彛� 嶺뚮ㅏ援앲�곤옙?�젆源곴껀??�땻占� ?亦끸넁�돦占쏙옙亦끸뼺�떊占쎈닑占쎈츎 ?�굢占�?�뇡占�?獄�占�?占쎈굵 ?占쎈빢?筌묕옙.
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
    input wire RS_BR_IF_ID_taken,
    input wire RS_BR_IF_ID_hit,
    input wire Predict_Result,
    
    input wire [7:0] BR_Phy,
    input wire BR_Done,

    input wire [7:0] P_Phy,
    input wire P_Done,
    
    input wire [7:0] CSR_Phy,
    input wire CSR_Done,
    
    input wire exception_sig,
    input wire mret_sig,
    
    output reg RS_BR_Branch,
    output reg RS_BR_Jump,
    output reg RS_BR_Hit,
    output reg RS_BR_taken,
    output reg [7:0] RS_BR_Phy,
    output reg [31:0] RS_BR_inst_num_output,
    output reg [2:0] RS_BR_funct3,
    output reg [31:0] immediate_BR,
    output reg [31:0] PC_BR,
    output reg [7:0] Operand1_BR_phy,
    output reg [7:0] Operand2_BR_phy
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
    reg [63:0] valid_entries1;  // operand1??�억옙 valid?占쎈눀占쎈꺋壤쏉옙?
    reg [63:0] valid_entries2; // operand2占쎈쨬?? valid?占쎈눀占쎈꺋壤쏉옙?
    reg [63:0] takens;
    reg [63:0] hits;
    reg [6:0] tail;
    reg [6:0] head;
       integer i;
    integer j;
    integer k;
    integer l;
    integer m;
    integer n;
    integer o;

   (* keep = "true" *)wire operand1_ALU_conflict = ((operand1 == ALU_result_dest)&&ALU_result_valid);
  (* keep = "true" *)wire operand1_MUL_conflict = ((operand1 == MUL_result_dest)&&MUL_result_valid);
  (* keep = "true" *)wire operand1_DIV_conflict = ((operand1 == DIV_result_dest)&&DIV_result_valid);
  (* keep = "true" *)wire operand1_MEM_conflict = ((operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead == 1));
  (* keep = "true" *)wire operand1_BR_conflict = ((operand1 == BR_Phy)&&BR_Done);
  (* keep = "true" *)wire operand1_P_conflict = ((operand1 == P_Phy)&&P_Done);
  (* keep = "true" *)wire operand1_CSR_conflict = ((operand1 == CSR_Phy)&&CSR_Done);
  (* keep = "true" *)wire operand1_conflict = operand1_ALU_conflict || operand1_MUL_conflict || operand1_DIV_conflict || operand1_MEM_conflict || operand1_BR_conflict || operand1_P_conflict || operand1_CSR_conflict;

   (* keep = "true" *)wire operand2_ALU_conflict = ((operand2 == ALU_result_dest)&&ALU_result_valid);
  (* keep = "true" *)wire operand2_MUL_conflict = ((operand2 == MUL_result_dest)&&MUL_result_valid);
  (* keep = "true" *)wire operand2_DIV_conflict = ((operand2 == DIV_result_dest)&&DIV_result_valid);
  (* keep = "true" *)wire operand2_MEM_conflict = (operand2 == EX_MEM_Physical_Address && EX_MEM_MemRead == 1);
   (* keep = "true" *)wire operand2_BR_conflict = ((operand2 == BR_Phy)&&BR_Done);
   (* keep = "true" *)wire operand2_P_conflict = ((operand2 == P_Phy)&&P_Done);
  (* keep = "true" *)wire operand2_CSR_conflict = ((operand2 == CSR_Phy)&&CSR_Done);
  (* keep = "true" *)wire operand2_conflict = operand2_ALU_conflict || operand2_MUL_conflict || operand2_DIV_conflict || operand2_MEM_conflict || operand2_BR_conflict || operand2_P_conflict || operand2_CSR_conflict;


    always @(posedge clk) begin    //占쎈뎨占쎈봾占쏙옙?占쎈뼁?占쎄퉰�슖占�? 占쎈／占쎈쐝�뵳占�?占쎈꼨 ?占쎈뻣占쎈끃裕뉐ㅇ占�
        if (reset|exception_sig|mret_sig) begin
            tail <= 0;
            head <=0;
            for (i = 0; i < 64; i = i + 1) begin
                inst_nums[i] <=0;
                PCs[i] <= 0;
                Rds[i] <= 0;
                Jumps[i] <= 0;
                Branchs[i] <= 0;
                funct3s[i] <= 0;
                immediates[i] <=0;
                operand1s[i] <= 0;
                operand2s[i] <= 0;
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
            PC_BR <= 0;
            Operand1_BR_phy<=0;
            Operand2_BR_phy<=0;
            end
            end else if (Predict_Result) begin
            tail <= 0;
            head <=0;
            for (i = 0; i < 64; i = i + 1) begin
                inst_nums[i] <=0;
                PCs[i] <= 0;
                Rds[i] <= 0;
                Jumps[i] <= 0;
                Branchs[i] <= 0;
                funct3s[i] <= 0;
                immediates[i] <=0;
                operand1s[i] <= 0;
                operand2s[i] <= 0;
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
            PC_BR <= 0;
            Operand1_BR_phy<=0;
            Operand2_BR_phy<=0;
            end
        end else begin
        if(start) begin
            if ((operand1_conflict == 1'b1) && (operand2_conflict == 1'b0)) begin  // 嶺뚮ㅏ援앲�곤옙?�젆湲룹쾸? 嶺뚳퐣瑗뤄옙踰� ?獄�占�?�젆占�?占쎈꼨?占쎈굵?�뇡占�, alu?占쎈꺄 �뇦猿됲�쀯옙沅�?? 嶺뚮ㅏ援앲�곤옙?�젆占�?占쎈꺄 operand 占쎈닱占쎈닑占쎈뉴�썒�슣�닔占쎄틬占쎈ご? 占쎈쑏熬곥룊爰�?�뇡占�?�굢占� 
                                                    // ?驪볩옙?占쎌몥?占쎈턄?占쎈콦�뤆占�? ?�뇡占�?占쎈뭵?占쎈뻣 ?占쎈빢?筌묕옙?�뜮癒㏓뭄??占쎈펲.
                inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                takens[tail] <= RS_BR_IF_ID_taken;
                hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= valid[1];
                tail <= (tail + 1) % 64;
            end else if ((operand1_conflict == 1'b0) && (operand2_conflict == 1'b1)) begin 
                inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                takens[tail] <= RS_BR_IF_ID_taken;
                hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= 1; 
                takens[i] <= RS_BR_IF_ID_taken;
                tail <= (tail + 1) % 64;  
            end else if ((operand1_conflict == 1'b1) && (operand2_conflict == 1'b1)) begin 
                inst_nums[tail] <= RS_BR_inst_num;
                PCs[tail] <= PC;
                Rds[tail] <= Rd;
                Jumps[tail] <= Jump;
                Branchs[tail] <= Branch;
                funct3s[tail] <= funct3;
                immediates[tail] <= immediate;
                operand1s[tail] <= operand1;
                operand2s[tail] <= operand2;
                takens[tail] <= RS_BR_IF_ID_taken;
                hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= 1; 
                takens[i] <= RS_BR_IF_ID_taken;
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
                takens[tail] <= RS_BR_IF_ID_taken;
                hits[tail] <= RS_BR_IF_ID_hit;
                valid_entries1[tail] <= valid[0];
                valid_entries2[tail] <= valid[1]; 
                tail <= (tail + 1) % 64;
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
            PC_BR <= PCs[head];
            Operand1_BR_phy <= operand1s[head];
            Operand2_BR_phy <= operand2s[head];
            valid_entries1[head] <= 0;            // Clear the ready flag after consuming the entry
            valid_entries2[head] <= 0;
            operand1s[head] <= 0;
            operand2s[head] <= 0;
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
            PC_BR <= 0;
            Operand1_BR_phy <= 0;
            Operand2_BR_phy <= 0;
         end
            end
           
            if (ALU_result_valid) begin                 //alu?占쎈꺄 �뇦猿됲�쀯옙沅€뤆占�? ?獄�占�?�젆占�?占쎈꼨?占쎈굵?�뇡占�, �뼨轅명�ｏ옙占�?�굢占� RS?�굢占� ?獄�占�?�젆占�?占쎈엿?占쎌맪 嶺뚮ㅏ援앲�곤옙?�젆占�?獄��뼅占쏙옙? 占쎈닱占쎈닑占쎈뉴�썒�슣�닔占쎄틬占쎈ご? 占쎈쑏熬곥룊爰�?�뇡占�?�굢占�
                                                        //?�뇡占�?占쎈뭵?�뇡占� �뤆�룆占썩뫖援�?占쎈굵 ?驪볩옙?占쎌몥?占쎈턄?占쎈콦 ?占쎈뻣占쎈끃裕�??占쎈펲.
                for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == ALU_result_dest) begin
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == ALU_result_dest) begin
                        valid_entries2[i] <= 1;
                    end
                end
            end
            if (MUL_result_valid) begin                     //mul?占쎈꺄 �뇦猿됲�쀯옙沅€뤆占�? ?獄�占�?�젆占�?占쎈꼨?占쎈굵?�뇡占�, �뼨轅명�ｏ옙占�?�굢占� RS?�굢占� ?獄�占�?�젆占�?占쎈엿?占쎌맪 嶺뚮ㅏ援앲�곤옙?�젆占�?獄��뼅占쏙옙? 占쎈닱占쎈닑占쎈뉴�썒�슣�닔占쎄틬占쎈ご? 占쎈쑏熬곥룊爰�?�뇡占�?�굢占�
                                                        //?�뇡占�?占쎈뭵?�뇡占� �뤆�룆占썩뫖援�?占쎈굵 ?驪볩옙?占쎌몥?占쎈턄?占쎈콦 ?占쎈뻣占쎈끃裕�??占쎈펲.
                for (j = 0; j < 64; j = j + 1) begin
                    if (!valid_entries1[j] && operand1s[j] == MUL_result_dest) begin
                        valid_entries1[j] <= 1;
                    end
                    if (!valid_entries2[j] && operand2s[j] == MUL_result_dest) begin
                        valid_entries2[j] <= 1;
                    end
                end
            end
            if (DIV_result_valid) begin         //div?占쎈꺄 �뇦猿됲�쀯옙沅€뤆占�? ?獄�占�?�젆占�?占쎈꼨?占쎈굵?�뇡占�, �뼨轅명�ｏ옙占�?�굢占� RS?�굢占� ?獄�占�?�젆占�?占쎈엿?占쎌맪 嶺뚮ㅏ援앲�곤옙?�젆占�?獄��뼅占쏙옙? 占쎈닱占쎈닑占쎈뉴�썒�슣�닔占쎄틬占쎈ご? 占쎈쑏熬곥룊爰�?�뇡占�?�굢占�
                                                        //?�뇡占�?占쎈뭵?�뇡占� �뤆�룆占썩뫖援�?占쎈굵 ?驪볩옙?占쎌몥?占쎈턄?占쎈콦 ?占쎈뻣占쎈끃裕�??占쎈펲.
                for (k = 0; k < 64; k = k + 1) begin
                    if (!valid_entries1[k] && operand1s[k] == DIV_result_dest) begin
                        valid_entries1[k] <= 1;
                    end
                    if (!valid_entries2[k] && operand2s[k] == DIV_result_dest) begin
                        valid_entries2[k] <= 1;
                    end
                end
            end
           if (EX_MEM_MemRead) begin                //load?占쎈꺄 �뇦猿됲�쀯옙沅€뤆占�? ?獄�占�?�젆占�?占쎈꼨?占쎈굵?�뇡占�, �뼨轅명�ｏ옙占�?�굢占� RS?�굢占� ?獄�占�?�젆占�?占쎈엿?占쎌맪 嶺뚮ㅏ援앲�곤옙?�젆占�?獄��뼅占쏙옙? 占쎈닱占쎈닑占쎈뉴�썒�슣�닔占쎄틬占쎈ご? 占쎈쑏熬곥룊爰�?�뇡占�?�굢占�
                                                        //?�뇡占�?占쎈뭵?�뇡占� �뤆�룆占썩뫖援�?占쎈굵 ?驪볩옙?占쎌몥?占쎈턄?占쎈콦 ?占쎈뻣占쎈끃裕�??占쎈펲.
           for (l = 0; l < 64; l = l + 1) begin
                    if (!valid_entries1[l] && operand1s[l] == EX_MEM_Physical_Address) begin
                        valid_entries1[l] <= 1;
                    end
                    if (!valid_entries2[l] && operand2s[l] == EX_MEM_Physical_Address) begin
                        valid_entries2[l] <= 1;
                    end
                end     
            end
           if (BR_Done) begin                //load?占쎈꺄 �뇦猿됲�쀯옙沅€뤆占�? ?獄�占�?�젆占�?占쎈꼨?占쎈굵?�뇡占�, �뼨轅명�ｏ옙占�?�굢占� RS?�굢占� ?獄�占�?�젆占�?占쎈엿?占쎌맪 嶺뚮ㅏ援앲�곤옙?�젆占�?獄��뼅占쏙옙? 占쎈닱占쎈닑占쎈뉴�썒�슣�닔占쎄틬占쎈ご? 占쎈쑏熬곥룊爰�?�뇡占�?�굢占�
                                                        //?�뇡占�?占쎈뭵?�뇡占� �뤆�룆占썩뫖援�?占쎈굵 ?驪볩옙?占쎌몥?占쎈턄?占쎈콦 ?占쎈뻣占쎈끃裕�??占쎈펲.
           for (m = 0; m < 64; m = m + 1) begin
                    if (!valid_entries1[m] && operand1s[m] == BR_Phy) begin
                        valid_entries1[m] <= 1;
                    end
                    if (!valid_entries2[m] && operand2s[m] ==  BR_Phy) begin
                        valid_entries2[m] <= 1;
                    end
                end     
            end

            if (P_Done) begin                 //alu?占쎈꺄 �뇦猿됲�쀯옙沅€뤆占�? ?獄�占�?�젆占�?占쎈꼨?占쎈굵?�뇡占�, �뼨轅명�ｏ옙占�?�굢占� RS?�굢占� ?獄�占�?�젆占�?占쎈엿?占쎌맪 嶺뚮ㅏ援앲�곤옙?�젆占�?獄��뼅占쏙옙? 占쎈닱占쎈닑占쎈뉴�썒�슣�닔占쎄틬占쎈ご? 占쎈쑏熬곥룊爰�?�뇡占�?�굢占�
                                                        //?�뇡占�?占쎈뭵?�뇡占� �뤆�룆占썩뫖援�?占쎈굵 ?驪볩옙?占쎌몥?占쎈턄?占쎈콦 ?占쎈뻣占쎈끃裕�??占쎈펲.
                for (n = 0; n < 64; n = n + 1) begin
                    if (!valid_entries1[n] && operand1s[n] == P_Phy) begin
                        valid_entries1[n] <= 1;
                    end
                    if (!valid_entries2[n] && operand2s[n] == P_Phy) begin
                        valid_entries2[n] <= 1;
                    end
                end
            end
        
            if (CSR_Done) begin                 //alu?占쎈꺄 �뇦猿됲�쀯옙沅€뤆占�? ?獄�占�?�젆占�?占쎈꼨?占쎈굵?�뇡占�, �뼨轅명�ｏ옙占�?�굢占� RS?�굢占� ?獄�占�?�젆占�?占쎈엿?占쎌맪 嶺뚮ㅏ援앲�곤옙?�젆占�?獄��뼅占쏙옙? 占쎈닱占쎈닑占쎈뉴�썒�슣�닔占쎄틬占쎈ご? 占쎈쑏熬곥룊爰�?�뇡占�?�굢占�
                                                        //?�뇡占�?占쎈뭵?�뇡占� �뤆�룆占썩뫖援�?占쎈굵 ?驪볩옙?占쎌몥?占쎈턄?占쎈콦 ?占쎈뻣占쎈끃裕�??占쎈펲.
                for (o = 0; o < 64; o = o + 1) begin
                    if (!valid_entries1[o] && operand1s[o] == CSR_Phy) begin
                        valid_entries1[o] <= 1;
                    end
                    if (!valid_entries2[o] && operand2s[o] == CSR_Phy) begin
                        valid_entries2[o] <= 1;
                    end
                end
            end
        

end
    



endmodule
