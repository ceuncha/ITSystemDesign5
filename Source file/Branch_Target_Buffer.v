module branch_target_buffer (
    input wire clk,
    input wire reset,
    input wire ID_EX_Branch,
    input wire [31:0] ID_EX_PC,
    input wire Pcsrc,
    input wire [31:0] PC_Branch,
    input wire [31:0] PC, // Input for read operation
    output reg [31:0] PC_Target,
    output reg first,
    output reg hit
);

// Define the BTB with 8 entries
reg valid [0:7];
reg [31:0] pc [0:7];
reg [31:0] target [0:7];
reg [2:0] next_index; // Next index to insert new entry

// Temporary index variable
reg [2:0] find_index;

// Reset all entries
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        valid[0] <= 1'b0;
        valid[1] <= 1'b0;
        valid[2] <= 1'b0;
        valid[3] <= 1'b0;
        valid[4] <= 1'b0;
        valid[5] <= 1'b0;
        valid[6] <= 1'b0;
        valid[7] <= 1'b0;
        pc[0] <= 32'd0;
        pc[1] <= 32'd0;
        pc[2] <= 32'd0;
        pc[3] <= 32'd0;
        pc[4] <= 32'd0;
        pc[5] <= 32'd0;
        pc[6] <= 32'd0;
        pc[7] <= 32'd0;
        target[0] <= 32'd0;
        target[1] <= 32'd0;
        target[2] <= 32'd0;
        target[3] <= 32'd0;
        target[4] <= 32'd0;
        target[5] <= 32'd0;
        target[6] <= 32'd0;
        target[7] <= 32'd0;
        first <= 1'b0;
        next_index <= 3'd0; // Initialize next_index
        hit <= 1'b0; // Initialize hit signal
    end
end

// Write operation triggered by ID_EX_Branch signal
always @(ID_EX_Branch or Pcsrc or PC_Branch) begin
    if (ID_EX_Branch && Pcsrc) begin
        find_index = 3'd7; // Default to an invalid index
        if (valid[0] && (pc[0] == ID_EX_PC)) find_index = 3'd0;
        else if (valid[1] && (pc[1] == ID_EX_PC)) find_index = 3'd1;
        else if (valid[2] && (pc[2] == ID_EX_PC)) find_index = 3'd2;
        else if (valid[3] && (pc[3] == ID_EX_PC)) find_index = 3'd3;
        else if (valid[4] && (pc[4] == ID_EX_PC)) find_index = 3'd4;
        else if (valid[5] && (pc[5] == ID_EX_PC)) find_index = 3'd5;
        else if (valid[6] && (pc[6] == ID_EX_PC)) find_index = 3'd6;
        else if (valid[7] && (pc[7] == ID_EX_PC)) find_index = 3'd7;

        if (find_index == 3'd7) begin
            // Add new entry if not found
            valid[next_index] <= 1'b1;
            pc[next_index] <= ID_EX_PC;
            target[next_index] <= PC_Branch;
            first <= 1'b1; // Set first to 1 when a new entry is created

            // Update next_index
            if (next_index == 3'd7)
                next_index <= 3'd0;
            else
                next_index <= next_index + 1;
        end else begin
            // Update the existing entry with the new target
            target[find_index] <= PC_Branch;
            first <= 1'b0; // Keep first at 0 when updating an existing entry
        end
    end else begin
        first <= 1'b0; // Default state of first is 0
    end
end

always @(*) begin
    // Read operation
    find_index = 3'd7; // Default to an invalid index
    if (valid[0] && (pc[0] == PC)) find_index = 3'd0;
    else if (valid[1] && (pc[1] == PC)) find_index = 3'd1;
    else if (valid[2] && (pc[2] == PC)) find_index = 3'd2;
    else if (valid[3] && (pc[3] == PC)) find_index = 3'd3;
    else if (valid[4] && (pc[4] == PC)) find_index = 3'd4;
    else if (valid[5] && (pc[5] == PC)) find_index = 3'd5;
    else if (valid[6] && (pc[6] == PC)) find_index = 3'd6;
    else if (valid[7] && (pc[7] == PC)) find_index = 3'd7;

    if (find_index != 3'd7 && valid[find_index]) begin
        PC_Target = target[find_index];
        hit = 1'b1;
    end else begin
        PC_Target = PC + 32'd4;
        hit = 1'b0;
    end
end

endmodule