module DataMemory(
    input wire clk,
    input wire reset,
    input wire LS_MemRead,
    input wire LS_MemWrite,
    input wire [31:0] LS_inst_num,
    input wire [2:0] funct3_LS,
    input wire [31:0] LS_Result,
    input wire [31:0] Operand2_LS,
    input wire [7:0] Load_phy_in,

    input wire exception_sig,
    input wire [31:0] ROB_Store_Addr,
    input wire [31:0] ROB_Store_Data,
    input wire ROB_MemWrite,
    
    output reg [31:0] Load_Data,
    output reg [31:0] Load_inst_num,
    output reg Load_Done,
    output reg [7:0]  Load_phy_out,
    output reg [31:0] Store_Address,
    output reg addr_exception
);
   (* keep = "true" *) integer i;
   (* keep = "true" *) reg [31:0] memory [0:2047];
   (* keep = "true" *) reg [31:0] backup_memory [0:2047]; // Backup memory for exception signal

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 2047; i = i + 1) begin
            memory[i] <= i + 3;
            backup_memory[i] <= i + 3;
        end
    end else if (exception_sig) begin
         for (i = 0; i < 2047; i = i + 1) begin
             memory[i] <= backup_memory[i]; // restore data from backup memory to memory
        end
    end else if (LS_Result >= 32'd2048) begin
            addr_exception <= 1'b1
            Load_Done <= LS_MemWrite;
    end else begin
        if (ROB_MemWrite) begin
            bakcup_memory[ROB_Store_Addr][31:0] <= ROB_Store_Data;
        end
        if (LS_MemWrite) begin
            if (funct3_LS == 3'b000) begin
                memory[LS_Result][7:0] <= Operand2_LS[7:0]; // SB
                Load_Data <= {{24{Operand2_LS[7]}}, Operand2_LS[7:0]}; // LB
                Load_inst_num <= LS_inst_num;
                Load_Done <= LS_MemWrite;
                Store_Address <= LS_Result;
                Load_phy_out <= 8'd160;
            end else if (funct3_LS == 3'b001) begin
                memory[LS_Result][15:0] <= Operand2_LS[15:0]; // SH
                Load_Data <= {{16{Operand2_LS[15]}}, Operand2_LS[15:0]}; // LB
                Load_inst_num <= LS_inst_num;
                Load_Done <= LS_MemWrite;
                Store_Address <= LS_Result;
                Load_phy_out <= 8'd160;
            end else if (funct3_LS == 3'b010) begin
                memory[LS_Result] <= Operand2_LS; // SW
                Load_Data <= Operand2_LS[31:0]}; // LB
                Load_inst_num <= LS_inst_num;
                Load_Done <= LS_MemWrite;
                Store_Address <= LS_Result;
                Load_phy_out <= 8'd160;
            end
        end

        
    end
end

    always @ (clk) begin
    // Default value for Load_Data, ensures it is always assigned
    if (reset) begin
            Load_Data <= 32'd0; // Default value assignment to handle cases when Load_Done is false or EX_MEM_funct3 is not matched
            Load_inst_num <=  32'd0;
            Load_Done <= 0;
    end else begin

    if (funct3_LS == 3'b000) begin
        Load_Data <= {{24{memory[LS_Result][31]}}, memory[LS_Result][7:0]}; // LB
        Load_inst_num <= LS_inst_num;
        Load_Done <= LS_MemRead;
        Load_phy_out <= Load_phy_in;
        end else if (funct3_LS == 3'b001) begin
            Load_Data <= {{16{memory[LS_Result][31]}}, memory[LS_Result][15:0]}; // LH
            Load_inst_num <= LS_inst_num;
            Load_Done <= LS_MemRead;
            Load_phy_out <= Load_phy_in;
        end else if (funct3_LS == 3'b010) begin
            Load_Data <= memory[LS_Result]; // LW
            Load_inst_num <= LS_inst_num;
            Load_Done <= LS_MemRead;
            Load_phy_out <= Load_phy_in;

        end else if (funct3_LS == 3'b100) begin
            Load_Data <= {{24{1'b0}}, memory[LS_Result][7:0]}; // LBU
            Load_inst_num <= LS_inst_num;
            Load_Done <= LS_MemRead;
            Load_phy_out <= Load_phy_in;

        end else if (funct3_LS == 3'b101) begin
            Load_Data <= {{16{1'b0}}, memory[LS_Result][15:0]}; // LHU
            Load_inst_num <= LS_inst_num;
            Load_Done <= LS_MemRead;
            Load_phy_out <= Load_phy_in;

        end else begin
            Load_Data <= 32'd0; // Default value assignment to handle cases when Load_Done is false or EX_MEM_funct3 is not matched
            Load_inst_num <=  32'd0;
            Load_Done <= 0;
            Load_phy_out <= 0;

        end
    end
    end

endmodule
