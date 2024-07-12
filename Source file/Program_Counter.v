module Program_Counter(
    input wire clk,
    input wire reset, // ?猷욄묾怨쀫뻼 �뵳�딅�� ?�뻿?�깈 �빊遺�?
    input wire [31:0] PC_final_next,
    input wire taken,
    output reg PC_taken,
    output reg [31:0] PC
);

initial begin
    PC = 32'd0; // PC �룯�뜃由겼첎? ?苑�?�젟
    PC_taken = 0;
end

always @(posedge clk) begin
    if (reset) begin
        // reset ?�뻿?�깈揶�? ?�넞?苑�?�넅?留� 野껋럩�뒭 PC �룯�뜃由�?�넅
        PC <= 32'd0;
    end else begin
        // PC�몴? PC_final_next 揶쏅�れ몵嚥�? ?毓�?�쑓?�뵠?�뱜
        PC <= PC_final_next;
        PC_taken <= taken;
    end
end

endmodule
