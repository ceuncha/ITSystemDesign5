module branch_correction_buffer (
    input wire clk,
    input wire reset,
    input wire hit,
    input wire [31:0] PC,
    input wire [31:0] PC_Target,
    input wire taken,
    input wire [31:0] ID_EX_PC,
    input wire ID_EX_Branch,
    input wire Pcsrc,
    output reg [31:0] PC_reverse,
    output reg Wrong
);

// Define the buffer with 8 entries
reg valid [0:7];
reg taken_entry [0:7];
reg [31:0] pc [0:7];
reg [31:0] pc_reverse [0:7];
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
        taken_entry[0] <= 1'b0;
        taken_entry[1] <= 1'b0;
        taken_entry[2] <= 1'b0;
        taken_entry[3] <= 1'b0;
        taken_entry[4] <= 1'b0;
        taken_entry[5] <= 1'b0;
        taken_entry[6] <= 1'b0;
        taken_entry[7] <= 1'b0;
        pc[0] <= 32'd0;
        pc[1] <= 32'd0;
        pc[2] <= 32'd0;
        pc[3] <= 32'd0;
        pc[4] <= 32'd0;
        pc[5] <= 32'd0;
        pc[6] <= 32'd0;
        pc[7] <= 32'd0;
        pc_reverse[0] <= 32'd0;
        pc_reverse[1] <= 32'd0;
        pc_reverse[2] <= 32'd0;
        pc_reverse[3] <= 32'd0;
        pc_reverse[4] <= 32'd0;
        pc_reverse[5] <= 32'd0;
        pc_reverse[6] <= 32'd0;
        pc_reverse[7] <= 32'd0;
        next_index <= 3'd0; // Initialize next_index
        Wrong <= 1'b0; // Initialize Wrong signal
    end else begin
        // Write operation
        if (hit) begin
            find_index = 3'd7; // Default to an invalid index
            if (valid[0] && (pc[0] == PC)) find_index = 3'd0;
            else if (valid[1] && (pc[1] == PC)) find_index = 3'd1;
            else if (valid[2] && (pc[2] == PC)) find_index = 3'd2;
            else if (valid[3] && (pc[3] == PC)) find_index = 3'd3;
            else if (valid[4] && (pc[4] == PC)) find_index = 3'd4;
            else if (valid[5] && (pc[5] == PC)) find_index = 3'd5;
            else if (valid[6] && (pc[6] == PC)) find_index = 3'd6;
            else if (valid[7] && (pc[7] == PC)) find_index = 3'd7;

            if (find_index == 3'd7) begin
                // Find the next index to store the new entry
                if (!valid[0]) next_index = 3'd0;
                else if (!valid[1]) next_index = 3'd1;
                else if (!valid[2]) next_index = 3'd2;
                else if (!valid[3]) next_index = 3'd3;
                else if (!valid[4]) next_index = 3'd4;
                else if (!valid[5]) next_index = 3'd5;
                else if (!valid[6]) next_index = 3'd6;
                else if (!valid[7]) next_index = 3'd7;
                else next_index = next_index % 8; // If all entries are valid, use the next_index in a circular manner

                valid[next_index] <= 1'b1;
                pc[next_index] <= PC;
                taken_entry[next_index] <= taken;
                if (taken) begin
                    pc_reverse[next_index] <= PC + 32'd4; // If taken, store PC + 4
                end else begin
                    pc_reverse[next_index] <= PC_Target; // If not taken, store PC_Target
                end
                // Update next_index after adding the new entry
                next_index <= next_index + 1;
            end else begin
                // Update the existing entry with the new values
                taken_entry[find_index] <= taken;
                if (taken) begin
                    pc_reverse[find_index] <= PC + 32'd4; // If taken, store PC + 4
                end else begin
                    pc_reverse[find_index] <= PC_Target; // If not taken, store PC_Target
                end
            end
        end
    end
end

// Read operation
always @(*) begin
    find_index = 3'd7; // Default to an invalid index
    if (valid[0] && (pc[0] == ID_EX_PC)) find_index = 3'd0;
    else if (valid[1] && (pc[1] == ID_EX_PC)) find_index = 3'd1;
    else if (valid[2] && (pc[2] == ID_EX_PC)) find_index = 3'd2;
    else if (valid[3] && (pc[3] == ID_EX_PC)) find_index = 3'd3;
    else if (valid[4] && (pc[4] == ID_EX_PC)) find_index = 3'd4;
    else if (valid[5] && (pc[5] == ID_EX_PC)) find_index = 3'd5;
    else if (valid[6] && (pc[6] == ID_EX_PC)) find_index = 3'd6;
    else if (valid[7] && (pc[7] == ID_EX_PC)) find_index = 3'd7;
    
    
    if (find_index != 3'd7 && valid[find_index]) begin
        PC_reverse <= pc_reverse[find_index];
        if (taken_entry[find_index] == Pcsrc) begin
            Wrong = 1'b0; // Prediction is correct
        end else begin
            Wrong = 1'b1; // Prediction is incorrect
        end
    end else begin
        Wrong = 1'b0; // Default state of Wrong is 0
    end
end

endmodule
