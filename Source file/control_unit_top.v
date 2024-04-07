module control_rom(
    input [5:0] mapped_address,
    output RegWrite,
    output MemToReg,
    output MemRead,
    output MemWrite,
    output [3:0] ALUOp,
    output ALUSrc,
    output RWsel //
);

reg [9:0] ROM [0:63]; // ROM 

assign {RegWrite, MemToReg, MemRead, MemWrite, ALUOp, ALUSrc, RWsel} = ROM[mapped_address];

initial begin
    // All control signals are initialized to 0 at address 0
    ROM[0] = 10'b0_0_0_0_0000_0_0;

    // R-type operations, shifted by one address
    ROM[1] = 10'b1_0_0_0_0010_0_0; // ADD
    ROM[2] = 10'b1_0_0_0_0110_0_0; // SUB
    ROM[3] = 10'b1_0_0_0_0000_0_0; // AND
    ROM[4] = 10'b1_0_0_0_0001_0_0; // OR
    ROM[5] = 10'b1_0_0_0_0011_0_0; // XOR
    ROM[6] = 10'b1_0_0_0_0100_0_0; // SLL
    ROM[7] = 10'b1_0_0_0_0101_0_0; // SRL
    ROM[8] = 10'b1_0_0_0_0111_0_0; // SRA
    ROM[9] = 10'b1_0_0_0_1000_0_0; // SLT
    ROM[10] = 10'b1_0_0_0_1001_0_0; // SLTU

    // Load and Store, shifted by one address
    ROM[11] = 10'b1_1_1_0_0010_1_0; // Load instructions
    ROM[12] = 10'b0_0_0_1_0010_1_0; // Store instructions

    // I-type Immediate and ALU operations, shifted by one address
    ROM[14] = 10'b1_0_0_0_0010_1_0; // ADDI
    ROM[15] = 10'b1_0_0_0_1000_1_0; // SLTI
    ROM[16] = 10'b1_0_0_0_1001_1_0; // SLTIU
    ROM[17] = 10'b1_0_0_0_0011_1_0; // XORI
    ROM[18] = 10'b1_0_0_0_0001_1_0; // ORI
    ROM[19] = 10'b1_0_0_0_0000_1_0; // ANDI
    ROM[20] = 10'b1_0_0_0_0100_1_0; // SLLI
    ROM[21] = 10'b1_0_0_0_0101_1_0; // SRLI
    ROM[22] = 10'b1_0_0_0_0111_1_0; // SRAI

    // LUI, AUIPC, JAL, JALR, shifted by one address
    ROM[23] = 10'b1_0_0_0_0000_0_1; // LUI
    ROM[24] = 10'b1_0_0_0_0000_0_1; // AUIPC
    ROM[25] = 10'b1_0_0_0_0000_0_1; // JAL 
    ROM[26] = 10'b1_0_0_0_0010_1_1; // JALR
end

endmodule
