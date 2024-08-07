module RAT (
    input wire clk,
    input wire reset,

    input wire save_state,    
    input wire restore_state, 
    input wire [4:0] save_page,     // 5-bit for 32 pages
    input wire [4:0] restore_page,  // 5-bit for 32 pages
    input wire [4:0] logical_addr1, 
    input wire [4:0] logical_addr2, 
    input wire [4:0] rd_logical_addr, 
    input wire [7:0] free_phy_addr,  
    input wire if_id_flush, 
    input wire [31:0] instnum,


    input wire [6:0] opcode,
    
    input wire exception_sig,
    input wire mret_sig,

    output reg [7:0] phy_addr_out1,   
    output reg [7:0] phy_addr_out2,   
    output reg [7:0] rd_phy_out,
    output reg [7:0] free_phy_addr_out, 
    output reg no_reg_write


);

    reg [7:0] phy_addr_table [0:31]; 
    reg [31:0] instnums [0:31];
    wire [7:0] shadow_data_out [0:31][0:31];
    reg [7:0] shadow_data_in [0:31][0:31];
    reg [31:0] shadow_inst_in [0:31][0:31];
    wire [31:0] shadow_inst_out [0:31][0:31];
    reg shadow_write_enable [0:31];
    reg [4:0] shadow_addr;

    genvar i, j;
    generate                                                               
        for (i = 0; i < 32; i = i + 1) begin : shadow_RAT_reg_array
            for (j = 0; j < 32; j = j + 1) begin : shadow_RAT_regs
                shadow_RAT_register u_shadow_RAT_register (
                    .reset(reset),
                    .addr(j[4:0]),  
                    .data_in(shadow_data_in[i][j]),
                    .data_out(shadow_data_out[i][j]),
                    .write_enable(shadow_write_enable[i])
                    .inst_num_in(shadow_inst_in[i][j]),
                    .inst_num_out(shadow_inst_out[i][j])
                );
            end
        end
    endgenerate

    integer k;

    always @(posedge clk) begin     
        if (reset|exception_sig|mret_sig) begin
            for (k = 0; k < 32; k = k + 1) begin
                phy_addr_table[k] <= k;
                instnums[k] <= 0;
            end
            free_phy_addr_out <= 159; 
            rd_phy_out <= 8'b11111111; 
            phy_addr_out1 <= 8'b11111110;
            phy_addr_out2 <= 8'b11111110;
            no_reg_write <= 1'b1;
        end else begin
            inst_num_out <= instnums[rd_logical_addr];
            no_reg_write <= 1'b0;
            if (restore_state) begin
                for (k = 0; k < 32; k = k + 1) begin
                    phy_addr_table[k] <= shadow_data_out[restore_page][k];
                    instnums[k] <= shadow_inst_out[restore_page][k];
                end
                if (opcode == 7'b1100111 || opcode == 7'b0000011 || opcode == 7'b0010011) begin
                    phy_addr_out1 <= shadow_data_out[restore_page][logical_addr1];
                    phy_addr_out2 <= 8'b11111110;
                    instnums[logical_addr1] <= instnum;
                        if((rd_logical_addr==logical_addr1)) begin
                            inst_num_out <= instnum;
                        end

                end else if (opcode == 7'b0110111 || opcode == 7'b0010111 || opcode == 7'b1101111) begin
                    phy_addr_out1 <= 8'b11111110;
                    phy_addr_out2 <= 8'b11111110;
                end else begin
                    phy_addr_out1 <= shadow_data_out[restore_page][logical_addr1];
                    phy_addr_out2 <= shadow_data_out[restore_page][logical_addr2];
                    instnums[logical_addr1] <= instnum;
                    instnums[logical_addr2] <= instnum;
                        if((rd_logical_addr==logical_addr1)&&(rd_logical_addr==logical_addr2)) begin
                            inst_num_out <= instnum;
                        end
                end

                if ((opcode != 7'b1100011) && (opcode != 7'b0100011) && (opcode != 7'b0000000) && (rd_logical_addr != 0)) begin
                    free_phy_addr_out <= phy_addr_table[rd_logical_addr];
                    phy_addr_table[rd_logical_addr] <= free_phy_addr;
                    rd_phy_out <= free_phy_addr;
                    instnums[rd_logical_addr] <= instnum;
                end else begin
                    free_phy_addr_out <= free_phy_addr;
                    rd_phy_out <= 8'b11111111;
                    no_reg_write <= 1'b1;
                end
            end else begin
                if (if_id_flush) begin
                    free_phy_addr_out <= free_phy_addr;
                    no_reg_write <= 1'b1;
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
                        instnums[logical_addr1] <= instnum;
                        if((rd_logical_addr==logical_addr1)) begin
                            inst_num_out <= instnum;
                        end
                    end else if (opcode == 7'b0110111 || opcode == 7'b0010111 || opcode == 7'b1101111) begin
                        phy_addr_out1 <= 8'b11111110;
                        phy_addr_out2 <= 8'b11111110;
                    end else begin
                        phy_addr_out1 <= phy_addr_table[logical_addr1];
                        phy_addr_out2 <= phy_addr_table[logical_addr2];
                        instnums[logical_addr1] <= instnum;
                        instnums[logical_addr2] <= instnum;
                        if((rd_logical_addr==logical_addr1)&&(rd_logical_addr==logical_addr2)) begin
                            inst_num_out <= instnum;
                        end
                    end

                    if ((opcode != 7'b1100011) && (opcode != 7'b0100011) && (opcode != 7'b0000000) && (rd_logical_addr != 0)) begin
                        free_phy_addr_out <= phy_addr_table[rd_logical_addr];
                        phy_addr_table[rd_logical_addr] <= free_phy_addr;
                        rd_phy_out <= free_phy_addr;
                        instnums[rd_logical_addr] <= instnum;
                        
                    end else begin
                        free_phy_addr_out <= free_phy_addr;
                        rd_phy_out <= 8'b11111111;
                        no_reg_write <= 1'b1;
                    end
                end
            end
        end
    end
endmodule

module shadow_RAT_register(
    input wire reset,
    input wire [4:0] addr,    
    input wire [7:0] data_in,
    input wire [31:0] inst_num_in,
    output reg [7:0] data_out,
    output reg [31:0] inst_num_out,
    input wire write_enable
);
    reg [7:0] registers [0:31];  
    integer l;

    always @(posedge write_enable) begin
        registers[addr] <= data_in;
        instnum_reg[addr] <= inst_num_in;
    end

    always @(*) begin
        data_out = registers[addr];
        inst_num_out = instnum_reg[addr];
    end
endmodule
