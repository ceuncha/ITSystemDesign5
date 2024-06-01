module Program_Counter(
    input clk,
    input rst,
    input [31:0] PC_Branch,
    input PCSrc,
    output reg [31:0] PC
);

    reg [31:0] PC_Plus4;
    reg [31:0] PC_next
    
    always @ (*) begin
        PC_Plus4 <= PC + 32'd4;
        if (PCSrc) begin
            PC_next <= PC_Branch;
        end else begin
            PC_next <= PC_Plus4;
    end

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 32'd0;
            PC_Plus4 <= 32'd0;
        end else begin
            PC <= PC_next;
        end
    end

endmodule
