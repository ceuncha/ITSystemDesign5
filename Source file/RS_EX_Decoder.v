module RS_EX_decoder(
    input clk,              // 클럭 신호
    input reset,            // 리셋 신호
    input in_execute_on,    // 1-bit, 실행 여부 결정 신호
    input [6:0] in_opcode,  // 7-bit, 연산 코드
    input [31:0] in_operand1,  // 32-bit, 첫 번째 피연산자
    input [31:0] in_operand2,  // 32-bit, 두 번째 피연산자
    input [2:0] in_func3,   // 3-bit, 부가적 연산 정보
    input [31:0] in_pc,     // 32-bit, 프로그램 카운터
    input [31:0] in_label,  // 조건 분기 명령어에서 사용될 Immediate 값
    input [6:0] in_control, // 7-bit, 제어 신호
    input [7:0] rd_phy_reg,
    
    output reg [31:0] add_alu_operand1,  // Add ALU로 보낼 첫 번째 피연산자
    output reg [31:0] add_alu_operand2,  // Add ALU로 보낼 두 번째 피연산자
    output reg [2:0] add_alu_func3,  // Add ALU로 보낼 func3
    output reg [31:0] add_alu_pc,    // Add ALU로 보낼 프로그램 카운터
    output reg [31:0] add_alu_label, // Add ALU로 보낼 Immediate 값
    output reg [6:0] add_control,    // Add ALU로 보낼 제어 신호
    output reg [7:0] add_rd_phy_reg,

    output reg [31:0] mul_alu_operand1,  // Mul ALU로 보낼 첫 번째 피연산자
    output reg [31:0] mul_alu_operand2,  // Mul ALU로 보낼 두 번째 피연산자
    output reg [2:0] mul_alu_func3,  // Mul ALU로 보낼 func3
    output reg [31:0] mul_alu_pc,    // Mul ALU로 보낼 프로그램 카운터
    output reg [31:0] mul_alu_label, // Mul ALU로 보낼 Immediate 값
    output reg [6:0] mul_control,    // Mul ALU로 보낼 제어 신호
   output reg [7:0] mul_rd_phy_reg,

    output reg [31:0] div_alu_operand1,  // Div ALU로 보낼 첫 번째 피연산자
    output reg [31:32] div_alu_operand2,  // Div ALU로 보낼 두 번째 피연산자
    output reg [2:0] div_alu_func3,  // Div ALU로 보낼 func3
    output reg [31:32] div_alu_pc,    // Div ALU로 보낼 프로그램 카운터
    output reg [31:32] div_alu_label, // Div ALU로 보낼 Immediate 값
    output reg [6:0] div_control,   // Div ALU로 보낼 제어 신호
    output reg [7:0] div_rd_phy_reg
);
always @(posedge reset) begin

        // 모든 출력을 리셋

        add_alu_operand1 <= 0;
        add_alu_operand2 <= 0;
        add_alu_func3 <= 0;
        add_alu_pc <= 0;
        add_alu_label <= 0;
        add_control <= 0;


        mul_alu_operand1 <= 0;
        mul_alu_operand2 <= 0;
        mul_alu_func3 <= 0;
        mul_alu_pc <= 0;
        mul_alu_label <= 0;
        mul_control <= 0;


        div_alu_operand1 <= 0;
        div_alu_operand2 <= 0;
        div_alu_func3 <= 0;
        div_alu_pc <= 0;
        div_alu_label <= 0;
        div_control <= 0;
    end

always @(posedge clk) begin
    if(in_execute_on) begin
        case (in_opcode)
            7'b0110011: begin // MUL 명령어
                mul_alu_operand1 <= in_operand1;
                mul_alu_operand2 <= in_operand2;
                mul_alu_func3 <= in_func3;
                mul_alu_pc <= in_pc;
                mul_alu_label <= in_label;
                mul_control <= in_control;
            end
            7'b1001111: begin // DIV 명령어

                div_alu_operand1 <= in_operand1;
                div_alu_operand2 <= in_operand2;
                div_alu_func3 <= in_func3;
                div_alu_pc <= in_pc;
                div_alu_label <= in_label;
                div_control <= in_control;
            end
            default: begin // ADD 명령어
                add_alu_operand1 <= in_operand1;
                add_alu_operand2 <= in_operand2;
                add_alu_func3 <= in_func3;
                add_alu_pc <= in_pc;
                add_alu_label <= in_label;
                add_control <= in_control;
            end
        endcase
    end
end

endmodule
