module DataMemory(
    input wire clk,
    input wire reset,
    input wire exception_sig,
    input wire [31:0] Store_Addr,
    input reg [31:0] Store_Data,

);
   (* keep = "true" *) integer i;
   (* keep = "true" *) reg [31:0] memory [0:2047];

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 2047; i = i + 1) begin
            memory[i] <= i + 3;
        end
      
    end else begin
        memory[Store_Addr][31:0] <= Store_Data;
    end
       
end


endmodule
