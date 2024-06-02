module RAT (
    input wire clk,
    input wire reset,

    input wire save_state,    // �궗蹂� �젅吏��뒪�꽣�뿉 �긽�깭 ���옣 �떊�샇
    input wire restore_state, // �궗蹂� �젅吏��뒪�꽣�뿉�꽌 �긽�깭 蹂듭썝 �떊�샇
    input wire [2:0] save_page,     // �긽�깭 ���옣�슜 �궗蹂� �젅吏��뒪�꽣 �럹�씠吏� �꽑�깮 �떊�샇
    input wire [2:0] restore_page,  // �긽�깭 蹂듭썝 �떊�샇
    input wire [4:0] logical_addr1, // �삤�띁�옖�뱶 1 �끉由� 二쇱냼
    input wire [4:0] logical_addr2, // �삤�띁�옖�뱶 2 �끉由� 二쇱냼
    input wire [4:0] rd_logical_addr, // �벐湲� �옉�뾽�쓣 �븯�뒗 �끉由� 二쇱냼 (Rd)
    input wire [7:0] free_phy_addr,   // �봽由щ━�뒪�듃濡쒕��꽣 諛쏆� 鍮꾩뼱�엳�뒗 臾쇰━ 二쇱냼

    input wire [6:0] opcode,

    output reg [7:0] phy_addr_out1,   // �삤�띁�옖�뱶 1 臾쇰━ 二쇱냼 異쒕젰
    output reg [7:0] phy_addr_out2,   // �삤�띁�옖�뱶 2 臾쇰━ 二쇱냼 異쒕젰
    output reg [7:0] rd_phy_out,


    output reg [7:0] free_phy_addr_out // �봽由щ━�뒪�듃濡� 鍮꾩뼱�엳�뒗 二쇱냼 �쟾�넚
);

    // �궡遺� �젅吏��뒪�꽣
    reg [7:0] phy_addr_table [0:31]; // �끉由� 二쇱냼�뿉 ���쓳�븯�뒗 臾쇰━ 二쇱냼 �뀒�씠釉�

    // �궗蹂� �젅吏��뒪�꽣 諛곗뿴 �씤�뒪�꽩�뒪
    wire [7:0] shadow_data_out [0:7][0:31];
    reg [7:0] shadow_data_in [0:7][0:31];
    reg shadow_write_enable [0:7];
    reg [4:0] shadow_addr;

    genvar i, j;
    generate
        for (i = 0; i < 8; i = i + 1) begin : shadow_RAT_reg_array
            for (j = 0; j < 32; j = j + 1) begin : shadow_RAT_regs
                shadow_RAT_register u_shadow_RAT_register (
    
                    .reset(reset),
                    .addr(j[4:0]),  // �젙�닔�삎�쓣 5鍮꾪듃濡� 媛뺤젣 蹂��솚
                    .data_in(shadow_data_in[i][j]),
                    .data_out(shadow_data_out[i][j]),
                    .write_enable(shadow_write_enable[i])
                );
            end
        end
    endgenerate

    integer k;

    // 珥덇린�솕
    always @(posedge reset) begin
        if (reset) begin
            for (k = 0; k < 32; k = k + 1) begin
                phy_addr_table[k] <= k;
            end
            free_phy_addr_out <= 8'b10100000; // 珥덇린 二쇱냼 �쟾�넚 // 160踰덉�吏�
        end
    end

    // �궗蹂� �젅吏��뒪�꽣�뿉 �긽�깭 ���옣
    always @(posedge save_state) begin

            for (k = 0; k < 32; k = k + 1) begin
                shadow_data_in[save_page][k] <= phy_addr_table[k];
            end
            shadow_write_enable[save_page] <= 1;


    end
    
        always @(negedge save_state) begin

            shadow_write_enable[save_page] <= 0;
      

    end
    
        always @(posedge restore_state) begin

            for (k = 0; k < 32; k = k + 1) begin
                phy_addr_table[k] <= shadow_data_out[restore_page][k];
            end

    end


    // id_on�씠 1�씪 �븣 �룞�옉
    always @(posedge clk) begin
  
            // 1. �삤�띁�옖�뱶 �쑀�슚�꽦 寃��궗 諛� 臾쇰━ 二쇱냼 �젒洹�
            case (opcode)
                7'b1100111, 7'b0000011, 7'b0010011: begin  // jalr, load, i-type
                    phy_addr_out1 <= phy_addr_table[logical_addr1];
                    phy_addr_out2 <= 8'b11111110;
                end
                7'b0110111, 7'b0010111, 7'b1101111: begin // lui, auipc, jal
                    phy_addr_out1 <= 8'b11111110;
                    phy_addr_out2 <= 8'b11111110;
                end
                default: begin
                    phy_addr_out1 <= phy_addr_table[logical_addr1];
                    phy_addr_out2 <= phy_addr_table[logical_addr2];
                end
            endcase

            // 2. Rd �젅吏��뒪�꽣 �쑀�슚�꽦 諛� �깉濡쒖슫 臾쇰━ 二쇱냼 �븷�떦
            if ((opcode != 7'b1100011) && (opcode != 7'b0100011)) begin  // beq, store need no Rd
                free_phy_addr_out <= phy_addr_table[rd_logical_addr]; // �봽由щ━�뒪�듃濡� 鍮꾩뼱�엳�뒗 二쇱냼 �쟾�넚 
                phy_addr_table[rd_logical_addr] <= free_phy_addr; // �깉濡쒖슫 臾쇰━ 二쇱냼 �븷�떦
                rd_phy_out <= free_phy_addr;
   
            end else begin
                free_phy_addr_out <= free_phy_addr; // �봽由щ━�뒪�듃濡� 鍮꾩뼱�엳�뒗 二쇱냼 �떎�떆 �쟾�넚
                rd_phy_out <= 8'b11111111;   
            end
        end


endmodule

module shadow_RAT_register(

    input wire reset,
    input wire [4:0] addr,    // �젅吏��뒪�꽣 二쇱냼 (0-31)
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire write_enable
);
    reg [7:0] registers [0:31];  // 32媛쒖쓽 8鍮꾪듃 �젅吏��뒪�꽣
    integer l;
    
    always @(posedge reset) begin
        if (reset) begin
            for (l = 0; l < 32; l = l + 1) begin
                registers[l] <= 8'b0;
            end

    end
end

    always @(posedge write_enable) begin
        registers[addr] <= data_in;
    end

    always @(*) begin
        data_out = registers[addr];

    end
endmodule
