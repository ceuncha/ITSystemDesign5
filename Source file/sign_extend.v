module sign_extend(
    input [31:0] inst,  // 전체 명령어 입력
    input clk,          // 클락 신호 입력
    output reg [31:0] Imm  // 신호 확장된 즉시값 출력
);

// Opcode는 명령어의 가장 낮은 7비트에 위치
wire [6:0] opcode = inst[6:0];

// Opcode를 기반으로 명령어 유형 판별 및 적절한 즉시값 추출 및 신호 확장
always @(posedge clk) begin
    case(opcode)
        // I-type (예: load, immediate, JALR)
        7'b0000011, 7'b0010011, 7'b1100111: begin
            Imm[11:0] <= inst[31:20];
            Imm[31:12] <= {20{inst[31]}};
        end
        // S-type (store)
        7'b0100011: begin
            Imm[11:5] <= inst[31:25];
            Imm[4:0] <= inst[11:7];
            Imm[31:12] <= {20{inst[31]}};
        end
        // B-type (branch)
        7'b1100011: begin
            Imm[12] <= inst[31];
            Imm[10:5] <= inst[30:25];
            Imm[4:1] <= inst[11:8];
            Imm[11] <= inst[7];
            Imm[0] <= 1'b0; // B-type 즉시값은 항상 짝수
            Imm[31:13] <= {19{inst[31]}};
        end
        // U-type (LUI, AUIPC)
        7'b0110111, 7'b0010111: begin
            Imm[31:12] <= inst[31:12];
            Imm[11:0] <= 12'b0; // 하위 12비트는 0
        end
        // J-type (JAL)
        7'b1101111: begin
            Imm[20] <= inst[31];
            Imm[10:1] <= inst[30:21];
            Imm[11] <= inst[20];
            Imm[19:12] <= inst[19:12];
            Imm[0] <= 1'b0; // J-type 즉시값은 항상 짝수
            Imm[31:21] <= {11{inst[31]}};
        end
        default: Imm <= 32'b0; // 즉시값이 없는 명령어 유형의 경우
    endcase
end

endmodule
