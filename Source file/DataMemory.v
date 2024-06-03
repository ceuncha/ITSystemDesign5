module DataMemory(
    input wire Load_Done,
    input wire EX_MEM_MemWrite,
    input wire [2:0] EX_MEM_funct3,
    input wire [31:0] EX_MEM_ALUResult,
    input wire [31:0] EX_MEM_Rdata2,
    output reg [31:0] Load_Data
);

reg [31:0] memory [0:255];
initial begin
memory[0] = 3;
    memory[1] = 4;
    memory[2] = 5;
    memory[3] = 6;
    memory[4] = 7;
    memory[5] = 8;
    memory[6] = 9;
    memory[7] = 10;
    memory[8] = 11;
    memory[9] = 12;
    memory[10] = 13;
    memory[11] = 14;
    memory[12] = 15;
    memory[13] = 16;
    memory[14] = 17;
    memory[15] = 18;
    memory[16] = 19;
    memory[17] = 20;
    memory[18] = 21;
    memory[19] = 22;
    memory[20] = 23;
    memory[21] = 24;
    memory[22] = 25;
    memory[23] = 26;
    memory[24] = 27;
    memory[25] = 28;
    memory[26] = 29;
    memory[27] = 30;
    memory[28] = 31;
    memory[29] = 32;
    memory[30] = 33;
    memory[31] = 34;
end

always @ (*) begin
// Default value for RData, ensures it is always assigned
    Load_Data <= 32'd0; // if MemRead is false
    if (Load_Done) begin
        case (EX_MEM_funct3)
            3'b000: Load_Data <= {{24{memory[EX_MEM_ALUResult][31]}}, memory[EX_MEM_ALUResult][7:0]}; // LB
            3'b001: Load_Data <= {{16{memory[EX_MEM_ALUResult][31]}}, memory[EX_MEM_ALUResult][15:0]}; // LH
            3'b010: Load_Data <= memory[EX_MEM_ALUResult]; // LW
            3'b100: Load_Data <= {{24{1'b0}}, memory[EX_MEM_ALUResult][7:0]}; // LBU
            3'b101: Load_Data <= {{16{1'b0}}, memory[EX_MEM_ALUResult][15:0]}; // LHU
            default: Load_Data <= 32'd0; // Default value assignment to handle cases when MemRead is false
        endcase
    end
end

always @ (*) begin
    if (EX_MEM_MemWrite) begin
        case (EX_MEM_funct3)
            3'b000: memory[EX_MEM_ALUResult][7:0] <= EX_MEM_Rdata2[7:0]; // SB
            3'b001: memory[EX_MEM_ALUResult][15:0] <= EX_MEM_Rdata2[15:0]; // SH
            3'b010: memory[EX_MEM_ALUResult] <= EX_MEM_Rdata2; // SW
            default: ; // No operation (NOP) for other funct3 values, explicitly defined
        endcase
    end
    else if (!EX_MEM_MemWrite) ; // If EX_MEM_MemWrite is false, no changes are made to memory - it retains its previous state
end

endmodule
