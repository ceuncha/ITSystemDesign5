module RAT (
    input wire clk,
    input wire reset,

    input wire save_state,    // 사본 레지스터에 상태 저장 신호
    input wire restore_state, // 사본 레지스터에서 상태 복원 신호
    input wire [2:0] save_page,     // 상태 저장용 사본 레지스터 페이지 선택 신호
    input wire [2:0] restore_page,  // 상태 복원 신호
    input wire [4:0] logical_addr1, // 오퍼랜드 1 논리 주소
    input wire [4:0] logical_addr2, // 오퍼랜드 2 논리 주소
    input wire [4:0] rd_logical_addr, // 쓰기 작업을 하는 논리 주소 (Rd)
    input wire [7:0] free_phy_addr,   // 프리리스트로부터 받은 비어있는 물리 주소
    input wire [7:0] wb_phy_addr,     // WB 단계에서의 물리 주소
    input wire [4:0] wb_logical_addr, // WB 단계에서의 논리 주소
    input wire [6:0] opcode,

    output reg [7:0] phy_addr_out1,   // 오퍼랜드 1 물리 주소 출력
    output reg [7:0] phy_addr_out2,   // 오퍼랜드 2 물리 주소 출력
    output reg [7:0] rd_phy_out,
    output reg [4:0] rd_log_out,

    output reg [7:0] free_phy_addr_out // 프리리스트로 비어있는 주소 전송
);

    // 내부 레지스터
    reg [7:0] phy_addr_table [0:31]; // 논리 주소에 대응하는 물리 주소 테이블

    // 사본 레지스터 배열 인스턴스
    wire [7:0] shadow_data_out [0:7][0:31];
    reg [7:0] shadow_data_in [0:7][0:31];
    reg shadow_write_enable [0:7];
    reg [4:0] shadow_addr;

    genvar i, j;
    generate
        for (i = 0; i < 8; i = i + 1) begin : shadow_RAT_reg_array
            for (j = 0; j < 32; j = j + 1) begin : shadow_RAT_regs
                shadow_RAT_register u_shadow_RAT_register (
                    .clk(clk),
                    .reset(reset),
                    .addr(j[4:0]),  // 정수형을 5비트로 강제 변환
                    .data_in(shadow_data_in[i][j]),
                    .data_out(shadow_data_out[i][j]),
                    .write_enable(shadow_write_enable[i])
                );
            end
        end
    endgenerate

    integer k;

    // 초기화
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (k = 0; k < 32; k = k + 1) begin
                phy_addr_table[k] <= k;
            end
        end
    end

    // 사본 레지스터에 상태 저장
    always @(posedge clk) begin
        if (save_state) begin
            for (k = 0; k < 32; k = k + 1) begin
                shadow_data_in[save_page][k] <= phy_addr_table[k];
            end
            shadow_write_enable[save_page] <= 1;
        end else begin
            shadow_write_enable[save_page] <= 0;
        end
    end

    // 사본 레지스터에서 상태 복원
    always @(posedge clk) begin
        if (restore_state) begin
            for (k = 0; k < 32; k = k + 1) begin
                phy_addr_table[k] <= shadow_data_out[restore_page][k];
            end
        end
    end

    // id_on이 1일 때 동작
    always @(posedge clk) begin
        if (!restore_state) begin
            // 1. 오퍼랜드 유효성 검사 및 물리 주소 접근
            case (opcode)
                7'b1100111, 7'b0000011, 7'b0010011: begin  // jalr, load, i-type
                    phy_addr_out1 <= phy_addr_table[logical_addr1];
                    phy_addr_out2 <= 8'd254;
                end
                7'b0110111, 7'b0010111, 7'b1101111: begin // lui, auipc, jal
                    phy_addr_out1 <= 8'd0;
                    phy_addr_out2 <= 8'd254;
                end
                default: begin
                    phy_addr_out1 <= phy_addr_table[logical_addr1];
                    phy_addr_out2 <= phy_addr_table[logical_addr2];
                end
            endcase

            // 2. Rd 레지스터 유효성 및 새로운 물리 주소 할당
            if ((opcode != 7'b1100011) && (opcode != 7'b0100011)) begin  // beq, store need no Rd
                free_phy_addr_out <= phy_addr_table[rd_logical_addr]; // 프리리스트로 비어있는 주소 전송 
                phy_addr_table[rd_logical_addr] <= free_phy_addr; // 새로운 물리 주소 할당
                rd_phy_out <= free_phy_addr;
                rd_log_out <= rd_logical_addr;
            end else begin
                free_phy_addr_out <= free_phy_addr; // 프리리스트로 비어있는 주소 다시 전송
                rd_phy_out <= 8'd255;   
            end
        end
    end

endmodule

module shadow_RAT_register(
    input wire clk,
    input wire reset,
    input wire [4:0] addr,    // 레지스터 주소 (0-31)
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire write_enable
);
    reg [7:0] registers [0:31];  // 32개의 8비트 레지스터
    integer l;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (l = 0; l < 32; l = l + 1) begin
                registers[l] <= 8'b0;
            end
        end else if (write_enable) begin
            registers[addr] <= data_in;
        end
    end

    always @(*) begin
        data_out = registers[addr];
    end
endmodule
