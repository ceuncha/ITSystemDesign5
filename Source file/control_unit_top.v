module control_unit_top(
    input rst
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output RegWrite,
    output MemToReg,
    output MemRead,
    output MemWrite,
    output [3:0] ALUOp,
    output [1:0]ALUSrc,
    output RWsel,
    output Branch,
    output Jump
);

wire [5:0] mapped_address;

// address_mapper ?��?��?��?��
address_mapper addr_mapper (
    .reset(rst),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .mapped_address(mapped_address)
);

// control_rom ?��?��?��?��
control_rom ctrl_rom (
    .reset(rst),
    .mapped_address(mapped_address),
    .RegWrite(RegWrite),
    .MemToReg(MemToReg),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .RWsel(RWsel),
    .Branch(Branch),
    .Jump(Jump)
);

endmodule
