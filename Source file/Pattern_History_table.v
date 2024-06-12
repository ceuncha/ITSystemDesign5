module pattern_history_table (
    input wire clk,
    input wire reset,
    input wire ID_EX_Branch,
    input wire Pcsrc,
    input wire [3:0] gbh, // 4-bit gbh
    output reg taken
);

// 2-bit branch history table with 16 entries + 1-bit valid bit
(* keep = "true" *)reg [2:0] bht [0:15]; // [2] is the valid bit, [1:0] is the history

// Write operation
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        bht[0] <= 3'b001;
        bht[1] <= 3'b001;
        bht[2] <= 3'b001;
        bht[3] <= 3'b001;
        bht[4] <= 3'b001;
        bht[5] <= 3'b001;
        bht[6] <= 3'b001;
        bht[7] <= 3'b001;
        bht[8] <= 3'b001;
        bht[9] <= 3'b001;
        bht[10] <= 3'b001;
        bht[11] <= 3'b001;
        bht[12] <= 3'b001;
        bht[13] <= 3'b001;
        bht[14] <= 3'b001;
        bht[15] <= 3'b001;
        taken <=0;
    end else if (ID_EX_Branch) begin
        bht[gbh][2] <= 1'b1; // ID_EX_Branch�� 1�̸� valid bit�� 1�� ����
        if (Pcsrc) begin
            // Taken branch, increment state if not in strongly taken
            if (bht[gbh][1:0] != 2'b11) begin
                bht[gbh][1:0] <= bht[gbh][1:0] + 1;
            end
        end else begin
            // Not taken branch, decrement state if not in strongly not taken
            if (bht[gbh][1:0] != 2'b00) begin
                bht[gbh][1:0] <= bht[gbh][1:0] - 1;
            end
        end
    end
end

// Read operation
always @(*) begin
    // Predict taken if in state 10 or 11, otherwise predict not taken
    if (bht[gbh][2] == 1'b1) begin
        case (bht[gbh][1:0])
            2'b00, 2'b01: taken = 1'b0; // Not taken
            2'b10, 2'b11: taken = 1'b1; // Taken
        endcase
    end else begin
        taken = 1'b0; // Valid bit�� 0�̸� �⺻������ not taken ����
    end
end

endmodule
