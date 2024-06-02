`timescale 1ns / 1ps

module CPU_top_tb;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [31:0] x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15;
    wire [31:0] x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31;

    // Instantiate the Unit Under Test (UUT)
    CPU_top uut (
        .clk(clk), 
        .rst(rst), 
        .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .x8(x8), .x9(x9), .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14), .x15(x15),
        .x16(x16), .x17(x17), .x18(x18), .x19(x19), .x20(x20), .x21(x21), .x22(x22), .x23(x23),
        .x24(x24), .x25(x25), .x26(x26), .x27(x27), .x28(x28), .x29(x29), .x30(x30), .x31(x31)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;

        // Wait 10 ns for global reset to finish
        #10;
        
        // Deassert reset
        rst = 0;

        // Add stimulus here
        // Example: Apply some input stimuli and observe the outputs
        
        // Run the simulation for a certain period
        #1000;
        
        // Finish simulation
        $finish;
    end
    
    // Clock generator
    always #5 clk = ~clk;

endmodule
