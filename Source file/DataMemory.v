module DataMemory(
    input wire Load_Done,
    input wire EX_MEM_MemWrite,
    input wire clk,
    input wire reset,
    input wire [2:0] EX_MEM_funct3,
    input wire [31:0] EX_MEM_ALUResult,
    input wire [31:0] EX_MEM_Rdata2,
    output reg [31:0] Load_Data
);
   (* keep = "true" *) integer i;
   (* keep = "true" *) reg [31:0] memory [0:2047];

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 2047; i = i + 1) begin
            memory[i] <= i + 3;
        end
    end else begin
        if (EX_MEM_MemWrite) begin
            if (EX_MEM_funct3 == 3'b000) begin
                memory[EX_MEM_ALUResult][7:0] <= EX_MEM_Rdata2[7:0]; // SB
            end else if (EX_MEM_funct3 == 3'b001) begin
                memory[EX_MEM_ALUResult][15:0] <= EX_MEM_Rdata2[15:0]; // SH
            end else if (EX_MEM_funct3 == 3'b010) begin
                memory[EX_MEM_ALUResult] <= EX_MEM_Rdata2; // SW
            end
        end
    end
end

always @ (*) begin
    // Default value for Load_Data, ensures it is always assigned
    Load_Data = 32'd0; // if Load_Done is false

   
        if (EX_MEM_funct3 == 3'b000) begin
            Load_Data = {{24{memory[EX_MEM_ALUResult][31]}}, memory[EX_MEM_ALUResult][7:0]}; // LB
        end else if (EX_MEM_funct3 == 3'b001) begin
            Load_Data = {{16{memory[EX_MEM_ALUResult][31]}}, memory[EX_MEM_ALUResult][15:0]}; // LH
        end else if (EX_MEM_funct3 == 3'b010) begin
            Load_Data = memory[EX_MEM_ALUResult]; // LW
        end else if (EX_MEM_funct3 == 3'b100) begin
            Load_Data = {{24{1'b0}}, memory[EX_MEM_ALUResult][7:0]}; // LBU
        end else if (EX_MEM_funct3 == 3'b101) begin
            Load_Data = {{16{1'b0}}, memory[EX_MEM_ALUResult][15:0]}; // LHU
        end else begin
            Load_Data = 32'd0; // Default value assignment to handle cases when Load_Done is false or EX_MEM_funct3 is not matched
        end
    end


endmodule
