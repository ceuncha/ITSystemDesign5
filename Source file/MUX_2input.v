module MUX_2input(
    input [31:0] a,      // 첫 번째 입력
    input [31:0] b,      // 두 번째 입력
    input sel,    // 선택 신호
    output  [31:0] y      // 출력 신호
);

assign y = (sel) ? b : a;

endmodule
