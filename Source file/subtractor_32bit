module subtractor_32bit (
    input [31:0] A,
    input [31:0] B,
    output negative,
    output overflow,
    output zero,
    output carry
);

    wire [31:0] B_neg;  // B의 2의 보수 (negative B)
    wire [31:0] sum;    // A와 B_neg의 합
    wire carry_out;

    // B의 2의 보수를 계산
    assign B_neg = ~B + 1;

    // A와 B_neg의 합을 계산
    assign {carry_out, sum} = A + B_neg;

    // 결과를 출력

    // negative 플래그: 결과의 최상위 비트가 1이면 음수
    assign negative = sum[31];

    // zero 플래그: 결과가 0이면 1
    assign zero = (sum == 0);

    // overflow 플래그: A와 B의 최상위 비트가 같고, 결과의 최상위 비트가 A와 다르면 오버플로우 발생
    assign overflow = (A[31] == B_neg[31]) && (sum[31] != A[31]);

    // carry 플래그: 32비트 덧셈 시 캐리가 발생하면 1
    assign carry = carry_out;

endmodule
