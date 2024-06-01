module Program_Counter(
    input clk,
    input rst,
    input [31:0] PC_Branch,
    input PCSrc,
    output reg [31:0] PC
);

    reg [31:0] PC_Plus4;

    always @ (*) begin
        PC_Plus4 <= PC + 32'd4;
    end

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 32'd0;
            PC_Plus4 <= 32'd0;
        end else if (PC_Stall) begin
            PC <= PC;
        end else if (PCSrc) begin
            PC <= PC_Branch;
        end else begin
            PC <= PC_Plus4;
        end
    end

endmodule
