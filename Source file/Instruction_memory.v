module Instruction_memory(

    input wire [31:0] pc,

    input wire reset,
    output reg [31:0] instOut

);
  reg [7:0] memory [0:1023]; // 1KB memory
integer i;

always @(posedge reset) begin

    for (i = 48; i < 1024; i = i + 1) begin

            memory[i] <= 8'b0;

        end

// ADDI x1, x0, 5
{memory[0], memory[1], memory[2], memory[3]} <= 32'b00000000010100000000000010010011;
// ADDI x3, x0, 0
{memory[4], memory[5], memory[6], memory[7]} <= 32'b00000000000000000000000110010011;
// ADDI x4, x0, 0
{memory[8], memory[9], memory[10], memory[11]} <= 32'b00000000000000000000001000010011;
// ADDI x2, x0, 3
    {memory[12], memory[13], memory[14], memory[15]} <= 32'b00000000001100000000000100010011;

    
    // ADDI x3, x3, 1
    {memory[16], memory[17], memory[18], memory[19]} <= 32'b00000000000100011000000110010011;
        // ADDI x2, x2, -1
    {memory[20], memory[21], memory[22], memory[23]} <= 32'b11111111111100010000000100010011;
        // BNE x2, x0, -12
    {memory[24], memory[25], memory[26], memory[27]} <= 32'b11111110000000010001101011100011;
        // addi x1, x1, -1
        {memory[28], memory[29], memory[30], memory[31]} <= 32'b11111111111100001000000010010011;
        
    
    // ADDI x4, x4, 1
        {memory[32], memory[33], memory[34], memory[35]} <= 32'b00000000000100100000001000010011;
        // bne x0, x1, -28
        {memory[36], memory[37], memory[38], memory[39]} <= 32'b11111110000100000001001011100011;
        // sw x3, 4(x0
        {memory[40], memory[41], memory[42], memory[43]} <= 32'b00000000001100000010001000100011;
        // sw x4, 8(x0)
    {memory[44], memory[45], memory[46], memory[47]} <= 32'b00000000010000000010010000100011;
    end

    always @ (*) begin

        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]};

    end

endmodule
