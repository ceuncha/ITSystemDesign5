 module RS_CSR (                                             //嶺뚮ㅏ援앲��??�젆? forwarding, 繞�???�쑏熬곣뫀彛� 嶺뚮ㅏ援앲��??�젆源곴껀??�땻? ?亦끸넁�돦??亦끸뼺�떊?�닑?裕� ?�굢??�뇡??獄�???諭� ??�빢?筌�?.
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] RS_alu_inst_num,
    input wire [7:0] Rd,
    input wire [3:0] ALUOP,

    input wire [31:0] csr_data,
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
    input wire Branch_result_valid,
    input wire [7:0] BR_Phy,
    input wire EX_MEM_MemRead,
  input wire P_Done,
  input wire [7:0] P_Phy,
  
  output reg [82:0] result_out
    
);
    
    // Internal storage for reservation station entries
   (* keep = "true" *) reg [31:0] inst_nums[0:63];

    (* keep = "true" *) reg [7:0] Rds [0:63];

   (* keep = "true" *) reg [3:0] ALUOPs [0:63];


   (* keep = "true" *) reg [31:0] csr_datas [0:63];
   (* keep = "true" *) reg [7:0] operand1s [0:63];


   (* keep = "true" *) reg [63:0] valid_entries1;  

   (* keep = "true" *) reg [6:0] current_block;
   (* keep = "true" *) reg [6:0] next_block;

   (* keep = "true" *) integer i, j, k, l, m, n;
   (* keep = "true" *) reg RS_ALU_on [0:63];

    wire operand1_ALU_conflict = (operand1 == ALU_result_dest);
    wire operand1_MUL_conflict = (operand1 == MUL_result_dest);
    wire operand1_DIV_conflict = (operand1 == DIV_result_dest);
    wire operand1_MEM_conflict = (operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead == 1);
    wire operand1_BR_conflict = (operand1 == BR_Phy);
    wire operand1_P_conflict = (operand1 == P_Phy);
    wire operand1_conflict = operand1_ALU_conflict || operand1_MUL_conflict || operand1_DIV_conflict || operand1_MEM_conflict || operand1_BR_conflict || operand1_P_conflict;


    always @(posedge clk) begin    
        if (reset) begin
            current_block <= 0;
            next_block <= 1;
            for (i = 0; i < 64; i = i + 1) begin
                inst_nums[i] <=0;

                Rds[i] <= 0;
                ALUOPs[i] <= 0;
                csr_datas[i] <=0;
                operand1s[i] <= 0;
                valid_entries1[i] <= 1'b0; 
                RS_ALU_on[i] <=0; 
            end
        end else begin
            if (start) begin
                if (operand1_conflict) begin
                                                   
                    inst_nums[current_block] <= RS_alu_inst_num;
                    Rds[current_block] <= Rd;

                    ALUOPs[current_block] <= ALUOP;

       
                    csr_datas[current_block] <= csr_data;
                    operand1s[current_block] <= operand1;
                    valid_entries1[current_block] <= 1;
                    RS_ALU_on[current_block] <= 1;

         
                end else begin
                    inst_nums[current_block] <= RS_alu_inst_num;
          
                    Rds[current_block] <= Rd;
  
                    ALUOPs[current_block] <= ALUOP;

       
                    csr_datas[current_block] <= csr_data;
                    operand1s[current_block] <= operand1;
        
                 valid_entries1[current_block] <= valid[0];
   
                    RS_ALU_on[current_block] <=0;
                end 
             
                for (i = 63; i >= 0; i = i - 1) begin
                    if(!RS_ALU_on[i] && (i != current_block)) begin
                        next_block <= i;
                    end
                end
                current_block <= next_block;
            end
        
           
                if (ALU_result_valid) begin                
                    for (i = 0; i < 64; i = i + 1) begin
                        if (!valid_entries1[i] && operand1s[i] == ALU_result_dest) begin
                            valid_entries1[i] <= 1;
                        end
    
                    end
                end
                if (MUL_result_valid) begin                     
                    for (j = 0; j < 64; j = j + 1) begin
                        if (!valid_entries1[j] && operand1s[j] == MUL_result_dest) begin
                            valid_entries1[j] <= 1;
                        end

                    end
                end
                if (DIV_result_valid) begin        
                    for (k = 0; k < 64; k = k + 1) begin
                        if (!valid_entries1[k] && operand1s[k] == DIV_result_dest) begin
                            valid_entries1[k] <= 1;
                        end

                    end
                end
                if (EX_MEM_MemRead) begin               
                    for (l = 0; l < 64; l = l + 1) begin
                        if (!valid_entries1[l] && operand1s[l] == EX_MEM_Physical_Address) begin
                            valid_entries1[l] <= 1;
                        end
    
                    end     
                end
                if (Branch_result_valid) begin               
                    for (m = 0; m < 64; m = m + 1) begin
                        if (!valid_entries1[m] && operand1s[m] == BR_Phy) begin
                            valid_entries1[m] <= 1;
                        end

                    end     
                end
            if (P_Done) begin                
                for (n = 0; n < 64; n = n + 1) begin
                    if (!valid_entries1[n] && operand1s[n] == P_Phy) begin
                        valid_entries1[n] <= 1;
                    end

                end
            end
         
         
 
            result_out <= 0;


            for (i = 63; i >= 0; i = i - 1) begin
                if (valid_entries1[i] == 1) begin
                result_out <= {1'b1, operand1s[i], inst_nums[i], 1'b1, Rds[i], ALUOPs[i], csr_datas[i]};
                operand1s[i] <= 0;
                valid_entries1[i] <= 0;
                RS_ALU_on[i] <= 0;
                end
            end

        end
    end

 endmodule
