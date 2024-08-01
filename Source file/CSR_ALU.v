module CSR_ALU (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] CSR_ALUop,
    output reg [31:0] Result
);
    
always @(*) begin
    case (CSR_ALUop)
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
