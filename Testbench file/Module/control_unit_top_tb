`timescale 1ns / 1ps

module control_unit_top_tb;

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    
    wire RegWrite;
    wire MemToReg;
    wire MemRead;
    wire MemWrite;
    wire [3:0] ALUOp;
    wire [1:0] ALUSrc;
    wire RWsel;
    wire Branch;
    wire Jump;

    control_unit_top CUT(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .RegWrite(RegWrite),
        .MemToReg(MemToReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .RWsel(RWsel),
        .Branch(Branch),
        .Jump(Jump)
    );

    initial begin
        // Initialize inputs
        opcode = 7'b0000000;
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        // Delay for visual clarity
        #20;

        // Test Case 1: R-type (ADD)
        opcode = 7'b0110011; // R-type opcode
        funct3 = 3'b000;     // ADD
        funct7 = 7'b0000000; // ADD
        #10;

        // Test Case 2: I-type (LW)
        opcode = 7'b0000011; // I-type opcode
        funct3 = 3'b010;     // LW
        funct7 = 7'b0000000; // Not used in LW
        #10;

        // Test Case 3: S-type (SW)
        opcode = 7'b0100011; // S-type opcode
        funct3 = 3'b010;     // SW
        funct7 = 7'b0000000; // Not used in SW
        #10;

        // Test Case 4: B-type (BEQ)
        opcode = 7'b1100011; // B-type opcode
        funct3 = 3'b000;     // BEQ
        funct7 = 7'b0000000; // Not used in BEQ
        #10;

        // Test Case 5: U-type (LUI)
        opcode = 7'b0110111; // U-type opcode for LUI
        #10;

        // Test Case 6: U-type (AUIPC)
        opcode = 7'b0010111; // U-type opcode for AUIPC
        #10;

        // Test Case 7: J-type (JAL)
        opcode = 7'b1101111; // J-type opcode for JAL
        #10;

        // Terminate simulation
        $finish;
    end

    initial begin
        $monitor("At time %t, opcode = %b, funct3 = %b, funct7 = %b, RegWrite = %b, MemToReg = %b, MemRead = %b, MemWrite = %b, ALUOp = %b, ALUSrc = %b, RWsel = %b, Branch = %b, Jump = %b",
                 $time, opcode, funct3, funct7, RegWrite, MemToReg, MemRead, MemWrite, ALUOp, ALUSrc, RWsel, Branch, Jump);
    end

endmodule
