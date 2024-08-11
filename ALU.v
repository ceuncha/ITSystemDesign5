module ALU(A,B,ALUop,Result);
    input [31:0] A,B;
    input [3:0] ALUop;
    output reg [31:0] Result;

    wire [31:0] Result_Adder;
    wire C_out,overflow_out;
    reg [31:0] compare;
    
    CLA_32bit CLA_32bit(A,B,ALUop[2],Result_Adder,C_out,overflow_out);

always @(*) begin
    case (ALUop)
        4'b0010: begin  //ADD
            Result = Result_Adder; 

            end
        4'b0110: begin  //SUB
            Result = Result_Adder; 

            end
        4'b0000: begin  //AND
            Result = A & B; // 

            end
        4'b0001: begin  //OR
            Result = A | B; 

            end
        4'b0011: begin  //XOR
            Result = A^B;
            end
        4'b0100: begin  //SLL
            Result = A << B[4:0]; 

            end
        4'b0101: begin  //SRL
            Result = A >> B[4:0]; // SRL (Logical Right Shift)

            end
        4'b0111: begin  // SRA
                if (A[31] == 1) begin
                    Result = (A >> B[4:0]) | ~(32'hFFFFFFFF >> B[4:0]);
                end else begin
                    Result = A >> B[4:0];
                end
            end
        4'b1000: begin  //SLT
            compare=A-B;
            Result=compare[31]?1:0;

            end
        4'b1001: begin  //SLTU
            Result = (A < B) ? 32'b1 : 32'b0; // SLTU (Set Less Than Unsigned)

            end
        default: Result = 32'b0; // Default: Output 0
    endcase

end
endmodule

module CLA_4bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [3:0] P, G;  // Propagate and Generate
    wire [3:0] C;     // Carry

    // Propagate and Generate signals
    assign P = A ^ B;
    assign G = A & B;

    // Carry calculation using CLA logic
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    // Sum calculation
    assign Sum = P ^ C;

endmodule

module CLA_32bit(
    input [31:0] A,
    input [31:0] B,
    input subtract,   // 0: Add, 1: Subtract
    output [31:0] Result_Adder,
    output C_out,
    output Overflow
);
    wire [31:0] B_xor;
    wire [7:0] carry;
    wire [31:0] Sum;

    // B�몴占� XOR 占쎈염占쎄텦占쎈릭占쎈연 占쎈쑄占쎈�띷�⑨옙 筌먭쑴�랃옙肉� 占쎄텢占쎌뒠
    assign B_xor = B ^ {32{subtract}};

    // 4-bit CLA modules instantiation
    CLA_4bit CLA0 (.A(A[3:0]), .B(B_xor[3:0]), .Cin(subtract), .Sum(Sum[3:0]), .Cout(carry[0]));
    CLA_4bit CLA1 (.A(A[7:4]), .B(B_xor[7:4]), .Cin(carry[0]), .Sum(Sum[7:4]), .Cout(carry[1]));
    CLA_4bit CLA2 (.A(A[11:8]), .B(B_xor[11:8]), .Cin(carry[1]), .Sum(Sum[11:8]), .Cout(carry[2]));
    CLA_4bit CLA3 (.A(A[15:12]), .B(B_xor[15:12]), .Cin(carry[2]), .Sum(Sum[15:12]), .Cout(carry[3]));
    CLA_4bit CLA4 (.A(A[19:16]), .B(B_xor[19:16]), .Cin(carry[3]), .Sum(Sum[19:16]), .Cout(carry[4]));
    CLA_4bit CLA5 (.A(A[23:20]), .B(B_xor[23:20]), .Cin(carry[4]), .Sum(Sum[23:20]), .Cout(carry[5]));
    CLA_4bit CLA6 (.A(A[27:24]), .B(B_xor[27:24]), .Cin(carry[5]), .Sum(Sum[27:24]), .Cout(carry[6]));
    CLA_4bit CLA7 (.A(A[31:28]), .B(B_xor[31:28]), .Cin(carry[6]), .Sum(Sum[31:28]), .Cout(carry[7]));

    // 筌ㅼ뮇伊� 野껉퀗�궢
    assign Result_Adder = Sum;

    // Overflow �④쑴沅� (Sign �뜮袁る뱜占쎌벥 Carry)
    assign Overflow = carry[6] ^ carry[7];
    
    // Carry flag �④쑴沅� (subtract揶쏉옙 0占쎌뵠筌롳옙 Cout, subtract揶쏉옙 1占쎌뵠筌롳옙 獄쏆꼷�읈占쎈쭆 Cout)
    assign C_out = (subtract == 0) ? carry[7] : ~carry[7];

endmodule
