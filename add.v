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

// ADDI x2, x0, 12
{memory[0], memory[1], memory[2], memory[3]} <= 32'b000000001100_00000_000_00010_0010011;
// ADDI x3, x0, 1
{memory[4], memory[5], memory[6], memory[7]} <= 32'b000000000001_00000_000_00011_0010011;
// MUL x1, x1, x2
{memory[8], memory[9], memory[10], memory[11]} <= 32'b0000001_00010_00001_000_00001_0110011;
// DIV x1, x1, x3
{memory[12], memory[13], memory[14], memory[15]} <= 32'b00000010000000001100000010110011;
// ADDI x2, x2, -1
{memory[16], memory[17], memory[18], memory[19]} <= 32'b111111111111_00010_000_00010_0010011;
// ADDI x3, x3, 1
{memory[20], memory[21], memory[22], memory[23]} <= 32'b000000000001_00011_000_00011_0010011;
//addi x10,x7,2000
{memory[24], memory[25], memory[26], memory[27]} <= 32'b01111101000000111000010100010011;
// lw x5, 2000(x10)
{memory[28], memory[29], memory[30], memory[31]} <= 32'b01111101000001010010001010000011;

{memory[700], memory[701], memory[702], memory[703]} <= 32'b00000000001000000001111101110011;

{memory[704], memory[705], memory[706], memory[707]} <= 32'b00000000000100000001111011110011;

{memory[708], memory[709], memory[710], memory[711]} <= 32'b00110101110000000000111001100111;

{memory[740], memory[741], memory[742], memory[743]} <= 32'b00000000001000000001111101110011;

{memory[744], memory[745], memory[746], memory[747]} <= 32'b00000000000100000001111011110011;

{memory[748], memory[749], memory[750], memory[751]} <= 32'b00110101110000000000111001100111;

{memory[780], memory[781], memory[782], memory[783]} <= 32'b00000000001000000001111101110011;

{memory[784], memory[785], memory[786], memory[787]} <= 32'b00000000000100000001111011110011;

{memory[788], memory[789], memory[790], memory[791]} <= 32'b00110000001000000000000001110011;

{memory[820], memory[821], memory[822], memory[823]} <= 32'b00000000001000000001111101110011;

{memory[824], memory[825], memory[826], memory[827]} <= 32'b00000000000100000001111011110011;

{memory[828], memory[829], memory[830], memory[831]} <= 32'b00110101110000000000111001100111;


    end
    always @ (*) begin

        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]};

    end

endmodule
