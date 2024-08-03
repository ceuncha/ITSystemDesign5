module IVT(
    input rob_cause,
    output reg [15:0] handler_address  // 예외 핸들러 주소
);

always @(*) begin
    if (rob_cause== 2'b00) begin
        handler_address <= 32'h02BC; // Illegal Instruction: 700번지
    end else if (rob_cause == 2'b01) begin
        handler_address <= 32'h030C; // DIV 0: 780번지
    end else if (rob_cause == 2'b10) begin
        handler_address <= 32'h02E4; // LS: 740번지
    end else if (rob_cause == 2'b11) begin
        handler_address <= 32'h0334; // Address: 820번지
    end else begin
        handler_address <=32'h0000;
    end
    end
endmodule
