module IVT(
    input clk,
    input illegal_instruction,
    input IF_ID_inst_num,
    input LS,
    input LS_que_inst_num,
    input Div_0,
    input Div_inst_num,
    input Address,
    input Address_inst_num,

    output IVT_inst_num,
    output reg [15:0] handler_address  // 예외 핸들러 주소
);

always @(posedge clk) begin
    if (illegal_instruction) begin
        handler_address <= 16'h02BC; // Illegal Instruction: 700번지
        IVT_inst_num <= IF_ID_inst_num;
    end else if (LS) begin
        handler_address <= 16'h02E4; // LS: 740번지
        IVT_inst_num <= LS_que_inst_num;
    end else if (Div_0) begin
        handler_address <= 16'h030C; // DIV 0: 780번지
        IVT_inst_num <= Div_inst_num;
    end else if (Address) begin
        handler_address <= 16'h0334; // Address: 820번지
        IVT_inst_num <= Address_inst_num;
    end else begin
        handler_address <= 16'h0000; // Default: 0000번지
    end
end
