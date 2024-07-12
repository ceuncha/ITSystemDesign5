module Global_History_Register (
    input wire clk,
    input wire reset,
    input wire ID_EX_Branch,
    input wire Pcsrc,
    output reg [3:0] branch_history // 4-bit branch history
);

// 鍮꾨룞湲� 由ъ뀑 諛� 遺꾧린 �엳�뒪�넗由� �뾽�뜲�씠�듃
always @(posedge clk ) begin
    if (reset) begin
        branch_history <= 4'b0000; // 鍮꾨룞湲� 由ъ뀑
    end else if (ID_EX_Branch) begin
        // �깉濡쒖슫 遺꾧린 寃곌낵瑜� LSB�뿉 異붽��븯怨� �굹癒몄�瑜� �삤瑜몄そ�쑝濡� �씠�룞
        branch_history <= {branch_history[2:0], Pcsrc};
    end
end

endmodule
