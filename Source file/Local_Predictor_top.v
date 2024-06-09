module Local_Predictor(
    input wire clk,
    input wire reset,
    input wire ID_EX_BPred,
    input wire ID_EX_BPredValid,
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

    parameter STRONGLY_NOT_TAKEN = 2'b00; // 0
    parameter WEAKLY_NOT_TAKEN   = 2'b01; // 1
    parameter WEAKLY_TAKEN       = 2'b10; // 2
    parameter STRONGLY_TAKEN     = 2'b11; // 3

    // wiring for submodule
    wire [31:0] PC_Target; // from BTB to Mux
    reg [31:0] PC_Plus4;
    wire [hist_width-1:0] PHT_index;
    wire [hist_width-1:0] PHT_Windex;
    wire [31:0] PC_Pred; // between PC Prediction MUX and PC Correction MUX
    wire [31:0] PC_Correct; // between PC Correction MUX and PC Control MUX

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
    Branch_History_Table u_BHT(
        .clk(clk), .reset(reset),
        .ID_EX_BPred(ID_EX_BPred), .ID_EX_BPredValid(ID_EX_BPredValid), .PCSrc(PCSrc),
        .ID_EX_Branch(ID_EX_Branch),
        .ID_EX_PC(ID_EX_PC), .PC_Plus4(IF_ID_PC),
        .Rhistory(PHT_index), .Whistory(PHT_Windex)
    );
    Branch_Target_Buffer u_BTB(
        .clk(clk), .reset(reset), 
        .PC_Plus4(IF_ID_PC), .ID_EX_PC(ID_EX_PC), .PC_Branch(PC_Branch), 
        .ID_EX_BPredValid(ID_EX_BPredValid), .PCSrc(PCSrc),
        .PC_Target(PC_Target)
    );
    Pattern_History_Table i_PHT(
        .clk(clk), .reset(reset),
        .PHT_index(PHT_index), .PHT_Windex(PHT_Windex),
        .ID_EX_Branch(ID_EX_Branch), .PCSrc(PCSrc),
        .ID_EX_PC(ID_EX_PC), .PC_Plus4(IF_ID_PC),
        .BPred(BPred), .BPredValid(BPredValid)
    );

// PC Prediction MUX
assign PC_Pred = BPred ? PC_Target : PC_Plus4;
// PC Correction MUX
assign PC_Correct = (!ID_EX_BPredValid && PCSrc) ? PC_Branch : // not predicted
                    (ID_EX_BPredValid && ID_EX_BPred && !PCSrc) ? (ID_EX_PC + 4) : // must not branch, but did branch
                    (ID_EX_BPredValid && !ID_EX_BPred && PCSrc) ? PC_Branch : // must branch, but didn't branch
                    PC_Pred; 
// PC Control MUX
assign o_PC = (reset) ? 0 : (PC_Stall) ? o_PC : PC_Correct;
endmodule
