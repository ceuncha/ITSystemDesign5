module DataMemory(
    input wire MemRead,
    input wire MemWrite,
    input wire [2:0] funct3,
    input wire [31:0] ALUResult,
    input wire [31:0] WriteData,
    output reg [31:0] ReadData
);

reg [31:0] memory [0:255];

always @ (*) begin
// Default value for ReadData, ensures it is always assigned
    ReadData <= 32'd0; // if MemRead is false
    if (MemRead) begin
        case (funct3)
            3'b000: ReadData <= {{24{memory[ALUResult][31]}}, memory[ALUResult][7:0]}; // LB
            3'b001: ReadData <= {{16{memory[ALUResult][31]}}, memory[ALUResult][15:0]}; // LH
            3'b010: ReadData <= memory[ALUResult]; // LW
            3'b100: ReadData <= {{24{1'b0}}, memory[ALUResult][7:0]}; // LBU
            3'b101: ReadData <= {{16{1'b0}}, memory[ALUResult][15:0]}; // LHU
            default: ReadData <= 32'd0; // Default value assignment to handle cases when MemRead is false
        endcase
    end
end

always @ (*) begin
    if (MemWrite) begin
        case (funct3)
            3'b000: memory[ALUResult][7:0] <= WriteData[7:0]; // SB
            3'b001: memory[ALUResult][15:0] <= WriteData[15:0]; // SH
            3'b010: memory[ALUResult] <= WriteData; // SW
            default: ; // No operation (NOP) for other funct3 values, explicitly defined
        endcase
    end
    else if (!MemWrite) ; // If MemWrite is false, no changes are made to memory - it retains its previous state
end

endmodule
