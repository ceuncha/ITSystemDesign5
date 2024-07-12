module subtractor_32bit (
    input [31:0] A,
    input [31:0] B,
    output negative,
    output overflow,
    output zero,
    output carry
);

    wire [31:0] B_neg;  // B�쓽 2�쓽 蹂댁닔 (negative B)
    wire [31:0] sum;    // A�� B_neg�쓽 �빀
    wire carry_out;

    // B�쓽 2�쓽 蹂댁닔瑜� 怨꾩궛
    assign B_neg = ~B + 1;

    // A�� B_neg�쓽 �빀�쓣 怨꾩궛
    assign {carry_out, sum} = A + B_neg;

    // 寃곌낵瑜� 異쒕젰

    // negative �뵆�옒洹�: 寃곌낵�쓽 理쒖긽�쐞 鍮꾪듃媛� 1�씠硫� �쓬�닔
    assign negative = sum[31];

    // zero �뵆�옒洹�: 寃곌낵媛� 0�씠硫� 1
    assign zero = (sum == 0);

    // overflow �뵆�옒洹�: A�� B�쓽 理쒖긽�쐞 鍮꾪듃媛� 媛숆퀬, 寃곌낵�쓽 理쒖긽�쐞 鍮꾪듃媛� A�� �떎瑜대㈃ �삤踰꾪뵆濡쒖슦 諛쒖깮
    assign overflow = (A[31] == B_neg[31]) && (sum[31] != A[31]);

    // carry �뵆�옒洹�: 32鍮꾪듃 �뜤�뀍 �떆 罹먮━媛� 諛쒖깮�븯硫� 1
    assign carry = carry_out;

endmodule
