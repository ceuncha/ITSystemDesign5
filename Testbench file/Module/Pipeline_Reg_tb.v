`timescale 1ns / 1ps

module testbench();

    reg clk;
    reg IF_ID_Stall, IF_ID_Flush;
    reg [31:0] instOut, PC;
    wire [31:0] IF_ID_instOut, IF_ID_PC;

    // Instantiate the pipeline register module
    ifid_pipeline_register dut(
        .clk(clk),
        .IF_ID_Stall(IF_ID_Stall),
        .IF_ID_Flush(IF_ID_Flush),
        .instOut(instOut),
        .PC(PC),
        .IF_ID_instOut(IF_ID_instOut),
        .IF_ID_PC(IF_ID_PC)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #7.5 clk = ~clk;  // 15 ns cycle time
    end

    // Initial setup and test cases
    initial begin
        // Reset all inputs
        IF_ID_Stall = 0;
        IF_ID_Flush = 0;
        instOut = 0;
        PC = 0;

        // Apply initial stimulus after a brief delay
        #10;
        PC = 32'h00000000;
        instOut = 32'h12345678; // Example instruction code
        IF_ID_Stall = 0;
        IF_ID_Flush = 0;

        // Test flushing the pipeline
        #15;
        IF_ID_Flush = 1;
        #15;
        IF_ID_Flush = 0;

        // Test stalling the pipeline
        #30;
        IF_ID_Stall = 1;
        #15;
        IF_ID_Stall = 0;

        // More scenarios can be added here
    end

    // Monitor changes
    initial begin
        $monitor("Time = %t, IF_ID_instOut = %h, IF_ID_PC = %h", $time, IF_ID_instOut, IF_ID_PC);
    end

endmodule
