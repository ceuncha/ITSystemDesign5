module BB(
    input wire clk,                      // Clock signal
    input wire rst,                      // Reset signal
    input wire [6:0] opcode,             // Input opcode
    input wire PCSrc,                    // Branch decision signal
    input wire [31:0] branch_PC,         // Branch index in ROB
    input wire [31:0] PC,                // Current PC value (expanded to 32 bits)
    output reg [2:0] tail_num,               // Output value
    output reg Copy_RAT,                 // Output register destination extracted from instr[11:7]
    output reg [2:0] head_num,               // Output RegWrite signal to indicate a register write operation
    output reg Paste_RAT
);

// ROB memory
reg [31:0] BB_entry [0:7];          
reg ready [0:7];                       // Ready flag array for ROB entries
integer i;

// Reset BB entries
task reset_bb_entries;
    begin
        for (i = 0; i < 8; i = i + 1) begin
            BB_entry[i] <= 32'b0;     // Reset ROB entry with all fields set to 0
            ready[i] <= 1'b0;         // Reset ready flag
        end
    end
endtask

// BB control logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        head <= 0;
        tail <= 0;
        Paste_RAT <= 0;
        reset_bb_entries();
    end else begin
        // Check for jump or branch opcode
        if (opcode == 7'b1101111 || opcode == 7'b1100111) begin // Assuming these are jump or branch opcodes
            BB_entry[tail] <= PC;    // Store the current PC value in ROB at tail position
            ready[tail] <= 1'b0;     // Set ready flag to 0
            tail_num <= tail;	//
            Copy_RAT <=1;
            tail <= tail + 1;        // Increment the tail pointer
        end

        // Compare branch_PC with head's PC and check PCSrc
        if (BB_entry[head] == branch_PC) begin
            if (PCSrc == 1'b1) begin
                Paste_RAT <= 1;      // Set Paste_RAT to 1
                head_num <= head
                reset_bb_entries();  // Reset BB entries

            end else begin
                head <= head + 1;    // Increment head
                Paste_RAT <= 0;      // Reset Paste_RAT to 0
            end
        end

        for (i = 0; i < 8; i = i + 1) begin
            if (BB_entry[i] == branch_PC) begin
                if (PCSrc == 1'b1) begin
                    ready[i] <= 1'b1;   // Set the ready flag to 1
                end
            end
         end
    end
end

endmodule
