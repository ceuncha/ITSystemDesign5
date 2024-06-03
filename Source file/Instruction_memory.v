module Instruction_memory(pc, instOut);
    input [31:0] pc;
    output reg [31:0] instOut;

    reg [7:0] memory [0:1023]; // 1KB memory

initial begin
    // 기존 명령어들
    {memory[0], memory[1], memory[2], memory[3]} <= 32'b0000001_00100_01000_100_00111_0110011; // div x7, x8, x4
    {memory[4], memory[5], memory[6], memory[7]} <= 32'b000000000000_00101_010_00100_0000011; // load x4, 0(x5)
    {memory[8], memory[9], memory[10], memory[11]} <= 32'b0000000_00100_00001_000_00110_0110011; // add x6, x1, x4
    {memory[12], memory[13], memory[14], memory[15]} <= 32'b0100000_00010_00011_000_00001_0110011; // sub x1, x3, x2
    {memory[16], memory[17], memory[18], memory[19]} <= 32'b0000000_01000_00111_000_00100_0110011; // add x4, x7, x8
    {memory[20], memory[21], memory[22], memory[23]} <= 32'b0000000_00111_00101_000_00001_0110011; // add x1, x5, x7
    {memory[24], memory[25], memory[26], memory[27]} <= 32'b0000000_01000_01000_111_01001_0110011; // and x9, x8, x8
    {memory[28], memory[29], memory[30], memory[31]} <= 32'b0000000_01010_01010_110_01001_0110011; // or x9, x10, x10
    {memory[32], memory[33], memory[34], memory[35]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3

    // 마지막 명령어 23번 반복 저장
    {memory[36], memory[37], memory[38], memory[39]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[40], memory[41], memory[42], memory[43]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[44], memory[45], memory[46], memory[47]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[48], memory[49], memory[50], memory[51]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[52], memory[53], memory[54], memory[55]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[56], memory[57], memory[58], memory[59]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[60], memory[61], memory[62], memory[63]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[64], memory[65], memory[66], memory[67]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[68], memory[69], memory[70], memory[71]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[72], memory[73], memory[74], memory[75]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[76], memory[77], memory[78], memory[79]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[80], memory[81], memory[82], memory[83]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[84], memory[85], memory[86], memory[87]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[88], memory[89], memory[90], memory[91]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[92], memory[93], memory[94], memory[95]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[96], memory[97], memory[98], memory[99]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[100], memory[101], memory[102], memory[103]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[104], memory[105], memory[106], memory[107]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[108], memory[109], memory[110], memory[111]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[112], memory[113], memory[114], memory[115]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[116], memory[117], memory[118], memory[119]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[120], memory[121], memory[122], memory[123]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[124], memory[125], memory[126], memory[127]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3
    {memory[128], memory[129], memory[130], memory[131]} <= 32'b0000000_00011_01000_000_00001_0110011; // add x1, x8, x3

    // 새로운 마지막 명령어
    {memory[132], memory[133], memory[134], memory[135]} <= 32'b0000000_00100_00111_000_00110_0110011; // add x6, x7, x4


end

    always @ (*) begin
        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]};
    end
endmodule
