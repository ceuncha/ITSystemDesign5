module divider (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [7:0] Physical_address_in, 
    input wire [31:0] PC_in,
    input wire [3:0] divider_op_in,
    output reg [31:0] Result,
    output reg done,
    output reg [7:0] Physical_address_out,
    output reg [31:0] PC_out
);

    // 내부 레지스터
    reg [63:0] temp_dividend[0:31];
    reg [31:0] divisor[0:31];
    reg [7:0] Physical_address_reg[0:31];
    reg [31:0] PC_reg[0:31];
    reg [3:0] divider_op_reg[0:31];
    reg done_reg[0:31];
    integer i;

    // 초기화 및 시작


    // 32 스테이지 생성
    always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 32; i = i + 1) begin
            temp_dividend[i] <= 64'd0;
            divisor[i] <= 32'd0;
            Physical_address_reg[i] <= 8'd0;
            PC_reg[i] <= 32'd0;
            divider_op_reg[i] <= 1'd0;
            done_reg[i] <= 1'd0;
        end
        end
       else begin
       if (start) begin
            temp_dividend[0] <= {31'b0, A, 1'b0};
            divisor[0] <= B;
            Physical_address_reg[0] <= Physical_address_in;
            PC_reg[0] <= PC_in;
            divider_op_reg[0] <= divider_op_in;
            done_reg[0] <= 1'd1;
        end
        for (i = 0; i < 31; i = i + 1) begin
            if (temp_dividend[i][63:32] >= divisor[i]) begin
                temp_dividend[i][63:32] = temp_dividend[i][63:32] - divisor[i];
                temp_dividend[i][0] = 1'b1;
            end else begin
                temp_dividend[i][0] = 1'b0;
            end
            temp_dividend[i+1] <= {temp_dividend[i][62:0], 1'b0};
            divisor[i+1] <= divisor[i];
            Physical_address_reg[i+1] <= Physical_address_reg[i];
            PC_reg[i+1] <= PC_reg[i];
            divider_op_reg[i+1] <= divider_op_reg[i];
            done_reg[i+1] <= done_reg[i];
        end
        end
        end

    // 결과 설정
   always @(posedge clk) begin
        if(reset) begin
         Result <=0;
         Physical_address_out <= 0;
         PC_out <= 0;
         done <= 0;
         end else begin
                // 조건부 뺄셈
                
                if(divider_op_reg[31]==4'b0001) begin
                if (temp_dividend[31][63:32] >= divisor[31]) begin
                Result = {temp_dividend[31][31:1],1'b1};
                Physical_address_out = Physical_address_reg[31];
                PC_out = PC_reg[31];
                done = done_reg[31];
                end else begin 
                Result = temp_dividend[31][31:0];
                Physical_address_out = Physical_address_reg[31];
                PC_out = PC_reg[31];
                done = done_reg[31];
                end
                end
                else begin
                if (temp_dividend[31][63:32] >= divisor[31]) begin
                    Result = temp_dividend[31][63:32] - divisor[31];
                     Physical_address_out = Physical_address_reg[31];
                     PC_out = PC_reg[31];
                     done = done_reg[31];
                end else begin
                Result = temp_dividend[31][63:32];
                Physical_address_out = Physical_address_reg[31];
                PC_out = PC_reg[31];
                done = done_reg[31];
                end
                end
                end
                end
endmodule
