module physical_register_file (
    input clk,
    input reset,
    input [7:0] Operand1_phy,
    input [7:0] Operand2_phy,
    input [7:0] Rd_phy, 

    input ALU_add_Write,
    input ALU_load_Write,
    input ALU_mul_Write,
    input ALU_div_Write,
    input ALU_done_Write,
    input [31:0] ALU_add_Data,
    input [31:0] ALU_load_Data,
    input [31:0] ALU_mul_Data,
    input [31:0] ALU_div_Data,
    input [31:0] ALU_done_Data,
    input [7:0] ALU_add_phy,
    input [7:0] ALU_load_phy,
    input [7:0] ALU_mul_phy,
    input [7:0] ALU_div_phy,
    input [7:0] ALU_done_phy,

    input [7:0] Operand1_phy_ALU,
    input [7:0] Operand2_phy_ALU,
    input [7:0] Operand1_phy_MUL,
    input [7:0] Operand2_phy_MUL,
    input [7:0] Operand1_phy_DIV,
    input [7:0] Operand2_phy_DIV,
    input [7:0] Operand1_phy_branch,
    input [7:0] Operand2_phy_branch,

    output reg [31:0] Operand1_data_ALU,
    output reg [31:0] Operand2_data_ALU,
    output reg [31:0] Operand1_data_MUL,
    output reg [31:0] Operand2_data_MUL,
    output reg [31:0] Operand1_data_DIV,
    output reg [31:0] Operand2_data_DIV,
    output reg [31:0] Operand1_data_branch,
    output reg [31:0] Operand2_data_branch,

    output reg [31:0] Operand1_data,
    output reg [31:0] Operand2_data,
    output reg valid1,
    output reg valid2
);


   (* keep = "true" *) reg [31:0] registers [0:255];
   (* keep = "true" *) reg valid [0:255];
   (* keep = "true" *) integer i;




always @(posedge clk) begin         

   if (reset) begin
       for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= i;
            valid[i] <= 1'b1; 
        end
       for (i = 32; i < 256; i = i + 1) begin
            registers[i] <= 32'h00000000;
           valid[i] <= 1'b1; 
        end
    end else begin
    
        if (ALU_add_Write == 1'b1 && ALU_add_phy != 7'b0) begin
            registers[ALU_add_phy] <= ALU_add_Data;
            valid[ALU_add_phy] <= 1'b1; 
        end
        if (ALU_load_Write == 1'b1 && ALU_load_phy != 7'b0) begin
            registers[ALU_load_phy] <= ALU_load_Data;
            valid[ALU_load_phy] <= 1'b1; 
        end
        if (ALU_mul_Write == 1'b1 && ALU_mul_phy != 7'b0) begin
            registers[ALU_mul_phy] <= ALU_mul_Data;
            valid[ALU_mul_phy] <= 1'b1; 
        end
        if (ALU_div_Write == 1'b1 && ALU_div_phy != 7'b0) begin
            registers[ALU_div_phy] <= ALU_div_Data;
            valid[ALU_div_phy] <= 1'b1; 
        end
        if (ALU_done_Write == 1'b1 && ALU_done_phy != 7'b0) begin
            registers[ALU_done_phy] <= ALU_done_Data;
            valid[ALU_done_phy] <= 1'b1; 
        end
        if (Rd_phy != 7'b0) begin
        valid[Rd_phy] <= 1'b0;
        end
    end
end




        Operand1_data = registers[Operand1_phy];   
        Operand2_data = registers[Operand2_phy];
        valid1 = valid[Operand1_phy];
        valid2 = valid[Operand2_phy];

 
        Operand1_data_ALU = registers[Operand1_phy_ALU];
        Operand2_data_ALU = registers[Operand2_phy_ALU];

    
    // Update MUL operands
    
        Operand1_data_MUL = registers[Operand1_phy_MUL];
        Operand2_data_MUL = registers[Operand2_phy_MUL];

   
    
    // Update DIV operands
    
        Operand1_data_DIV = registers[Operand1_phy_DIV];
        Operand2_data_DIV = registers[Operand2_phy_DIV];

    
    
    // Update Branch operands
    
        Operand1_data_branch = registers[Operand1_phy_branch];
        Operand2_data_branch = registers[Operand2_phy_branch];

    


endmodule 
