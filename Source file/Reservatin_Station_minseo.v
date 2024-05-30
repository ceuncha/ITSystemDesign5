module Reservation_station (
    input clk,
    input reset,
    input [6:0] opcode,
    input [31:0] PC,
    input [6:0] Rd,
    input [6:0] operand1,
    input [6:0] operand2,
    input [31:0] operand1_data,
    input [31:0] operand2_data,
    input [1:0] valid,
    input [31:0] ALU_result,
    input [6:0] ALU_result_dest,
    input ALU_result_valid,
    output reg [123:0] result,
    output reg ready
);
    
    // Internal storage for reservation station entries
    reg [6:0] opcodes [15:0];
    reg [31:0] PCs [15:0];
    reg [6:0] Rds [15:0];
    reg [6:0] operand1s [15:0];
    reg [6:0] operand2s [15:0];
    reg [31:0] operand1_datas [15:0];  //operand1 data
    reg [31:0] operand2_datas [15:0]; //operand2 data
    reg [15:0] valid_entries1;  // operand1이 valid한지
    reg [15:0] valid_entries2; // operand2가 valid한지
    
    reg [3:0] tail;
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
           tail <=0;
           
        end else if ( valid == 00) begin  //operand1,operand2 둘 다 사용가능하지 않을때
          
                    opcodes[tail] <= opcode;
                    PCs[tail] <= PC;
                    Rds[tail] <= Rd;
                    operand1s[tail] <= operand1;
                    operand2s[tail] <= operand2;
                    operand1_datas[tail] <= 0;
                    operand2_datas[tail] <= 0;
                    valid_entries1[tail] <= 0;
                    valid_entries2[tail] <= 0;
                    tail <= (tail + 1) % 16;
 
          end else if ( valid == 01) begin  //operand1 만 사용 가능할때
          
                    opcodes[tail] <= opcode;
                    PCs[tail] <= PC;
                    Rds[tail] <= Rd;
                    operand1s[tail] <= operand1;
                    operand2s[tail] <= operand2;
                    operand1_datas[tail] <= operand1_data;
                    operand2_datas[tail] <= 0;
                    valid_entries1[tail] <= 1;
                    valid_entries2[tail] <= 0; 
                    tail <= (tail + 1) % 16;
           
        end else if ( valid == 10) begin  //operand2 만 사용 가능할때
          
                    opcodes[tail] <= opcode;
                    PCs[tail] <= PC;
                    Rds[tail] <= Rd;
                    operand1s[tail] <= operand1;
                    operand2s[tail] <= operand2;
                    operand1_datas[tail] <= 0;
                    operand2_datas[tail] <= operand2_data;
                    valid_entries1[tail] <= 0;
                    valid_entries2[tail] <= 1; 
                    tail <= (tail + 1) % 16;
       
        end else if ( valid == 11) begin  //operand1,operand2 둘 다 사용 가능할때
          
                    opcodes[tail] <= opcode;
                    PCs[tail] <= PC;
                    Rds[tail] <= Rd;
                    operand1s[tail] <= operand1;
                    operand2s[tail] <= operand2;
                    operand1_datas[tail] <= operand1_data;
                    operand2_datas[tail] <= operand2_data;
                    valid_entries1[tail] <= 1;
                    valid_entries2[tail] <= 1; 
                    tail <= (tail + 1) % 16;
        end 
         if (ALU_result_valid) begin
            for (i = 0; i < 16; i = i + 1) begin
                if (Rds[i] == ALU_result_dest) begin
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
        end
        end
    // Logic to check dependencies and issue instructions
    always @(*) begin
       
        for (i = 0; i < 16; i = i + 1) begin
            if (valid_entries1[i]&&valid_entries2[i]) begin
                ready = 1;
                result = {opcodes[i],PCs[i], Rds[i], operand1s[i], operand2s[i],operand1_datas[i],operand2_datas[i]};
                valid_entries1[i] = 0;
                valid_entries2[i] = 0;
                break;
            end
        end
    end
    
endmodule
