module reservation_station (

    input wire rst,
    input wire rs_on,
    input wire clk,
    input wire stall,
    
    input wire mem_write,

    input wire alu_done_add,
    input wire [31:0] alu_result_add,
    input wire [6:0] alu_phy_reg_add,
    input wire [6:0] alu_rs_add_add,
    
    input wire alu_done_load,
    input wire [31:0] alu_result_load,
    input wire [6:0] alu_phy_reg_load,
    input wire [6:0] alu_rs_add_load,
    
    input wire alu_done_mul,
    input wire [31:0] alu_result_mul,
    input wire [6:0] alu_phy_reg_mul,
    input wire [6:0] alu_rs_add_mul,
    
    input wire alu_done_div,
    input wire [31:0] alu_result_div,
    input wire [6:0] alu_phy_reg_div,
    input wire [6:0] alu_rs_add_div,



    // 파이프라인 입력들
    input wire in_branch_flag,
    input wire [6:0] in_rd_phy,
    input wire [4:0] in_rd_reg,
    input wire in_done,
    input wire [1:0] in_ready,
    input wire [6:0] in_opcode,
    input wire [2:0] in_func3,
    input wire [9:0] in_control,
    input wire [31:0] in_operand1,
    input wire [31:0] in_operand2,
    input wire [6:0] in_phy_add1,
    input wire [6:0] in_phy_add2,
    input wire [9:0] in_pc,
    input wire [31:0] in_label,
    
    

    // 브랜치 유닛으로부터 수신
    input wire [6:0] branch_rs_add,
    input wire branch_in,

    // ALU로 보내는 출력들
    output reg [4:0] out_rs_add,
    output reg [6:0] out_rd_phy,
    output reg [4:0] out_rd_reg,
    output reg [31:0] out_operand1,
    output reg [31:0] out_operand2,

    output reg [6:0] out_opcode,
    output reg [2:0] out_func3,
    output reg [9:0] out_control,
    output reg [9:0] out_pc,
    output reg out_execute_on,

    // 브랜치 유닛으로 보내는 출력
    output reg [31:0] out_label,
    output reg out_branch_flag

);

parameter rs_size = 128;
parameter add_cycle = 3;
parameter load_cycle = 4;
parameter mul_cycle = 10;
parameter div_cycle = 20;

// 내부 레지스터
reg branch_flag [0:rs_size-1];
reg rd_ready [0:rs_size-1];
reg [31:0] rd_data [0:rs_size-1];
reg [6:0] rd_phy [0:rs_size-1];
reg [4:0] rd_reg [0:rs_size-1];
reg done [0:rs_size-1];
reg [1:0] ready [0:rs_size-1];
reg [6:0] opcode [0:rs_size-1];
reg [2:0] func3 [0:rs_size-1];
reg [9:0] control [0:rs_size-1];
reg [31:0] operand1 [0:rs_size-1];
reg [31:0] operand2 [0:rs_size-1];
reg [6:0] phy_add1 [0:rs_size-1];
reg [6:0] phy_add2 [0:rs_size-1];
reg [9:0] pc [0:rs_size-1];
reg [31:0] label [0:rs_size-1];
reg [9:0] head, tail;
reg loop_done;


integer i,x,y,z,w;

// 메인 프로세스
always @(posedge rs_on or posedge rst) begin
    if (rst) begin
        // 모든 RS 항목을 리셋합니다.
        for (i = 0; i < rs_size; i = i + 1) begin
            branch_flag[i] <= 0; 
            rd_ready[i] <= 0;    // 초기값 0
            rd_data[i] <= 32'b0; // 초기값 0
            rd_phy[i] <= 0;
            rd_reg[i] <= 0;
            done[i] <= 0;
            ready[i][1:0] <= 0;
            opcode[i] <= 0;
            func3[i] <= 0;
            control[i] <= 0;
            operand1[i] <= 0;
            operand2[i] <= 0;
            phy_add1[i] <= 0;
            phy_add2[i] <= 0;
            pc[i] <= 0;
            label[i] <= 0;
         end
;       head <= 0;
        tail <=0;
        end
        
        
   else begin
        // 브랜치가 바뀌면 tail을 업데이트합니다.
        
        out_execute_on <= 1'b0; // 0이 출력되면 stall이라는 뜻
        loop_done <= 0;
        if (in_branch_flag != branch_flag[branch_rs_add]) begin
            tail <= (branch_rs_add + 1) % rs_size;
        end
        
               
        // 여러 ALU로부터의 업데이트를 처리합니다.
        if (alu_done_add) begin  // 유효한 결과를 확인합니다. alu done add  는 파이프라인에서 한사이클마다 0으로 업데이트 해줘야함,
            x = alu_rs_add_add;
            rd_data[x] <= alu_result_add;  // Rd_result 업데이트
            rd_ready[x] <= 1'b1;

            for (i = (x+1) % rs_size; i != (x+add_cycle) % rs_size; i = (i + 1) % rs_size) begin
                if (alu_phy_reg_add == phy_add1[i]) begin
                    operand1[i] <= alu_result_add;
                    ready[i][0] <= 1'b1;
                end
                if (alu_phy_reg_add == phy_add2[i]) begin
                    operand2[i] <= alu_result_add;
                    ready[i][1] <= 1'b1;
                end
            end
        end

        if (alu_done_load) begin  // 유효한 결과를 확인합니다.
            y = alu_rs_add_load;
            rd_data[y] <= alu_result_load;  // Rd_result 업데이트
            rd_ready[y] <= 1'b1;

            for (i = (y+1) % rs_size; i != (y + load_cycle) % rs_size; i = (i + 1) % rs_size) begin
                if (alu_phy_reg_load == phy_add1[i]) begin
                    operand1[i] <= alu_result_load;
                    ready[i][0] <= 1'b1;
                end
                if (alu_phy_reg_load == phy_add2[i]) begin
                    operand2[i] <= alu_result_load;
                    ready[i][1] <= 1'b1;
                end
            end
        end
        
        if (alu_done_mul) begin  // 유효한 결과를 확인합니다.
            z = alu_rs_add_mul;
            rd_data[z] <= alu_result_mul;  // Rd_result 업데이트
            rd_ready[z] <= 1'b1;

            for (i = (z+1) % rs_size; i != (z + mul_cycle) % rs_size; i = (i + 1) % rs_size) begin
                if (alu_phy_reg_mul == phy_add1[i]) begin
                    operand1[i] <= alu_result_mul;
                    ready[i][0] <= 1'b1;
                end
                if (alu_phy_reg_mul == phy_add2[i]) begin
                    operand2[i] <= alu_result_mul;
                    ready[i][1] <= 1'b1;
                end
            end
        end
        
        if (alu_done_div) begin  // 유효한 결과를 확인합니다.
            w = alu_rs_add_div;
            rd_data[w] <= alu_result_div;  // Rd_result 업데이트
            rd_ready[w] <= 1'b1;

            for (i = (w+1) % rs_size; i != (w + div_cycle) % rs_size; i = (i + 1) % rs_size) begin
                if (alu_phy_reg_div == phy_add1[i]) begin
                    operand1[i] <= alu_result_div;
                    ready[i][0] <= 1'b1;
                end
                if (alu_phy_reg_div == phy_add2[i]) begin
                    operand2[i] <= alu_result_div;
                    ready[i][1] <= 1'b1;
                end
            end
        end
    end
end

always @(negedge clk) begin
        // 들어오는 명령어를 위해 tail에 새로운 주소를 할당합니다.
        branch_flag[tail] <= branch_in; 
        rd_ready[tail] <= 1'b0;    // 초기값 0
        rd_data[tail] <= 32'b0;    // 초기값 0
        rd_phy[tail] <= in_rd_phy;
        rd_reg[tail] <= in_rd_reg;
        done[tail] <= in_done;
        ready[tail] <= in_ready;
        opcode[tail] <= in_opcode;
        func3[tail] <= in_func3;
        control[tail] <= in_control;
        operand1[tail] <= in_operand1;
        operand2[tail] <= in_operand2;
        phy_add1[tail] <= in_phy_add1;
        phy_add2[tail] <= in_phy_add2;
        pc[tail] <= in_pc;
        label[tail] <= in_label;

        // 할당된 주소의 operand를 업데이트 해줍니다.
        // 할당된 주소의 operand를 업데이트 해줍니다.
        for (i = head; i != tail; i = (i + 1) % rs_size) begin
            if(rd_ready[i]) begin
                if ( in_phy_add1== rd_phy[i]) begin
                    operand1[tail] <= rd_data[i];
                    ready[tail][0] <= 1'b1;
                end
                if (in_phy_add2 == rd_phy[i]) begin
                    operand2[tail] <= rd_data[i];
                    ready[tail][1] <= 1'b1;
                end
            end
        end

        // ALU로 명령어 내보내기, done != 1, ready bit 준비된 것 중
        // 먼저 들어온 순으로 명령어를 ALU로 보냅니다.


        // 업데이트된 명령어는 rs에서 제거합니다.
        if (mem_write) begin            
            head <= (head + 1) % rs_size;
        end
        if (!stall) begin
        tail <= (tail + 1) % rs_size;  // 순환 버퍼 처리를 합니다.
        end
    end

always @(*) begin
    for (i = head; i != tail; i = (i + 1) % rs_size) begin 
        if (!loop_done) begin
            if (!done[i] && ready[i][0] == 1'b1 && ready[i][1] == 1'b1) begin
                done[i] <= 1'b1;
                out_execute_on <= 1'b1;
                out_rs_add <= i;
                out_branch_flag <= branch_flag[i];
                out_rd_phy <= rd_phy[i];
                out_rd_reg <= rd_reg[i];
                out_operand1 <= operand1[i];
                out_operand2 <= operand2[i];
                out_opcode <= opcode[i];
                out_func3 <= func3[i];
                out_control <= control[i];
                out_pc <= pc[i];
                loop_done <= 1;
            end // 첫 번째 준비된 명령어만 ALU로 보냅니다.
        end
    end
end

endmodule
