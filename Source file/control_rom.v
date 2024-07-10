module control_rom(
    input [5:0] mapped_address,
    input reset, // 由ъ뀑 �떊�샇 異붽�
    output RegWrite,
    output MemToReg,
    output MemRead,
    output MemWrite,
    output [3:0] ALUOp,
    output [1:0] ALUSrc,
    output RWsel,
    output Branch,
    output Jump // 異붽��맂 Jump �떊�샇
);

reg [12:0] ROM [0:63]; // ROM �겕湲곕�� 13鍮꾪듃濡� 利앷�

assign {RegWrite, MemToReg, MemRead, MemWrite, ALUOp, ALUSrc, RWsel, Branch, Jump} = ROM[mapped_address];

    always @(posedge reset) begin
   
        // 紐⑤뱺 �젣�뼱 �떊�샇瑜� 二쇱냼 0�뿉�꽌 0�쑝濡� 珥덇린�솕
        ROM[0] = 13'b0_0_0_0_0000_00_0_0_0;

        // R-���엯 紐낅졊�뼱
        ROM[1] = 13'b1_0_0_0_0010_10_0_0_0; // ADD
        ROM[2] = 13'b1_0_0_0_0110_10_0_0_0; // SUB
        ROM[3] = 13'b1_0_0_0_0000_10_0_0_0; // AND
        ROM[4] = 13'b1_0_0_0_0001_10_0_0_0; // OR
        ROM[5] = 13'b1_0_0_0_0011_10_0_0_0; // XOR
        ROM[6] = 13'b1_0_0_0_0100_10_0_0_0; // SLL
        ROM[7] = 13'b1_0_0_0_0101_10_0_0_0; // SRL
        ROM[8] = 13'b1_0_0_0_0111_10_0_0_0; // SRA
        ROM[9] = 13'b1_0_0_0_1000_10_0_0_0; // SLT
        ROM[10] = 13'b1_0_0_0_1001_10_0_0_0; // SLTU

        // 濡쒕뱶 諛� �뒪�넗�뼱
        ROM[11] = 13'b1_1_1_0_0010_11_0_0_0; // 濡쒕뱶
        ROM[12] = 13'b0_0_0_1_0010_11_0_0_0; // �뒪�넗�뼱

        // Branch 紐낅졊�뼱
        ROM[13] = 13'b0_0_0_0_0110_10_0_1_0; // 遺꾧린 紐낅졊�뼱�뿉 ���븳 ALUOp �꽕�젙

        // I-���엯 利됱떆媛� �뿰�궛 諛� ALU 紐낅졊�뼱
        ROM[14] = 13'b1_0_0_0_0010_11_0_0_0; // ADDI
        ROM[15] = 13'b1_0_0_0_1000_11_0_0_0; // SLTI
        ROM[16] = 13'b1_0_0_0_1001_11_0_0_0; // SLTIU
        ROM[17] = 13'b1_0_0_0_0011_11_0_0_0; // XORI
        ROM[18] = 13'b1_0_0_0_0001_11_0_0_0; // ORI
        ROM[19] = 13'b1_0_0_0_0000_11_0_0_0; // ANDI
        ROM[20] = 13'b1_0_0_0_0100_11_0_0_0; // SLLI
        ROM[21] = 13'b1_0_0_0_0101_11_0_0_0; // SRLI
        ROM[22] = 13'b1_0_0_0_0111_11_0_0_0; // SRAI

        // LUI, AUIPC, JAL, JALR
        ROM[23] = 13'b1_0_0_0_0010_11_0_0_0; // LUI
        ROM[24] = 13'b1_0_0_0_0010_01_0_0_0; // AUIPC
        ROM[25] = 13'b1_0_0_0_0010_01_1_0_1; // JAL
        ROM[26] = 13'b1_0_0_0_0010_11_1_0_1; // JALR

        // 異붽��맂 紐낅졊�뼱
        ROM[27] = 13'b1_0_0_0_1010_10_0_0_0; // MUL
        ROM[28] = 13'b1_0_0_0_0001_10_0_0_0; // DIV (紐�)
        ROM[29] = 13'b1_0_0_0_0000_10_0_0_0; // REM (�굹癒몄�)

end

endmodule
