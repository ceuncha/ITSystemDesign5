
module BranchUnit(
    input rst
    input wire ID_EX_Jump,
    input wire ID_EX_Branch,
    input wire [2:0] ID_EX_funct3,
    input wire [31:0] ALUResult,
    input wire [31:0] imm,
    input wire [31:0] PC,
    input wire ALUNegative, // ALU에서 오는 Negative 플래그
    input wire ALUZero,     // ALU에서 오는 Zero 플래그
    input wire ALUOverflow, // ALU에서 오는 Overflow 플래그
    input wire ALUCarry,    // ALU에서 오는 Carry 플래그
    output reg [31:0] PC_Branch,
    output reg [31:0] branch_index
    output reg PCSrc,
    output reg IF_ID_Flush,

);

  always @ (posedge rst) begin
        PCSrc = 0;
        PC_Branch = 0;  // 기본 분기 주소
        IF_ID_Flush = 0;
  end
    
always @(*) begin
        if(ID_EX_Jump) begin
            PC_Branch = ALUResult; // 점프 처리
            PCSrc = 1; // 점프 시 PC 소스 신호 활성화
            IF_ID_Flush = 1'b1;
            branch_index = PC
        end
        else if(ID_EX_Branch) begin
            case(ID_EX_funct3)
                3'b000: PCSrc = ALUZero; // BEQ: Zero 플래그가 1이면 참
                3'b001: PCSrc = ~ALUZero; // BNE: Zero 플래그가 0이면 참
                3'b100: PCSrc = ALUNegative; // BLT: Negative 플래그가 1이면 참
                3'b101: PCSrc = ~ALUNegative; // BGE: Negative 플래그가 0이면 참
                3'b110: PCSrc = ALUCarry; // BLTU: Carry 플래그가 1이면 참
                3'b111: PCSrc = ~ALUCarry; // BGEU: Carry 플래그가 0이면 참
                default: PCSrc = 0;
            endcase
            if(PCSrc) begin
                PC_Branch = imm + PC + 4; // 분기 주소 업데이트
                IF_ID_Flush = 1'b1;
                branch_index = PC
            end
        end
        else begin
            PC_Branch = 32'd0; // 기본값
            PCSrc = 0;
        end
    end


endmodule
