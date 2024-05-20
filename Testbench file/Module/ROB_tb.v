module ROB_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] instr;
    reg reg_write;
    reg [6:0] phys_addr;
    reg exec_done;
    reg [31:0] exec_value;
    reg [9:0] exec_index;
    reg [31:0] mul_exec_value;
    reg mul_exec_done;
    reg PcSrc;
    reg [9:0] PC_Branch;
    reg [9:0] PC;

    // Outputs
    wire [31:0] out_value;
    wire [4:0] out_dest;
    wire [6:0] out_phys_addr;
    wire out_reg_write;

    // Instantiate the ReorderBuffer module
    ROB uut (
        .clk(clk), 
        .rst(rst), 
        .instr(instr), 
        .reg_write(reg_write), 
        .phys_addr(phys_addr), 
        .exec_done(exec_done), 
        .exec_value(exec_value), 
        .exec_index(exec_index), 
        .mul_exec_value(mul_exec_value), 
        .mul_exec_done(mul_exec_done), 
        .PcSrc(PcSrc), 
        .PC_Branch(PC_Branch), 
        .PC(PC), 
        .out_value(out_value), 
        .out_dest(out_dest), 
        .out_phys_addr(out_phys_addr), 
        .out_reg_write(out_reg_write)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Stimulus
    initial begin
        // Initialize inputs
        rst = 1;
        instr = 0;
        reg_write = 0;
        phys_addr = 0;
        exec_done = 0;
        exec_value = 0;
        exec_index = 0;
        mul_exec_value = 0;
        mul_exec_done = 0;
        PcSrc = 0;
        PC_Branch = 0;
        PC = 0;

        // Reset sequence
        #10;
        rst = 0;

        // Test case 1: Insert instruction into ROB

        instr = 32'h0000_1234;
        reg_write = 1;
        phys_addr = 7'b000_0001;
        PC = 10'b0000_0000_01;
        #10;
        instr = 32'h0000_5678;
        reg_write = 1;
        phys_addr = 7'b000_0010;
        PC = 10'b0000_0000_10;

        // Test case 2: Execution done and update ROB entry
        #20;
        exec_done = 1;
        exec_index = 10'b0000_0000_01;
        exec_value = 32'hABCD_EF01;
        #10;
        exec_done = 0;

        // Test case 3: Branch taken
        #20;
        PcSrc = 1;
        PC_Branch = 10'b0000_0000_01;
        #10;
        PcSrc = 0;

        // Test case 4: Multiplier execution done
        #20;
        mul_exec_done = 1;
        exec_index = 10'b0000_0000_10;
        mul_exec_value = 32'h1234_5678;
        #10;
        mul_exec_done = 0;

        // Wait for a few cycles to observe the output
        #50;
        $stop;
    end

endmodule
