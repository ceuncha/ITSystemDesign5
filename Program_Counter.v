module Program_Counter(
    input wire clk,
    input wire reset, // ?룞湲곗떇 由ъ뀑 ?떊?샇 異붽?
    input wire [31:0] PC_final_next,
    input wire taken,
    output reg PC_taken,
    output reg [31:0] PC
);

initial begin
    PC = 32'd0; // PC 珥덇린媛? ?꽕?젙
    PC_taken = 0;
end

always @(posedge clk) begin
    if (reset) begin
        // reset ?떊?샇媛? ?솢?꽦?솕?맂 寃쎌슦 PC 珥덇린?솕
        PC <= 32'd0;
    end else begin
        // PC瑜? PC_final_next 媛믪쑝濡? ?뾽?뜲?씠?듃
        PC <= PC_final_next;
        PC_taken <= taken;
    end
end

endmodule
