module ROB(
    input wire clk,                      // Clock signal
    input wire rst,                      // Reset signal
    input wire [31:0] IF_ID_instOut,     // Input instruction (expanded to 32 bits)
    input wire reg_write,                // Register write enable signal from the decode stage
    input wire [31:0] PC,                // Current PC value (expanded to 32 bits)
    input wire MemWrite,
    input wire [31:0] IF_ID_PC,
    input wire mret_inst,
    input wire ID_exception,
    input wire Address_exception,
    input wire [31:0] CSR_inst_num,
    input wire ROB_Flush,
    
    input wire alu_exec_done,            // ALU execution completion signal
    input wire [31:0] alu_exec_value,    // ALU executed value
    input wire [31:0] alu_exec_PC,       // ALU execution index

    input wire mul_exec_done,            // Multiplier execution completion signal
    input wire [31:0] mul_exec_value,    // Multiplier executed value
    input wire [31:0] mul_exec_PC,       // Multiplier execution index

    input wire div_exception,
    input wire div_exec_done,            // Divider execution completion signal
    input wire [31:0] div_exec_value,    // Divider executed value
    input wire [31:0] div_exec_PC,       // Divider execution index
    
    input wire PcSrc,                    // Branch signal (acts like a done signal)
    input wire [31:0] PC_Return,         // Jump address
    input wire [31:0] branch_index,      // Branch index in ROB
    input wire BR_Done,                

    input wire P_Done,
    input wire [31:0] P_Data,
    input wire [31:0] P_inst_num,

    input wire Load_Done,
    input wire MemRead,
    input wire [31:0] Store_Addr,
    input wire [31:0] Load_Data,
    input wire [31:0] Load_inst_num,

    input wire CSR_Done,
    input wire [31:0] CSR_Data,
    
    output reg [31:0] EPC,
    output reg [31:0] out_value,         // Output value
    output reg [4:0] out_dest,           // Output register destination extracted from instr[11:7]
    output reg out_reg_write,            // Output RegWrite signal to indicate a register write operation
    output reg [31:0] out_Addr,
    output reg out_MemWrite,
    output reg ROB_MemRead,
    output reg exception_sig,
    output reg mret_sig,
    output reg [1:0] exception_cause,
    output reg [2:0] ROB_funct3,
    output reg [31:0] out_inst_num
);

// ROB memory
    reg [136:0] rob_entry [0:63];            // ROB entry: new_bit(1), ready(1), reg_write(1), value(32), instr(32), PC(32)
    reg [31:0] Store_Addrs [0:63];
    reg [5:0] head;                        // Head pointer (5 bits for 32 entries)
    reg [5:0] tail;                        // Tail pointer (5 bits for 32 entries)
    integer i;

// Reset ROB entries
task reset_rob_entries;
    begin
        for (i = 0; i < 64; i = i + 1) begin
            rob_entry[i] <= 137'b0;     // Reset ROB entry with all fields set to 0
            Store_Addrs[i] <= 32'b0;
        end
    end
endtask

// ROB control logic
always @(posedge clk) begin
    if (rst | ROB_Flush) begin
        head <= 0;
        tail <= 0;
        exception_sig <= 0;
        mret_sig <= 0;
        reset_rob_entries();
    end else begin
         for (i = 0; i < 64; i = i + 1) begin
                if (rob_entry[i][98]) begin // Check if the new bit is set to 1
                    if ( alu_exec_done &&rob_entry[i][31:0] == alu_exec_PC) begin
                        rob_entry[i][136:0] <= {rob_entry[i][136],2'b00, rob_entry[i][133], rob_entry[i][132:101], rob_entry[i][100], rob_entry[i][99], rob_entry[i][98], 1'b1, rob_entry[i][96], alu_exec_value, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC
                    end
                    if ( mul_exec_done && rob_entry[i][31:0] == mul_exec_PC) begin
                        rob_entry[i][136:0] <= {rob_entry[i][136], 2'b00, rob_entry[i][133], rob_entry[i][132:101], rob_entry[i][100], rob_entry[i][99], rob_entry[i][98], 1'b1, rob_entry[i][96], mul_exec_value, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC       
                    end
                    if ( div_exec_done &&rob_entry[i][31:0] == div_exec_PC) begin
                        if (div_exception == 1'b1) begin
                            rob_entry[i][136:0] <= {rob_entry[i][136], 2'b01, rob_entry[i][133], rob_entry[i][132:101], rob_entry[i][100], 1'b1, rob_entry[i][98], 1'b1, rob_entry[i][96], div_exec_value, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC  
                        end else begin
                            rob_entry[i][136:0] <= {rob_entry[i][136], 2'b00,rob_entry[i][133], rob_entry[i][132:101], rob_entry[i][100], rob_entry[i][99], rob_entry[i][98], 1'b1, rob_entry[i][96], div_exec_value, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC     
                        end
                    end
                    if ( BR_Done&& rob_entry[i][31:0] == branch_index) begin
                        rob_entry[i][136:0] <= {2'b00,rob_entry[i][133], rob_entry[i][132:101], rob_entry[i][100], rob_entry[i][99], rob_entry[i][98], 1'b1, rob_entry[i][96], PC_Return, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC
                    end
                    if ( P_Done&& rob_entry[i][31:0] == P_inst_num) begin
                        rob_entry[i][136:0] <= {rob_entry[i][136], 2'b00,rob_entry[i][133], rob_entry[i][132:101], rob_entry[i][100], rob_entry[i][99], rob_entry[i][98], 1'b1, rob_entry[i][96], P_Data, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC
                    end
                    if ( Load_Done&& rob_entry[i][31:0] == Load_inst_num) begin
                        if (Address_exception == 1'b1)begin
                            rob_entry[i][136:0] <= {rob_entry[i][136], 2'b11, rob_entry[i][133], rob_entry[i][132:101], rob_entry[i][100], 1'b1, rob_entry[i][98], 1'b1, rob_entry[i][96], Load_Data, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC
                            Store_Addrs[i][31:0] <= Store_Addr;
                        end else begin
                            rob_entry[i][136:0] <= {rob_entry[i][136], 2'b00, rob_entry[i][133], rob_entry[i][132:101], rob_entry[i][100], rob_entry[i][99], rob_entry[i][98], 1'b1, rob_entry[i][96], Load_Data, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC
                            Store_Addrs[i][31:0] <= Store_Addr;
                        end
                    end
                    if ( CSR_Done&& rob_entry[i][31:0] == CSR_inst_num) begin
                        rob_entry[i][136:0] <= {rob_entry[i][136], 2'b00, rob_entry[i][133], rob_entry[i][132:101], rob_entry[i][100], rob_entry[i][99], rob_entry[i][98], 1'b1, rob_entry[i][96], CSR_Data, rob_entry[i][63:32], rob_entry[i][31:0]}; // Update value and maintain new_bit, reg_write, instr, PC
                    end
                end
            end
        if (PcSrc) begin
            // Update the branch entry with PC_Return value
            for (i = 0; i < 64; i = i + 1) begin
                if (rob_entry[i][31:0] == branch_index) begin
                    rob_entry[i][136:0] <= {rob_entry[i][136], rob_entry[i][135:134], rob_entry[i][133],rob_entry[i][132:101],rob_entry[i][100], rob_entry[i][99], rob_entry[i][98], 1'b1, rob_entry[i][96], PC_Return, rob_entry[i][63:32], rob_entry[i][31:0]};
                    tail <= (i + 1) % 64; // Move tail to the entry right after the branch entry
                    rob_entry[(i+1)%64][136:0] <= 0; // Flush under tail entry
                    rob_entry[(i+2)%64][136:0] <= 0; // Fulsh under tail entry
  
                end
            end
        end else if (IF_ID_instOut != 32'b0) begin  // Only increment tail if the instruction is not invalid (i.e., not a bubble)
            if (ID_exception == 1'b0) begin
                if (mret_inst == 1'b1) begin
                    rob_entry[tail] <= {MemRead, 2'b00,mret_inst, IF_ID_PC, MemWrite, 1'b0, 1'b1, 1'b1, reg_write, 32'b0, IF_ID_instOut, PC}; // Store input data in the ROB entry with value set to 32'b0 and new_bit set to 1 [99]는 exceptionflag
                    tail <= (tail + 1) % 64;                // Circular buffer handling
                end else begin
                    rob_entry[tail] <= {MemRead, 2'b00,mret_inst, IF_ID_PC, MemWrite, 1'b0, 1'b1, 1'b0, reg_write, 32'b0, IF_ID_instOut, PC}; // Store input data in the ROB entry with value set to 32'b0 and new_bit set to 1 [99]는 exceptionflag
                    tail <= (tail + 1) % 64;                // Circular buffer handling
                end
            end else begin
                rob_entry[tail] <= {MemRead, 2'b00,mret_inst, IF_ID_PC, MemWrite, 1'b1, 1'b1, 1'b1, reg_write, 32'b0, IF_ID_instOut, PC}; // Store input data in the ROB entry with value set to 32'b0 and new_bit set to 1 [99]는 exceptionflag
                tail <= (tail + 1) % 64;                // Circular buffer handling
            end
        end

        
        // Update the value and set ready flag upon execution completion
        
           
        
            if (rob_entry[head][97]) begin       // Check if the entry is ready
                if (rob_entry[head][99] == 1'b0) begin
                    if(rob_entry[head][133] == 1'b1) begin
                        mret_sig <= 1'b1;
                        out_reg_write <= 0;
                        ROB_MemRead <= 0;
                        out_MemWrite <= 0;
                    end else begin
                        out_value <= rob_entry[head][95:64];     // Output value
                        out_dest <= rob_entry[head][43:39];      // Extract out_dest from instr[11:7]
                        ROB_funct3 <= rob_entry[head][46:44]; //ROB_funct3 from instr[14:12]
                        out_reg_write <= rob_entry[head][96];   // Output RegWrite status
                        out_Addr <= Store_Addrs[head][31:0];
                        out_MemWrite <= rob_entry[head][100];
                        ROB_MemRead <= rob_entry [head] [136];
                        out_inst_num <= rob_entry[head][31:0];
                        exception_sig <= 1'b0;
                        mret_sig <= 1'b0;
                        rob_entry[head] <= 0;            // Clear the ready flag after consuming the entry
                        Store_Addrs[head] <= 32'd0;
                        head <= (head + 1) % 64;                 // Circular buffer handling
                    end
                end else begin
                    exception_sig <= 1'b1;
                    mret_sig <= 1'b0;
                    exception_cause <= rob_entry[head][135:134];
                    EPC <= rob_entry[head][132:101];
                    out_reg_write <= 0; 
                    head <= 0;
                    tail <= 0;
                    reset_rob_entries();
                end
            end else begin
                    out_value <= 0;     // Output value
                    out_dest <= 0;      // Extract out_dest from instr[11:7]
                    out_reg_write <= 0;   // Output RegWrite status
                    out_Addr <= 32'd0;
                    out_MemWrite <= 0;
                    out_inst_num <=0;
                    ROB_funct3 <= 0;
                    exception_sig <= 0;
                    mret_sig <= 0;
                    ROB_MemRead <= 0;
            end
     end



end

endmodule
