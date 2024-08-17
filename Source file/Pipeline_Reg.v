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
    input mret_sig,
    output reg IF_ID_taken,
    output reg [31:0] IF_ID_instOut,  
    output reg [31:0] IF_ID_inst_num,
    output reg [31:0] IF_ID_PC,
    output reg ROB_Flush,
    output reg IF_ID_hit
);
    always @(posedge clk) begin
        if (reset) begin
            // ???뼲?삕??뜝?럥?뒇?? ??嶺뚮쵓?삕??濚밸Ŧ?쎖筌???? ???뜝?럡?맓??뜝?럥鍮?????뜝?럡????뜝?럥?렓??눀?鍮섊빊?? ???쇀?뜝???뜝?럩留껃뜝?럥?렓????뜝?럡??
            IF_ID_instOut <= 32'b0;
            IF_ID_inst_num <= 32'b0;
            IF_ID_PC <= 32'b0;
            ROB_Flush <= 1'b0;
            IF_ID_taken<= 1'b0;
            IF_ID_hit <= 1'b0;
        end else if (exception_sig | mret_sig|Predict_Result) begin
            IF_ID_instOut <= 32'b0;
            IF_ID_inst_num <= 32'b0;
            IF_ID_PC <= 32'b0;
            ROB_Flush <= 1'b0;
            IF_ID_taken<= 1'b0;
            IF_ID_hit <= 1'b0;
            ROB_Flush <= 1'b1;
        end else begin
            // ??뜝?룞?삕????뜝?럥泥???嶺뚮쵐沅륅쭔??? ??뜝?럥???????쑏?뜝???? ???뜏類㏃삕????빝?뜝???뜝?럥??? ??뜝?럥???????쑏?뜝? ??뜝?럥??? ???뜝?럩?졂??堉ⓨ뜝?? ??뜝?럥??????뜝?럡?꺘
            IF_ID_instOut <= instOut;
            IF_ID_inst_num <= inst_num;
            IF_ID_PC <= PC;
            ROB_Flush <= 1'b0;
            IF_ID_taken<= taken;
            IF_ID_hit <= hit;

        end
    end

endmodule

