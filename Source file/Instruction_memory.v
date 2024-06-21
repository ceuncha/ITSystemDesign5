module Instruction_memory(pc, instOut);

    input [31:0] pc;

    output reg [31:0] instOut;


    reg [7:0] memory [0:1023]; // 1KB memory
integer i;

initial begin

        for (i = 80; i < 1024; i = i + 1) begin

            memory[i] <= 8'b0;

        end

// R-type instructions
//  addi x5, x0, 140
{memory[0], memory[1], memory[2], memory[3]} <= 32'b00001000110000000000001010010011;
//addi x8,x8,4
{memory[4], memory[5], memory[6], memory[7]} <= 32'b00000000010001000000010000010011;
//mul x13,x5,x11
{memory[8], memory[9], memory[10], memory[11]} <= 32'b00000010101100101000011010110011;
// div x1,x8,x4
{memory[12], memory[13], memory[14], memory[15]} <= 32'b0000001_00100_01000_100000010110011;
//mul x14,x5,x4
{memory[16], memory[17], memory[18], memory[19]} <= 32'b00000010010000101000011100110011;
//  xor x11,x11,x4
{memory[20], memory[21], memory[22], memory[23]} <= 32'b00000000010001011100010110110011;
// mul x12,x8,x4
{memory[24], memory[25], memory[26], memory[27]} <= 32'b00000010010001000000011000110011;
//  lw x2,1(x8)
{memory[28], memory[29], memory[30], memory[31]} <= 32'b00000000000101000010000100000011;
//  mul x3,x2,x4
{memory[32], memory[33], memory[34], memory[35]} <= 32'b00000010010000010000000110110011;
//addi x5,x5,-1
{memory[36], memory[37], memory[38], memory[39]} <= 32'b11111111111100101000001010010011;
// bne x5,x0,-40
{memory[40], memory[41], memory[42], memory[43]} <= 32'b11111100000000101001110011100011;
// add x4,x7,x10
{memory[44], memory[45], memory[46], memory[47]} <= 32'b00000000101000111000001000110011;

// addi x1, x0, 1
{memory[48], memory[49], memory[50], memory[51]} <= 32'b000000000001_00000_000_00001_0010011;
// ADDI x2, x0, 12
{memory[52], memory[53], memory[54], memory[55]} <= 32'b000000001100_00000_000_00010_0010011;
// ADDI x3, x0, 1
{memory[56], memory[57], memory[58], memory[59]} <= 32'b000000000001_00000_000_00011_0010011;
// MUL x1, x1, x2
{memory[60], memory[61], memory[62], memory[63]} <= 32'b0000001_00010_00001_000_00001_0110011;
// DIV x1, x1, x3
{memory[64], memory[65], memory[66], memory[67]} <= 32'b0000001_00011_00001_100_00001_0110011;
// ADDI x2, x2, -1
{memory[68], memory[69], memory[70], memory[71]} <= 32'b111111111111_00010_000_00010_0010011;
// ADDI x3, x3, 1
{memory[72], memory[73], memory[74], memory[75]} <= 32'b000000000001_00011_000_00011_0010011;
// BNE x3, x11, -20
{memory[76], memory[77], memory[78], memory[79]} <= 32'b1111111_01011_00011_001_01101_1100011;
    end
    always @ (*) begin

        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]};

    end

endmodule
