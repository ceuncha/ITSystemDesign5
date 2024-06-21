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
    output reg out_reg_write,             // Output RegWrite signal to indicate a register write operation
   output reg [98:0] rob_entry_out_0,  // Separate ports for each ROB entry
    output reg [98:0] rob_entry_out_1,
    output reg [98:0] rob_entry_out_2,
    output reg [98:0] rob_entry_out_3,
    output reg [98:0] rob_entry_out_4,
    output reg [98:0] rob_entry_out_5,
    output reg [98:0] rob_entry_out_6,
    output reg [98:0] rob_entry_out_7,
    output reg [98:0] rob_entry_out_8,
    output reg [98:0] rob_entry_out_9,
    output reg [98:0] rob_entry_out_10,
    output reg [98:0] rob_entry_out_11,
    output reg [98:0] rob_entry_out_12,
    output reg [98:0] rob_entry_out_13,
    output reg [98:0] rob_entry_out_14,
    output reg [98:0] rob_entry_out_15,
    output reg [98:0] rob_entry_out_16,
    output reg [98:0] rob_entry_out_17,
    output reg [98:0] rob_entry_out_18,
    output reg [98:0] rob_entry_out_19,
    output reg [98:0] rob_entry_out_20,
    output reg [98:0] rob_entry_out_21,
    output reg [98:0] rob_entry_out_22,
    output reg [98:0] rob_entry_out_23,
    output reg [98:0] rob_entry_out_24,
    output reg [98:0] rob_entry_out_25,
    output reg [98:0] rob_entry_out_26,
    output reg [98:0] rob_entry_out_27,
    output reg [98:0] rob_entry_out_28,
    output reg [98:0] rob_entry_out_29,
    output reg [98:0] rob_entry_out_30,
    output reg [98:0] rob_entry_out_31,
    output reg [98:0] rob_entry_out_32,
    output reg [98:0] rob_entry_out_33,
    output reg [98:0] rob_entry_out_34,
    output reg [98:0] rob_entry_out_35,
    output reg [98:0] rob_entry_out_36,
    output reg [98:0] rob_entry_out_37,
    output reg [98:0] rob_entry_out_38,
    output reg [98:0] rob_entry_out_39,
    output reg [98:0] rob_entry_out_40,
    output reg [98:0] rob_entry_out_41,
    output reg [98:0] rob_entry_out_42,
    output reg [98:0] rob_entry_out_43,
    output reg [98:0] rob_entry_out_44,
    output reg [98:0] rob_entry_out_45,
    output reg [98:0] rob_entry_out_46,
    output reg [98:0] rob_entry_out_47,
    output reg [98:0] rob_entry_out_48,
    output reg [98:0] rob_entry_out_49,
    output reg [98:0] rob_entry_out_50,
    output reg [98:0] rob_entry_out_51,
    output reg [98:0] rob_entry_out_52,
    output reg [98:0] rob_entry_out_53,
    output reg [98:0] rob_entry_out_54,
    output reg [98:0] rob_entry_out_55,
    output reg [98:0] rob_entry_out_56,
    output reg [98:0] rob_entry_out_57,
    output reg [98:0] rob_entry_out_58,
    output reg [98:0] rob_entry_out_59,
    output reg [98:0] rob_entry_out_60,
    output reg [98:0] rob_entry_out_61,
    output reg [98:0] rob_entry_out_62,
    output reg [98:0] rob_entry_out_63

);

// ROB memory
reg [98:0] rob_entry [0:63];            // ROB entry: new_bit(1), ready(1), reg_write(1), value(32), instr(32), PC(32)
reg [5:0] head;                        // Head pointer (5 bits for 32 entries)
reg [5:0] tail;                        // Tail pointer (5 bits for 32 entries)
integer i;

// Reset ROB entries
task reset_rob_entries;
    begin
        for (i = 0; i < 64; i = i + 1) begin
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
            for (i = 0; i < 64; i = i + 1) begin
                if (rob_entry[i][31:0] == branch_index) begin
                    rob_entry[i][98:0] <= {rob_entry[i][98], 1'b1, rob_entry[i][96], PC_Return, rob_entry[i][63:32], rob_entry[i][31:0]};
                    tail <= (i + 1) % 64; // Move tail to the entry right after the branch entry
                    rob_entry[(i+1)%64][98:0] <= 0; // Flush under tail entry
                    rob_entry[(i+2)%64][98:0] <= 0; // Fulsh under tail entry
  
                end
            end
      
        end else if (IF_ID_instOut != 32'b0) begin  // Only increment tail if the instruction is not invalid (i.e., not a bubble)
            rob_entry[tail] <= {1'b1, 1'b0, reg_write, 32'b0, IF_ID_instOut, PC}; // Store input data in the ROB entry with value set to 32'b0 and new_bit set to 1
            tail <= (tail + 1) % 64;                // Circular buffer handling
        end

        // Update the value and set ready flag upon execution completion
        if (alu_exec_done || mul_exec_done || div_exec_done) begin
            for (i = 0; i < 64; i = i + 1) begin
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
        
   rob_entry_out_0 <= rob_entry[0];
    rob_entry_out_1 <= rob_entry[1];
    rob_entry_out_2 <= rob_entry[2];
    rob_entry_out_3 <= rob_entry[3];
    rob_entry_out_4 <= rob_entry[4];
    rob_entry_out_5 <= rob_entry[5];
    rob_entry_out_6 <= rob_entry[6];
    rob_entry_out_7 <= rob_entry[7];
    rob_entry_out_8 <= rob_entry[8];
    rob_entry_out_9 <= rob_entry[9];
    rob_entry_out_10 <= rob_entry[10];
    rob_entry_out_11 <= rob_entry[11];
    rob_entry_out_12 <= rob_entry[12];
    rob_entry_out_13 <= rob_entry[13];
    rob_entry_out_14 <= rob_entry[14];
    rob_entry_out_15 <= rob_entry[15];
    rob_entry_out_16 <= rob_entry[16];
    rob_entry_out_17 <= rob_entry[17];
    rob_entry_out_18 <= rob_entry[18];
    rob_entry_out_19 <= rob_entry[19];
    rob_entry_out_20 <= rob_entry[20];
    rob_entry_out_21 <= rob_entry[21];
    rob_entry_out_22 <= rob_entry[22];
    rob_entry_out_23 <= rob_entry[23];
    rob_entry_out_24 <= rob_entry[24];
    rob_entry_out_25 <= rob_entry[25];
    rob_entry_out_26 <= rob_entry[26];
    rob_entry_out_27 <= rob_entry[27];
    rob_entry_out_28 <= rob_entry[28];
    rob_entry_out_29 <= rob_entry[29];
    rob_entry_out_30 <= rob_entry[30];
    rob_entry_out_31 <= rob_entry[31];
    rob_entry_out_32 <= rob_entry[32];
    rob_entry_out_33 <= rob_entry[33];
    rob_entry_out_34 <= rob_entry[34];
    rob_entry_out_35 <= rob_entry[35];
    rob_entry_out_36 <= rob_entry[36];
    rob_entry_out_37 <= rob_entry[37];
    rob_entry_out_38 <= rob_entry[38];
    rob_entry_out_39 <= rob_entry[39];
    rob_entry_out_40 <= rob_entry[40];
    rob_entry_out_41 <= rob_entry[41];
    rob_entry_out_42 <= rob_entry[42];
    rob_entry_out_43 <= rob_entry[43];
    rob_entry_out_44 <= rob_entry[44];
    rob_entry_out_45 <= rob_entry[45];
    rob_entry_out_46 <= rob_entry[46];
    rob_entry_out_47 <= rob_entry[47];
    rob_entry_out_48 <= rob_entry[48];
    rob_entry_out_49 <= rob_entry[49];
    rob_entry_out_50 <= rob_entry[50];
    rob_entry_out_51 <= rob_entry[51];
    rob_entry_out_52 <= rob_entry[52];
    rob_entry_out_53 <= rob_entry[53];
    rob_entry_out_54 <= rob_entry[54];
    rob_entry_out_55 <= rob_entry[55];
    rob_entry_out_56 <= rob_entry[56];
    rob_entry_out_57 <= rob_entry[57];
    rob_entry_out_58 <= rob_entry[58];
    rob_entry_out_59 <= rob_entry[59];
    rob_entry_out_60 <= rob_entry[60];
    rob_entry_out_61 <= rob_entry[61];
    rob_entry_out_62 <= rob_entry[62];
    rob_entry_out_63 <= rob_entry[63];
    end
end

// Output logic
always @(posedge clk) begin
    if (rob_entry[head][97]) begin       // Check if the entry is ready
        out_value <= rob_entry[head][95:64];     // Output value
        out_dest <= rob_entry[head][43:39];      // Extract out_dest from instr[11:7]
        out_reg_write <= rob_entry[head][96];   // Output RegWrite status
        rob_entry[head] <= 0;            // Clear the ready flag after consuming the entry
        head <= (head + 1) % 64;                 // Circular buffer handling
    end
    
end

endmodule
