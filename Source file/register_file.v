module register_file (clk, Rs1, Rs2, MeM_WB_RegWrite, Write_Data, RD, RData1, RData2);
    input clk;   
    input [4:0] Rs1;
    input [4:0] Rs2;
    input MeM_WB_RegWrite;
    input Write_Data;
    input RD;
    
    reg [31:0] registers [0:31];
    
    output reg [31:0] RData1;
    output reg [31:0] RData2;
    
    integer i;
    
    initial begin 
        for (i=0; i<32; i=i+1)
        begin 
            registers[i] <= 32'b0;
        end
    end
    
    always @(*) begin
        RData1 = registers[Rs1];
        RData2 = registers[Rs2];
    
        if (MeM_WB_RegWrite == 1) begin
            registers[RD] = Write_Data;
        end
    end
endmodule
