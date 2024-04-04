module WbMux (Address, RData, wm2reg, mem_out);
        input [31:0] Address;
        input [31:0] RData;
        input wm2reg;
        output reg [31:0] mem_out;
        
        always@(*) begin
            if (wm2reg == 1) begin
                mem_out <= RData;
            end
            else if (wm2reg == 0) begin
                mem_out <= Address;
            end
        end
endmodule
