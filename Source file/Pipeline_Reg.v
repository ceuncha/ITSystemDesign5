module ifid_pipeline_register (
    input clk,
    input reset,
    input [31:0] instOut,
    input [31:0] inst_num,
    input [31:0] PC,
    input Predict_Result,
    input taken,
    input hit,
    input exception_sig,
    output reg IF_ID_taken,
    output reg [31:0] IF_ID_instOut,  
    output reg [31:0] IF_ID_inst_num,
    output reg [31:0] IF_ID_PC,
    output reg ROB_Flush,
    output reg IF_ID_hit
);
    always @(posedge clk) begin
        if (reset) begin
            // ??억옙?占쎈늅?? ??筌묕옙??繹먮뛽琉??? ??占쎄퐥?占쎈빝???占쎄섀?占쎈뎨?뇡?빘異?? ??뙴占??占쎌맃占쎈뎨???占쎄섀
            IF_ID_instOut <= 32'b0;
            IF_ID_inst_num <= 32'b0;
            IF_ID_PC <= 32'b0;
            ROB_Flush <= 1'b0;
            IF_ID_taken<= 1'b0;
            IF_ID_hit <= 1'b0;
        end else if (exception_sig) begin
            IF_ID_instOut <= 32'b0;
            IF_ID_inst_num <= 32'b0;
            IF_ID_PC <= 32'b0;
            ROB_Flush <= 1'b0;
            IF_ID_taken<= 1'b0;
            IF_ID_hit <= 1'b0;
            ROB_Flush <= 1'b1;
        end else begin
            // ?占쏙옙???占쎈첓??筌묒궏琉??? ?占쎈눀????뜮占???? ??獒뺧옙???땻占??占쎈쇀? ?占쎈눀????뜮占? ?占쎈눀? ??占쎌젳??뼨占?? ?占쎈쇀???占쎄탾
            IF_ID_instOut <= instOut;
            IF_ID_inst_num <= inst_num;
            IF_ID_PC <= PC;
            ROB_Flush <= 1'b0;
            IF_ID_taken<= taken;
            IF_ID_hit <= hit;

        end
    end

endmodule

