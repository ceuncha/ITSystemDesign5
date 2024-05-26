module ROB(
    input wire clk,                      // Clock signal
    input wire rst,                      // Reset signal
    input wire [31:0] instr,             // Input instruction (expanded to 32 bits)
    input wire reg_write,                // Register write enable signal from the decode stage
    input wire [6:0] phys_addr,          // Input physical address
    input wire alu_exec_done,            // ALU execution completion signal
    input wire [31:0] alu_exec_value,    // ALU executed value
    input wire [31:0] alu_exec_index,    // ALU execution index
    input wire mul_exec_done,            // Multiplier execution completion signal
    input wire [31:0] mul_exec_value,    // Multiplier executed value
    input wire [31:0] mul_exec_index,    // Multiplier execution index
    input wire div_exec_done,            // Divider execution completion signal
    input wire [31:0] div_exec_value,    // Divider executed value
    input wire [31:0] div_exec_index,    // Divider execution index
    input wire PcSrc,                    // Branch signal (acts like a done signal)
    input wire [31:0] PC_Return,         // Jump address
    input wire [31:0] branch_index,      // Branch index in ROB
    input wire [31:0] PC,                // Current PC value (expanded to 32 bits)
    output reg [31:0] out_value,         // Output value
    output reg [4:0] out_dest,           // Output register destination extracted from instr[11:7]
    output reg [6:0] out_phys_addr,      // Output physical address
    output reg out_reg_write             // Output RegWrite signal to indicate a register write operation
);

// ROB memory
reg [104:0] rob_entry [0:1023];          // ROB entry: ready(1), reg_write(1), value(32), instr(32), phys_addr(7), PC(32)
reg [9:0] head;                          // Head pointer (10 bits)
reg [9:0] tail;                          // Tail pointer (10 bits)
integer i;

// Reset ROB entries
task reset_rob_entries;
    for (i = 0; i < 1024; i = i + 1) begin
        rob_entry[i] <= 105'b0;           // Reset ROB entry with all fields set to 0
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
            // Update the branch entry with PC_Branch value
            for (i = 0; i < 1024; i = i + 1) begin
                if (rob_entry[i][31:0] == branch_index) begin
                    rob_entry[i][104:0] <= {1'b0, rob_entry[i][103], PC_Return, rob_entry[i][71:40], rob_entry[i][39:33], rob_entry[i][32:0]};
                    tail <= (i + 1) % 1024; // Move tail to the entry right after the branch entry
                end
            end
        end else if (instr != 32'b0) begin  // Only increment tail if the instruction is not invalid (i.e., not a bubble)
            rob_entry[tail] <= {1'b0, reg_write, 32'b0, instr, 7'b0, PC}; // Store input data in the ROB entry with value set to 32'b0
            tail <= (tail + 1) % 1024;                 // Circular buffer handling
        end

        // Update the value and set ready flag upon execution completion
        if (alu_exec_done || mul_exec_done || div_exec_done) begin
            for (i = 0; i < 1024; i = i + 1) begin
                if (alu_exec_done && rob_entry[i][31:0] == alu_exec_index) begin
                    rob_entry[i][104:0] <= {1'b1, rob_entry[i][103], alu_exec_value, rob_entry[i][71:40], phys_addr, rob_entry[i][32:0]}; // Update value and maintain reg_write,  instr, phys_addr, PC
                end
                if (mul_exec_done && rob_entry[i][31:0] == mul_exec_index) begin
                    rob_entry[i][104:0] <= {1'b1, rob_entry[i][103], mul_exec_value, rob_entry[i][71:40], phys_addr, rob_entry[i][32:0]}; // Update value and maintain reg_write,  instr, phys_addr, PC       
                end
                if (div_exec_done && rob_entry[i][31:0] == div_exec_index) begin
                    rob_entry[i][104:0] <= {1'b1, rob_entry[i][103], div_exec_value, rob_entry[i][71:40], phys_addr, rob_entry[i][32:0]}; // Update value and maintain reg_write,  instr, phys_addr, PC     
                end
            end
        end
    end
end

// Output logic
always @(posedge clk) begin
    if (rob_entry[head][104]) begin       // Check if the entry is ready
        out_value <= rob_entry[head][102:71];     // Output value
        out_dest <= rob_entry[head][70:66];      // Extract out_dest from instr[11:7]
        out_phys_addr <= rob_entry[head][65:59]; // Output physical address
        out_reg_write <= rob_entry[head][103];    // Output RegWrite status
        head <= (head + 1) % 1024;               // Circular buffer handling
        rob_entry[head][104] <= 1'b0;             // Clear the ready flag after consuming the entry
    end
end

endmodule
