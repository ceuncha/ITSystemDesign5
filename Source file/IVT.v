module IVT(
    input [1:0] rob_cause,
    output reg [31:0] handler_address  // ?삁?쇅 ?빖?뱾?윭 二쇱냼
);

always @(*) begin
    if (rob_cause== 2'b00) begin
        handler_address <= 32'd1700; // Illegal Instruction: 700踰덉?
    end else if (rob_cause == 2'b01) begin
        handler_address <= 32'd1740; // DIV 0: 740踰덉?
    end else if (rob_cause == 2'b10) begin
        handler_address <= 32'd1780; // LS: 780踰덉?
    end else if (rob_cause == 2'b11) begin
        handler_address <= 32'd1820; // Address: 820踰덉?
    end
    end
endmodule
