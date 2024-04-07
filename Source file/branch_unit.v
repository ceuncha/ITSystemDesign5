module branch_unit(
    input [6:0] opcode,      // Opcode signal that determines the type of instruction
    input [2:0] funct3,      // Funct3 signal that determines the type of branch instruction
    input [31:0] immediate,  // Immediate value extracted from the instruction
    input [31:0] PC,         // Current Program Counter value
    input [31:0] RData1,     // rs1 value for JALR operation (Jump location: rs1 + immediate)
    input [31:0] RData2,     // rs2 value for comparison in branch instructions
    output reg [31:0] PC_Branch, // PC value to be updated by branch or jump
    output reg PCSrc,        // Set to 1 if a branch or jump occurs, otherwise 0
    output reg [31:0] Rd_data,   // Value to be written to Rd for LUI, AUIPC, JAL, JALR instructions
    output reg IF_ID_Flush   // Signal to flush the IF/ID pipeline register on branch or jump execution
);

reg [2:0] compare_result; // 3-bit variable for comparison result

always @(*) begin
    // Initialize comparison result
    compare_result = 3'b0;

    // Equal comparison
    compare_result[0] = (RData1 == RData2);

    // Signed less than comparison
    compare_result[1] = $signed(RData1) < $signed(RData2);

    // Unsigned less than comparison
    compare_result[2] = RData1 < RData2;

    // Initialize output signals
    PCSrc = 0;
    PC_Branch = 32'b0;
    Rd_data = 32'b0;
    IF_ID_Flush = 0;
    
    case(opcode)
        7'b0110111: begin // LUI
            Rd_data = immediate;
        end
        7'b0010111: begin // AUIPC
            Rd_data = PC + immediate;
        end
        7'b1101111: begin // JAL
            PCSrc = 1;
            PC_Branch = PC + immediate;
            Rd_data = PC + 4;
            IF_ID_Flush = 1;
        end
        7'b1100111: begin // JALR
            PCSrc = 1;
            PC_Branch = (RData1 + immediate) & ~1;
            Rd_data = PC + 4;
            IF_ID_Flush = 1;
        end
        7'b1100011: begin // Conditional Branch Instructions
            case (funct3)
                3'b000: PCSrc = compare_result[0]; // BEQ
                3'b001: PCSrc = ~compare_result[0]; // BNE
                3'b100: PCSrc = compare_result[1]; // BLT (signed)
                3'b101: PCSrc = ~compare_result[1] | compare_result[0]; // BGE (signed)
                3'b110: PCSrc = compare_result[2]; // BLTU (unsigned)
                3'b111: PCSrc = ~compare_result[2] | compare_result[0]; // BGEU (unsigned)
            endcase
            if (PCSrc) begin
                PC_Branch = PC + immediate;
                IF_ID_Flush = 1;
            end
        end
    endcase
end

endmodule
