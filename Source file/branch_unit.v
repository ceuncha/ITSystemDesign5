
module BranchUnit(
    input wire ID_EX_Jump,
    input wire ID_EX_Branch,
    input wire [2:0] ID_EX_funct3,
    input wire [31:0] ALUResult,
    input wire [31:0] imm,
    input wire [31:0] PC,
    
    input wire ALUNegative, // Negative flag from ALU
    input wire ALUZero,     // Zero flag from ALU
    input wire ALUOverflow, // Overflow flag from ALU
    input wire ALUCarry,     // Carry flag from ALU

    output reg [31:0] PC_Branch,
    output reg [31:0] branch_index,
    output reg PCSrc,
    output reg IF_ID_Flush

);


always @(*) begin
        PCSrc = 0;
        PC_Branch = 0;  // 湲곕낯 遺꾧린 二쇱냼
        IF_ID_Flush = 0;
   
        if(ID_EX_Jump) begin
            PC_Branch = ALUResult; // ?젏?봽 泥섎━
            PCSrc = 1; // ?젏?봽 ?떆 PC ?냼?뒪 ?떊?샇 ?솢?꽦?솕
            IF_ID_Flush = 1'b1;
            branch_index = PC;
        end
        else if(ID_EX_Branch) begin
            case(ID_EX_funct3)
            3'b000: PCSrc = ALUZero; // BEQ: Branch if Zero flag is 1
            3'b001: PCSrc = ~ALUZero; // BNE: Branch if Zero flag is 0
            3'b100: PCSrc = ALUNegative; // BLT: Branch if Negative flag is 1
            3'b101: PCSrc = ~ALUNegative; // BGE: Branch if Negative flag is 0
            3'b110: PCSrc = ALUCarry; // BLTU: Branch if Carry flag is 1
            3'b111: PCSrc = ~ALUCarry; // BGEU: Branch if Carry flag is 0

            default: PCSrc = 0;
            endcase
            if(PCSrc) begin
                PC_Branch = imm + PC + 4; // 遺꾧린 二쇱냼 ?뾽?뜲?씠?듃
                IF_ID_Flush = 1'b1;
                branch_index = PC;
            end
        end

    end


endmodule
