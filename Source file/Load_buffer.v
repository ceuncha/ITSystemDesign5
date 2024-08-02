module Load_buffer(
    input clk,
    input reset,
    input exception,
    input memwrite,
    input memread,

    input [31:0] load_inst_num,
    input [31:0] load_address,
    
    input [31:0] store_address,
    input [31:0] store_inst_num,

    output reg Load_exception,

    input [31:0] mem_addr_rob,
    input [31:0] inst_num_rob
);
    parameter SIZE = 32;
    
    reg [31:0] buffer_inst_num [0:SIZE-1];
    reg [31:0] buffer_mem_addr [0:SIZE-1];
    reg [31:0] buffer_mem_data [0:SIZE-1];

    reg [SIZE-1:0] entry_val;
    reg [4:0] current_block;
    reg [4:0] next_block;
    integer i;
    
    // Reset logic
    always @(posedge clk) begin

        if (reset || exception) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                buffer_inst_num[i] <= 0;
                buffer_mem_addr[i] <= 0;
                buffer_mem_data[i] <= 0;
                entry_val[i] <= 0;
            end
            current_block <= 0;
            next_block <= 1;

        end else begin
            
             for (i = 0; i < SIZE; i = i + 1) begin
               if((buffer_mem_addr[i] == mem_addr_rob)&&(buffer_inst_num[i]==inst_num_rob)) begin
                    entry_val[i] <= 0;
               end
             end

            
            for (i = SIZE-1; i >= 0; i = i - 1) begin
               if(!entry_val[i] && (i != current_block)) begin
                    next_block <= i;
               end
             end
            
            if (memread) begin
                buffer_mem_addr[current_block] <= load_address;  
                buffer_inst_num[current_block] <= load_inst_num; 
                entry_val[current_block] <= 1'b1;






            // Check for existing entry with the same address
                for (i = 0; i < SIZE; i = i + 1) begin
                    if (buffer_mem_addr[i] == load_address) begin
                        if (buffer_inst_num[i] < load_inst_num) begin
                            buffer_mem_addr[i] <= 0;  
                            entry_val[i] <= 1'b0;
                        end else begin
                            buffer_mem_addr[current_block] <= 0;  
                            entry_val[current_block] <= 1'b0;
                        end
                    end
                end

        
     
            end else if (memwrite) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                    if (buffer_mem_addr[i] == store_address) begin
                        if (buffer_inst_num[i] > store_inst_num) begin
                            Load_exception <= 1'b1;  
                            
                        end else begin
                          Load_exception <= 0;
                        end
                    end
                end
            current_block <= next_block;
        end   

    end
end
endmodule
