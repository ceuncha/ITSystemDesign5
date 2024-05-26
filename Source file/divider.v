module divider (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] A,
    input wire [31:0] B,
    output reg [31:0] quotient,
    output reg [31:0] remainder,
    output reg done
);

    // 내부 레지스터
    reg [63:0] dividend;
    reg [31:0] divisor;
    reg [63:0] temp_dividend;
    reg [5:0] count;
    reg running;

    // 초기화 및 시작
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dividend <= 64'd0;
            divisor <= 32'd0;
            count <= 6'd0;
            done <= 1'b0;
            running <= 1'b0;
            quotient <= 32'd0;
            remainder <= 32'd0;
        end else if (start && !running) begin
            dividend <= {32'd0, A};
            divisor <= B;
            count <= 6'd32;
            done <= 1'b0;
            running <= 1'b1;
        end
    end

    // 비복원 나눗셈 알고리즘
    always @(posedge clk) begin
        if (running) begin
            if (count > 0) begin
                // 임시 변수 사용
               
                
                // 왼쪽 시프트
                temp_dividend = {dividend[62:0], 1'b0};

                // 조건부 뺄셈
                if (temp_dividend[63:32] >= divisor) begin
                    temp_dividend[63:32] = temp_dividend[63:32] - divisor;
                    temp_dividend[0] = 1'b1;
                end else begin
                    temp_dividend[0] = 1'b0;
                end
                
                // 업데이트
                dividend <= temp_dividend;
                count <= count - 1;
            end else begin
                quotient <= dividend[31:0];
                remainder <= dividend[63:32];
                done <= 1'b1;
                running <= 1'b0;
            end
        end
    end

endmodule
