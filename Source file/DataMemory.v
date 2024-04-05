module DataMemory(

    input wire MemRead,

    input wire MemWrite,

    input wire [2:0] funct3,

    input wire [31:0] ALUResult,

    input wire [31:0] WriteData,

    output reg [31:0] ReadData

);



reg [31:0] memory [0:255];



always @ (*) begin

    if (MemRead) begin

        case (funct3)

            3'b000: ReadData <= {{24{memory[ALUResult >> 2][7]}}, memory[ALUResult >> 2][7:0]}; // LB

            3'b001: ReadData <= {{16{memory[ALUResult >> 2][15]}}, memory[ALUResult >> 2][15:0]}; // LH

            3'b010: ReadData <= memory[ALUResult >> 2]; // LW

            3'b100: ReadData <= {{24{1'b0}}, memory[ALUResult >> 2][7:0]}; // LBU

            3'b101: ReadData <= {{16{1'b0}}, memory[ALUResult >> 2][15:0]}; // LHU

            default: ReadData <= 32'd0;

        endcase

    end

    if (MemWrite) begin

        case (funct3)

            3'b000: memory[ALUResult >> 2][7:0] <= WriteData[7:0]; // SB

            3'b001: memory[ALUResult >> 2][15:0] <= WriteData[15:0]; // SH

            3'b010: memory[ALUResult >> 2] <= WriteData; // SW

        endcase

    end

    end
endmodule
