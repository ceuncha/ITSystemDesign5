`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/30 23:07:18
// Design Name: 
// Module Name: tb_Local_Predictor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Local_Predictor_tb;

    // ?��?�� ?��?��
    reg clk;
    reg reset;
    reg ID_EX_BPred;
    reg ID_EX_BPredValid;
    reg PCSrc;
    reg PC;
    reg [31:0] ID_EX_PC;
    reg [31:0] PC_Branch;
    wire BPred;
    wire BPredValid;
    wire [31:0] PC_Next;

    // ?��?��?��?�� 모듈 ?��?��?��?��?��
    Local_Predictor uut (
        .clk(clk),
        .reset(reset),
        .ID_EX_BPred(ID_EX_BPred),
        .ID_EX_BPredValid(ID_EX_BPredValid),
        .PCSrc(PCSrc),
        .ID_EX_PC(ID_EX_PC),
        .PC_Branch(PC_Branch),
        .PC(PC),
        .BPred(BPred),
        .BPredValid(BPredValid),
        .PC_Next(PC_Next)
    );

    // ?��?�� ?��?��
    initial begin
        clk = 1;
        forever #10 clk = ~clk; // 15ns ?��?�� 주기
    end

    // ?��?��?�� ?��?��리오
    initial begin
        // for reset
        reset = 1;
        ID_EX_BPred = 0;
        ID_EX_BPredValid = 0;
        PCSrc = 0;
        ID_EX_PC = 0;
        PC_Branch = 0;
        PC = 0;

        #20;
        reset = 0;

        // 시나리오 1. 분기를 예측하는 경우
        ID_EX_BPred = 0;
        ID_EX_BPredValid = 0;
        PCSrc = 1;
        ID_EX_PC = 32'h00000010;
        PC_Branch = 32'h00000014;
        PC = 32'h00000000;
        
        #20;
        ID_EX_BPred = 0;
        ID_EX_BPredValid = 0;
        PCSrc = 0;
        ID_EX_PC = 32'h00000020;
        PC_Branch = 32'h00000024;
        PC = 32'h00000000;

        // 시나리오 2. 분기 결과를 기록하는 경우
        #20;
        ID_EX_BPred = 1;
        ID_EX_BPredValid = 1;
        PCSrc = 1;
        ID_EX_PC = 32'h00000004;
        PC_Branch = 32'h00000008;
        PC = 32'h00000012;

        // 시나리오 3. 분기 예측과 분기 결과 기록을 동시에 하는 경우
        #20;
        ID_EX_BPred = 1;
        ID_EX_BPredValid = 1;
        PCSrc = 1;
        ID_EX_PC = 32'h00000008;
        PC_Branch = 32'h00000016;
        PC = 32'h00000004;

        // 시나리오 4. 분기 예측을 정정하는 경우
        #20; // must not branch, but did branch
        ID_EX_BPred = 1;
        ID_EX_BPredValid = 1;
        PCSrc = 0;
        ID_EX_PC = 32'h000000008;
        PC_Branch = 32'h00000000;
        PC = 32'h00000032;

        #20; // must branch, but didn't branch
        ID_EX_BPred = 0;
        ID_EX_BPredValid = 1;
        PCSrc = 1;
        ID_EX_PC = 32'h000000004;
        PC_Branch = 32'h000000008;
        PC = 32'h00000036;

        #20;
        $finish;
    end

endmodule

