module DIMux (
    input [31:0] PData2,
    input [31:0] imm32,
    input ALUSrc2,
    output reg [31:0] mux_out2
);

    always @(*) begin
        if (ALUSrc2)
            mux_out2 = imm32;
        else
            mux_out2 = PData2;
    end

endmodule
