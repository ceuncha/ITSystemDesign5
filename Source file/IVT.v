module IVT(
    input illegal_instruction,
    input LS,
    input Div_0,
    input Address,
    output reg [15:0] handler_address  // 예외 핸들러 주소
);

always @(*) begin
    if (illegal_instruction) begin
        handler_address = 16'h02BC; // Illegal Instruction: 700번지
    end else if (LS) begin
        handler_address = 16'h02E4; // LS: 740번지
    end else if (Div_0) begin
        handler_address = 16'h030C; // DIV 0: 780번지
    end else if (Address) begin
        handler_address = 16'h0334; // Address: 820번지
    end else begin
        handler_address = 16'h0000; // Default: 0000번지
    end
end
