module Program_Counter(clk, PC_Stall, PC_Next, pc);
    input clk;
    input PC_Stall
    input [31:0] PC_Next;
    output reg [31:0] PC;
   
always @ (posedge clk) begin
    if (PC_Stall) begin
        // stall signal = 1 이면 , keep PC unchanged
        PC <= PC;
    end else begin
        PC <= PC_Next;
    end
end
endmodule
