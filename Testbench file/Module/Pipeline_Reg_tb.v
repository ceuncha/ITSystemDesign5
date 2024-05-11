`timescale 1ns / 1ps
`define IDEX

`ifdef IFID
module ifid_tb();

    // Inputs
    reg clk;
    reg IF_ID_Stall, IF_ID_Flush;
    reg [31:0] instOut, PC;

    // Outputs
    wire [31:0] IF_ID_instOut, IF_ID_PC;

    // Instantiate the pipeline register module
    ifid_pipeline_register u_ifid_pipeline_register(
        .clk(clk),
        .IF_ID_Stall(IF_ID_Stall),
        .IF_ID_Flush(IF_ID_Flush),
        .instOut(instOut),
        .PC(PC),
        .IF_ID_instOut(IF_ID_instOut),
        .IF_ID_PC(IF_ID_PC)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #7.5 clk = ~clk;  // 15 ns cycle time
    end

    // Initial setup and test cases
    initial begin
        // Reset all inputs
        IF_ID_Stall = 0;
        IF_ID_Flush = 0;
        instOut = 0;
        PC = 0;

        // Apply initial stimulus after a brief delay
        #10;
        PC = 32'h00000000;
        instOut = 32'h12345678; // Example instruction code
        IF_ID_Stall = 0;
        IF_ID_Flush = 0;

        // Test flushing the pipeline
        #15;
        IF_ID_Flush = 1;
        #15;
        IF_ID_Flush = 0;

        // Test stalling the pipeline
        #30;
        IF_ID_Stall = 1;
        #15;
        IF_ID_Stall = 0;

        // More scenarios can be added here
    end
endmodule
`endif

`ifdef IDEX
module idex_testbench();

    reg clk;
    reg Control_Sig_Stall, ID_EX_Flush, RegWrite, MemToReg, MemRead, MemWrite, RWsel, Jump, Branch;
    reg [3:0] ALUOp;
    reg [1:0] ALUSrc;
    reg [4:0] IF_ID_Rs1, IF_ID_Rs2, IF_ID_Rd;
    reg [2:0] IF_ID_funct3;
    reg [31:0] RData1, RData2, imm32, IF_ID_PC;
    wire [1:0] ID_EX_ALUSrc;
    wire [3:0] ID_EX_ALUOp;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    wire [2:0] ID_EX_funct3;
    wire [31:0] ID_EX_RData1, ID_EX_RData2, ID_EX_imm32, ID_EX_PC;
    wire ID_EX_RWsel, ID_EX_MemWrite, ID_EX_MemRead, ID_EX_MemToReg, ID_EX_RegWrite, ID_EX_Jump, ID_EX_Branch;

    // Instantiate the IDEX pipeline register module
    idex_pipeline_register dut(
        .clk(clk),
        .Control_Sig_Stall(Control_Sig_Stall),
        .ID_EX_Flush(ID_EX_Flush),
        .RegWrite(RegWrite),
        .MemToReg(MemToReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .RWsel(RWsel),
        .IF_ID_Rs1(IF_ID_Rs1),
        .IF_ID_Rs2(IF_ID_Rs2),
        .IF_ID_Rd(IF_ID_Rd),
        .IF_ID_funct3(IF_ID_funct3),
        .RData1(RData1),
        .RData2(RData2),
        .imm32(imm32),
        .Jump(Jump),
        .Branch(Branch),
        .IF_ID_PC(IF_ID_PC),
        .ID_EX_RWsel(ID_EX_RWsel),
        .ID_EX_ALUSrc(ID_EX_ALUSrc),
        .ID_EX_ALUOp(ID_EX_ALUOp),
        .ID_EX_MemWrite(ID_EX_MemWrite),
        .ID_EX_MemRead(ID_EX_MemRead),
        .ID_EX_MemToReg(ID_EX_MemToReg),
        .ID_EX_RegWrite(ID_EX_RegWrite),
        .ID_EX_Rs1(ID_EX_Rs1),
        .ID_EX_Rs2(ID_EX_Rs2),
        .ID_EX_Rd(ID_EX_Rd),
        .ID_EX_funct3(ID_EX_funct3),
        .ID_EX_RData1(ID_EX_RData1),
        .ID_EX_RData2(ID_EX_RData2),
        .ID_EX_imm32(ID_EX_imm32),
        .ID_EX_Jump(ID_EX_Jump),
        .ID_EX_Branch(ID_EX_Branch),
        .ID_EX_PC(ID_EX_PC)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #7.5 clk = ~clk;  // 15 ns cycle time
    end

    // Initial setup and test cases
    initial begin
        // Initialize all inputs
        Control_Sig_Stall = 0;
        ID_EX_Flush = 0;
        RegWrite = 0;
        MemToReg = 0;
        MemRead = 0;
        MemWrite = 0;
        ALUOp = 4'b0000;
        ALUSrc = 2'b00;
        RWsel = 0;
        Jump = 0;
        Branch = 0;
        IF_ID_Rs1 = 5'b00000;
        IF_ID_Rs2 = 5'b00000;
        IF_ID_Rd = 5'b00000;
        IF_ID_funct3 = 3'b000;
        RData1 = 32'b0;
        RData2 = 32'b0;
        imm32 = 32'b0;
        IF_ID_PC = 32'h00000000;

        // Test case 1: Normal operation
        #10;
        RegWrite = 1;
        MemToReg = 1;
        MemRead = 1;
        MemWrite = 0;
        ALUOp = 4'b1010;
        ALUSrc = 2'b01;
        RWsel = 1;
        Jump = 0;
        Branch = 0;
        IF_ID_Rs1 = 5'b00010;
        IF_ID_Rs2 = 5'b00100;
        IF_ID_Rd = 5'b00001;
        IF_ID_funct3 = 3'b101;
        RData1 = 32'hAAAA;
        RData2 = 32'h5555;
        imm32 = 32'h00010010;
        IF_ID_PC = 32'h0000FF00;

        // Test case 2: Flushing
        #15;
        ID_EX_Flush = 1;
        #15;
        ID_EX_Flush = 0;

        // Test case 3: Stalling
        #30;
        Control_Sig_Stall = 1;
        #15;
        Control_Sig_Stall = 0;

        // Additional cases can be included as needed
    end
endmodule
`endif

`ifdef EXMEM
module exmem_testbench();

    reg clk;
    reg ID_EX_RegWrite, ID_EX_MemToReg, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_RWsel;
    reg [2:0] ID_EX_funct3;
    reg [4:0] ID_EX_Rd;
    reg [31:0] ALUResult, ID_EX_RData2, Rd_data;
    wire EX_MEM_RegWrite, EX_MEM_MemToReg, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_RWsel;
    wire [2:0] EX_MEM_funct3;
    wire [4:0] EX_MEM_Rd;
    wire [31:0] EX_MEM_ALUResult, EX_MEM_RData2, EX_MEM_Rd_data;

    // Instantiate the EXMEM pipeline register module
    exmem_pipeline_register dut(
        .clk(clk),
        .ID_EX_RegWrite(ID_EX_RegWrite),
        .ID_EX_MemToReg(ID_EX_MemToReg),
        .ID_EX_MemRead(ID_EX_MemRead),
        .ID_EX_MemWrite(ID_EX_MemWrite),
        .ID_EX_RWsel(ID_EX_RWsel),
        .ID_EX_funct3(ID_EX_funct3),
        .ID_EX_Rd(ID_EX_Rd),
        .ALUResult(ALUResult),
        .ID_EX_RData2(ID_EX_RData2),
        .Rd_data(Rd_data),
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .EX_MEM_MemToReg(EX_MEM_MemToReg),
        .EX_MEM_MemRead(EX_MEM_MemRead),
        .EX_MEM_MemWrite(EX_MEM_MemWrite),
        .EX_MEM_RWsel(EX_MEM_RWsel),
        .EX_MEM_funct3(EX_MEM_funct3),
        .EX_MEM_Rd(EX_MEM_Rd),
        .EX_MEM_ALUResult(EX_MEM_ALUResult),
        .EX_MEM_RData2(EX_MEM_RData2),
        .EX_MEM_Rd_data(EX_MEM_Rd_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #7.5 clk = ~clk;  // 15 ns cycle time
    end

    // Initial setup and test cases
    initial begin
        // Initialize all inputs
        ID_EX_RegWrite = 0;
        ID_EX_MemToReg = 0;
        ID_EX_MemRead = 0;
        ID_EX_MemWrite = 0;
        ID_EX_RWsel = 0;
        ID_EX_funct3 = 3'b000;
        ID_EX_Rd = 5'b00000;
        ALUResult = 32'b0;
        ID_EX_RData2 = 32'b0;
        Rd_data = 32'b0;

        // Test case 1: Normal operation
        #10;
        ID_EX_RegWrite = 1;
        ID_EX_MemToReg = 1;
        ID_EX_MemRead = 1;
        ID_EX_MemWrite = 0;
        ID_EX_RWsel = 1;
        ID_EX_funct3 = 3'b101;
        ID_EX_Rd = 5'b00010;
        ALUResult = 32'hAAAA;
        ID_EX_RData2 = 32'hBBBB;
        Rd_data = 32'hCCCC;

        // Continue to add more test scenarios for complete coverage
    end

endmodule
`endif

`ifdef MEMWB
module memwb_testbench();

    reg clk;
    reg EX_MEM_RegWrite, EX_MEM_MemToReg, EX_MEM_RWsel;
    reg [4:0] EX_MEM_Rd;
    reg [31:0] EX_MEM_Rd_data, EX_MEM_ALUResult, RData;
    wire MEM_WB_RegWrite, MEM_WB_MemToReg, MEM_WB_RWsel;
    wire [4:0] MEM_WB_Rd;
    wire [31:0] MEM_WB_Rd_data, MEM_WB_ALUResult, MEM_WB_RData;

    // Instantiate the MEMWB pipeline register module
    memwb_pipeline_register dut(
        .clk(clk),
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .EX_MEM_MemToReg(EX_MEM_MemToReg),
        .EX_MEM_RWsel(EX_MEM_RWsel),
        .EX_MEM_Rd(EX_MEM_Rd),
        .EX_MEM_Rd_data(EX_MEM_Rd_data),
        .EX_MEM_ALUResult(EX_MEM_ALUResult),
        .RData(RData),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .MEM_WB_MemToReg(MEM_WB_MemToReg),
        .MEM_WB_RWsel(MEM_WB_RWsel),
        .MEM_WB_Rd(MEM_WB_Rd),
        .MEM_WB_Rd_data(MEM_WB_Rd_data),
        .MEM_WB_ALUResult(MEM_WB_ALUResult),
        .MEM_WB_RData(MEM_WB_RData)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #7.5 clk = ~clk;  // 15 ns cycle time
    end

    // Initial setup and test cases
    initial begin
        // Initialize all inputs
        EX_MEM_RegWrite = 0;
        EX_MEM_MemToReg = 0;
        EX_MEM_RWsel = 0;
        EX_MEM_Rd = 5'b00000;
        EX_MEM_Rd_data = 32'b0;
        EX_MEM_ALUResult = 32'b0;
        RData = 32'b0;

        // Test case 1: Normal operation
        #10;
        EX_MEM_RegWrite = 1;
        EX_MEM_MemToReg = 1;
        EX_MEM_RWsel = 1;
        EX_MEM_Rd = 5'b01010;
        EX_MEM_Rd_data = 32'hDEADBEEF;
        EX_MEM_ALUResult = 32'hABCD1234;
        RData = 32'hFEEDBEEF;

        // Continue to add more test scenarios for complete coverage
    end

endmodule
`endif
