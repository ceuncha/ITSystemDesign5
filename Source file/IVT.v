module IVT(
    input rob_cause,
    output reg [15:0] handler_address,  // 예외 핸들러 주소
    output reg [1:0] e_cause
);

always @(*) begin
    if (rob_cause== 2'b00) begin
        handler_address <= 16'h02BC; // Illegal Instruction: 700번지
        e_cause <= 2'b00;
    end else if (rob_cause == 2'b01) begin
        handler_address <= 16'h030C; // DIV 0: 780번지
        e_cause <=2'b01;
    end else if (rob_cause == 2'b10) begin
        handler_address <= 16'h02E4; // LS: 740번지
        e_cause <=2'b10;
    end else if (rob_cause == 2'b11) begin
        handler_address <= 16'h0334; // Address: 820번지
        e_cause <=2'b11;
    end else begin
        handler_address <=16'h0000;
        e_cause <= 2'b00;
    end
end
