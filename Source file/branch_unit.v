module BranchUnit(
    input wire RS_BR_Jump,
    input wire RS_BR_Branch,
    input wire [2:0] RS_BR_funct3,
    input wire [31:0] PC_BR,
    input wire [31:0] immediate_BR,
    input wire [31:0] PC_Return,
    input wire [31:0] RS_BR_inst_num,
    input wire RS_BR_taken,
    input wire ALUNegative, // Negative flag from ALU
    input wire ALUZero,     // Zero flag from ALU
    input wire ALUOverflow, // Overflow flag from ALU
    input wire ALUCarry,    // Carry flag from ALU
    
    input wire [31:0] operand2,

    output reg [31:0] PC_Branch,
    output reg [31:0] branch_index,
    output reg PCSrc,

    output reg Predict_Result
);

always @(*) begin
        PCSrc = 0;
        PC_Branch = 0;  

        if(RS_BR_Jump) begin
          if(RS_BR_funct3==3'b000) begin
          PC_Branch = immediate_BR+operand2;
          PCSrc=1;
          end
          else begin
            PC_Branch = immediate_BR + PC_BR; 
            PCSrc = 1; 
            end
            
        end
        else if(RS_BR_Branch) begin
            case(RS_BR_funct3)
            3'b000: PCSrc = ALUZero; // BEQ: Branch if Zero flag is 1
            3'b001: PCSrc = ~ALUZero; // BNE: Branch if Zero flag is 0
            3'b100: PCSrc = ALUNegative; // BLT: Branch if Negative flag is 1
            3'b101: PCSrc = ~ALUNegative; // BGE: Branch if Negative flag is 0
            3'b110: PCSrc = ALUCarry; // BLTU: Branch if Carry flag is 1
            3'b111: PCSrc = ~ALUCarry; // BGEU: Branch if Carry flag is 0
            
            default: PCSrc = 0; 
            endcase
            if(PCSrc) begin
                PC_Branch = immediate_BR + PC_Return; 

                
            end
        end
        
        branch_index = RS_BR_inst_num;
        Predict_Result = RS_BR_taken ^ PCSrc;
    end

endmodule
