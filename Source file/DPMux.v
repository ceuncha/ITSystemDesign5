module DPMux (
    input [31:0] IF_ID_PC,
    input [31:0] PData1,
    input ALUSrc1,
    output reg [31:0] mux_out
);

    always @(*) begin
        if (ALUSrc1)
            mux_out = IF_ID_PC;
        else
            mux_out = PData1;
    end

endmodule
