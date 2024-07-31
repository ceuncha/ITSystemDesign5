module IVT(
    input illegal_instruction,
    input LS,
  input Div_0,
  input Address,
  // 예외 원인
    output reg [15:0] handler_address  // 예외 핸들러 주소
);
reg [3:0] exception_cause
    // 예외 원인에 따른 예외 핸들러 주소
    always @(*) begin
        exception_cause = {Adress, Div_0, LS, illegal_instruction};
        case (exception_cause)
            4'b0001: handler_address = 16'h02BC; // Illegal Instruction: 700번지
            4'b0010: handler_address = 16'h02E4; // LS: 740번지
            4'b0100: handler_address = 16'h030C; // DIV 0: 780번지
            4'b1000: handler_address = 16'h0334; // Address: 820번지
            default: handler_address = 16'h0000; // Default: 0000번지
        endcase
    end
endmodule
