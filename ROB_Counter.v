module ROB_Counter(
    input clk,
    input rst,
    output reg [31:0] inst_num
);

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            inst_num <= 32'b0;
        end else begin
            inst_num <= inst_num + 32'b1;
        end
    end

endmodule
