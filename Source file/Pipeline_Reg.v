module ifid_pipeline_register (
    input clk,
    input reset,
    input [31:0] instOut,
    input [31:0] inst_num,
    input [31:0] PC,
    input Predict_Result,
    input taken,
    input hit,
    output reg IF_ID_taken,
    output reg [31:0] IF_ID_instOut,  
    output reg [31:0] IF_ID_inst_num,
    output reg [31:0] IF_ID_PC,
    output reg ROB_Flush,
    output reg IF_ID_hit
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // ?逾�?�봾?? ??六�??源덃뤆?? ??�꽎?�땻???�꼨?�뵳釉앹춺? ?猷�?�쐝�뵳???�꼨
            IF_ID_instOut <= 32'b0;
            IF_ID_inst_num <= 32'b0;
            IF_ID_PC <= 32'b0;
            ROB_Flush <= 1'b0;
            IF_ID_taken<= 1'b0;
            IF_ID_hit <= 1'b0;

        end else if (Predict_Result) begin
            IF_ID_instOut <= 32'b0;
            IF_ID_inst_num <= 32'b0;
            IF_ID_PC <= 32'b0;
            ROB_Flush <= 1'b1;
            IF_ID_taken<= 1'b0;
            IF_ID_hit <= 1'b0;
        end else begin
            // ?��???�몠??六삥뤆?? ?�뇡???鍮�??? ??裕�??苑�?�뙴? ?�뇡???鍮� ?�뇡? ??�젧?疫�? ?�뙴???�굚
            IF_ID_instOut <= instOut;
            IF_ID_inst_num <= inst_num;
            IF_ID_PC <= PC;
            ROB_Flush <= 1'b0;
            IF_ID_taken<= taken;
            IF_ID_hit <= hit;

        end
    end

endmodule

