module divider (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [6:0] Physical_address_in, 
    input wire [31:0] PC_in,
    input wire [3:0] divider_op_in,
    output reg [31:0] Result,
    output reg done,
    output reg [6:0] Physical_address_out,
    output reg [31:0] PC_out
);

    // 내부 레지스터
    reg [63:0] temp_dividend[0:31];
    reg [31:0] divisor[0:31];
    reg [6:0] Physical_address_reg[0:31];
    reg [31:0] PC_reg[0:31];
    reg [3:0] divider_op_reg[0:31];
    reg done_reg[0:31];

    // 초기화 및 시작
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            temp_dividend[0] <= 64'd0;
            divisor[0] <= 32'd0;
            Physical_address_reg[0] <= 7'd0;
            PC_reg[0] <= 32'd0;
            divider_op_reg[0] <=1'd0;
            done_reg[0] <= 1'd0;
        end else if (start) begin
            temp_dividend[0] <= {31'b0, A, 1'b0};
            divisor[0] <= B;
            Physical_address_reg[0] <= Physical_address_in;
            PC_reg[0] <= PC_in;
            divider_op_reg[0] <= divider_op_in;
            done_reg[0] <= 1'd1;
        end
    end

    // 32 스테이지 생성
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : stages
            always @(posedge clk or posedge reset) begin
                if (reset) begin
                    temp_dividend[i+1] <= 64'd0;
                    divisor[i+1] <= 32'd0;
                    Physical_address_reg[i+1] <= 7'd0;
                    PC_reg[i+1] <= 32'd0;
                    divider_op_reg [i+1] <=1'd0; 
                    done_reg[i+1] <= 1'd0;                   
                end else begin
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
                    divider_op_reg [i+1] <= divider_op_reg [i];
                    done_reg[i+1] <= done_reg[i];
                end
            end
        end
    endgenerate

    // 결과 설정
   always @(posedge clk or posedge reset) begin
        if(reset) begin
         Result <=0;
         Physical_address_out <= 0;
         PC_out <= 0;
         done <= 0;
         end else begin
                // 조건부 뺄셈
                if (temp_dividend[31][63:32] >= divisor[31]) begin
                    temp_dividend[31][63:32] = temp_dividend[31][63:32] - divisor[31];
                    temp_dividend[31][0] = 1'b1;
                end else begin
                    temp_dividend[31][0] = 1'b0;
                end
                if(divider_op_reg[31]==4'b0001) begin
                Result <= temp_dividend[31][31:0];
                Physical_address_out <= Physical_address_reg[31];
                PC_out <= PC_reg[31];
                done <= done_reg[31];
                end
                else begin
                Result <= temp_dividend[31][63:32];
                Physical_address_out <= Physical_address_reg[31];
                PC_out <= PC_reg[31];
                done <= done_reg[31];
                end
                end
                end
endmodule
