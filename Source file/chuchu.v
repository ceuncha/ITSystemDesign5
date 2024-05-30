module chuchu (
    input clk,
    input reset,
    input [6:0] rat_data,
    output reg [6:0] chuchu_out
);
    reg [6:0] chuchu_array [0:95];
    reg [6:0] current_index;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 96; i = i + 1) begin
                chuchu_array[i] = 32 + i;
            end
            current_index = 0;
        end else begin
            chuchu_out <= chuchu_array[current_index];
            chuchu_array[current_index] <= rat_data;
            current_index <= (current_index + 1) % 96;
        end
    end
endmodule
