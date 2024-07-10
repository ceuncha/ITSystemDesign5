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

//div x1, x2, x3

{memory[0], memory[1], memory[2], memory[3]} <= 32'b00000010001100010100000010110011;

//add x2, x1, x4

{memory[4], memory[5], memory[6], memory[7]} <= 32'b00000000010000001000000100110011;

//addi x3, x1, 10

{memory[8], memory[9], memory[10], memory[11]} <= 32'b00000000101000001000000110010011;

//addi x15,x3,x0

{memory[12], memory[13], memory[14], memory[15]} <= 32'b00000000000000011000011110010011;

//sub x8, x7, 10
{memory[16], memory[17], memory[18], memory[19]} <= 32'b01000000010000111000010000110011;

//add x7 x8, x6

{memory[20], memory[21], memory[22], memory[23]} <= 32'b00000000011001000000001110110011;


{memory[24], memory[25], memory[26], memory[27]} <= 32'b00000010010000001000010010110011; //mul x9, x1, x4


{memory[28], memory[29], memory[30], memory[31]} <= 32'b00000000100100001111010100110011; //and x10, x1, x9

{memory[32], memory[33], memory[34], memory[35]} <= 32'b01000000100101100000010100110011; //sub x10, x12, x9

{memory[36], memory[37], memory[38], memory[39]} <= 32'b00000000000000110010001010000011; //lw x5, 0(x6)

{memory[40], memory[41], memory[42], memory[43]} <= 32'b00000000010100100000000100110011; //add x2, x4, x5

{memory[44], memory[45], memory[46], memory[47]} <= 32'b00000000001000110000001000110011; //add x4, x6, x2

{memory[48], memory[49], memory[50], memory[51]} <= 32'b00000000110100111000001000110011; //add x4, x7, x13
    end
    always @ (*) begin

        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]};

    end

endmodule
