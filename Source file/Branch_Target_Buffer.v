module Branch_Target_Buffer(
    input clk,
    input reset,
    input wire [31:0] PC_Plus4,
    input wire [31:0] ID_EX_PC,
    input wire [31:0] PC_Branch,
    input wire ID_EX_BPredValid,
    input wire PCSrc,
    output wire [31:0] PC_Target
);
    parameter PC_width = 32;
    parameter index_width = 8; // for small programs
    parameter hist_width = 4;
    parameter BTB_depth = 1 << index_width; // 2 ^ index_width
    parameter BHT_width = hist_width;
    parameter BHT_depth = 1 << index_width; // 2 ^ index_width
    parameter PHT_width = 2; // for two bit counter
    parameter PHT_depth = 1 << hist_width; // 2 ^ hist_width

    integer i;
    reg [PC_width-1:0] BTB [0:BTB_depth-1];
    reg BTB_valid [0:BTB_depth-1];

    wire [index_width-1:0] BTB_index;
    assign BTB_index = PC_Plus4[9:2];
    wire [index_width-1:0] BTB_Windex; // tag to write
    assign BTB_Windex = ID_EX_PC[9:2];

    // reset BTB
        always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < BTB_depth; i = i + 1) begin
                BTB[i] <= 0;
                BTB_valid[i] <= 0;
            end
        end
        end

    // read BTB (search for PC_Plus4) combinationally using assign
    assign PC_Target = (BTB_valid[BTB_index]) ? BTB[BTB_index] : PC_Plus4;

    // update BTB
    always @(posedge clk) begin 
        if ((ID_EX_BPredValid || PCSrc) && !reset) begin // if PCSrc == 1
                if (BTB_valid[BTB_Windex]) begin
                    BTB[BTB_Windex] <= PC_Branch;  // if ID_EX_PC found in BTB
                end
                else begin
                    BTB[BTB_Windex] <= PC_Branch;
                    BTB_valid[BTB_Windex] <= 1; // if ID_EX_PC not found in BTB
                end
        end
    end
endmodule
