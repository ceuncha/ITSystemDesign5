module instruction_decoder(
    input [188:0] data_in,   // 189비트 입력 데이터
    output reg [188:0] Rs_alu,
    output reg [188:0] Rs_mul,
    output reg [188:0] Rs_div
);

    // 입력 데이터 필드 정의
    wire MemToReg;
    wire MemRead;
    wire MemWrite;
    wire [3:0] ALUOp;
    wire ALUSrc1;
    wire ALUSrc2;
    wire Jump;
    wire Branch;
    wire [31:0] PC;
    wire [6:0] opcode;
    wire [6:0] Rd_phy;
    wire [4:0] Rd_Reg;
    wire [31:0] RData1;
    wire [31:0] RData2;
    wire [1:0] Ready_flag;
    wire [31:0] imm32;

    // 데이터 필드를 데이터 입력에서 분리
    assign {imm32, Ready_flag, RData2, RData1, Rd_Reg, Rd_phy, opcode, PC, Branch, Jump, ALUSrc2, ALUSrc1, ALUOp, MemWrite, MemRead, MemToReg} = data_in;

    always @(*) begin
        // 기본값으로 모든 출력 레지스터를 초기화
        Rs_alu = 189'b0;
        Rs_mul = 189'b0;
        Rs_div = 189'b0;
        
        case (opcode)
            7'b0110011: begin
                Rs_mul = data_in;  // OPCODE가 0110011이면 Rs_mul에 저장
                Rs_alu = 189'b0;   // 나머지는 0으로 초기화
                Rs_div = 189'b0;
            end
            7'b1001111: begin
                Rs_div = data_in;  // OPCODE가 1001111이면 Rs_div에 저장
                Rs_alu = 189'b0;   // 나머지는 0으로 초기화
                Rs_mul = 189'b0;
            end
            default: begin
                Rs_alu = data_in;  // 나머지 경우는 Rs_alu에 저장
                Rs_mul = 189'b0;   // 나머지는 0으로 초기화
                Rs_div = 189'b0;
            end
        endcase
    end
endmodule
