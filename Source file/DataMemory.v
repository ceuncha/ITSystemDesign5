module DataMemory(
    input wire clk,
    input wire reset,
    input wire LS_MemRead,
    input wire LS_MemWrite,
    input wire [31:0] LS_inst_num,
    input wire [2:0] funct3_LS,
    input wire [31:0] LS_Result,
    input wire [31:0] Operand2_LS,
    output reg [31:0] Load_Data,
    output reg [31:0] Load_inst_num,
    output reg Load_Done
);
   (* keep = "true" *) integer i;
   (* keep = "true" *) reg [31:0] memory [0:2047];

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 2047; i = i + 1) begin
            memory[i] <= i + 3;
        end
    end else begin
        if (LS_MemWrite) begin
            if (funct3_LS == 3'b000) begin
                memory[LS_Result][7:0] <= Operand2_LS[7:0]; // SB
            end else if (funct3_LS == 3'b001) begin
                memory[LS_Result][15:0] <= Operand2_LS[15:0]; // SH
            end else if (funct3_LS == 3'b010) begin
                memory[LS_Result] <= Operand2_LS; // SW
            end
        end
    end
end

    always @ (clk) begin
    // Default value for Load_Data, ensures it is always assigned
    if (reset) begin
            Load_Data <= 32'd0; // Default value assignment to handle cases when Load_Done is false or EX_MEM_funct3 is not matched
            Load_inst_num <=  32'd0;
            Load_Done <= 0;
    end else begin

    if (funct3_LS == 3'b000) begin
        Load_Data <= {{24{memory[LS_Result][31]}}, memory[LS_Result][7:0]}; // LB
        Load_inst_num <= LS_inst_num;
        Load_Done <= LS_MemRead;
        end else if (funct3_LS == 3'b001) begin
            Load_Data <= {{16{memory[LS_Result][31]}}, memory[LS_Result][15:0]}; // LH
            Load_inst_num <= LS_inst_num;
            Load_Done <= LS_MemRead;
        end else if (funct3_LS == 3'b010) begin
            Load_Data <= memory[LS_Result]; // LW
            Load_inst_num <= LS_inst_num;
            Load_Done <= LS_MemRead;

        end else if (funct3_LS == 3'b100) begin
            Load_Data <= {{24{1'b0}}, memory[LS_Result][7:0]}; // LBU
            Load_inst_num <= LS_inst_num;
            Load_Done <= LS_MemRead;

        end else if (funct3_LS == 3'b101) begin
            Load_Data <= {{16{1'b0}}, memory[LS_Result][15:0]}; // LHU
            Load_inst_num <= LS_inst_num;
            Load_Done <= LS_MemRead;

        end else begin
            Load_Data <= 32'd0; // Default value assignment to handle cases when Load_Done is false or EX_MEM_funct3 is not matched
            Load_inst_num <=  32'd0;
            Load_Done <= 0;

        end
    end
    end

endmodule
