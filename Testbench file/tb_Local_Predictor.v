`timescale 1ns / 1ps

module Local_Predictor_tb;
    reg clk;
    reg reset;
    reg IF_ID_BPred;
    reg IF_ID_BPredValid;
    reg PCSrc;
    reg PC_Stall;
    reg ID_EX_Branch;
    reg [31:0] ID_EX_PC;
    reg [31:0] PC_Branch;
    reg [31:0] IF_ID_PC;
    wire BPred;
    wire BPredValid;
    wire [31:0] PC_Next;

    Local_Predictor uut (
        .clk(clk),
        .reset(reset),
        .IF_ID_BPred(IF_ID_BPred),
        .IF_ID_BPredValid(IF_ID_BPredValid),
        .PCSrc(PCSrc), .PC_Stall(PC_Stall),
        .ID_EX_Branch(ID_EX_Branch),
        .ID_EX_PC(ID_EX_PC),
        .PC_Branch(PC_Branch),
        .IF_ID_PC(IF_ID_PC),
        .BPred(BPred),
        .BPredValid(BPredValid),
        .o_PC(PC_Next)
    );

    initial begin
        clk = 1;
        forever #10 clk = ~clk;
    end

    initial begin
        PC_Stall = 0;
    end

    initial begin
        // for reset
        reset = 0;
        IF_ID_BPred = 0;
        IF_ID_BPredValid = 0;
        PCSrc = 0;
        ID_EX_PC = 0;
        PC_Branch = 0;

        // 시나리오 1. 분기를 예측하는 경우
        // at 20ns
        #20;
        reset = 1;
        IF_ID_BPred = 0;
        IF_ID_BPredValid = 0;
        PCSrc = 0;
        ID_EX_Branch = 0;
        IF_ID_PC = 32'h00000004;  // 0x04에 대해 분기 예측
        // initial 값은 not taken이므로 o_PC는 0x08
        ID_EX_PC = 32'h00000000;
        PC_Branch = 32'h00000000;
        
        // at 40ns
        #20;
        IF_ID_BPred = 0;
        IF_ID_BPredValid = 0;
        PCSrc = 0;
        ID_EX_Branch = 0;
        IF_ID_PC = 32'h00000008; // 0x08에 대해 분기 예측
        // initial 값은 not taken이므로 o_PC는 0x0c
        ID_EX_PC = 32'h00000004;
        PC_Branch = 32'h00000000;

        // 시나리오 2. 분기 결과를 기록하는 경우
        // at 60ns
        #20;
        IF_ID_BPred = 0;
        IF_ID_BPredValid = 0;
        // 예측되지 않은 branch이므로 o_PC는 0x08
        PCSrc = 1;
        ID_EX_Branch = 1;
        IF_ID_PC = 32'h000000c;
        ID_EX_PC = 32'h00000008;
        PC_Branch = 32'h00000008;
        // 0x08에 대해 BHT에 0001, PHT에 0001 valid, BTB에 0x08

        // 시나리오 3. 분기 예측과 분기 결과 기록을 동시에 하는 경우
        // at 80ns
        #20;
        IF_ID_BPred = 1;
        IF_ID_BPredValid = 1;
        PCSrc = 1;
        ID_EX_Branch = 1;
        IF_ID_PC = 32'h00000008;
        // 0x08에 대해 table이 update되었으므로 o_PC는 0x08
        ID_EX_PC = 32'h0000000c;
        PC_Branch = 32'h0000002c;
        // 0x0c에 대해 BHT에 0001, PHT의 0001은 STRONGLY_TAKEN, BTB에 0x2c

        // 시나리오 4. 분기 예측을 정정하는 경우
        // at 100ns
        #20; 
        IF_ID_BPred = 1;
        IF_ID_BPredValid = 1;
        PCSrc = 0;
        ID_EX_Branch = 1;
        // must not branch, but did branch
        IF_ID_PC = 32'h00000008;
        ID_EX_PC = 32'h00000008;
        PC_Branch = 32'h00000000;
        // o_PC는 ID_EX_PC + 4인 0x0c

        // at 120ns
        #20; 
        IF_ID_BPred = 0;
        IF_ID_BPredValid = 1;
        PCSrc = 1;
        ID_EX_Branch = 1;
        // must branch, but didn't branch
        IF_ID_PC = 32'h0000000c;
        ID_EX_PC = 32'h00000008;
        PC_Branch = 32'h0000002c;
        // o_PC는 0x2c

        #20;
        $finish;
    end
endmodule
