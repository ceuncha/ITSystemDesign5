

module BUFF(     input clk,
input rst,                                          
    input PC_taken,
    output reg real_taken // 64鍮꾪듃 Y 異쒕젰
    );
 always @(posedge clk) begin
        if (rst) begin
        
            real_taken <= 1'b0;
        end else begin
         real_taken <= PC_taken;
        end
    end
endmodule
