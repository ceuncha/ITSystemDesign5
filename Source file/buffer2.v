module buff2(
    input wire clk,
    input wire reset,
    input wire RS_BR_Branch,
    input wire RS_BR_Jump,
    input wire RS_BR_taken,
    input wire RS_BR_hit, 
    input wire [7:0] BR_Phy,  
    input wire [31:0] RS_BR_inst_num_output, 
    input wire [31:0] immediate_BR,

    input wire [31:0] Operand2_BR,
    input wire [2:0] RS_BR_funct3,
    input wire negative,
    input wire zero,
    input wire overflow,
    input wire carry, 
    input wire PC_Return,
    
    output reg b_RS_BR_Branch,
    output reg b_RS_BR_Jump,
    output reg b_RS_BR_taken,
    output reg b_RS_BR_hit, 
  output reg [7:0] b_BR_Phy,  
  output reg [31:0] b_RS_BR_inst_num_output, 
  output reg [31:0] b_immediate_BR,

    output reg [2:0] b_RS_BR_funct3,
    output reg [31:0] b_Operand2_BR,
    output reg b_negative,
    output reg b_zero,
    output reg b_overflow,
    output reg b_carry, 
        output reg b_PC_Return,

);


always @(posedge clk) begin
    if (reset) begin
    b_RS_BR_Branch <= 0;
    b_RS_BR_Jump <= 0;
    b_RS_BR_taken <= 0;
    b_RS_BR_hit <= 0;
    b_BR_Phy <= 0;
    b_RS_BR_inst_num_output <= 0;
    b_immediate_BR <= 0;
    b_PC_BR <= 0;

    b_RS_BR_funct3 <= 0;
    b_negative <= 0;
    b_zero <= 0;
    b_overflow <= 0;
    b_carry <= 0;
    b_Operand2_BR <= 0;
    b_PC_Return <= 0;
    end else begin
    b_RS_BR_Branch <=RS_BR_Branch;
    b_RS_BR_Jump <= RS_BR_Jump;
    b_RS_BR_taken <= RS_BR_taken;
    b_RS_BR_hit <= RS_BR_hit;
    b_BR_Phy <= BR_Phy;
    b_RS_BR_inst_num_output <= RS_BR_inst_num_output;
    b_immediate_BR <= immediate_BR;
    b_PC_BR <= PC_BR;

    b_RS_BR_funct3 <= RS_BR_funct3;
    b_negative <= negative;
    b_zero <= zero;
    b_overflow <= overflow;
    b_carry <= carry;
        b_Operand2_BR <= Operand2_BR;
        b_PC_Return <= PC_Return;
    end
    end
endmodule
