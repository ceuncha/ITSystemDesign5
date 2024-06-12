module branch_unit(
    input [31:0] ResultA,       // ù ��° �� ���
    input [31:0] ResultB,       // �� ��° �� ���
    input [31:0] ID_EX_PC,      // ���� ���ɾ� �ּ�
    input ID_EX_Branch,         // �б� Ȱ��ȭ ��ȣ
    input [2:0] ID_EX_funct3,   // �б� ������ �����ϴ� �Լ� �ڵ�
    input [31:0] ALUResult,     // ALU ��� (�б� �ּ� ��꿡 ���)
    input ID_EX_Jump,
    input ID_EX_hit,                 // ���� Ȱ��ȭ ��ȣ
    output reg PCSrc,           // PC �ҽ� ���� ��ȣ (�б� �Ǵ� ���� ���� �� 1)
    output reg [31:0] PC_Branch,// ���ο� �б� �Ǵ� ���� �ּ�
    output reg [31:0] Rd_data,  // Rd �������Ϳ� ������ ������
    output reg IF_ID_Flush,     // IF/ID ���������� �������� �÷���
    output reg ID_EX_Flush      // ID/EX ���������� �������� �÷���
);

always @(*) begin
    // �⺻ ����
    PCSrc = 0;
    PC_Branch = 0;  // �⺻ �б� �ּ�
    Rd_data = 0;                       // �⺻������ 0
    IF_ID_Flush = 0;
    ID_EX_Flush = 0;

    if (ID_EX_Jump) begin
        // Jump�� Ȱ��ȭ�� ���
        PCSrc = 1;
        PC_Branch = ALUResult;         // Jump �ּҴ� ALU ����� ����
        Rd_data = ID_EX_PC + 4;         // Rd_data���� PC + 4 ����
        IF_ID_Flush = 1;
        ID_EX_Flush = 1;
    end else if (ID_EX_Branch) begin
        // �б� ������ ��
        case (ID_EX_funct3)
            3'b000: PCSrc = (ResultA == ResultB);   // BEQ
            3'b001: PCSrc = (ResultA != ResultB);   // BNE
            3'b100: PCSrc = ($signed(ResultA) < $signed(ResultB));  // BLT
            3'b101: PCSrc = ($signed(ResultA) >= $signed(ResultB)); // BGE
            3'b110: PCSrc = ($unsigned(ResultA) < $unsigned(ResultB)); // BLTU
            3'b111: PCSrc = ($unsigned(ResultA) >= $unsigned(ResultB)); // BGEU
            default: PCSrc = 0;
        endcase

        if ((ID_EX_hit==0) && PCSrc) begin
           IF_ID_Flush = 1;
            ID_EX_Flush = 1;
        end

        if (PCSrc) begin
            // �бⰡ Ȱ��ȭ�Ǿ��� �� PC �ּ� ����, �÷��� ��ȣ �߻�
            PC_Branch = ALUResult;

        end
    end
end

endmodule
