module logical_address_register (
    input clk,
    input reset,
    input Reg_write,        // MEM 단계에서 데이터 쓰기 신호
    input [4:0] logical_address, // 논리 주소 (0번지부터 31번지)
    input [31:0] write_data,    // MEM 단계에서 쓰기 데이터
    output [31:0] x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15,
    output [31:0] x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31
);
    reg [31:0] logical_registers [0:31]; // 논리 주소 저장 레지스터
    integer i;

    // 클락 또는 리셋 신호 처리
    always @(*) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                logical_registers[i] <= i; // 초기값은 번지수
            end
        end else if (Reg_write) begin
            if (logical_address != 5'b0) begin
                logical_registers[logical_address] <= write_data;
            end
        end
    end

    // 모든 레지스터 값을 출력하는 부분
    assign x0 = logical_registers[0];
    assign x1 = logical_registers[1];
    assign x2 = logical_registers[2];
    assign x3 = logical_registers[3];
    assign x4 = logical_registers[4];
    assign x5 = logical_registers[5];
    assign x6 = logical_registers[6];
    assign x7 = logical_registers[7];
    assign x8 = logical_registers[8];
    assign x9 = logical_registers[9];
    assign x10 = logical_registers[10];
    assign x11 = logical_registers[11];
    assign x12 = logical_registers[12];
    assign x13 = logical_registers[13];
    assign x14 = logical_registers[14];
    assign x15 = logical_registers[15];
    assign x16 = logical_registers[16];
    assign x17 = logical_registers[17];
    assign x18 = logical_registers[18];
    assign x19 = logical_registers[19];
    assign x20 = logical_registers[20];
    assign x21 = logical_registers[21];
    assign x22 = logical_registers[22];
    assign x23 = logical_registers[23];
    assign x24 = logical_registers[24];
    assign x25 = logical_registers[25];
    assign x26 = logical_registers[26];
    assign x27 = logical_registers[27];
    assign x28 = logical_registers[28];
    assign x29 = logical_registers[29];
    assign x30 = logical_registers[30];
    assign x31 = logical_registers[31];

endmodule
