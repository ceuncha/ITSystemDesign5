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
    input BR_Write,
    input Pass_done,
    input CSR_done,
    
    input [31:0] ALU_add_Data,
    input [31:0] ALU_load_Data,
    input [31:0] ALU_mul_Data,
    input [31:0] ALU_div_Data,
    input [31:0] BR_Data,
    input [31:0] Pass_done_data,
    input [31:0] CSR_done_data,
    
    input [7:0] ALU_add_phy,
    input [7:0] ALU_load_phy,
    input [7:0] ALU_mul_phy,
    input [7:0] ALU_div_phy,
    input [7:0] BR_phy,
    input [7:0] Pass_done_phy,
    input [7:0] CSR_done_phy,
    
    input [7:0] Operand1_phy_ALU,
    input [7:0] Operand2_phy_ALU,
    input [7:0] Operand1_phy_MUL,
    input [7:0] Operand2_phy_MUL,
    input [7:0] Operand1_phy_DIV,
    input [7:0] Operand2_phy_DIV,
    input [7:0] Operand1_phy_branch,
    input [7:0] Operand2_phy_branch,
    input [7:0] Operand1_phy_LS,
    input [7:0] Operand2_phy_LS,
    input [7:0] Operand2_phy_CSR,

    input exception, // 추가된 exception 신호
    input mret_sig,
    input [31:0] x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15,
    input [31:0] x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31,

    output reg [31:0] Operand1_data_ALU,
    output reg [31:0] Operand2_data_ALU,
    output reg [31:0] Operand1_data_MUL,
    output reg [31:0] Operand2_data_MUL,
    output reg [31:0] Operand1_data_DIV,
    output reg [31:0] Operand2_data_DIV,
    output reg [31:0] Operand1_data_branch,
    output reg [31:0] Operand2_data_branch,
    output reg [31:0] Operand1_data_LS,
    output reg [31:0] Operand2_data_LS,
    output reg [31:0] Operand1_data_CSR,

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
   end else if (exception|mret_sig) begin
        // exception 신호가 들어오면 논리 레지스터의 데이터를 물리 레지스터로 복사
        registers[0] <= x0;
        registers[1] <= x1;
        registers[2] <= x2;
        registers[3] <= x3;
        registers[4] <= x4;
        registers[5] <= x5;
        registers[6] <= x6;
        registers[7] <= x7;
        registers[8] <= x8;
        registers[9] <= x9;
        registers[10] <= x10;
        registers[11] <= x11;
        registers[12] <= x12;
        registers[13] <= x13;
        registers[14] <= x14;
        registers[15] <= x15;
        registers[16] <= x16;
        registers[17] <= x17;
        registers[18] <= x18;
        registers[19] <= x19;
        registers[20] <= x20;
        registers[21] <= x21;
        registers[22] <= x22;
        registers[23] <= x23;
        registers[24] <= x24;
        registers[25] <= x25;
        registers[26] <= x26;
        registers[27] <= x27;
        registers[28] <= x28;
        registers[29] <= x29;
        registers[30] <= x30;
        registers[31] <= x31;

        for (i = 0; i < 32; i = i + 1) begin
            
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
        if (BR_Write == 1'b1 && BR_phy != 7'b0) begin
            registers[BR_phy] <= BR_Data;
            valid[BR_phy] <= 1'b1; 
        end
        if (Pass_done == 1'b1 && Pass_done_phy != 7'b0) begin
            registers[Pass_done_phy] <= Pass_done_data;
            valid[Pass_done_phy] <= 1'b1; 
        end
        if (CSR_done == 1'b1 && CSR_done_phy != 7'b0) begin
            registers[CSR_done_phy] <= CSR_done_data;
            valid[CSR_done_phy] <= 1'b1; 
        end
        if (Rd_phy != 7'b0) begin
        valid[Rd_phy] <= 1'b0;
        end

    end
end

always @(*) begin    


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
        
     //LS
        Operand1_data_LS = registers[Operand1_phy_LS];
        Operand2_data_LS = registers[Operand2_phy_LS];
    //CSR
        Operand1_data_CSR = registers[Operand1_phy_CSR];
end   


endmodule 
