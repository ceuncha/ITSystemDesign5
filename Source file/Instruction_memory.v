module Instruction_memory(pc, instOut);
    input [31:0] pc;
    output reg [31:0] instOut;

    reg [7:0] memory [0:1023]; // 1KB memory

    initial begin
        // R-type instructions
       // 32'b0000001_00011_00010_000_00001_0110011; // mul x1, x2, x3
        {memory[0], memory[1], memory[2], memory[3]} <= 32'b0000001_00011_00010_000_00001_0110011;
        //32'b000000000000_00101_010_00100_0000011; //load x4,0(x5)
        {memory[4], memory[5], memory[6], memory[7]} <= 32'b000000000000_00101_010_00100_0000011;
        // 32'b0000000_00100_00001_000_00110_0110011; //add x6, x1, x4
        {memory[8], memory[9], memory[10], memory[11]} <= 32'b0000000_00100_00001_000_00110_0110011;
        //32'b0100000 00010 00011 000 00001 0110011 //sub x1, x3, x2 
        {memory[12], memory[13], memory[14], memory[15]} <= 32'b0100000 00010 00011 000 00001 0110011;
        // 32'b0000000 01000 00111 000 00100 0110011 //add x4, x7, x8 
        {memory[16], memory[17], memory[18], memory[19]} <= 32'b0000000 01000 00111 000 00100 0110011;

        // I-type instructions
        // 32'b0000000 00111 00101 000 00001 0110011 //add x1, x5, x7
        {memory[20], memory[21], memory[22], memory[23]} <= 32'b0000000 00111 00101 000 00001 0110011;
        // 32'b0000000 01000 01000 111 01001 0110011 //and x9, x8, x8   
        {memory[24], memory[25], memory[26], memory[27]} <= 32'b0000000 01000 01000 111 01001 0110011 ;
        // 32'b0000000 01010 01010 110 01001 0110011 //or x9, x10, x10  
        {memory[28], memory[29], memory[30], memory[31]} <= 32'b0000000 01010 01010 110 01001 0110011;
        // 32'b0000000 00011 01000 000 00001 0110011 //add x1, x8, x3   
        {memory[32], memory[33], memory[34], memory[35]} <= 32'b0000000 00011 01000 000 00001 0110011;
        // LW x28, 0(x29): 000000000000 11101 010 11100 0000011
        //{memory[36], memory[37], memory[38], memory[39]} <= 32'b000000000000_11101_010_11100_0000011;
    end

    always @ (*) begin
        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]};
    end
endmodule
