module sign_extend(
    input [31:0] inst,  // �쟾泥� 紐낅졊�뼱 �엯�젰
    input clk,          // �겢�씫 �떊�샇 �엯�젰
    output reg [31:0] Imm  // �떊�샇 �솗�옣�맂 利됱떆媛� 異쒕젰
);

// Opcode�뒗 紐낅졊�뼱�쓽 媛��옣 �궙�� 7鍮꾪듃�뿉 �쐞移�
wire [6:0] opcode = inst[6:0];

// Opcode瑜� 湲곕컲�쑝濡� 紐낅졊�뼱 �쑀�삎 �뙋蹂� 諛� �쟻�젅�븳 利됱떆媛� 異붿텧 諛� �떊�샇 �솗�옣
always @(posedge clk) begin
    if (opcode == 7'b0000011 || opcode == 7'b0010011 || opcode == 7'b1100111) begin
        // I-type (�삁: load, immediate, JALR)
        Imm[11:0] <= inst[31:20];
        Imm[31:12] <= {20{inst[31]}};
    end
    else if (opcode == 7'b0100011) begin
        // S-type (store)
        Imm[11:5] <= inst[31:25];
        Imm[4:0] <= inst[11:7];
        Imm[31:12] <= {20{inst[31]}};
    end
    else if (opcode == 7'b1100011) begin
        // B-type (branch)
        Imm[12] <= inst[31];
        Imm[10:5] <= inst[30:25];
        Imm[4:1] <= inst[11:8];
        Imm[11] <= inst[7];
        Imm[0] <= 1'b0; // B-type 利됱떆媛믪� �빆�긽 吏앹닔
        Imm[31:13] <= {19{inst[31]}};
    end
    else if (opcode == 7'b0110111 || opcode == 7'b0010111) begin
        // U-type (LUI, AUIPC)
        Imm[31:12] <= inst[31:12];
        Imm[11:0] <= 12'b0; // �븯�쐞 12鍮꾪듃�뒗 0
    end
    else if (opcode == 7'b1101111) begin
        // J-type (JAL)
        Imm[20] <= inst[31];
        Imm[10:1] <= inst[30:21];
        Imm[11] <= inst[20];
        Imm[19:12] <= inst[19:12];
        Imm[0] <= 1'b0; // J-type 利됱떆媛믪� �빆�긽 吏앹닔
        Imm[31:21] <= {11{inst[31]}};
    end
    else begin
        Imm <= 32'b0; // 利됱떆媛믪씠 �뾾�뒗 紐낅졊�뼱 �쑀�삎�쓽 寃쎌슦
    end
end

endmodule
