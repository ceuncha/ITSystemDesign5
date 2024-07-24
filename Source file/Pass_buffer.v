 module Pass_buffer (                                       
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] P_inst_num,
    input wire [31:0] PC,
    input wire [7:0] Rd,
    input wire [3:0] ALUOP,
    input wire ALUSrc1,
    input wire ALUSrc2,
    input wire [31:0] immediate,
    input wire [31:0] operand1,
    input wire [31:0] operand2,
    output wire [174:0] result_out
    
);
    
    // Internal storage for reservation station entries
   (* keep = "true" *) reg [31:0] inst_nums;
   (* keep = "true" *) reg [31:0] PCs ;
   (* keep = "true" *) reg [7:0] Rds;
   (* keep = "true" *) reg [3:0] ALUOPs;
   (* keep = "true" *) reg  ALUSrc1s;
   (* keep = "true" *) reg  ALUSrc2s;
   (* keep = "true" *) reg [31:0] immediates ;
   (* keep = "true" *) reg [31:0] operand1s ;
   (* keep = "true" *) reg [31:0] operand2s ;



    always @(posedge clk) begin   
        if (reset) begin
               inst_nums <=0;
                PCs <= 0;
                Rds <= 0;
                ALUOPs <= 0;
                ALUSrc1s <= 0;
                ALUSrc2s <= 0;
                immediates <=0;
                operand1s <= 0;
                operand2s <= 0;
             
            end
         else begin
        if (start) begin
                inst_nums <= P_inst_num;
                PCs <= PC;
                Rds<= Rd;
                ALUOPs <= ALUOP;
                ALUSrc1s <= ALUSrc1;
                ALUSrc2s <= ALUSrc2;
                immediates <= immediate;
                operand1s <= operand1;
                operand2s <= operand2;
             end 
             end
             end
        assign result_out={operand2s ,operand1s,inst_nums, 1'b1, PCs, Rds, ALUOPs, ALUSrc1s, ALUSrc2s, immediates};
 endmodule
