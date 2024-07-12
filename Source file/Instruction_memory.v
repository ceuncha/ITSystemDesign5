module Instruction_memory(

    input wire [31:0] pc,

    input wire reset,
    output reg [31:0] instOut

);
  reg [7:0] memory [0:1023]; // 1KB memory
integer i;

always @(posedge reset) begin

        for (i = 52; i < 1024; i = i + 1) begin

            memory[i] <= 8'b0;

        end

//  addi x5, x0, 500
{memory[0], memory[1], memory[2], memory[3]} <= 32'b00011111010000000000001010010011;
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
    end
    always @ (*) begin

        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]};

    end

endmodule
