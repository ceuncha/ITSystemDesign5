module chuchu (
    input clk,
    input reset,
    input save_state,          // 상태 저장 신호
    input restore_state,       // 상태 복원 신호
    input [2:0] save_page,     // 상태 저장 페이지 선택 신호
    input [2:0] restore_page,  // 상태 복원 페이지 선택 신호
    input [7:0] rat_data,
    output reg [7:0] chuchu_out
);

    reg [7:0] chuchu_array [0:127];
    reg [6:0] current_index;
    integer i;

    // 사본 레지스터 배열 인스턴스
    wire [7:0] shadow_data_out [0:7][0:127];
    reg [7:0] shadow_data_in [0:7][0:127];
    reg shadow_write_enable [0:7];
    reg [6:0] shadow_addr;

    genvar j, k;
    generate
        for (j = 0; j < 8; j = j + 1) begin : shadow_chuchu_array
            shadow_chuchu u_shadow_chuchu (
                .clk(clk),
                .reset(reset),
                .addr(shadow_addr),
                .data_in(shadow_data_in[j][shadow_addr]),
                .data_out(shadow_data_out[j][shadow_addr]),
                .write_enable(shadow_write_enable[j])
            );
        end
    endgenerate

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 128; i = i + 1) begin
                chuchu_array[i] = 32 + i;
            end
            current_index = 0;
        end else begin
            if (save_state) begin
                for (i = 0; i < 128; i = i + 1) begin
                    shadow_data_in[save_page][i] <= chuchu_array[i];
                end
                shadow_write_enable[save_page] <= 1;
            end else if (restore_state) begin
                for (i = 0; i < 128; i = i + 1) begin
                    chuchu_array[i] <= shadow_data_out[restore_page][i];
                end
            end else begin
                chuchu_out <= chuchu_array[current_index];
                chuchu_array[current_index] <= rat_data;
                current_index <= (current_index + 1) % 128;
            end
        end
    end

endmodule

module shadow_chuchu(
    input wire clk,
    input wire reset,
    input wire [6:0] addr,    // 레지스터 주소 (0-127)
    input wire [7:0] data_in,
    output wire [7:8] data_out,
    input wire write_enable
);
    reg [7:0] registers [0:127];  // 128개의 8비트 레지스터

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                registers[i] <= 8'b0;
            end
        end else if (write_enable) begin
            registers[addr] <= data_in;
        end
    end

    assign data_out = registers[addr];
endmodule
