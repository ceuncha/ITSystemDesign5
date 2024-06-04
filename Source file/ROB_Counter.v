module ROB_Counter(
    input clk,
    input rst,
    output reg inst_num
);

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            inst_num <= 32'b0;
        end else begin
            inst_num <= inst_num + 32'b1;
        end
    end

endmodule
