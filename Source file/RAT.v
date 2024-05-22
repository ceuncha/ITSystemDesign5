module RAT (
input wire id_on,
input wire reset,
input wire [4:0] logical_addr, // 논리 주소
input wire [7:0] phy_addr_in, // 물리 주소
input wire write_enable, // 쓰기 활성화 신호
input wire [4:0] logical_addr1, // 오퍼랜드 1 논리 주소
input wire [4:0] logical_addr2, // 오퍼랜드 2 논리 주소
input wire [4:0] rd_logical_addr, // 쓰기 작업을 하는 논리 주소 (Rd)
input wire [6:0] free_phy_addr, // 프리리스트로부터 받은 비어있는 물리 주소
input wire [6:0] wb_phy_addr, // WB 단계에서의 물리 주소
input wire [4:0] wb_logical_addr, // WB 단계에서의 논리 주소
input wire [6:0] opcode,

output reg [6:0] phy_addr_out1, // 오퍼랜드 1 물리 주소 출력
output reg [6:0] phy_addr_out2, // 오퍼랜드 2 물리 주소 출력
output reg [1:0] ready_out, // 레디 플래그 출력
output reg rat_done,

output reg [6:0] free_phy_addr_out



);


// 내부 레지스터
reg [7:0] phy_addr_table [0:31]; // 논리 주소에 대응하는 물리 주소 테이블
reg valid_table [0:31]; // 유효성 테이블
integer i;

// 초기화
always @(posedge id_on or posedge reset) begin
    if (reset) begin
        
        for (i = 0; i < 32; i = i + 1) begin
            phy_addr_table[i] <= 8'b0;
            valid_table[i] <= 1'b0;
        end

    end 
    else begin
        // 1. 오퍼랜드 유효성 검사 및 물리 주소 접근
        phy_addr_out1 <= phy_addr_table[logical_addr1];
        phy_addr_out2 <= phy_addr_table[logical_addr2];

        case (opcode)
        7'b1101111, 7'b0000011, 7'b0010011: begin
            ready_out[0] <= valid_table[logical_addr1];
            ready_out[1] <= 1;
        end
        7'b0110111, 7'b0010111, 7'b1100111: begin
            ready_out <= 2'b11;
        end
        default: begin
            ready_out[1] <= valid_table[logical_addr2];
            ready_out[0] <= valid_table[logical_addr1];
        end
        endcase
        
        // 2. Rd 레지스터 유효성 및 새로운 물리 주소 할당
        if((opcode != 7'b1100011) && (opcode != 7'b0100011)) begin
        valid_table[rd_logical_addr] <= 1'b0; // 유효성을 0으로 변경
        free_phy_addr_out <= phy_addr_table[rd_logical_addr]; //프리리스트로 비어있는 주소 전송 
        phy_addr_table[rd_logical_addr] <= free_phy_addr; // 새로운 물리 주소 할당
        
        end
        

end
end

always @(posedge write_enable) begin
            // 3. 유효성 업데이트 및 쓰기 동작 반영
            if (valid_table[wb_logical_addr] == 1'b0 && phy_addr_table[wb_logical_addr] == wb_phy_addr) begin
                valid_table[wb_logical_addr] <= 1'b1;
              end
end

endmodule
