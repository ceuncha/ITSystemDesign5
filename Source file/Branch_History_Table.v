module Branch_History_Table(
    input clk,
    input reset,
    input ID_EX_BPred,
    input ID_EX_BPredValid,
    input ID_EX_Branch,
    input PCSrc,
    input [31:0] ID_EX_PC,
    input [31:0] PC_Plus4,
    output wire [3:0] Rhistory,
    output wire [3:0] Whistory
);
    parameter PC_width = 32;
    parameter index_width = 8; // for small programs
    parameter hist_width = 4;
    parameter BTB_depth = 1 << index_width; // 2 ^ index_width
    parameter BHT_width = hist_width;
    parameter BHT_depth = 1 << index_width; // 2 ^ index_width
    
    integer i;
    reg [BHT_width-1:0] BHT [0:BHT_depth-1];
    reg BHT_valid [0:BHT_depth-1];

    wire [index_width-1:0] BHT_index;
    assign BHT_index = PC_Plus4[9:2];
    wire [index_width-1:0] BHT_Windex;
    assign BHT_Windex = ID_EX_PC[9:2];

    // reset registers
    // this code is written for ACTIVE HIGH reset. must be corrected.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < BHT_depth; i = i + 1) begin
                BHT[i] <= 0;
                BHT_valid[i] <= 0;
            end
        end
    end 

    // read BHT (search for PC_Plus4)
    assign Rhistory = BHT_valid[BHT_index] ? BHT[BHT_index] : 0;

    // update BHT
    assign Whistory = (ID_EX_Branch && BHT_valid[BHT_Windex]) ? {BHT[BHT_Windex][2:0], PCSrc} : {3'b000, PCSrc};

    always @(posedge clk) begin
        if(ID_EX_Branch && !reset) begin // if ID_EX_PC is branch inst.
            if(BHT_valid[BHT_Windex]) begin
                BHT[BHT_Windex] <= {BHT[BHT_Windex][2:0], PCSrc};
            end else begin
                BHT[BHT_Windex] <= {3'b000, PCSrc}; // write PCSrc to History
                BHT_valid[BHT_Windex] <= 1;
            end
            $display("Time: %0t | Updated BHT[%0d] to: %b", $time, BHT_Windex, BHT[BHT_Windex]);
        end
    end
endmodule
