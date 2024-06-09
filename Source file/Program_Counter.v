module Program_Counter(
    input clk,
    input reset,  // Active-low reset
    input [31:0] PC_Branch,
    input PC_Stall,
    input PCSrc,
    output reg [31:0] PC
);
   
    reg [31:0] PC_Plus4;
   
    initial begin
        PC = 32'd0;
        PC_Plus4 = 32'd0;
    end
   
    always @ (*) begin
        PC_Plus4 = PC + 32'd4;  // �񵿱� �Ҵ����� ����
    end

    always @ (posedge clk) begin
        if (!reset) begin
            PC <= 32'd0;  // ����� ���� ó��, active-low
        end else if (PC_Stall) begin
            // stall signal = 1 , keep PC unchanged
            PC <= PC;
        end else begin
            if (PCSrc == 1) begin
                PC <= PC_Branch;
            end else if (PCSrc == 0) begin
                PC <= PC_Plus4;
            end
        end
    end
endmodule
