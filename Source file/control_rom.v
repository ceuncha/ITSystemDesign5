module control_rom(
    input [5:0] mapped_address,
    input reset, // 리셋 신호 추가
    output RegWrite,
    output MemToReg,
    output MemRead,
    output MemWrite,
    output [3:0] ALUOp,
    output [1:0] ALUSrc,
    output RWsel,
    output Branch,
    output Jump // 추가된 Jump 신호
);

reg [12:0] ROM [0:63]; // ROM 크기를 13비트로 증가

assign {RegWrite, MemToReg, MemRead, MemWrite, ALUOp, ALUSrc, RWsel, Branch, Jump} = ROM[mapped_address];

    always @(posedge reset) begin
   
        // 모든 제어 신호를 주소 0에서 0으로 초기화
        ROM[0] = 13'b0_0_0_0_0000_00_0_0_0;

        // R-타입 명령어
        ROM[1] = 13'b1_0_0_0_0010_10_0_0_0; // ADD
        ROM[2] = 13'b1_0_0_0_0110_10_0_0_0; // SUB
        ROM[3] = 13'b1_0_0_0_0000_10_0_0_0; // AND
        ROM[4] = 13'b1_0_0_0_0001_10_0_0_0; // OR
        ROM[5] = 13'b1_0_0_0_0011_10_0_0_0; // XOR
        ROM[6] = 13'b1_0_0_0_0100_10_0_0_0; // SLL
        ROM[7] = 13'b1_0_0_0_0101_10_0_0_0; // SRL
        ROM[8] = 13'b1_0_0_0_0111_10_0_0_0; // SRA
        ROM[9] = 13'b1_0_0_0_1000_10_0_0_0; // SLT
        ROM[10] = 13'b1_0_0_0_1001_10_0_0_0; // SLTU

        // 로드 및 스토어
        ROM[11] = 13'b1_1_1_0_0010_11_0_0_0; // 로드
        ROM[12] = 13'b0_0_0_1_0010_11_0_0_0; // 스토어

        // Branch 명령어
        ROM[13] = 13'b0_0_0_0_0110_10_0_1_0; // 분기 명령어에 대한 ALUOp 설정

        // I-타입 즉시값 연산 및 ALU 명령어
        ROM[14] = 13'b1_0_0_0_0010_11_0_0_0; // ADDI
        ROM[15] = 13'b1_0_0_0_1000_11_0_0_0; // SLTI
        ROM[16] = 13'b1_0_0_0_1001_11_0_0_0; // SLTIU
        ROM[17] = 13'b1_0_0_0_0011_11_0_0_0; // XORI
        ROM[18] = 13'b1_0_0_0_0001_11_0_0_0; // ORI
        ROM[19] = 13'b1_0_0_0_0000_11_0_0_0; // ANDI
        ROM[20] = 13'b1_0_0_0_0100_11_0_0_0; // SLLI
        ROM[21] = 13'b1_0_0_0_0101_11_0_0_0; // SRLI
        ROM[22] = 13'b1_0_0_0_0111_11_0_0_0; // SRAI

        // LUI, AUIPC, JAL, JALR
        ROM[23] = 13'b1_0_0_0_0010_11_0_0_0; // LUI
        ROM[24] = 13'b1_0_0_0_0010_01_0_0_0; // AUIPC
        ROM[25] = 13'b1_0_0_0_0010_01_1_0_1; // JAL
        ROM[26] = 13'b1_0_0_0_0010_11_1_0_1; // JALR

        // 추가된 명령어
        ROM[27] = 13'b1_0_0_0_1010_10_0_0_0; // MUL
        ROM[28] = 13'b1_0_0_0_0001_10_0_0_0; // DIV (몫)
        ROM[29] = 13'b1_0_0_0_0000_10_0_0_0; // REM (나머지)

end

endmodule
