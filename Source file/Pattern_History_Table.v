module Pattern_History_Table(
    input clk,
    input reset,
    input PHTrd,
    input PC_Target_valid,
    input ID_EX_Branch,
    input PCSrc,
    input [3:0] PHT_index,
    input [3:0] PHT_Windex,
    input [31:0] IF_ID_PC,
    //output reg BPred,
    //output reg BPredValid
    output wire BPred,
    output wire BPredValid
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

    wire readPHT;
    assign readPHT = PHTrd && PC_Target_valid && reset;
    assign BPred = !readPHT ? 0 :
                    !(PHT_valid[PHT_index]) ? 0 :
                    ((PHT[PHT_index] == STRONGLY_NOT_TAKEN) || (PHT[PHT_index] == WEAKLY_NOT_TAKEN)) ? 0 :
                    ((PHT[PHT_index] == STRONGLY_TAKEN) || (PHT[PHT_index] == WEAKLY_TAKEN)) ? 1 :
                    0;
    assign BPredValid = readPHT && PHT_valid[PHT_index] ? 1 : 0;

/*
// read PHT (search for IF_ID_PC)
    always @(*) begin
        if (PHTrd && PC_Target_valid && reset) begin // if index found in BHT && index found in BTB
                if (PHT_valid[PHT_index]) begin // if hist found in PHT
                    if ((PHT[PHT_index] == STRONGLY_NOT_TAKEN) || (PHT[PHT_index] == WEAKLY_NOT_TAKEN)) begin
                        BPred <= 0;
                        BPredValid <= 1;
                    end
                    else if((PHT[PHT_index] == STRONGLY_TAKEN) || (PHT[PHT_index] == WEAKLY_TAKEN)) begin
                        BPred <= 1;
                        BPredValid <= 1;
                    end
                    else begin // if something goes wrong with PHT
                        BPred <= 0;
                        BPredValid <= 0; // prediction invalid
                    end
                end
                else begin // if hist not found in PHT
                    BPred <= 0; // default: branch not taken
                    BPredValid <= 0;

                end
            end
            else begin
                BPred <= 0; // default: branch not taken
                BPredValid <= 0;
            end
        if(BPredValid) begin
            $display("Time: %0t | for PC %h, Predicted branch %d", $time, IF_ID_PC, BPred);
        end
    end
*/
    // update PHT
    always @(posedge clk or negedge reset) begin
        if (!reset) begin // reset registers
            //BPred <= 0;
            //BPredValid <= 0;
            for (i = 0; i < PHT_depth; i = i + 1) begin
                PHT[i] <= 2'b10; // initially WEAKLY_TAKEN
                PHT_valid[i] <= 0;
            end
        end
        else if(ID_EX_Branch && reset) begin // if ID_EX_PC is branch inst.
            PHT_valid[PHT_Windex] <= 1;
            if(PHT_valid[PHT_Windex]) begin
                if((PHT[PHT_Windex] == WEAKLY_TAKEN) && PCSrc) begin // if branch taken, increment state
                    PHT[PHT_Windex] <= PHT[PHT_Windex] + 1;
                    $display("Time: %0t | Updated PHT[%0d] to: %b", $time, PHT_Windex, PHT[PHT_Windex]);
                end else if ((PHT[PHT_Windex] == WEAKLY_NOT_TAKEN) && !PCSrc) begin // if branch not taken, decrement state
                    PHT[PHT_Windex] <= PHT[PHT_Windex] - 1;
                    $display("Time: %0t | Updated PHT[%0d] to: %b", $time, PHT_Windex, PHT[PHT_Windex]);
                end  
            end
        end
    end
endmodule
