module register_file (
    input clk,
    input reset,
    input [6:0] Operand1_phy,
    input [6:0] Operand2_phy,
    input [6:0] Rd_phy, // 명령어의 Rd 주소

    input ALU_add_Write,
    input ALU_load_Write,
    input ALU_mul_Write,
    input ALU_div_Write,
    input [31:0] ALU_add_Data,
    input [31:0] ALU_load_Data,
    input [31:0] ALU_mul_Data,
    input [31:0] ALU_div_Data,
    input [6:0] ALU_add_phy,
    input [6:0] ALU_load_phy,
    input [6:0] ALU_mul_phy,
    input [6:0] ALU_div_phy,

    output reg [31:0] Operand1_data,
    output reg [31:0] Operand2_data,
    output reg valid1,
    output reg valid2
);

// 레지스터와 valid 비트 저장
reg [31:0] registers [0:127];
reg valid [0:127];
integer i;

always @(posedge reset) begin
	    if (reset) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= i;
            valid[i] <= 1'b1; // 초기 valid 비트는 1로 설정
        end
        for (i = 32; i < 128; i = i + 1) begin
            registers[i] <= 32'h00000000;
            valid[i] <= 1'b0; // 초기 valid 비트는 0으로 설정
        end
    end
end


// 클락 또는 리셋 신호 처리
always @(posedge clk) begin

        if (ALU_add_Write == 1'b1 && ALU_add_phy != 7'b0) begin
            registers[ALU_add_phy] <= ALU_add_Data;
            valid[ALU_add_phy] <= 1'b1; // validation 값 1로 설정
        end
        if (ALU_load_Write == 1'b1 && ALU_load_phy != 7'b0) begin
            registers[ALU_load_phy] <= ALU_load_Data;
            valid[ALU_load_phy] <= 1'b1; // validation 값 1로 설정
        end
        if (ALU_mul_Write == 1'b1 && ALU_mul_phy != 7'b0) begin
            registers[ALU_mul_phy] <= ALU_mul_Data;
            valid[ALU_mul_phy] <= 1'b1; // validation 값 1로 설정
        end
        if (ALU_div_Write == 1'b1 && ALU_div_phy != 7'b0) begin
            registers[ALU_div_phy] <= ALU_div_Data;
            valid[ALU_div_phy] <= 1'b1; // validation 값 1로 설정
        end

end

always @(Rd_phy) begin
    if (Rd_phy != 7'b0) begin
        valid[Rd_phy] <= 1'b0;
    end
end

// 읽기 연산
always @(Operand1_phy or Operand2_phy) begin
    Operand1_data = registers[Operand1_phy];
    Operand2_data = registers[Operand2_phy];
    valid1 = valid[Operand1_phy];
    valid2 = valid[Operand2_phy];
end

endmodule
