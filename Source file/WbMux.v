module WbMux (MEM_WB_ALUResult, MEM_WB_RData, MEM_WB_MemToReg, alu_exec_value);
        input [31:0] MEM_WB_ALUResult;
        input [31:0] MEM_WB_RData;
        input MEM_WB_MemToReg;
        output reg [31:0] alu_exec_value;
        
        always@(*) begin
            if (MEM_WB_MemToReg == 1) begin
                alu_exec_value <= MEM_WB_RData;
            end
            else if (MEM_WB_MemToReg == 0) begin
                alu_exec_value <= MEM_WB_ALUResult;
            end
        end
endmodule
