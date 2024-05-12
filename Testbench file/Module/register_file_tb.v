`timescale 1ns / 1ps

module register_file_tb;

    // Inputs
    reg clk;
    reg [4:0] Rs1;
    reg [4:0] Rs2;
    reg MEM_WB_RegWrite;
    reg [31:0] Write_Data;
    reg [4:0] RD;

    // Outputs
    wire [31:0] RData1;
    wire [31:0] RData2;

    // Instantiate the Unit Under Test (UUT)
    register_file uut (
        .clk(clk),
        .Rs1(Rs1), 
        .Rs2(Rs2), 
        .MEM_WB_RegWrite(MEM_WB_RegWrite), 
        .Write_Data(Write_Data), 
        .RD(RD), 
        .RData1(RData1), 
        .RData2(RData2)
    );

    // Clock generation
    always #10 clk = ~clk; // 50 MHz Clock

    // Test procedure
    initial begin
        // Initialize Inputs
        clk = 0;
        Rs1 = 0;
        Rs2 = 0;
        MEM_WB_RegWrite = 0;
        Write_Data = 0;
        RD = 0;

        // Wait for the global reset
        #100;

        // Write some data
        MEM_WB_RegWrite = 1; // Enable writing
        RD = 5;  Write_Data = 32'hAAAA_BBBB;  #20;
        RD = 10; Write_Data = 32'h1234_5678;  #20;
        RD = 15; Write_Data = 32'hDEAD_BEEF;  #20;
        MEM_WB_RegWrite = 0; // Disable writing

        // Read the written data
        Rs1 = 5;  Rs2 = 10; #20;
        Rs1 = 15; Rs2 = 5;  #20;

        // Finish test
        $finish;
    end

    // Optional: Display changes
    initial begin
        $monitor("Time=%t, Rs1=%d, RData1=%h, Rs2=%d, RData2=%h", $time, Rs1, RData1, Rs2, RData2);
    end

endmodule
