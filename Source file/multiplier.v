module multiplier (
    input clk,
    input rst,
    input start,
    input [31:0] A,
    input [31:0] B,
    input [7:0] Physical_address_in,
    input [31:0] PC_in,
    output reg [63:0] Product,
    output reg done,
    output reg [7:0] Physical_address_out,
    output reg [31:0] PC_out
);
    reg [31:0] A_reg, B_reg;
    reg done_reg;
    reg [7:0] Physical_address_reg;
    reg [31:0] PC_reg;
    wire [63:0] partial_products[31:0];
    wire [63:0] stage1_sums[15:0], stage1_carries[15:0];
    wire [63:0] stage2_sums[7:0], stage2_carries[7:0];
    wire [63:0] stage3_sums[3:0], stage3_carries[3:0];
    wire [63:0] stage4_sums[1:0], stage4_carries[1:0];
    reg [63:0] stage4_sum_reg, stage4_carry_reg;
    integer j;
    genvar i;

    // A�� B 媛믪쓣 �옒移�
    always @(posedge clk) begin
        if (rst) begin
            A_reg <= 0;
            B_reg <= 0;
            done_reg <= 0;
            Physical_address_reg <= 0;
            PC_reg <= 0;
        end else if (start) begin
            A_reg <= A;
            B_reg <= B;
            done_reg <= 1;
            Physical_address_reg <= Physical_address_in;
            PC_reg <= PC_in;
        end
    end

    // 遺�遺� 怨� �깮�꽦
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = (B_reg[i]) ? ({32'd0, A_reg} << i) : 64'd0;
        end
    endgenerate

    // 1�떒怨�
    reg [63:0] stage1_sums_reg[15:0], stage1_carries_reg[15:0];
    reg stage1_done_reg;
    reg [7:0] stage1_Physical_address_reg;
    reg [31:0] stage1_PC_reg;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1
            wire [63:0] pp0 = partial_products[2*i];
            wire [63:0] pp1 = partial_products[2*i+1];
            wire [63:0] sum, carry;
            CSA_64bit csa1 (.a(pp0), .b(pp1), .c(64'd0), .sum(sum), .carry(carry));
            assign stage1_sums[i] = sum;
            assign stage1_carries[i] = carry << 1;
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            for (j = 0; j < 16; j = j + 1) begin
                stage1_sums_reg[j] <= 0;
                stage1_carries_reg[j] <= 0;
                stage1_done_reg <= 0;
                stage1_Physical_address_reg <= 0;
                stage1_PC_reg <= 0;
            end
        end else begin
            for (j = 0; j < 16; j = j + 1) begin
                stage1_sums_reg[j] <= stage1_sums[j];
                stage1_carries_reg[j] <= stage1_carries[j];
                stage1_done_reg <= done_reg;
                stage1_Physical_address_reg <= Physical_address_reg;
                stage1_PC_reg <= PC_reg;
            end
        end
    end

    // 2�떒怨�
    reg [63:0] stage2_sums_reg[7:0], stage2_carries_reg[7:0];
    reg stage2_done_reg;
    reg [7:0] stage2_Physical_address_reg;
    reg [31:0] stage2_PC_reg;
    
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2
            wire [63:0] sum, carry;
            wire [63:0] temp_sum, temp_carry;
            CSA_64bit csa2 (.a(stage1_sums_reg[2*i]), .b(stage1_sums_reg[2*i+1]), .c(stage1_carries_reg[2*i]), .sum(temp_sum), .carry(temp_carry));
            CSA_64bit csa2_carry (.a(temp_sum), .b(temp_carry<<1), .c(stage1_carries_reg[2*i+1]), .sum(sum), .carry(carry));
            assign stage2_sums[i] = sum;
            assign stage2_carries[i] = carry << 1;
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            for (j = 0; j < 8; j = j + 1) begin
                stage2_sums_reg[j] <= 0;
                stage2_carries_reg[j] <= 0;
                stage2_done_reg <= 0;
                stage2_Physical_address_reg <= 0;
                stage2_PC_reg <= 0;
            end
        end else begin
            for (j = 0; j < 8; j = j + 1) begin
                stage2_sums_reg[j] <= stage2_sums[j];
                stage2_carries_reg[j] <= stage2_carries[j];
                stage2_done_reg <= stage1_done_reg;
                stage2_Physical_address_reg <= stage1_Physical_address_reg;
                stage2_PC_reg <= stage1_PC_reg;
            end
        end
    end

    // 3�떒怨�
    reg [63:0] stage3_sums_reg[3:0], stage3_carries_reg[3:0];
    reg stage3_done_reg;
    reg [7:0] stage3_Physical_address_reg;
    reg [31:0] stage3_PC_reg;
    
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage3
            wire [63:0] sum, carry;
            wire [63:0] temp_sum, temp_carry;
            CSA_64bit csa3 (.a(stage2_sums_reg[2*i]), .b(stage2_sums_reg[2*i+1]), .c(stage2_carries_reg[2*i]), .sum(temp_sum), .carry(temp_carry));
            CSA_64bit csa3_carry (.a(temp_sum), .b(temp_carry<<1), .c(stage2_carries_reg[2*i+1]), .sum(sum), .carry(carry));
            assign stage3_sums[i] = sum;
            assign stage3_carries[i] = carry << 1;
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            for (j = 0; j < 4; j = j + 1) begin
                stage3_sums_reg[j] <= 0;
                stage3_carries_reg[j] <= 0;
                stage3_done_reg <= 0;
                stage3_Physical_address_reg <= 0;
                stage3_PC_reg <= 0;
            end
        end else begin
            for (j = 0; j < 4; j = j + 1) begin
                stage3_sums_reg[j] <= stage3_sums[j];
                stage3_carries_reg[j] <= stage3_carries[j];
                stage3_done_reg <= stage2_done_reg;
                stage3_Physical_address_reg <= stage2_Physical_address_reg;
                stage3_PC_reg <= stage2_PC_reg;
            end
        end
    end

    // 4�떒怨�
    reg [63:0] stage4_sums_reg[1:0], stage4_carries_reg[1:0];
    reg stage4_done_reg;
    reg [7:0] stage4_Physical_address_reg;
    reg [31:0] stage4_PC_reg;
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage4
            wire [63:0] sum, carry;
            wire [63:0] temp_sum, temp_carry;
            CSA_64bit csa4 (.a(stage3_sums_reg[2*i]), .b(stage3_sums_reg[2*i+1]), .c(stage3_carries_reg[2*i]), .sum(temp_sum), .carry(temp_carry));
            CSA_64bit csa4_carry (.a(temp_sum), .b(temp_carry<<1), .c(stage3_carries_reg[2*i+1]), .sum(sum), .carry(carry));
            assign stage4_sums[i] = sum;
            assign stage4_carries[i] = carry << 1;
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            for (j = 0; j < 2; j = j + 1) begin
                stage4_sums_reg[j] <= 0;
                stage4_carries_reg[j] <= 0;
                stage4_done_reg <= 0;
            end
        end else begin
            for (j = 0; j < 2; j = j + 1) begin
                stage4_sums_reg[j] <= stage4_sums[j];
                stage4_carries_reg[j] <= stage4_carries[j];
                stage4_done_reg <= stage3_done_reg;
                stage4_Physical_address_reg <= stage3_Physical_address_reg;
                stage4_PC_reg <= stage3_PC_reg;
            end
        end
    end

    // 理쒖쥌 寃곌낵�� done �떊�샇 �뾽�뜲�씠�듃
    always @(posedge clk) begin
        if (rst) begin
            Product <= 0;
            done <= 0;
            Physical_address_out <= 0;
            PC_out <= 0;
            end    
            else begin      
            Product <= stage4_sums_reg[0] + stage4_sums_reg[1] + stage4_carries_reg[0] + stage4_carries_reg[1];
            done <= stage4_done_reg;
            Physical_address_out <= stage4_Physical_address_reg;
            PC_out <= stage4_PC_reg;
        end
    end
endmodule

// 64鍮꾪듃 CSA 紐⑤뱢 �젙�쓽
module CSA_64bit (
    input [63:0] a,
    input [63:0] b,
    input [63:0] c,
    output [63:0] sum,
    output [63:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (b & c) | (c & a);
endmodule
