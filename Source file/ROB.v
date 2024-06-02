module ROB(
    input wire clk,                      // Clock signal
    input wire rst,                      // Reset signal
    input wire ROB_Flush,                // ROB Flush signal
    input wire [31:0] IF_ID_instOut,     // Input instruction (expanded to 32 bits)
    input wire reg_write,                // Register write enable signal from the decode stage
    input wire alu_exec_done,            // ALU execution completion signal
    input wire [31:0] alu_exec_value,    // ALU executed value
    input wire [31:0] alu_exec_PC,       // ALU execution index
    input wire mul_exec_done,            // Multiplier execution completion signal
    input wire [31:0] mul_exec_value,    // Multiplier executed value
    input wire [31:0] mul_exec_PC,       // Multiplier execution index
    input wire div_exec_done,            // Divider execution completion signal
    input wire [31:0] div_exec_value,    // Divider executed value
    input wire [31:0] div_exec_PC,       // Divider execution index
    input wire PcSrc,                    // Branch signal (acts like a done signal)
    input wire [31:0] PC_Return,         // Jump address
    input wire [31:0] branch_index,      // Branch index in ROB
    input wire [31:0] PC,                // Current PC value (expanded to 32 bits)
    output reg [31:0] out_value,         // Output value
    output reg [4:0] out_dest,           // Output register destination extracted from instr[11:7]
    output reg out_reg_write             // Output RegWrite signal to indicate a register write operation
);

// ROB memory
reg [98:0] rob_entry [0:31];            // ROB entry: new_bit(1), ready(1), reg_write(1), value(32), instr(32), PC(32)
reg [4:0] head;                        // Head pointer (5 bits for 32 entries)
reg [4:0] tail;                        // Tail pointer (5 bits for 32 entries)
integer i;

// Reset ROB entries
task reset_rob_entries;
    begin
        for (i = 0; i < 32; i = i + 1) begin
            rob_entry[i] <= 99'b0;     // Reset ROB entry with all fields set to 0
        end
    end
endtask

// ROB control logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        head <= 0;
        tail <= 0;
        reset_rob_entries();
    end else begin
        if (PcSrc) begin
            // Update the branch entry with PC_Return value
            for (i = 0; i < 32; i = i + 1) begin
                if (rob_entry[i][31:0] == branch_index) begin
                    rob_entry[i][98:0] <= {rob_entry[i][98], 1'b1, rob_entry[i][96], PC_Return, rob_entry[i][63:32], rob_entry[i][31:0]};
                    tail <= (i + 1) % 32; // Move tail to the entry right after the branch entry
                end
            end
        end else if (ROB_Flush) begin
            // Decrement tail on ROB_Flush signal
            if (tail == 0) begin
                tail <= 31; // Wrap around to 31 if tail is 0
            end else begin
                tail <= tail - 1;
            end
        end else if (IF_ID_instOut != 32'b0) begin  // Only increment tail if the instruction is not invalid (i.e., not a bubble)
            rob_entry[tail] <= {1'b1, 1'b0, reg_write, 32'b0, IF_ID_instOut, PC}; // Store input data in the ROB entry with value set to 32'b0 and new_bit set to 1
            tail <= (tail + 1) % 32;                // Circular buffer handling
        end

        // Update the value and set ready flag upon execution completion
        if (alu_exec_done || mul_exec_done || div_exec_done) begin
            for (i = 0; i < 32; i = i + 1) begin
                if (rob_entry[i][98]) begin // Check if the new bit is set to 1
                    if (alu_exec_done && rob_entry[i][31:0] == alu_exec_PC) begin
                        rob_entry[i][98:0] <= {rob_entry[i][98], 1'b1, rob_entry[i][96], alu_exec_value, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC
                    end
                    if (mul_exec_done && rob_entry[i][31:0] == mul_exec_PC) begin
                        rob_entry[i][98:0] <= {rob_entry[i][98], 1'b1, rob_entry[i][96], mul_exec_value, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC       
                    end
                    if (div_exec_done && rob_entry[i][31:0] == div_exec_PC) begin
                        rob_entry[i][98:0] <= {rob_entry[i][98], 1'b1, rob_entry[i][96], div_exec_value, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC     
                    end
                end
            end
        end
    end
end

// Output logic
always @(posedge clk) begin
    if (rob_entry[head][97]) begin       // Check if the entry is ready
        out_value <= rob_entry[head][95:64];     // Output value
        out_dest <= rob_entry[head][43:39];      // Extract out_dest from instr[11:7]
        out_reg_write <= rob_entry[head][96];   // Output RegWrite status
        rob_entry[head][97] <= 1'b0;            // Clear the ready flag after consuming the entry
        head <= (head + 1) % 32;                 // Circular buffer handling
    end
end

endmodule
