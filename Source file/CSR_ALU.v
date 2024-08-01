module ALU(A,B,ALUop,Result);
    input [31:0] A,B;
    input [3:0] ALUop;
    output reg [31:0] Result;

always @(*) begin
    case (ALUop)
        4'b0011: begin  //PASS
            Result = B; 
            end
        4'b0000: begin  //AND NOT
          Result = ~(A & B); // 
            end
        4'b0001: begin  OR
            Result = A | B; 
        default: Result = 32'b0; // Default: Output 0
    endcase

end
endmodule
