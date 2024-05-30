module register_file (
    input clk,
    input reset, // reset 신호 추가
    input [6:0] Ps1,          
    input [6:0] Ps2,          
    input MEM_WB_RegWrite,
    input [31:0] Write_Data,
    input [6:0] PD,          
    output reg [31:0] PData1,
    output reg [31:0] PData2
);
    reg [31:0] registers [0:127]; 
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= i;
            end
            for (i = 32; i < 128; i = i + 1) begin
                registers[i] <= 32'h00000000;
            end
        end else if (MEM_WB_RegWrite == 1'b1 && PD != 7'b0) begin
            registers[PD] <= Write_Data;
        end
    end

    always @(*) begin
        PData1 = (Ps1 != 7'b0) ? registers[Ps1] : 32'b0;
        PData2 = (Ps2 != 7'b0) ? registers[Ps2] : 32'b0;
    end
endmodule
