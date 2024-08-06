module freelist (  //RAT, CPU_TOP, ROB, 
    input clk,
    input reset,
    input exception,
    input mret_sig,

    input no_reg_write,
    input [7:0] rat_data,
    input [31:0] inst_num_in,
    input [31:0] rob_inst_num,
    input rob_regwrite,
    output reg [7:0] freelist_out
);
     parameter SIZE = 128;

    reg [7:0] freelist_array [0:SIZE-1];
    reg [6:0] current_block;
    reg [6:0] next_block;
    reg [6:0] prev_block;
    reg [6:0] prev2_block;
    reg rob_prev_regwrite;
    reg [6:0] commit_block;
    reg [31:0] inst_num [0:SIZE-1];
    reg freelist_on [0:SIZE-1];

    integer i;


always @(posedge clk) begin
    if(reset | exception | mret_sig) begin
        for (i = 0; i < SIZE; i = i + 1) begin
            freelist_array[i] <= 32 + i;
            prev_block <= 0;
            prev2_block <= SIZE-1;
            current_block <= 1;
            next_block <= 2;
            inst_num[i] <= 32'hffffffff;
            freelist_on[i] <= 1;
            rob_prev_regwrite <= 0;
            commit_block <= 0;
            freelist_out <= 32;
        end
        freelist_on[0] <= 0;
    end else begin
        freelist_out <= freelist_array[current_block];
        prev_block <= current_block;
        prev2_block <= prev_block;
        current_block <= next_block;
        freelist_array[prev2_block] <= rat_data;
        if(!no_reg_write) begin
            freelist_on[prev2_block] <= 0;
            inst_num[prev2_block] <= inst_num_in;
        end
        
        rob_prev_regwrite <= rob_regwrite;

        for (i = SIZE-1; i >= 0; i = i - 1) begin
            if(freelist_on[i] && (i != current_block) && (i != next_block) && (i!=commit_block)&&(i != prev_block)&&(i != prev2_block)) begin
                next_block <= i;
            end
        end

        for (i = SIZE-1; i >= 0; i = i - 1) begin
            if(rob_regwrite && (inst_num[i]==rob_inst_num)) begin
                commit_block <= i;
            end
        end        

        if(rob_prev_regwrite) begin
            freelist_on[commit_block] <= 1;
        end
        

    end



end




endmodule
