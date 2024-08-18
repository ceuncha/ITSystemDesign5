module chuchu (
    input clk,
    input reset,
    input exception,
    input mret,
    input save_state,        
    input restore_state,      
    input [2:0] save_page,     // 3-bit for 8 pages
    input [2:0] restore_page,  // 3-bit for 8 pages
    input [7:0] rat_data,
    output reg [7:0] chuchu_out
);

    reg [7:0] chuchu_array [0:127];
    reg [6:0] current_index;
    integer i;

    wire [7:0] shadow_data_out [0:7][0:127]; // Changed to 8 pages
    reg [7:0] shadow_data_in [0:7][0:127];   // Changed to 8 pages
    reg shadow_write_enable [0:7];           // Changed to 8 pages
    reg [6:0] shadow_addr;

    genvar j, k;
    generate
        for (j = 0; j < 8; j = j + 1) begin : shadow_chuchu_array // Loop now iterates for 8 pages
            for (k = 0; k < 128; k = k + 1) begin : shadow_chuchu_regs
                shadow_chuchu u_shadow_chuchu (
                    .reset(reset),
                    .addr(k[6:0]),  
                    .data_in(shadow_data_in[j][k]),
                    .data_out(shadow_data_out[j][k]),
                    .write_enable(shadow_write_enable[j])
                );
            end
        end
    endgenerate

    always @(posedge clk) begin   
        if (reset || exception || mret) begin
            for (i = 0; i < 128; i = i + 1) begin
                chuchu_array[i] <= 32 + i;
            end
            current_index <= 1;
            chuchu_out <= 32;
            chuchu_array[0] <=  8'b10100000;
        end else begin
            if (restore_state) begin
                for (i = 0; i < 128; i = i + 1) begin
                    chuchu_array[i] <= shadow_data_out[restore_page][i];
                end
                chuchu_out <= shadow_data_out[restore_page][current_index];
                chuchu_array[(current_index-2) % 128] <= rat_data;
                current_index <= (current_index + 1) % 128;
            end else begin
                shadow_write_enable[save_page] <= 0;
                if (save_state) begin
                    for (i = 0; i < 128; i = i + 1) begin
                        shadow_data_in[save_page][i] <= chuchu_array[i];
                    end
                    shadow_write_enable[save_page] <= 1;
                end
                chuchu_out <= chuchu_array[current_index];
                chuchu_array[(current_index-2) % 128] <= rat_data;
                current_index <= (current_index + 1) % 128;
            end
        end
    end
endmodule
