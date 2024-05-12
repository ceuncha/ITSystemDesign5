`timescale 1ns / 1ps

module data_memory_tb;
    reg clk;
    reg [31:0] Address;
    reg [31:0] Write_Data;
    reg EX_MEM_MemWrite_MemRead;
    wire [31:0] RData;

    data_memory dut (
        .clk(clk),
        .Address(Address),
        .Write_Data(Write_Data),
        .EX_MEM_MemWrite_MemRead(EX_MEM_MemWrite_MemRead),
        .RData(RData)
    );
  
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        Address = 0;
        Write_Data = 0;
        EX_MEM_MemWrite_MemRead = 0;
        #10; 
      
        Address = 32'h0;
        EX_MEM_MemWrite_MemRead = 0;
        #5;
      
        $display("Read: Memory[%d] = %h", Address, RData);
        Address = 32'h4;
        Write_Data = 32'h11223344;
        EX_MEM_MemWrite_MemRead = 1;
        #5;
      
        $display("Write: Memory[%d] = %h", Address, Write_Data);
        Address = 32'h4;
        EX_MEM_MemWrite_MemRead = 0;
        #5;
      
        $display("Read after Write: Memory[%d] = %h", Address, RData);
        $stop;
    end

endmodule
