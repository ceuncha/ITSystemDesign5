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

    output reg [31:0] Operand1_data,
    output reg [31:0] Operand2_data,
    output reg valid1,
    output reg valid2
);


reg [31:0] registers [0:255];
    reg valid [0:255];
integer i;




always @(posedge clk) begin         // 매 클락 계산기들 혹은 load로부터 데이터값을 받는다. 전송온 데이터가 있다면, 해당 데이터를 업데이트 시켜준다.
                                       // F0의 경우 항상 0을 유지해야 하므로 해당 물리주소는 업데이트 해주지 않는다,

   if (reset) begin
       for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= i;
            valid[i] <= 1'b1; 
        end
       for (i = 32; i < 256; i = i + 1) begin
            registers[i] <= 32'h00000000;
           valid[i] <= 1'b1; 
        end
    end
    if (!reset) begin
        if (ALU_add_Write == 1'b1 && ALU_add_phy != 7'b0) begin
            registers[ALU_add_phy] <= ALU_add_Data;
            valid[ALU_add_phy] <= 1'b1; // alu 신호가 들어왔을때 해당 물리주소와 데이터값을 받아서 pfile을 업데이트 시켜준다.
        end
        if (ALU_load_Write == 1'b1 && ALU_load_phy != 7'b0) begin
            registers[ALU_load_phy] <= ALU_load_Data;
            valid[ALU_load_phy] <= 1'b1; // load 신호가 들어왔을때 해당 물리주소와 데이터값을 받아서 pfile을 업데이트 시켜준다.
        end
        if (ALU_mul_Write == 1'b1 && ALU_mul_phy != 7'b0) begin
            registers[ALU_mul_phy] <= ALU_mul_Data;
            valid[ALU_mul_phy] <= 1'b1; // multiplier 신호가 들어왔을때 해당 물리주소와 데이터값을 받아서 pfile을 업데이트 시켜준다.
        end
        if (ALU_div_Write == 1'b1 && ALU_div_phy != 7'b0) begin
            registers[ALU_div_phy] <= ALU_div_Data;
            valid[ALU_div_phy] <= 1'b1; // divider 신호가 들어왔을때 해당 물리주소와 데이터값을 받아서 pfile을 업데이트 시켜준다.
        end
        if (ALU_done_Write == 1'b1 && ALU_done_phy != 7'b0) begin
            registers[ALU_done_phy] <= ALU_done_Data;
            valid[ALU_done_phy] <= 1'b1; // multiplier 신호가 들어왔을때 해당 물리주소와 데이터값을 받아서 pfile을 업데이트 시켜준다.
        end
        if (Rd_phy != 7'b0) begin
        valid[Rd_phy] <= 1'b0;
        end
    end
end



    always @(*) begin    //Operand 값이 들어오면 해당 물리주소의 data 값과 valid 값을 출력시켜 준다.
        Operand1_data <= registers[Operand1_phy];   
        Operand2_data <= registers[Operand2_phy];
        valid1 <= valid[Operand1_phy];
        valid2 <= valid[Operand2_phy];
    end

endmodule
