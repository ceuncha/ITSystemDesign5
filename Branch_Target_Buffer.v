module Branch_Target_Buffer (
    input wire clk,
    input wire reset,
    input wire ID_EX_Branch,
    input wire [31:0] ID_EX_PC,
    input wire Pcsrc,
    input wire [31:0] PC_Branch,
    input wire [31:0] PC, // Input for read operation
    output reg [31:0] PC_Target,
    output reg hit
);

// Define the BTB with 8 entries
reg [31:0] pc_BTB [0:7];
reg [31:0] target [0:7];
reg [2:0] next_index; // Next index to insert new entry

// Temporary index variable
reg [2:0] find_index;

// Reset all entries
always @(posedge clk) begin
    if (reset) begin
        pc_BTB[0] <= 32'd0;
        pc_BTB[1] <= 32'd0;
        pc_BTB[2] <= 32'd0;
        pc_BTB[3] <= 32'd0;
        pc_BTB[4] <= 32'd0;
        pc_BTB[5] <= 32'd0;
        pc_BTB[6] <= 32'd0;
        pc_BTB[7] <= 32'd0;
        target[0] <= 32'd0;
        target[1] <= 32'd0;
        target[2] <= 32'd0;
        target[3] <= 32'd0;
        target[4] <= 32'd0;
        target[5] <= 32'd0;
        target[6] <= 32'd0;
        target[7] <= 32'd0;
        next_index <= 3'd0; // Initialize next_index

    end else if (ID_EX_Branch && Pcsrc) begin
        find_index = 3'd7; // Default to an invalid index
        if  (pc_BTB[0] == ID_EX_PC) find_index = 3'd0;
        else if  (pc_BTB[1] == ID_EX_PC) find_index = 3'd1;
        else if  (pc_BTB[2] == ID_EX_PC) find_index = 3'd2;
        else if  (pc_BTB[3] == ID_EX_PC) find_index = 3'd3;
        else if  (pc_BTB[4] == ID_EX_PC) find_index = 3'd4;
        else if  (pc_BTB[5] == ID_EX_PC) find_index = 3'd5;
        else if  (pc_BTB[6] == ID_EX_PC) find_index = 3'd6;
        else if  (pc_BTB[7] == ID_EX_PC) find_index = 3'd7;

        if (find_index == 3'd7) begin
            // Add new entry if not found
            pc_BTB[next_index] <= ID_EX_PC;
            target[next_index] <= PC_Branch;

            // Update next_index
            if (next_index == 3'd7)
                next_index <= 3'd0;
            else
                next_index <= next_index + 1;
        end else begin
            // Update the existing entry with the new target
            target[find_index] <= PC_Branch;
        end
    end
end

// Read operation
always @(*) begin
    if (pc_BTB[0] == PC) begin
    PC_Target=target[0];
    hit=1;
    end
    else if (pc_BTB[1] == PC) begin
    PC_Target=target[1];
    hit=1;
    end
    else if (pc_BTB[2] == PC) begin
    PC_Target=target[2];
    hit=1;
    end
    else if (pc_BTB[3] == PC) begin
    PC_Target=target[3];
    hit=1;
    end
    else if (pc_BTB[4] == PC) begin
    PC_Target=target[4];
    hit=1;
    end
    else if (pc_BTB[5] == PC) begin
    PC_Target=target[5];
    hit=1;
    end
    else if (pc_BTB[6] == PC) begin
    PC_Target=target[6];
    hit=1;
    end
    else if (pc_BTB[7] == PC) begin
    PC_Target=target[7];
    hit=1;
    end
    else begin
     PC_Target=0;
     hit=0;
    end
end

endmodule
