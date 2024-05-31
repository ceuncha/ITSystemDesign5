module logical_address_register (
    input clk,
    input reset,
    input mem_to_write, // MEM 단계에서 데이터 쓰기 신호
    input [4:0] logical_address, // 논리 주소 (0번지부터 31번지)
    input [31:0] write_data, // MEM 단계에서 쓰기 데이터
    output reg [31:0] logical_registers [0:31] // 논리 주소 저장 레지스터
);
    integer i;

    // 클락 또는 리셋 신호 처리
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                logical_registers[i] <= i; // 초기값은 번지수
            end
        end else if (mem_to_write) begin
            if (logical_address != 5'b0) begin
                logical_registers[logical_address] <= write_data;
            end
        end
    end
endmodule
