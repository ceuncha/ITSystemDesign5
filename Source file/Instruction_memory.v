module Instruction_memory(

    input wire [31:0] pc,

    input wire reset,
    output reg [31:0] instOut

);
  reg [7:0] memory [0:1023]; // 1KB memory
integer i;

initial begin

    for (i = 0; i < 1024; i = i + 1) begin
      memory[i] = 8'h00;
    end
    
 $readmemh("i.mem", memory);
end



    always @ (*) begin

        instOut <= {memory[pc], memory[pc+1], memory[pc+2], memory[pc+3]};

    end

endmodule
