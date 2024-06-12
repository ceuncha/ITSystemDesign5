module branch_unit(
    //input clk,
    //input reset,
    input [31:0] ResultA,       // 첫 번째 비교 대상
    input [31:0] ResultB,       // 두 번째 비교 대상
    input [31:0] IF_ID_PC,
    input [31:0] ID_EX_PC,      // 현재 명령어 주소
    input ID_EX_Branch,         // 분기 활성화 신호
    input [2:0] ID_EX_funct3,   // 분기 유형을 결정하는 함수 코드
    input [31:0] ALUResult,     // ALU 결과 (분기 주소 계산에 사용)
    input wire IF_ID_BPred,
    input wire IF_ID_BPredValid,
    input wire ID_EX_Jump,                 // 점프 활성화 신호
    output reg PCSrc,           // PC 소스 선택 신호 (분기 또는 점프 수행 시 1)
    output reg [31:0] PC_Branch,// 새로운 분기 또는 점프 주소
    output reg [31:0] Rd_data,  // Rd 레지스터에 저장할 데이터
    output reg IF_ID_Flush,     // IF/ID 파이프라인 레지스터 플러시
    output reg ID_EX_Flush      // ID/EX 파이프라인 레지스터 플러시
);

wire prediction;
assign prediction = (IF_ID_BPredValid && (IF_ID_BPred == PCSrc)) ? 1 : 0;
//assign prediction = (IF_ID_PC == PC_Branch) ? 1 : 0;

/*
assign PC_Branch = ALUResult;
assign PCSrc = ID_EX_Jump ? 1 :
                (ID_EX_funct3 == 3'b000 && (ResultA == ResultB)) ? 1 :
                ()
*/
always @(*) begin
    // 기본 설정
    PCSrc = 0;
    PC_Branch = 0;  // 기본 분기 주소
    Rd_data = 0;                       // 기본적으로 0
    IF_ID_Flush = 0;
    ID_EX_Flush = 0;

    if (ID_EX_Jump) begin
        // Jump가 활성화된 경우
        PCSrc = 1;
        PC_Branch = ALUResult;         // Jump 주소는 ALU 결과로 설정
        $display("Time: %0t | in branch unit, Jump to %h", $time, PC_Branch);
        Rd_data = ID_EX_PC + 4;         // Rd_data에는 PC + 4 저장
        IF_ID_Flush = 1;
        ID_EX_Flush = 1;
    end 
    else if (ID_EX_Branch) begin
        // 분기 조건을 평가
        case (ID_EX_funct3)
            3'b000: PCSrc = (ResultA == ResultB);   // BEQ
            3'b001: PCSrc = (ResultA != ResultB);   // BNE
            3'b100: PCSrc = ($signed(ResultA) < $signed(ResultB));  // BLT
            3'b101: PCSrc = ($signed(ResultA) >= $signed(ResultB)); // BGE
            3'b110: PCSrc = ($unsigned(ResultA) < $unsigned(ResultB)); // BLTU
            3'b111: PCSrc = ($unsigned(ResultA) >= $unsigned(ResultB)); // BGEU
            default: PCSrc = 0;
        endcase
        if (PCSrc) begin
            // 분기가 활성화되었을 때 PC 주소 변경, 플러시 신호 발생
            PC_Branch = ALUResult;
            if (prediction) begin // if prediction was right
                // do not flush the pipeline
                //IF_ID_Flush = 0;
                ID_EX_Flush = 0;
                $display("Time: %0t | in branch unit, for PC: %h prediction was right", $time, ID_EX_PC);
            end else begin
                //IF_ID_Flush = 1;
                ID_EX_Flush = 1;
                $display("Time: %0t | in branch unit, for PC: %h prediction was wrong", $time, ID_EX_PC);
            end
            //$display("Time: %0t | in branch unit, for PC: %h Branch to %h", $time, ID_EX_PC, PC_Branch)
        end
    end
end

endmodule
