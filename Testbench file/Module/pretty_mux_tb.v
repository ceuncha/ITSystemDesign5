`timescale 1ns / 1ps

module pretty_mux_tb;

    reg [31:0] mem_out_tb;
    reg [31:0] MEM_WB_Rd_data_tb;
    reg MEM_WB_RWSet_tb;
    wire [31:0] Write_Data_tb;

    pretty_mux uut (
        .mem_out(mem_out_tb),
        .MEM_WB_Rd_data(MEM_WB_Rd_data_tb),
        .MEM_WB_RWSet(MEM_WB_RWSet_tb),
        .Write_Data(Write_Data_tb)
    );

    initial begin
      
        $monitor("Time = %d, mem_out = %h, MEM_WB_Rd_data = %h, MEM_WB_RWSet = %b, Write_Data = %h", $time, mem_out_tb, MEM_WB_Rd_data_tb, MEM_WB_RWSet_tb, Write_Data_tb);

        mem_out_tb = 32'hAAAA_BBBB;
        MEM_WB_Rd_data_tb = 32'hCCCC_DDDD;
        MEM_WB_RWSet_tb = 0;
        #10; 

        MEM_WB_RWSet_tb = 1;
        #10;

        mem_out_tb = 32'h1234_5678;
        MEM_WB_Rd_data_tb = 32'h8765_4321;
        MEM_WB_RWSet_tb = 0;
        #10;

        MEM_WB_RWSet_tb = 1;
        #10; 

        $finish; 
    end

endmodule
