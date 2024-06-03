module Instruction_memory(pc, instOut);
    input [31:0] pc;
    output reg [31:0] instOut;

    reg [7:0] memory [0:1023]; // 1KB memory

initial begin
    
{memory[0], memory[1], memory[2], memory[3]} <= 32'b0000001_00100_01000_100_00111_0110011; // div x7, x8, x4
{memory[4], memory[5], memory[6], memory[7]} <= 32'b000000000001_00101_010_00100_0000011; // load x4, 1(x5)
{memory[8], memory[9], memory[10], memory[11]} <= 32'b0000000_00100_00001_000_00110_0110011; // add x6, x1, x4
{memory[12], memory[13], memory[14], memory[15]} <= 32'b0100000_00010_00011_000_00001_0110011; // sub x1, x3, x2
{memory[16], memory[17], memory[18], memory[19]} <= 32'b0000000_01000_00111_000_00100_0110011; // add x4, x7, x8
{memory[20], memory[21], memory[22], memory[23]} <= 32'b0000000_00010_00001_000_00100_1100011; // beq x1, x2, 4 (분기 성공)
{memory[24], memory[25], memory[26], memory[27]} <= 32'b0000000_00111_00101_000_00001_0110011; // add x1, x5, x7
{memory[28], memory[29], memory[30], memory[31]} <= 32'b0000000_01000_01000_111_01001_0110011; // and x9, x8, x8
{memory[32], memory[33], memory[34], memory[35]} <= 32'b0000000_01010_01010_110_01001_0110011; // or x9, x10, x10
{memory[36], memory[37], memory[38], memory[39]} <= 32'b0000000_00100_00011_001_00100_1100011; // bne x3, x4, 4 (분기 실패)
{memory[40], memory[41], memory[42], memory[43]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3

// 새로운 명령어 추가
{memory[44], memory[45], memory[46], memory[47]} <= 32'b000000000001_00101_000_00110_0010011; // addi x6, x5, 1
{memory[48], memory[49], memory[50], memory[51]} <= 32'b000000000010_00110_000_01000_0010011; // addi x8, x6, 2
{memory[52], memory[53], memory[54], memory[55]} <= 32'b0000000_00100_00111_000_00110_0110011; // add x6, x7, x4
{memory[56], memory[57], memory[58], memory[59]} <= 32'b0000001_00111_00101_110_01001_0110011; // rem x9, x5, x7







end

    always @ (*) begin
        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]};
    end
endmodule
