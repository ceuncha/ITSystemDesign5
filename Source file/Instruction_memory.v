module Instruction_memory(pc, instOut); 

  

    input [31:0] pc; 

  

    output reg [31:0] instOut; 

  

  

    reg [7:0] memory [0:1023]; // 1KB memory 

integer i; 

  

initial begin

        for (i = 20; i < 1024; i = i + 1) begin

            memory[i] <= 8'b0;

        end

//addi x2, x0, 8
{memory[0], memory[1], memory[2], memory[3]} <= 32'b00000000100000000000000100010011;
//addi x3, x0, 1
{memory[4], memory[5], memory[6], memory[7]} <= 32'b00000000000100000000000110010011;
//mul x3, x3, x2
{memory[8], memory[9], memory[10], memory[11]} <= 32'b00000010001000011000000110110011;
//sub x2, x2, x1
{memory[12], memory[13], memory[14], memory[15]} <= 32'b01000000000100010000000100110011;
//bne x2, x0, -12
{memory[16], memory[17], memory[18], memory[19]} <= 32'b11111110000000010001101011100011;
  

    end 

  

    always @ (*) begin 

  

        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]}; 

  

    end 

  

endmodule 
