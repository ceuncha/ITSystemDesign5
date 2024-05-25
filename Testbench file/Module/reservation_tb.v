`timescale 1ns / 1ps

module test_reservation_station;

    // Inputs
    reg rst;
    reg rs_on;
    reg clk;
    reg stall;
    reg mem_write;

    reg alu_done_add;
    reg [31:0] alu_result_add;
    reg [6:0] alu_phy_reg_add;
    reg [6:0] alu_rs_add_add;
    
    reg alu_done_load;
    reg [31:0] alu_result_load;
    reg [6:0] alu_phy_reg_load;
    reg [6:0] alu_rs_add_load;
    
    reg alu_done_mul;
    reg [31:0] alu_result_mul;
    reg [6:0] alu_phy_reg_mul;
    reg [6:0] alu_rs_add_mul;
    
    reg alu_done_div;
    reg [31:0] alu_result_div;
    reg [6:0] alu_phy_reg_div;
    reg [6:0] alu_rs_add_div;

    reg in_branch_flag;
    reg [31:0] in_rd_data;
    reg [6:0] in_rd_phy;
    reg [4:0] in_rd_reg;
    reg in_done;
    reg [1:0] in_ready;
    reg [6:0] in_opcode;
    reg [2:0] in_func3;
    reg [9:0] in_control;
    reg [31:0] in_operand1;
    reg [31:0] in_operand2;
    reg [6:0] in_phy_add1;
    reg [6:0] in_phy_add2;
    reg [9:0] in_pc;
    reg [31:0] in_label;
    reg [6:0] branch_rs_add;
    reg branch_in;

    // Outputs
    wire [4:0] out_rs_add;
    wire [6:0] out_rd_phy;
    wire [4:0] out_rd_reg;
    wire [31:0] out_operand1;
    wire [31:0] out_operand2;
    wire [6:0] out_opcode;
    wire [2:0] out_func3;
    wire [9:0] out_control;
    wire [9:0] out_pc;
    wire out_execute_on;
    wire [31:0] out_label;
    wire out_branch_flag;

    // Instantiate the Unit Under Test (UUT)
    reservation_station uut (
        .rst(rst),
        .rs_on(rs_on),
        .clk(clk),
        .stall(stall),
        .mem_write(mem_write),
        .alu_done_add(alu_done_add),
        .alu_result_add(alu_result_add),
        .alu_phy_reg_add(alu_phy_reg_add),
        .alu_rs_add_add(alu_rs_add_add),
        .alu_done_load(alu_done_load),
        .alu_result_load(alu_result_load),
        .alu_phy_reg_load(alu_phy_reg_load),
        .alu_rs_add_load(alu_rs_add_load),
        .alu_done_mul(alu_done_mul),
        .alu_result_mul(alu_result_mul),
        .alu_phy_reg_mul(alu_phy_reg_mul),
        .alu_rs_add_mul(alu_rs_add_mul),
        .alu_done_div(alu_done_div),
        .alu_result_div(alu_result_div),
        .alu_phy_reg_div(alu_phy_reg_div),
        .alu_rs_add_div(alu_rs_add_div),
        .in_branch_flag(in_branch_flag),
        .in_rd_phy(in_rd_phy),
        .in_rd_reg(in_rd_reg),
        .in_done(in_done),
        .in_ready(in_ready),
        .in_opcode(in_opcode),
        .in_func3(in_func3),
        .in_control(in_control),
        .in_operand1(in_operand1),
        .in_operand2(in_operand2),
        .in_phy_add1(in_phy_add1),
        .in_phy_add2(in_phy_add2),
        .in_pc(in_pc),
        .in_label(in_label),
        .branch_rs_add(branch_rs_add),
        .branch_in(branch_in),
        .out_rs_add(out_rs_add),
        .out_rd_phy(out_rd_phy),
        .out_rd_reg(out_rd_reg),
        .out_operand1(out_operand1),
        .out_operand2(out_operand2),
        .out_opcode(out_opcode),
        .out_func3(out_func3),
        .out_control(out_control),
        .out_pc(out_pc),
        .out_execute_on(out_execute_on),
        .out_label(out_label),
        .out_branch_flag(out_branch_flag)
    );

    // Clock generation
    initial begin
        clk = 1;
        forever #10 clk = ~clk;
    end

    // Initialize inputs and define test sequences
    initial begin
        // Initialize Inputs
        rst =  1;
        rs_on = 0;
        mem_write = 0;
        alu_done_add = 0;
        alu_result_add = 0;
        alu_phy_reg_add = 0;
        alu_rs_add_add = 0;
        alu_done_load = 0;
        alu_result_load = 0;
        alu_phy_reg_load = 0;
        alu_rs_add_load = 0;
        alu_done_mul = 0;
        alu_result_mul = 0;
        alu_phy_reg_mul = 0;
        alu_rs_add_mul = 0;
        alu_done_div = 0;
        alu_result_div = 0;
        alu_phy_reg_div = 0;
        alu_rs_add_div = 0;
        in_branch_flag = 0;
        in_rd_phy = 0;
        in_rd_reg = 0;
        in_done = 0;
        in_ready = 0;
        in_opcode = 0;
        in_func3 = 0;
        in_control = 0;
        in_operand1 = 0;
        in_operand2 = 0;
        in_phy_add1 = 0;
        in_phy_add2 = 0;
        in_pc = 0;
        in_label = 0;
        branch_rs_add = 0;
        branch_in = 0;
        stall = 1;
        // Reset the UUT
;
        #20 rst = 0; stall=0;

        // Test sequence
        // 1st operation: ADD x1, x2, x3
        rs_on = 1;
        mem_write = 0;
        in_opcode = 7'b0110011; // R-type opcode
        in_func3 = 3'b000; // ADD
        in_rd_phy = 7'b0000001; // Physical register address for x1 (p1)
        in_rd_reg = 5'b00001; // Logical register address for x1
        in_operand1 = 32'd2; // Value of x2
        in_operand2 = 32'd3; // Value of x3
        in_phy_add1 = 7'b0000010; // Physical register address for x2 (p2)
        in_phy_add2 = 7'b0000011; // Physical register address for x3 (p3)
        in_ready = 2'b11; // Both operands ready
        in_done = 0;
        in_pc = 2'd00;

        #20 rs_on = 0;

        // 2nd operation: MUL x5, x1, x3
        rs_on = 1;
        in_opcode = 7'b0110011; // R-type opcode
        in_func3 = 3'b000; // MUL
        in_rd_phy = 7'b0000101; // Physical register address for x5 (p5)
        in_rd_reg = 5'b00101; // Logical register address for x5
        in_operand1 = 32'd1; // Value of x1
        in_operand2 = 32'd3; // Value of x3
        in_phy_add1 = 7'b0000001; // Physical register address for x1 (p1)
        in_phy_add2 = 7'b0000011; // Physical register address for x3 (p3)
        in_ready = 2'b10; // Both operands ready
        in_done = 0;
        in_pc = 2'd04;

        // ALU result for ADD (Available at the 2nd clock cycle)
        alu_done_add = 1;
        alu_result_add = 32'd5;
        alu_phy_reg_add = 7'b0000001;
        alu_rs_add_add = 7'b0000000;
        #10   alu_done_add = 0;
        #10 rs_on = 0;
 

        // 3rd operation: SUB x6, x1, x3
        rs_on = 1;
        in_opcode = 7'b0110011; // R-type opcode
        in_func3 = 3'b000; // SUB
        in_rd_phy = 7'b0000110; // Physical register address for x6 (p6)
        in_rd_reg = 5'b00110; // Logical register address for x6
        in_operand1 = 32'd5; // Value of x1
        in_operand2 = 32'd3; // Value of x3
        in_phy_add1 = 7'b0000001; // Physical register address for x1 (p1)
        in_phy_add2 = 7'b0000011; // Physical register address for x3 (p3)
        in_ready = 2'b10; // Both operands ready
        in_done = 0;
        in_pc = 2'd08;

        #20 rs_on = 0;

        // 4th operation: SUB x7, x5, x3
        rs_on = 1;
        in_opcode = 7'b0110011; // R-type opcode
        in_func3 = 3'b000; // SUB
        in_rd_phy = 7'b0000111; // Physical register address for x7 (p7)
        in_rd_reg = 5'b00111; // Logical register address for x7
        in_operand1 = 32'd5; // Value of x5
        in_operand2 = 32'd3; // Value of x3
        in_phy_add1 = 7'b0000101; // Physical register address for x5 (p5)
        in_phy_add2 = 7'b0000011; // Physical register address for x3 (p3)
        in_ready = 2'b10; // Both operands ready
        in_done = 0;
        in_pc = 2'd12;

        // ALU result for SUB x6 (Available at the 4th clock cycle)
        alu_done_add = 1;
        alu_result_add = 32'd2;
        alu_phy_reg_add = 7'b0000110;
        alu_rs_add_add = 2;

        #10   alu_done_add = 0;
        #10 rs_on = 0;

        // 5th operation: Load x8, x1, x2
        rs_on = 1;
        in_opcode = 7'b0000011; // Load opcode
        in_func3 = 3'b010; // Load function
        in_rd_phy = 7'b0001000; // Physical register address for x8 (p8)
        in_rd_reg = 5'b01000; // Logical register address for x8
        in_operand1 = 32'd5; // Value of x1
        in_operand2 = 32'd2; // Value of x2 (offset)
        in_phy_add1 = 7'b0000001; // Physical register address for x1 (p1)
        in_phy_add2 = 7'b0000010; // Physical register address for x2 (p2)
        in_ready = 2'b10; // Both operands ready
        in_done = 0;
        in_pc = 2'd16;

        // ALU result for SUB x7 (Available at the 5th clock cycle)
        alu_done_add = 1;
        alu_result_add = 32'd12;
        alu_phy_reg_add = 7'b0000111;
        alu_rs_add_add = 3;

        // ALU result for MUL (Available at the 3rd clock cycle)
        alu_done_mul = 1;
        alu_result_mul = 32'd15;
        alu_phy_reg_mul = 7'b0000101;
        alu_rs_add_mul = 1;

        #10   alu_done_add = 0;
              alu_done_mul = 0;
        #10 rs_on = 0;

        // 6th operation: ADD x9, x7, x3
        rs_on = 1;
        in_opcode = 7'b0110011; // R-type opcode
        in_func3 = 3'b000; // ADD
        in_rd_phy = 7'b0001001; // Physical register address for x9 (p9)
        in_rd_reg = 5'b01001; // Logical register address for x9
        in_operand1 = 32'd12; // Value of x7
        in_operand2 = 32'd3; // Value of x3
        in_phy_add1 = 7'b0000111; // Physical register address for x7 (p7)
        in_phy_add2 = 7'b0000011; // Physical register address for x3 (p3)
        in_ready = 2'b10; // Both operands ready
        in_done = 0;
        in_pc = 2'd20;

        #10   alu_done_add = 0;

        #10 rs_on = 0;

        // ALU result for Load x8 (Available at the 7th clock cycle)
        alu_done_load = 1;
        alu_result_load = 32'd7;
        alu_phy_reg_load = 7'b0001000;
        alu_rs_add_load = 4;

        // ALU result for Add x9 (Available at the 8th clock cycle)
        alu_done_add = 1;
        alu_result_add = 32'd15;
        alu_phy_reg_add = 7'b0001001;
        alu_rs_add_add = 5;

        #10   alu_done_add = 0;
              alu_done_load = 0;
        #10 rs_on = 0;



        // End of simulation
        #200 $finish;
    end
      
endmodule
