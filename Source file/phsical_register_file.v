module physical_register_file (
    input clk,
    input reset,
    input [7:0] Operand1_phy,
    input [7:0] Operand2_phy,
    input [7:0] Rd_phy, 

    input ALU_add_Write,
    input ALU_load_Write,
    input ALU_mul_Write,
    input ALU_div_Write,
    input ALU_done_Write,
    input [31:0] ALU_add_Data,
    input [31:0] ALU_load_Data,
    input [31:0] ALU_mul_Data,
    input [31:0] ALU_div_Data,
    input [31:0] ALU_done_Data,
    input [7:0] ALU_add_phy,
    input [7:0] ALU_load_phy,
    input [7:0] ALU_mul_phy,
    input [7:0] ALU_div_phy,
    input [7:0] ALU_done_phy,

    output reg [31:0] Operand1_data,
    output reg [31:0] Operand2_data,
    output reg valid1,
    output reg valid2
);


   (* keep = "true" *) reg [31:0] registers [0:255];
   (* keep = "true" *) reg valid [0:255];
   (* keep = "true" *) integer i;




always @(posedge clk) begin         // 留? ?겢?씫 怨꾩궛湲곕뱾 ?샊?? load濡쒕??꽣 ?뜲?씠?꽣媛믪쓣 諛쏅뒗?떎. ?쟾?넚?삩 ?뜲?씠?꽣媛? ?엳?떎硫?, ?빐?떦 ?뜲?씠?꽣瑜? ?뾽?뜲?씠?듃 ?떆耳쒖??떎.
                                       // F0?쓽 寃쎌슦 ?빆?긽 0?쓣 ?쑀吏??빐?빞 ?븯誘?濡? ?빐?떦 臾쇰━二쇱냼?뒗 ?뾽?뜲?씠?듃 ?빐二쇱? ?븡?뒗?떎,

   if (reset) begin
       for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= i;
            valid[i] <= 1'b1; 
        end
       for (i = 32; i < 256; i = i + 1) begin
            registers[i] <= 32'h00000000;
           valid[i] <= 1'b1; 
        end
    end else begin
    
        if (ALU_add_Write == 1'b1 && ALU_add_phy != 7'b0) begin
            registers[ALU_add_phy] <= ALU_add_Data;
            valid[ALU_add_phy] <= 1'b1; // alu ?떊?샇媛? ?뱾?뼱?솕?쓣?븣 ?빐?떦 臾쇰━二쇱냼?? ?뜲?씠?꽣媛믪쓣 諛쏆븘?꽌 pfile?쓣 ?뾽?뜲?씠?듃 ?떆耳쒖??떎.
        end
        if (ALU_load_Write == 1'b1 && ALU_load_phy != 7'b0) begin
            registers[ALU_load_phy] <= ALU_load_Data;
            valid[ALU_load_phy] <= 1'b1; // load ?떊?샇媛? ?뱾?뼱?솕?쓣?븣 ?빐?떦 臾쇰━二쇱냼?? ?뜲?씠?꽣媛믪쓣 諛쏆븘?꽌 pfile?쓣 ?뾽?뜲?씠?듃 ?떆耳쒖??떎.
        end
        if (ALU_mul_Write == 1'b1 && ALU_mul_phy != 7'b0) begin
            registers[ALU_mul_phy] <= ALU_mul_Data;
            valid[ALU_mul_phy] <= 1'b1; // multiplier ?떊?샇媛? ?뱾?뼱?솕?쓣?븣 ?빐?떦 臾쇰━二쇱냼?? ?뜲?씠?꽣媛믪쓣 諛쏆븘?꽌 pfile?쓣 ?뾽?뜲?씠?듃 ?떆耳쒖??떎.
        end
        if (ALU_div_Write == 1'b1 && ALU_div_phy != 7'b0) begin
            registers[ALU_div_phy] <= ALU_div_Data;
            valid[ALU_div_phy] <= 1'b1; // divider ?떊?샇媛? ?뱾?뼱?솕?쓣?븣 ?빐?떦 臾쇰━二쇱냼?? ?뜲?씠?꽣媛믪쓣 諛쏆븘?꽌 pfile?쓣 ?뾽?뜲?씠?듃 ?떆耳쒖??떎.
        end
        if (ALU_done_Write == 1'b1 && ALU_done_phy != 7'b0) begin
            registers[ALU_done_phy] <= ALU_done_Data;
            valid[ALU_done_phy] <= 1'b1; // multiplier ?떊?샇媛? ?뱾?뼱?솕?쓣?븣 ?빐?떦 臾쇰━二쇱냼?? ?뜲?씠?꽣媛믪쓣 諛쏆븘?꽌 pfile?쓣 ?뾽?뜲?씠?듃 ?떆耳쒖??떎.
        end
        if (Rd_phy != 7'b0) begin
        valid[Rd_phy] <= 1'b0;
        end
    end
end



    always @(*) begin    //Operand 媛믪씠 ?뱾?뼱?삤硫? ?빐?떦 臾쇰━二쇱냼?쓽 data 媛믨낵 valid 媛믪쓣 異쒕젰?떆耳? 以??떎.
        Operand1_data = registers[Operand1_phy];   
        Operand2_data = registers[Operand2_phy];
        valid1 = valid[Operand1_phy];
        valid2 = valid[Operand2_phy];
    end

endmodule
