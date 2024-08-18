module RAT (
    input wire clk,
    input wire reset,

    input wire save_state,    
    input wire restore_state, 
    input wire [4:0] save_page,     // 3-bit for 8 pages
    input wire [4:0] restore_page,  // 3-bit for 8 pages
    input wire [4:0] logical_addr1, 
    input wire [4:0] logical_addr2, 
    input wire [4:0] rd_logical_addr, 
    input wire [7:0] free_phy_addr,  
    input wire if_id_flush, 

    input wire [6:0] opcode,
    
    input wire exception_sig,
    input wire mret_sig,

    output reg [7:0] phy_addr_out1,   
    output reg [7:0] phy_addr_out2,   
    output reg [7:0] rd_phy_out,
    output reg [7:0] free_phy_addr_out 
);

    (* keep = "true" *) reg [7:0] phy_addr_table [0:31]; 

    (* keep = "true" *)  wire [7:0] shadow_data_out [0:7][0:31]; // Changed to 8 pages
    (* keep = "true" *) reg [7:0] shadow_data_in [0:7][0:31];    // Changed to 8 pages
    (* keep = "true" *) reg shadow_write_enable [0:7];           // Changed to 8 pages
    (* keep = "true" *) reg [4:0] shadow_addr;

    (* keep = "true" *) genvar i, j;
    generate                                                               
        for (i = 0; i < 8; i = i + 1) begin : shadow_RAT_reg_array // Loop now iterates for 8 pages
            for (j = 0; j < 32; j = j + 1) begin : shadow_RAT_regs
                shadow_RAT_register u_shadow_RAT_register (
                    .reset(reset),
                    .addr(j[4:0]),  
                    .data_in(shadow_data_in[i][j]),
                    .data_out(shadow_data_out[i][j]),
                    .write_enable(shadow_write_enable[i])
                );
            end
        end
    endgenerate

    integer k;

    always @(posedge clk) begin     
        if (reset | exception_sig | mret_sig) begin
            for (k = 0; k < 32; k = k + 1) begin
                phy_addr_table[k] <= k;
            end
            free_phy_addr_out <= 8'b10100001; 
            rd_phy_out <= 8'b11111111; 
            phy_addr_out1 <= 8'b11111110;
            phy_addr_out2 <= 8'b11111110;
        end else begin
            if (restore_state) begin
                for (k = 0; k < 32; k = k + 1) begin
                    phy_addr_table[k] <= shadow_data_out[restore_page][k];
                end
                if (opcode == 7'b1100111 || opcode == 7'b0000011 || opcode == 7'b0010011) begin
                    phy_addr_out1 <= shadow_data_out[restore_page][logical_addr1];
                    phy_addr_out2 <= 8'b11111110;
                end else if (opcode == 7'b0110111 || opcode == 7'b0010111 || opcode == 7'b1101111) begin
                    phy_addr_out1 <= 8'b11111110;
                    phy_addr_out2 <= 8'b11111110;
                end else begin
                    phy_addr_out1 <= shadow_data_out[restore_page][logical_addr1];
                    phy_addr_out2 <= shadow_data_out[restore_page][logical_addr2];
                end

                if ((opcode != 7'b1100011) && (opcode != 7'b0100011) && (opcode != 7'b0000000) && (rd_logical_addr != 0)) begin
                    free_phy_addr_out <= phy_addr_table[rd_logical_addr];
                    phy_addr_table[rd_logical_addr] <= free_phy_addr;
                    rd_phy_out <= free_phy_addr;
                end else begin
                    free_phy_addr_out <= free_phy_addr;
                    rd_phy_out <= 8'b11111111;
                end
            end else begin
                if (if_id_flush) begin
                    free_phy_addr_out <= free_phy_addr;
                end else begin
                    shadow_write_enable[save_page] <= 0;
                    if (save_state) begin
                        for (k = 0; k < 32; k = k + 1) begin
                            shadow_data_in[save_page][k] <= phy_addr_table[k];
                        end
                        shadow_write_enable[save_page] <= 1;
                    end

                    if (opcode == 7'b1100111 || opcode == 7'b0000011 || opcode == 7'b0010011 || opcode == 7'b1110011) begin
                        phy_addr_out1 <= phy_addr_table[logical_addr1];
                        phy_addr_out2 <= 8'b11111110;
                    end else if (opcode == 7'b0110111 || opcode == 7'b0010111 || opcode == 7'b1101111) begin
                        phy_addr_out1 <= 8'b11111110;
                        phy_addr_out2 <= 8'b11111110;
                    end else begin
                        phy_addr_out1 <= phy_addr_table[logical_addr1];
                        phy_addr_out2 <= phy_addr_table[logical_addr2];
                    end

                    if ((opcode != 7'b1100011) && (opcode != 7'b0100011) && (opcode != 7'b0000000) && (rd_logical_addr != 0)) begin
                        free_phy_addr_out <= phy_addr_table[rd_logical_addr];
                        phy_addr_table[rd_logical_addr] <= free_phy_addr;
                        rd_phy_out <= free_phy_addr;
                    end else begin
                        free_phy_addr_out <= free_phy_addr;
                        rd_phy_out <= 8'b11111111;
                    end
                end
            end
        end
    end
endmodule
