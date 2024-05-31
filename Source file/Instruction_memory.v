module Instruction_memory(pc, instOut);
    input [31:0] pc;
    output reg [31:0] instOut;

    reg [31:0] memory [0:9999];  // 10000개의 32비트 명령어를 저장할 수 있는 메모리, 약 40KB

    initial begin
        $readmemh("i.mem", memory);
    end

    always @(pc) begin
        instOut = memory[pc >> 2];
    end
/*
    reg [7:0] memory [0:1023]; // 1KB memory

    initial begin
        // R-type instructions
        // ADD x5, x6, x7: 0000000 00111 00110 000 00101 0110011
        {memory[0], memory[1], memory[2], memory[3]} <= 32'b0000000_00111_00110_000_00101_0110011;
        // SUB x8, x9, x10: 0100000 01010 01001 000 01000 0110011
        {memory[4], memory[5], memory[6], memory[7]} <= 32'b0100000_01010_01001_000_01000_0110011;
        // AND x11, x12, x13: 0000000 01101 01100 111 01011 0110011
        {memory[8], memory[9], memory[10], memory[11]} <= 32'b0000000_01101_01100_111_01011_0110011;
        // OR x14, x15, x16: 0000000 10000 01111 110 01110 0110011
        {memory[12], memory[13], memory[14], memory[15]} <= 32'b0000000_10000_01111_110_01110_0110011;
        // XOR x17, x18, x19: 0000000 10011 10010 100 10001 0110011
        {memory[16], memory[17], memory[18], memory[19]} <= 32'b0000000_10011_10010_100_10001_0110011;

        // I-type instructions
        // ADDI x20, x21, 100: 000000000100 10101 000 10100 0010011
        {memory[20], memory[21], memory[22], memory[23]} <= 32'b000000000100_10101_000_10100_0010011;
        // ANDI x22, x23, 101: 000000000101 10111 111 10110 0010011
        {memory[24], memory[25], memory[26], memory[27]} <= 32'b000000000101_10111_111_10110_0010011;
        // ORI x24, x25, 110: 000000000110 11001 110 11000 0010011
        {memory[28], memory[29], memory[30], memory[31]} <= 32'b000000000110_11001_110_11000_0010011;
        // XORI x26, x27, 111: 000000000111 11011 100 11010 0010011
        {memory[32], memory[33], memory[34], memory[35]} <= 32'b000000000111_11011_100_11010_0010011;
        // LW x28, 0(x29): 000000000000 11101 010 11100 0000011
        {memory[36], memory[37], memory[38], memory[39]} <= 32'b000000000000_11101_010_11100_0000011;
    end

    always @ (*) begin
        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]};
    end
*/
endmodule
