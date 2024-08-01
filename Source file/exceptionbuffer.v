module ExceptionBuffer (
    input clk,
    input [31:0] ex_inst_num,
    input [31:0] EHR_PC,
    input [31:0] exception_cause,
    
    input [31:0] inst_num_rob,
    input exception_on,
  
    output [31:0] handler_pc,
    output [31:0] CSR_EPC,
    output [3:0] CSR_cause
);
    reg [4:0] tail;
    reg [31:0] ehr_pc[0:15];
    reg [31:0] inst_num [0:15];
    reg [3:0] cause [0:15];
    // Exception buffer logic
    always @(posedge clk) begin
        if (rst) begin
            // Reset the buffer and write pointer
            for (i = 0; i < 16; i = i + 1) begin
                ehr_pc[i] <= 0;
                inst_num[i] <= 0;
                cause[i] <= 0;
            end
         handler_pc <= 0;
         CSR_cause <= 0;
         tail <= 0;
        end else begin
            if(exception_pc != 0) begin
                ehr_pc[tail] <= EHR_PC;
                inst_num[tail] <= ex_inst_num;
                cause[tail] <= excpetion_cause;
                tail <= (tail  + 1)%16; 
            end
        end
    end
    always @(*) begin
            // Output logic for exception handler address
            // Search for the matching instruction number in the buffer
        if(exception_on) begin
            for (i = 0; i < 16; i = i + 1) begin
                if (inst_num[i] == inst_num_rob) begin
                    handler_pc <= ehr_pc[i];
                    CSR_cause <= cause[i];
                end
            end
        end
    end

endmodule
