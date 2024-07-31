module ExceptionBuffer (
    input clk,
    input [31:0] ex_inst_num,
    input [31:0] exception_pc,

    input [31:0] inst_num_rob,
    input exception_on,
    output exception_on_out,
    output [31:0] handler_pc,

);
    reg [4:0] tail;
    reg [31:0] pc [0:15];
    reg [31:0] inst_num [0:15];

    // Exception buffer logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the buffer and write pointer
            for (i = 0; i < 16; i = i + 1) begin
                pc[i] = 0;
                inst_num[i]=0;                
            end
        handler_pc = 0;
         tail = 0;
        end else begin
            if(exception_pc != 0) begin
                pc[tail] = exception_pc;
                inst_num[tail] = ex_inst_num;
                tail = (tail  + 1)%16; 
            end
        end
    end
    always @(*) begin
            // Output logic for exception handler address
            // Search for the matching instruction number in the buffer
        if(exception_on) begin
            for (i = 0; i < 16; i = i + 1) begin
                if (inst_num[i] == inst_num_rob) begin
                    handler_pc = pc[i];
                    exception_on_out = 1'b1;                    
                end
            end
        end
    end

endmodule
