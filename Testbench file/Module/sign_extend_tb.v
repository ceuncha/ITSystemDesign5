`timescale 1ns / 1ps

module sign_extend_tb;

    reg [31:0] inst;
    wire [31:0] Imm;

    sign_extend se(
        .inst(inst),
        .Imm(Imm)
    );

    initial begin
        // Initialize instruction
        inst = 32'b0;

        // Delay for visual clarity
        #10;

        // Test Case 1: I-type (example: load, e.g., LW x0, 0(x0))
        inst = {12'hABC, 5'b00000, 3'b000, 5'b00000, 7'b0000011}; // opcode: 0000011 (LW)
        // LW x0, 0(x0) - Load word from memory address computed by adding the immediate (ABC in hex) to the base address in register x0, and store it in x0
        #10;

        // Test Case 2: S-type (example: store, e.g., SW x10, 0(x21))
        inst = {7'h3F, 5'b10101, 3'b010, 5'b01010, 7'b0100011}; // opcode: 0100011 (SW)
        // SW x10, 0(x21) - Store word in register x10 to memory address computed by adding the immediate (3F in hex) to the base address in register x21
        #10;

        // Test Case 3: B-type (example: branch, e.g., BEQ x1, x1, 0)
        inst = {1'b1, 6'h3F, 1'b1, 4'h5, 1'b0, 4'h8, 3'b001, 5'b00001, 7'b1100011}; // opcode: 1100011 (BEQ)
        // BEQ x1, x1, 0 - Branch if equal; if the values in registers x1 and x1 are equal, branch to the address computed by adding the immediate (3F in hex) to the current PC
        #10;

        // Test Case 4: U-type (example: LUI, e.g., LUI x0, 0xABCDE)
        inst = {20'hABCDE, 12'b0, 7'b0110111}; // opcode: 0110111 (LUI)
        // LUI x0, 0xABCDE - Load upper immediate; load the upper 20 bits of x0 with 0xABCDE, and the lower 12 bits with zeros
        #10;

        // Test Case 5: J-type (example: JAL, e.g., JAL x0, 0x3FFFF)
        inst = {1'b1, 10'h3FF, 1'b1, 8'hFF, 1'b0, 8'hFF, 7'b1101111}; // opcode: 1101111 (JAL)
        // JAL x0, 0x3FFFF - Jump and link; jump to the address computed by adding the immediate (3FFFF in hex) to the current PC, and store the return address in x0
        #10;

        // End simulation
        $finish;
    end

    initial begin
        $monitor("At time %t, instruction = %b, Immediate = %b (%0d)", $time, inst, Imm, Imm);
    end

endmodule
