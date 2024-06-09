module Pattern_History_Table(
    input clk,
    input reset,
    input ID_EX_Branch,
    input PCSrc,
    input [3:0] PHT_index,
    input [3:0] PHT_Windex,
    input [31:0] ID_EX_PC,
    input [31:0] PC_Plus4,
    output reg BPred,
    output reg BPredValid
);
    parameter PC_width = 32;
    parameter index_width = 8; // for small programs
    parameter hist_width = 4;
    parameter PHT_width = 2; // for two bit counter
    parameter PHT_depth = 1 << hist_width; // 2 ^ hist_width

    parameter STRONGLY_NOT_TAKEN = 2'b00; // 0
    parameter WEAKLY_NOT_TAKEN   = 2'b01; // 1
    parameter WEAKLY_TAKEN       = 2'b10; // 2
    parameter STRONGLY_TAKEN     = 2'b11; // 3

    integer i;
    reg [PHT_width-1:0] PHT [0:PHT_depth-1];
    reg PHT_valid [0:PHT_depth-1];

    // reset registers
    // this code is written for ACTIVE HIGH reset. must be corrected.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            BPred <= 0;
            BPredValid <= 0;
            for (i = 0; i < PHT_depth; i = i + 1) begin
                PHT[i] <= 2'b10; // initially WEAKLY_TAKEN
                PHT_valid[i] <= 0;
            end
        end
    end 

// read PHT (search for PC_Plus4)
    always @(*) begin
        if (!reset) begin
                if (PHT_valid[PHT_index]) begin // if hist found in PHT
                    if ((PHT[PHT_index] == STRONGLY_NOT_TAKEN) || (PHT[PHT_index] == WEAKLY_NOT_TAKEN)) begin
                        BPred <= 0;
                        BPredValid <= 1;
                    end
                    else if((PHT[PHT_index] == STRONGLY_TAKEN) || (PHT[PHT_index] == WEAKLY_TAKEN)) begin
                        BPred <= 1;
                        BPredValid <= 1;
                    end
                    else begin
                        BPred <= 0;
                        BPredValid <= 0;
                    end
                end
                else begin // if hist not found in PHT
                    BPred <= 0; // default: branch not taken
                    BPredValid <= 0;

                end
            end
            else begin // if PC_Plus4 not found in BHT
                BPred <= 0; // default: branch not taken
                BPredValid <= 0;
            end
        if(BPredValid) begin
            $display("Time: %0t | for PC %h, Predicted branch %d", $time, PC_Plus4, BPred);
        end
    end
        

    // mode 2. update tables & buffers
    // update PHT
    always @(posedge clk) begin
        if(ID_EX_Branch && !reset) begin // if ID_EX_PC is branch inst.
            PHT_valid[PHT_Windex] <= 1;
            if(PHT_valid[PHT_Windex]) begin
                if(PHT[PHT_Windex] == WEAKLY_TAKEN && PCSrc) begin // if branch taken, increment state
                    PHT[PHT_Windex] <= PHT[PHT_Windex] + 1;
                end else if (PHT[PHT_Windex] == WEAKLY_NOT_TAKEN && !PCSrc) begin // if branch not taken, decrement state
                    PHT[PHT_Windex] <= PHT[PHT_Windex] - 1;
                end
            end
        end
    end
endmodule
