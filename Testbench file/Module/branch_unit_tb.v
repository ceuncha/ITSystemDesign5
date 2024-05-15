`timescale 1ns / 1ps

module branch_unit_tb;

    reg [31:0] ResultA;
    reg [31:0] ResultB;
    reg [31:0] ID_EX_PC;
    reg ID_EX_Branch;
    reg [2:0] ID_EX_funct3;
    reg [31:0] ALUResult;
    reg ID_EX_Jump;

    wire PCSrc;
    wire [31:0] PC_Branch;
    wire [31:0] Rd_data;
    wire IF_ID_Flush;
    wire ID_EX_Flush;

    branch_unit BU(
        .ResultA(ResultA),
        .ResultB(ResultB),
        .ID_EX_PC(ID_EX_PC),
        .ID_EX_Branch(ID_EX_Branch),
        .ID_EX_funct3(ID_EX_funct3),
        .ALUResult(ALUResult),
        .ID_EX_Jump(ID_EX_Jump),
        .PCSrc(PCSrc),
        .PC_Branch(PC_Branch),
        .Rd_data(Rd_data),
        .IF_ID_Flush(IF_ID_Flush),
        .ID_EX_Flush(ID_EX_Flush)
    );

    initial begin
        // 입력 초기화
        ResultA = 0;
        ResultB = 0;
        ID_EX_PC = 32'h1000;
        ID_EX_Branch = 0;
        ID_EX_funct3 = 3'b000;
        ALUResult = 32'h2000;
        ID_EX_Jump = 0;

        // 지연시간 추가
        #10;

        // 테스트 케이스: BEQ - 분기 발생
        ResultA = 10; ResultB = 10;
        ID_EX_Branch = 1; ID_EX_funct3 = 3'b000;
        #10;

        // 테스트 케이스: BEQ - 분기 발생하지 않음
        ResultA = 10; ResultB = 20;
        #10;

        // 테스트 케이스: BNE - 분기 발생
        ResultA = 10; ResultB = 20;
        ID_EX_funct3 = 3'b001;
        #10;

        // 테스트 케이스: BNE - 분기 발생하지 않음
        ResultA = 20; ResultB = 20;
        #10;

        // 테스트 케이스: : Jump - jump 발생
        ID_EX_Jump = 1;
        ID_EX_Branch = 0;
        #10;
        $finish;
    end

    // 변화 모니터링
    initial begin
        $monitor("시간 %t에 PCSrc = %d, PC_Branch = %h, Rd_data = %h, IF_ID_Flush = %d, ID_EX_Flush = %d",
                 $time, PCSrc, PC_Branch, Rd_data, IF_ID_Flush, ID_EX_Flush);
    end

endmodule
