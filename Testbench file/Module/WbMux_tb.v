`timescale 1ns / 1ps

module WbMux_tb;
    reg [31:0] Address_tb;
    reg [31:0] RData_tb;
    reg wm2reg_tb;
    wire [31:0] mem_out_tb;

    WbMux uut (
        .Address(Address_tb), 
        .RData(RData_tb), 
        .wm2reg(wm2reg_tb), 
        .mem_out(mem_out_tb)
    );

    initial begin
        $monitor("Time = %d, Address = %h, RData = %h, wm2reg = %b, mem_out = %h", $time, Address_tb, RData_tb, wm2reg_tb, mem_out_tb);
      
        Address_tb = 32'hAAAA_BBBB;
        RData_tb = 32'hCCCC_DDDD;
        wm2reg_tb = 0;
        #10; 

        wm2reg_tb = 1;
        #10; 

        Address_tb = 32'h1234_5678;
        RData_tb = 32'h8765_4321;
        wm2reg_tb = 0;
        #10; 
        
        wm2reg_tb = 1;
        #10; 

        $finish; 
    end
