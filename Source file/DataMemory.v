module DataMemory(
    input wire Load_Done,
    input wire EX_MEM_MemWrite,
    input wire reset,
    input wire [2:0] EX_MEM_funct3,
    input wire [31:0] EX_MEM_ALUResult,
    input wire [31:0] EX_MEM_Rdata2,
    output reg [31:0] Load_Data
);
integer i;
reg [31:0] memory [0:1023];
always @(posedge reset) begin                       //리셋시에 각 번지수의 데이터는 번지수+3으로 한다,
   if (reset) begin
       for (i = 0; i < 1024; i = i + 1) begin
            memory[i] <= i+3;
        end
    end
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
