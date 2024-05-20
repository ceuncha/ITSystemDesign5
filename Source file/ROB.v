
module ROB(
    input wire clk,                      // Clock signal
    input wire rst,                      // Reset signal
    input wire [31:0] instr,             // Input instruction (expanded to 32 bits)
    input wire reg_write,                // Register write enable signal from the decode stage
    input wire [6:0] phys_addr,          // Input physical address
    input wire exec_done,                // Execution completion signal
    input wire [31:0] exec_value,        // Executed value from reservation station
    input wire [9:0] exec_index,         // Index of the ROB entry corresponding to the executed instruction (increased to 10 bits)
    input wire [31:0] mul_exec_value,    // Multiplier execution value
    input wire mul_exec_done,            // Multiplier execution completion signal
    input wire PcSrc,                    // Branch signal (renamed to PcSrc)
    input wire [9:0] PC_Branch,          // Index of the ROB entry corresponding to the branch instruction (increased to 10 bits)
    input wire [9:0] PC,                 // Current PC value (increased to 10 bits)
    output reg [31:0] out_value,         // Output value
    output reg [4:0] out_dest,           // Output register destination extracted from instr[11:7]
    output reg [6:0] out_phys_addr,      // Output physical address
    output reg out_reg_write             // Output RegWrite signal to indicate a register write operation
);

// ROB memory
reg [82:0] rob_entry [0:1023];          // ROB entry: ready(1), reg_write(1), value(32), instr(32), phys_addr(7), PC(10)
reg [9:0] head;                         // Head pointer (10 bits to cover 0-1023 range)
reg [9:0] tail;                         // Tail pointer (10 bits to cover 0-1023 range)
integer i;

// Reset ROB entries
task reset_rob_entries;
    for (i = 0; i < 1024; i = i + 1) begin
        rob_entry[i] <= 83'b0;           // Reset ROB entry with all fields set to 0
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
            // Clear all ROB entries after the PC_Branch index
            for (i = 0; i < 1024; i = i + 1) begin
                if (rob_entry[i][9:0] == PC_Branch) begin
                    tail <= (i + 1) % 1024; // Set tail to the next position after the PC_Branch index
                    i=1024;
                end
            end
        end else begin
            rob_entry[tail] <= {1'b0, reg_write, 32'b0, instr, phys_addr, PC}; // Store input data in the ROB entry with value set to 32'b0
            tail <= (tail + 1) % 1024;                 // Circular buffer handling
        end

        // Update the value and set ready flag upon execution completion
        if (exec_done || mul_exec_done) begin
            for (i = 0; i < 1024; i = i + 1) begin
                if (rob_entry[i][9:0] == exec_index) begin
                    if (exec_done) begin
                        rob_entry[i][82:0] <= {1'b1, rob_entry[i][81], exec_value, rob_entry[i][48:17], rob_entry[i][16:7], rob_entry[i][6:0]}; // Update value and maintain reg_write, instr, and phys_addr
                    end
                    if (mul_exec_done) begin
                        rob_entry[i][82:0] <= {1'b1, rob_entry[i][81], mul_exec_value, rob_entry[i][48:17], rob_entry[i][16:7], rob_entry[i][6:0]}; // Update value and maintain reg_write, instr, and phys_addr        
                    end
                     i = 1024;;
                end
            end
        end
    end
end

// Output logic
always @(posedge clk) begin
    if (rob_entry[head][82]) begin       // Check if the entry is ready
        out_value <= rob_entry[head][80:49];     // Output value
        out_dest <= rob_entry[head][42:38];      // Extract out_dest from instr[11:7]
        out_phys_addr <= rob_entry[head][16:10]; // Output physical address
        out_reg_write <= rob_entry[head][81];    // Output RegWrite status
        head <= (head + 1) % 1024;               // Circular buffer handling
        rob_entry[head][82] <= 1'b0;             // Clear the ready flag after consuming the entry
    end
end

endmodule
