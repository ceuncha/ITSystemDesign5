
module BranchUnit(
    input wire ID_EX_Jump,
    input wire ID_EX_Branch,
    input wire [2:0] ID_EX_funct3,
    input wire [31:0] ALUResult,
    input wire [31:0] imm,
    input wire [31:0] PC,
    input wire ALUNegative, // ALU?뿉?꽌 ?삤?뒗 Negative ?뵆?옒洹?
    input wire ALUZero,     // ALU?뿉?꽌 ?삤?뒗 Zero ?뵆?옒洹?
    input wire ALUOverflow, // ALU?뿉?꽌 ?삤?뒗 Overflow ?뵆?옒洹?
    input wire ALUCarry,    // ALU?뿉?꽌 ?삤?뒗 Carry ?뵆?옒洹?
    output reg [31:0] PC_Branch,
    output reg [31:0] branch_index,
    output reg PCSrc,
    output reg IF_ID_Flush

);


always @(*) begin
        PCSrc = 0;
        PC_Branch = 0;  // 湲곕낯 遺꾧린 二쇱냼
        IF_ID_Flush = 0;
        ROB_Flush = 0;
        if(ID_EX_Jump) begin
            PC_Branch = ALUResult; // ?젏?봽 泥섎━
            PCSrc = 1; // ?젏?봽 ?떆 PC ?냼?뒪 ?떊?샇 ?솢?꽦?솕
            IF_ID_Flush = 1'b1;
            branch_index = PC;
        end
        else if(ID_EX_Branch) begin
            case(ID_EX_funct3)
                3'b000: PCSrc = ALUZero; // BEQ: Zero ?뵆?옒洹멸? 1?씠硫? 李?
                3'b001: PCSrc = ~ALUZero; // BNE: Zero ?뵆?옒洹멸? 0?씠硫? 李?
                3'b100: PCSrc = ALUNegative; // BLT: Negative ?뵆?옒洹멸? 1?씠硫? 李?
                3'b101: PCSrc = ~ALUNegative; // BGE: Negative ?뵆?옒洹멸? 0?씠硫? 李?
                3'b110: PCSrc = ALUCarry; // BLTU: Carry ?뵆?옒洹멸? 1?씠硫? 李?
                3'b111: PCSrc = ~ALUCarry; // BGEU: Carry ?뵆?옒洹멸? 0?씠硫? 李?
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
