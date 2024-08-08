module Instruction_memory(

    input wire [31:0] pc,

    input wire reset,
    output reg [31:0] instOut

);
  reg [7:0] memory [0:1023]; // 1KB memory
integer i;

always @(posedge reset) begin

        for (i = 0; i < 1024; i = i + 1) begin

            memory[i] <= 32'b0;

        end
    //case 1
//0. addi x1, x0, 10
{memory[0], memory[1], memory[2], memory[3]} <= 32'b00000000101000000000000010010011;

//1. mul x2, x1, x5 
{memory[4], memory[5], memory[6], memory[7]} <= 32'b00000010010100001000000100110011;

//2. div x3, x20, x4
{memory[8], memory[9], memory[10], memory[11]} <= 32'b00000010010010100100000110110011;

//3. SW x6, 95(x3)
{memory[12], memory[13], memory[14], memory[15]} <= 32'b00000100011000011010111110100011;

//4. addi x1,x0, 1
{memory[16], memory[17], memory[18], memory[19]} <= 32'b00000000000100000000000010010011;

//5. addi x2,x0, 4
{memory[20], memory[21], memory[22], memory[23]} <= 32'b00000000010000000000000100010011;

//6. LW x5, 100(x0)
{memory[24], memory[25], memory[26], memory[27]} <= 32'b00000110010000000010001010000011;

//7. mul x7, x1, x2
{memory[28], memory[29], memory[30], memory[31]} <= 32'b00000010001000001000001110110011;

//8. div x8, x20, x7
{memory[32], memory[33], memory[34], memory[35]} <= 32'b00000010011110100100010000110011;

//9. SW x9, 95(x8)
{memory[36], memory[37], memory[38], memory[39]} <= 32'b00000100100101000010111110100011;

//10. ADD x11, x12, x13
{memory[40], memory[41], memory[42], memory[43]} <= 32'b00000000110101100000010110110011;
    //case 2
    /*
//0. addi x1, x0, 10
{memory[0], memory[1], memory[2], memory[3]} <= 32'b00000000101000000000000010010011;

//1. mul x2, x1, x5 
{memory[4], memory[5], memory[6], memory[7]} <= 32'b00000010010100001000000100110011;

//2. addi x1,x0,1
{memory[8], memory[9], memory[10], memory[11]} <= 32'b00000000000100000000000010010011;

//3. SW x6, 95(x5)
{memory[12], memory[13], memory[14], memory[15]} <= 32'b00000100011000101010111110100011;

//4. addi x2,x0, 4
{memory[16], memory[17], memory[18], memory[19]} <= 32'b00000000010000000000000100010011;

//5. div x3, x20, x4
{memory[20], memory[21], memory[22], memory[23]} <= 32'b00000010010010100100000110110011;

//6. LW x5, 95(x3)
{memory[24], memory[25], memory[26], memory[27]} <= 32'b00000101111100011010001010000011;

//7. add x7, x1, x2
{memory[28], memory[29], memory[30], memory[31]} <= 32'b00000000001000001000001110110011;

//8. add x8, x20, x7
{memory[32], memory[33], memory[34], memory[35]} <= 32'b00000000011110100000010000110011;

//9. SW x9, 100(x0)
{memory[36], memory[37], memory[38], memory[39]} <= 32'b00000110100100000010001000100011;

//10. ADD x11, x12, x13
{memory[40], memory[41], memory[42], memory[43]} <= 32'b00000000110101100000010110110011;
    */
{memory[700], memory[701], memory[702], memory[703]} <= 32'b00000000001000000001111101110011;

{memory[704], memory[705], memory[706], memory[707]} <= 32'b00000000000100000001111011110011;

{memory[708], memory[709], memory[710], memory[711]} <= 32'b00110101110000000000111001100111;

{memory[780], memory[781], memory[782], memory[783]} <= 32'b00000000001000000001111101110011;

{memory[784], memory[785], memory[786], memory[787]} <= 32'b00000000000100000001111011110011;

{memory[788], memory[789], memory[790], memory[791]} <= 32'b00110000001000000000000001110011;


    end
    always @ (*) begin

        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]};

    end

endmodule
