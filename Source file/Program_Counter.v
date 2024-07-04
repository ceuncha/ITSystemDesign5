module Program_Counter(
    input wire clk,
    input wire reset, // 동기식 리셋 신호 추가
    input wire [31:0] PC_final_next,
    output reg [31:0] PC
);

initial begin
    PC = 32'd0; // PC 초기값 설정
end

always @(posedge clk) begin
    if (reset) begin
        // reset 신호가 활성화된 경우 PC 초기화
        PC <= 32'd0;
    end else begin
        // PC를 PC_final_next 값으로 업데이트
        PC <= PC_final_next;
    end
end

endmodule
