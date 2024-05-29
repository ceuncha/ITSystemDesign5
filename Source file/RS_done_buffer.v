module RS_done_buffer(
    input clk,              // 클럭 신호
    input reset,            // 리셋 신호
    input in_execute_on,    // 1-bit, 실행 여부 결정 신호
    input in_branch_flag,   // 1-bit, 분기 여부 신호
    input [6:0] in_opcode,  // 7-bit, 연산 코드
    input [4:0] in_rs_add,  // 5-bit, RS 주소
    input [4:0] in_rd_reg,  // 5-bit, 대상 레지스터 주소
    input [31:0] in_operand1,  // 32-bit, 첫 번째 피연산자
    input [31:0] in_operand2,  // 32-bit, 두 번째 피연산자
    input [2:0] in_func3,   // 3-bit, 부가적 연산 정보
    input [31:0] in_pc,     // 32-bit, 프로그램 카운터
    input [31:0] in_label,  // 조건 분기 명령어에서 사용될 Immediate 값
    input add_done,         // Add ALU 연산 완료 신호
    input mul_done,         // Mul ALU 연산 완료 신호
    input div_done,         // Div ALU 연산 완료 신호
    output reg add_execute_on,     // Add ALU로 보낼 실행 여부 신호
    output reg add_branch_flag,    // Add ALU로 보낼 분기 여부 신호
    output reg [6:0] add_alu_opcode,  // Add ALU로 보낼 Opcode
    output reg [4:0] add_alu_rs_add,  // Add ALU로 보낼 RS 주소
    output reg [4:0] add_alu_rd_reg,  // Add ALU로 보낼 대상 레지스터 주소
    output reg [31:0] add_alu_operand1,  // Add ALU로 보낼 첫 번째 피연산자
    output reg [31:0] add_alu_operand2,  // Add ALU로 보낼 두 번째 피연산자
    output reg [2:0] add_alu_func3,  // Add ALU로 보낼 func3
    output reg [31:0] add_alu_pc,    // Add ALU로 보낼 프로그램 카운터
    output reg [31:0] add_alu_label, // Add ALU로 보낼 Immediate 값
    output reg mul_execute_on,     // Mul ALU로 보낼 실행 여부 신호
    output reg mul_branch_flag,    // Mul ALU로 보낼 분기 여부 신호
    output reg [6:0] mul_alu_opcode,  // Mul ALU로 보낼 Opcode
    output reg [4:0] mul_alu_rs_add,  // Mul ALU로 보낼 RS 주소
    output reg [4:0] mul_alu_rd_reg,  // Mul ALU로 보낼 대상 레지스터 주소
    output reg [31:0] mul_alu_operand1,  // Mul ALU로 보낼 첫 번째 피연산자
    output reg [31:0] mul_alu_operand2,  // Mul ALU로 보낼 두 번째 피연산자
    output reg [2:0] mul_alu_func3,  // Mul ALU로 보낼 func3
    output reg [31:0] mul_alu_pc,    // Mul ALU로 보낼 프로그램 카운터
    output reg [31:0] mul_alu_label, // Mul ALU로 보낼 Immediate 값
    output reg div_execute_on,     // Div ALU로 보낼 실행 여부 신호
    output reg div_branch_flag,    // Div ALU로 보낼 분기 여부 신호
    output reg [6:0] div_alu_opcode,  // Div ALU로 보낼 Opcode
    output reg [4:0] div_alu_rs_add,  // Div ALU로 보낼 RS 주소
    output reg [4:0] div_alu_rd_reg,  // Div ALU로 보낼 대상 레지스터 주소
    output reg [31:0] div_alu_operand1,  // Div ALU로 보낼 첫 번째 피연산자
    output reg [31:0] div_alu_operand2,  // Div ALU로 보낼 두 번째 피연산자
    output reg [2:0] div_alu_func3,  // Div ALU로 보낼 func3
    output reg [31:0] div_alu_pc,    // Div ALU로 보낼 프로그램 카운터
    output reg [31:0] div_alu_label  // Div ALU로 보낼 Immediate 값
);

parameter ADD_SIZE = 4;
parameter MUL_SIZE = 8;
parameter DIV_SIZE = 16;

// FIFO 버퍼를 배열 형태로 정의
reg [6:0] add_opcode_fifo [0:ADD_SIZE-1];
reg [4:0] add_rs_add_fifo [0:ADD_SIZE-1];
reg [4:0] add_rd_reg_fifo [0:ADD_SIZE-1];
reg [31:0] add_operand1_fifo [0:ADD_SIZE-1];
reg [31:0] add_operand2_fifo [0:ADD_SIZE-1];
reg [2:0] add_func3_fifo [0:ADD_SIZE-1];
reg [31:0] add_pc_fifo [0:ADD_SIZE-1];
reg [31:0] add_label_fifo [0:ADD_SIZE-1];
reg add_execute_on_fifo [0:ADD_SIZE-1];
reg add_branch_flag_fifo [0:ADD_SIZE-1];

reg [6:0] mul_opcode_fifo [0:MUL_SIZE-1];
reg [4:0] mul_rs_add_fifo [0:MUL_SIZE-1];
reg [4:0] mul_rd_reg_fifo [0:MUL_SIZE-1];
reg [31:0] mul_operand1_fifo [0:MUL_SIZE-1];
reg [31:0] mul_operand2_fifo [0:MUL_SIZE-1];
reg [2:0] mul_func3_fifo [0:MUL_SIZE-1];
reg [31:0] mul_pc_fifo [0:MUL_SIZE-1];
reg [31:0] mul_label_fifo [0:MUL_SIZE-1];
reg mul_execute_on_fifo [0:MUL_SIZE-1];
reg mul_branch_flag_fifo [0:MUL_SIZE-1];

reg [6:0] div_opcode_fifo [0:DIV_SIZE-1];
reg [4:0] div_rs_add_fifo [0:DIV_SIZE-1];
reg [4:0] div_rd_reg_fifo [0:DIV_SIZE-1];
reg [31:0] div_operand1_fifo [0:DIV_SIZE-1];
reg [31:0] div_operand2_fifo [0:DIV_SIZE-1];
reg [2:0] div_func3_fifo [0:DIV_SIZE-1];
reg [31:0] div_pc_fifo [0:DIV_SIZE-1];
reg [31:0] div_label_fifo [0:DIV_SIZE-1];
reg div_execute_on_fifo [0:DIV_SIZE-1];
reg div_branch_flag_fifo [0:DIV_SIZE-1];

integer add_head, add_tail;
integer mul_head, mul_tail;
integer div_head, div_tail;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        add_head <= 0; add_tail <= 0;
        mul_head <= 0; mul_tail <= 0;
        div_head <= 0; div_tail <= 0;
    end else begin
        if (in_execute_on) begin
            case (in_opcode)
                7'b0110011: // MUL 명령어
                    if (mul_done && mul_head == mul_tail) begin
                        mul_execute_on <= in_execute_on;
                        mul_branch_flag <= in_branch_flag;
                        mul_alu_opcode <= in_opcode;
                        mul_alu_rs_add <= in_rs_add;
                        mul_alu_rd_reg <= in_rd_reg;
                        mul_alu_operand1 <= in_operand1;
                        mul_alu_operand2 <= in_operand2;
                        mul_alu_func3 <= in_func3;
                        mul_alu_pc <= in_pc;
                        mul_alu_label <= in_label;
                    end else begin
                        mul_opcode_fifo[mul_tail] <= in_opcode;
                        mul_rs_add_fifo[mul_tail] <= in_rs_add;
                        mul_rd_reg_fifo[mul_tail] <= in_rd_reg;
                        mul_operand1_fifo[mul_tail] <= in_operand1;
                        mul_operand2_fifo[mul_tail] <= in_operand2;
                        mul_func3_fifo[mul_tail] <= in_func3;
                        mul_pc_fifo[mul_tail] <= in_pc;
                        mul_label_fifo[mul_tail] <= in_label;
                        mul_execute_on_fifo[mul_tail] <= in_execute_on;
                        mul_branch_flag_fifo[mul_tail] <= in_branch_flag;
                        mul_tail <= (mul_tail + 1) % MUL_SIZE;
                    end
                7'b1001111: // DIV 명령어
                    if (div_done && div_head == div_tail) begin
                        div_execute_on <= in_execute_on;
                        div_branch_flag <= in_branch_flag;
                        div_alu_opcode <= in_opcode;
                        div_alu_rs_add <= in_rs_add;
                        div_alu_rd_reg <= in_rd_reg;
                        div_alu_operand1 <= in_operand1;
                        div_alu_operand2 <= in_operand2;
                        div_alu_func3 <= in_func3;
                        div_alu_pc <= in_pc;
                        div_alu_label <= in_label;
                    end else begin
                        div_opcode_fifo[div_tail] <= in_opcode;
                        div_rs_add_fifo[div_tail] <= in_rs_add;
                        div_rd_reg_fifo[div_tail] <= in_rd_reg;
                        div_operand1_fifo[div_tail] <= in_operand1;
                        div_operand2_fifo[div_tail] <= in_operand2;
                        div_func3_fifo[div_tail] <= in_func3;
                        div_pc_fifo[div_tail] <= in_pc;
                        div_label_fifo[div_tail] <= in_label;
                        div_execute_on_fifo[div_tail] <= in_execute_on;
                        div_branch_flag_fifo[div_tail] <= in_branch_flag;
                        div_tail <= (div_tail + 1) % DIV_SIZE;
                    end
                default: // ADD 명령어
                    if (add_done && add_head == add_tail) begin
                        add_execute_on <= in_execute_on;
                        add_branch_flag <= in_branch_flag;
                        add_alu_opcode <= in_opcode;
                        add_alu_rs_add <= in_rs_add;
                        add_alu_rd_reg <= in_rd_reg;
                        add_alu_operand1 <= in_operand1;
                        add_alu_operand2 <= in_operand2;
                        add_alu_func3 <= in_func3;
                        add_alu_pc <= in_pc;
                        add_alu_label <= in_label;
                    end else begin
                        add_opcode_fifo[add_tail] <= in_opcode;
                        add_rs_add_fifo[add_tail] <= in_rs_add;
                        add_rd_reg_fifo[add_tail] <= in_rd_reg;
                        add_operand1_fifo[add_tail] <= in_operand1;
                        add_operand2_fifo[add_tail] <= in_operand2;
                        add_func3_fifo[add_tail] <= in_func3;
                        add_pc_fifo[add_tail] <= in_pc;
                        add_label_fifo[add_tail] <= in_label;
                        add_execute_on_fifo[add_tail] <= in_execute_on;
                        add_branch_flag_fifo[add_tail] <= in_branch_flag;
                        add_tail <= (add_tail + 1) % ADD_SIZE;
                    end
            endcase
        end

        // FIFO에서 데이터 전송 로직
        if (add_done && (add_head != add_tail)) begin
            add_execute_on <= add_execute_on_fifo[add_head];
            add_branch_flag <= add_branch_flag_fifo[add_head];
            add_alu_opcode <= add_opcode_fifo[add_head];
            add_alu_rs_add <= add_rs_add_fifo[add_head];
            add_alu_rd_reg <= add_rd_reg_fifo[add_head];
            add_alu_operand1 <= add_operand1_fifo[add_head];
            add_alu_operand2 <= add_operand2_fifo[add_head];
            add_alu_func3 <= add_func3_fifo[add_head];
            add_alu_pc <= add_pc_fifo[add_head];
            add_alu_label <= add_label_fifo[add_head];
            add_head <= (add_head + 1) % ADD_SIZE;
        end
        if (mul_done && (mul_head != mul_tail)) begin
            mul_execute_on <= mul_execute_on_fifo[mul_head];
            mul_branch_flag <= mul_branch_flag_fifo[mul_head];
            mul_alu_opcode <= mul_opcode_fifo[mul_head];
            mul_alu_rs_add <= mul_rs_add_fifo[mul_head];
            mul_alu_rd_reg <= mul_rd_reg_fifo[mul_head];
            mul_alu_operand1 <= mul_operand1_fifo[mul_head];
            mul_alu_operand2 <= mul_operand2_fifo[mul_head];
            mul_alu_func3 <= mul_func3_fifo[mul_head];
            mul_alu_pc <= mul_pc_fifo[mul_head];
            mul_alu_label <= mul_label_fifo[mul_head];
            mul_head <= (mul_head + 1) % MUL_SIZE;
        end
        if (div_done && (div_head != div_tail)) begin
            div_execute_on <= div_execute_on_fifo[div_head];
            div_branch_flag <= div_branch_flag_fifo[div_head];
            div_alu_opcode <= div_opcode_fifo[div_head];
            div_alu_rs_add <= div_rs_add_fifo[div_head];
            div_alu_rd_reg <= div_rd_reg_fifo[div_head];
            div_alu_operand1 <= div_operand1_fifo[div_head];
            div_alu_operand2 <= div_operand2_fifo[div_head];
            div_alu_func3 <= div_func3_fifo[div_head];
            div_alu_pc <= div_pc_fifo[div_head];
            div_alu_label <= div_label_fifo[div_head];
            div_head <= (div_head + 1) % DIV_SIZE;
        end
    end
end

endmodule
