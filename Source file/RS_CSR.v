 module RS_CSR (                                            
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
    input wire [31:0] immediate,
    input wire [11:0] CSR_addr,
    input wire ALUSrc2,

    input wire [7:0] CSR_phy,
    input wire [7:0] CSR_done,

  output reg [129:0] result_out
    
);

   parameter SIZE = 16;
  
    // Internal storage for reservation station entries
  (* keep = "true" *) reg [31:0] inst_nums[0:SIZE-1];

  (* keep = "true" *) reg [7:0] Rds [0:SIZE-1];

  (* keep = "true" *) reg [3:0] ALUOPs [0:SIZE-1];


  (* keep = "true" *) reg [31:0] csr_datas [0:SIZE-1];
(* keep = "true" *) reg [31:0] immediates [0:SIZE-1];
  (* keep = "true" *) reg [11:0] csr_addrs [0:SIZE-1];
  (* keep = "true" *) reg [7:0] operand1s [0:SIZE-1];


  (* keep = "true" *) reg valid_entries1 [0:SIZE-1];  
  (* keep = "true" *) reg ALUSrc2s [0:SIZE-1]; 

  (* keep = "true" *) reg [3:0] current_block;
  (* keep = "true" *) reg [3:0] next_block;

   (* keep = "true" *) integer i, j, k, l, m, n;
  (* keep = "true" *) reg RS_ALU_on [0:SIZE-1];


    wire operand1_ALU_conflict = (operand1 == ALU_result_dest);
    wire operand1_MUL_conflict = (operand1 == MUL_result_dest);
    wire operand1_DIV_conflict = (operand1 == DIV_result_dest);
    wire operand1_MEM_conflict = (operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead == 1);
    wire operand1_BR_conflict = (operand1 == BR_Phy);
    wire operand1_P_conflict = (operand1 == P_Phy);
    wire operand1_CSR_conflict = (operand1 == CSR_phy);
    
    wire operand1_conflict = operand1_ALU_conflict || operand1_MUL_conflict || operand1_DIV_conflict || operand1_MEM_conflict || operand1_BR_conflict || operand1_P_conflict || operand1_CSR_conflict;


    always @(posedge clk) begin    
        if (reset) begin
            current_block <= 0;
            next_block <= 1;
         for (i = 0; i < SIZE; i = i + 1) begin
                inst_nums[i] <=0;

                Rds[i] <= 0;
                ALUOPs[i] <= 0;
                csr_datas[i] <=0;
                operand1s[i] <= 0;
                valid_entries1[i] <= 1'b0; 
                RS_ALU_on[i] <=0;
                immediates[i] <= 0;
                csr_addrs[i] <= 0;
                ALUSrc2s[i] <= 0; 
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
                    immediates[i] <= immediate;
                    csr_addrs[i] <= CSR_addr;
                    ALUSrc2s[i] <= ALUSrc2; 

         
                end else begin
                    inst_nums[current_block] <= RS_alu_inst_num;
          
                    Rds[current_block] <= Rd;
  
                    ALUOPs[current_block] <= ALUOP;

       
                    csr_datas[current_block] <= csr_data;
                    operand1s[current_block] <= operand1;
        
                 valid_entries1[current_block] <= valid[0];
   
                    RS_ALU_on[current_block] <=0;
                end 
             
             for (i = SIZE-1; i >= 0; i = i - 1) begin
                    if(!RS_ALU_on[i] && (i != current_block)) begin
                        next_block <= i;
                    end
                end
                current_block <= next_block;
            end
        
           
                if (ALU_result_valid) begin                
                 for (i = 0; i < SIZE; i = i + 1) begin
                        if (!valid_entries1[i] && operand1s[i] == ALU_result_dest) begin
                            valid_entries1[i] <= 1;
                        end
    
                    end
                end
                if (MUL_result_valid) begin                     
                 for (j = 0; j < SIZE; j = j + 1) begin
                        if (!valid_entries1[j] && operand1s[j] == MUL_result_dest) begin
                            valid_entries1[j] <= 1;
                        end

                    end
                end
                if (DIV_result_valid) begin        
                 for (k = 0; k < SIZE; k = k + 1) begin
                        if (!valid_entries1[k] && operand1s[k] == DIV_result_dest) begin
                            valid_entries1[k] <= 1;
                        end

                    end
                end
                if (EX_MEM_MemRead) begin               
                 for (l = 0; l < SIZE; l = l + 1) begin
                        if (!valid_entries1[l] && operand1s[l] == EX_MEM_Physical_Address) begin
                            valid_entries1[l] <= 1;
                        end
    
                    end     
                end
                if (Branch_result_valid) begin               
                 for (m = 0; m < SIZE; m = m + 1) begin
                        if (!valid_entries1[m] && operand1s[m] == BR_Phy) begin
                            valid_entries1[m] <= 1;
                        end

                    end     
                end
            if (P_Done) begin                
             for (n = 0; n < SIZE; n = n + 1) begin
                    if (!valid_entries1[n] && operand1s[n] == P_Phy) begin
                        valid_entries1[n] <= 1;
                    end

                end
            end
            if(CSR_done) begin
                for (n = 0; n < SIZE; n = n + 1) begin
                    if (!valid_entries1[n] && operand1s[n] == CSR_phy) begin
                        valid_entries1[n] <= 1;
                    end

                end
            end
         
         
 
            result_out <= 0;


         for (i = SIZE-1; i >= 0; i = i - 1) begin
                if (valid_entries1[i] == 1) begin
                result_out <= {1'b1, operand1s[i], inst_nums[i], Rds[i], ALUOPs[i], ALUSrc2s[i], csr_datas[i], csr_addrs[i], immediates[i]};

                operand1s[i] <= 0;
                valid_entries1[i] <= 0;
                RS_ALU_on[i] <= 0;
                end
            end

        end
    end

 endmodule
