module register_file (clk, Rs1, Rs2, MEM_WB_RegWrite, Write_Data, RD, RData1, RData2);
    input clk;   
    input [4:0] Rs1;
    input [4:0] Rs2;
    input MEM_WB_RegWrite;
    input [31:0] Write_Data;
    input [4:0] RD;
    
    reg [31:0] registers [0:31];
    
    output reg [31:0] RData1;
    output reg [31:0] RData2;
    
    initial begin 
        registers[0] = 32'h00000000;
        registers[1] = 32'h00000001; // x1
        registers[2] = 32'h00000002; // x2
        registers[3] = 32'h00000003; // x3
        registers[4] = 32'h00000004; // x4
        registers[5] = 32'h00000005; // x5
        registers[6] = 32'h00000006; // x6
        registers[7] = 32'h00000007; // x7
        registers[8] = 32'h00000008; // x8
        registers[9] = 32'h00000009; // x9
        registers[10] = 32'h0000000A; // x10
        registers[11] = 32'h0000000B; // x11
        registers[12] = 32'h0000000C; // x12
        registers[13] = 32'h0000000D; // x13
        registers[14] = 32'h0000000E; // x14
        registers[15] = 32'h0000000F; // x15
        registers[16] = 32'h00000010; // x16
        registers[17] = 32'h00000011; // x17
        registers[18] = 32'h00000012; // x18
        registers[19] = 32'h00000013; // x19
        registers[20] = 32'h00000014; // x20
        registers[21] = 32'h00000015; // x21
        registers[22] = 32'h00000016; // x22
        registers[23] = 32'h00000017; // x23
        registers[24] = 32'h00000018; // x24
        registers[25] = 32'h00000019; // x25
        registers[26] = 32'h0000001A; // x26
        registers[27] = 32'h0000001B; // x27
        registers[28] = 32'h0000001C; // x28
        registers[29] = 32'h0000001D; // x29
        // x30 and x31 can be left as 0 or set to another value
        registers[30] = 32'h0000001E; // x30
        registers[31] = 32'h0000001F; // x31
    end
    
    always @(posedge clk) begin
        if (MEM_WB_RegWrite == 1'b1 && RD != 5'b0) begin
            registers[RD] <= Write_Data;
        end
    end

    always @(*) begin
        RData1 = (Rs1 != 5'b0) ? registers[Rs1] : 32'b0;
        RData2 = (Rs2 != 5'b0) ? registers[Rs2] : 32'b0;
    end
endmodule
