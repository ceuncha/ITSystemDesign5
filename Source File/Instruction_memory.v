module Instruction_memory(pc, instOut);
    input [31:0] pc;
    output reg [31:0] instOut;

    reg [31:0] memory [0:63];
    initial begin
        memory[25] <= 32'b10001100001000100000000000000000; //LW
        memory[26] <= 32'b10001100001000110000000000000100; //LW
        memory[27] <= 32'b10001100001001000000000000001000; //LW
        memory[28] <= 32'b10001100001001010000000000001100; //LW
        memory[29] <= 32'b00000000010010100011000000100000; //ADD 
    end
    always @ (*) begin
        instOut <= memory[pc[7:2]];
    end
