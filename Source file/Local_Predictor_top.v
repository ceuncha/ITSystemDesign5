module Local_Predictor(
    input wire clk,
    input wire reset,
    input wire IF_ID_BPred,
    input wire IF_ID_BPredValid,
    input wire PCSrc,
    input wire PC_Stall,
    input wire ID_EX_Branch,
    input wire [31:0] ID_EX_PC,
    input wire [31:0] PC_Branch,
    input wire [31:0] IF_ID_PC,
    output wire BPred,
    output wire BPredValid, // if BP made any prediction
    output wire [31:0] o_PC
);
    parameter PC_width = 32;
    parameter index_width = 8; // for small programs
    parameter hist_width = 4;
    parameter BTB_depth = 1 << index_width; // 2 ^ index_width
    parameter BHT_width = hist_width;
    parameter BHT_depth = 1 << index_width; // 2 ^ index_width
    parameter PHT_width = 2; // for two bit counter
    parameter PHT_depth = 1 << hist_width; // 2 ^ hist_width

    // wiring for submodule
    wire [31:0] PC_Target; // from BTB to Mux
    wire PC_Target_valid;
    reg [31:0] PC_Plus4;
    wire PHTrd;
    wire [hist_width-1:0] PHT_index;
    wire [hist_width-1:0] PHT_Windex;
    wire unpredicted;
    assign unpredicted = !IF_ID_BPredValid && PCSrc;
    wire mustNotBranch;
    assign mustNotBranch = IF_ID_BPredValid && IF_ID_BPred && !PCSrc;
    wire mustBranch;
    assign mustBranch = IF_ID_BPredValid && !IF_ID_BPred && PCSrc;
    wire [31:0] PC_Pred; // between PC Prediction MUX and PC Correction MUX
    wire [31:0] PC_Correct; // between PC Correction MUX and PC Control MUX
    reg [31:0] PC_reg;

    // reset registers
    // this code is written for ACTIVE HIGH reset. must be corrected.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC_Plus4 <= 4;
        end else begin
            PC_Plus4 <= o_PC + 4;
        end
    end 

    // instantiate modules
    (* keep_hierarchy = "yes" *)
    Branch_Target_Buffer u_BTB(
        .clk(clk), .reset(reset), 
        .PC_Plus4(PC_Plus4), .IF_ID_PC(IF_ID_PC),
        .ID_EX_PC(ID_EX_PC), .PC_Branch(PC_Branch), 
        .ID_EX_Branch(ID_EX_Branch), .PCSrc(PCSrc),
        .PC_Target(PC_Target), .PC_Target_valid(PC_Target_valid)
    );
    (* keep_hierarchy = "yes" *)
    Branch_History_Table u_BHT(
        .clk(clk), .reset(reset),
        .ID_EX_BPred(IF_ID_BPred), .ID_EX_BPredValid(IF_ID_BPredValid), .PCSrc(PCSrc),
        .ID_EX_Branch(ID_EX_Branch),
        .ID_EX_PC(ID_EX_PC), .IF_ID_PC(IF_ID_PC),
        .PHTrd(PHTrd),
        .Rhistory(PHT_index), .Whistory(PHT_Windex)
    );
    (* keep_hierarchy = "yes" *)
    Pattern_History_Table i_PHT(
        .clk(clk), .reset(reset), .PHTrd(PHTrd),
        .PC_Target_valid(PC_Target_valid),
        .PHT_index(PHT_index), .PHT_Windex(PHT_Windex),
        .ID_EX_Branch(ID_EX_Branch), .PCSrc(PCSrc),
        .IF_ID_PC(IF_ID_PC),
        .BPred(BPred), .BPredValid(BPredValid)
    );

// PC Prediction MUX
assign PC_Pred = (BPred && PC_Target_valid) ? PC_Target : PC_Plus4;
// PC Correction MUX
assign PC_Correct = unpredicted ? PC_Branch : // not predicted
                    mustNotBranch ? (ID_EX_PC + 4) : // must not branch, but did branch
                    mustBranch ? PC_Branch : // must branch, but didn't branch
                    PC_Pred; 
// PC Control MUX
/*
always @(posedge clk or posedge reset) begin
    if (reset) begin
        PC_reg <= 0;
    end else if (!PC_Stall) begin
        PC_reg <= PC_Correct;
    end else begin
    end
end
*/
assign o_PC = reset ? 0 : PC_Stall ? IF_ID_PC : PC_Correct;
//assign o_PC = PC_reg;
endmodule
