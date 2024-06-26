module address_mapper(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [5:0] mapped_address
);

initial begin
    mapped_address = 0;
end

always @(*) begin
    case(opcode)
        // New operation at address 0
        
        
        // R-type
        7'b0110011: begin
            case(funct3)
                3'b000: mapped_address = (funct7 == 7'b0000000) ? 6'd1 : // ADD
                                        (funct7 == 7'b0100000) ? 6'd2 : // SUB
                                        6'd0; // default case
                3'b111: mapped_address = 6'd3; // AND
                3'b110: mapped_address = 6'd4; // OR
                3'b100: mapped_address = 6'd5; // XOR
                3'b001: mapped_address = 6'd6; // SLL
                3'b101: mapped_address = (funct7 == 7'b0000000) ? 6'd7 : // SRL
                                        (funct7 == 7'b0100000) ? 6'd8 : // SRA
                                        6'd0; // default case
                3'b010: mapped_address = 6'd9; // SLT
                3'b011: mapped_address = 6'd10; // SLTU
                default: mapped_address = 6'd0; // default case
            endcase
        end
        // Load
        7'b0000011: mapped_address = 6'd11; // load
        // Store 
        7'b0100011: mapped_address = 6'd12; 
        // B-type Branch operations
        7'b1100011: mapped_address = 6'd13; // Branches (BEQ, BNE, BLT, BGE, BLTU, BGEU)
        // I-type Immediate and ALU operations
        7'b0010011: begin
            case(funct3)
                3'b000: mapped_address = 6'd14; // ADDI
                3'b010: mapped_address = 6'd15; // SLTI
                3'b011: mapped_address = 6'd16; // SLTIU
                3'b100: mapped_address = 6'd17; // XORI
                3'b110: mapped_address = 6'd18; // ORI
                3'b111: mapped_address = 6'd19; // ANDI
                3'b001: mapped_address = 6'd20; // SLLI
                3'b101: mapped_address = (funct7 == 7'b0000000) ? 6'd21 : // SRLI
                                        (funct7 == 7'b0100000) ? 6'd22 : // SRAI
                                        6'd0; // default case
                default: mapped_address = 6'd0; // default case
            endcase
        end
        // LUI
        7'b0110111: mapped_address = 6'd23;
        // AUIPC
        7'b0010111: mapped_address = 6'd24;
        // JAL
        7'b1101111: mapped_address = 6'd25;
        // JALR
        7'b1100111: mapped_address = 6'd26;
        default: mapped_address = 6'd0; // default case
    endcase
end

endmodule
