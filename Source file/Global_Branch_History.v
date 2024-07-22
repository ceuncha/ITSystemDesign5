module Global_History_Register (
    input wire clk,
    input wire reset,
    input wire ID_EX_Branch,
    input wire Pcsrc,
    output reg [3:0] branch_history // 4-bit branch history
);

// 비동기 리셋 및 분기 히스토리 업데이트
always @(posedge clk ) begin
    if (reset) begin
        branch_history <= 4'b0000; // 비동기 리셋
    end else if (ID_EX_Branch) begin
        // 새로운 분기 결과를 LSB에 추가하고 나머지를 오른쪽으로 이동
        branch_history <= {branch_history[2:0], Pcsrc};
    end
end

endmodule
