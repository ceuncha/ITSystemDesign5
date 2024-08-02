module store_buffer(
    input clk,
    input reset,
    input exception,
    input memwrite,
    input memread,
    input load_done,

    input [2:0] funct3,
    input [7:0] load_phy,
    input [31:0] inst_num,
    input [31:0] mem_addr,
    input [31:0] mem_data,


    output reg [31:0] load_data,
    output reg [7:0] load_phy_out,
    output reg [31:0] inst_num_out,
    output reg [2:0] load_valid,
    output reg [2:0] funct3_out,
    output reg load_done_out,
    output reg exception_flag,

    input memwrite_rob,
    input [31:0] mem_addr_rob,
    input [31:0] inst_num_rob
);
    parameter SIZE = 32;
    
    reg [31:0] buffer_inst_num [0:SIZE-1];
    reg [31:0] buffer_mem_addr [0:SIZE-1];
    reg [31:0] buffer_mem_data [0:SIZE-1];
    reg [2:0] funct3s [0:SIZE-1];

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
            load_data <= 0;
            load_valid <= 0;
            load_phy_out <= 0;
            load_done_out <= 0;

        end else begin
            load_done_out <= 0;
            load_phy_out <= load_phy;
            inst_num_out <= inst_num;
            
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
            
            if (memwrite) begin
                buffer_mem_addr[current_block] <= mem_addr;  
                buffer_inst_num[current_block] <= inst_num; 
                entry_val[current_block] <= 1'b1;
                inst_num_out <= inst_num;
                load_phy_out <= 8'd160;


                if (funct3 == 3'b000) begin
                    buffer_mem_data[current_block] <= mem_data[7:0]; // SB
                    funct3s[current_block]<= 3'b000;
                end else if (funct3 == 3'b001) begin
                    buffer_mem_data[current_block] <= mem_data[15:0]; // SH
                    funct3s[current_block]<= 3'b001;  
                end else if (funct3 == 3'b010) begin
                    buffer_mem_data[current_block] <= mem_data; // SW
                    funct3s[current_block] <= 3'b010;  
                end



            // Check for existing entry with the same address
                for (i = 0; i < SIZE; i = i + 1) begin
                    if (buffer_mem_addr[i] == mem_addr) begin
                        if (buffer_inst_num[i] < inst_num) begin
                            buffer_mem_addr[i] <= 0;  
                            entry_val[i] <= 1'b0;
                            if(funct3s[i] == 3'b010) begin
                                if(funct3 == 3'b000) begin
                                buffer_mem_addr[current_block] <= {buffer_mem_data[i][31:8], mem_data[7:0]}
                                funct3s[current_block] <= 3'b010;
                                end
                                else if(funct3 == 3'b001) begin
                                buffer_mem_addr[current_block] <= {buffer_mem_data[i][31:16], mem_data[15:0]}
                                funct3s[current_block] <= 3'b010;
                                end
                            end
                        else if (funct3s[i] == 3'b001) begin
                             if(funct3 == 3'b000) begin
                                buffer_mem_addr[current_block] <= {buffer_mem_data[i][31:8], mem_data[7:0]}
                            end
                        end
                        end else begin
                            buffer_mem_addr[current_block] <= 0;  
                            entry_val[current_block] <= 1'b0;
                            if(funct3 == 3'b010) begin
                                if(funct3s[i] == 3'b000) begin
                                buffer_mem_addr[i] <= {mem_data[31:8], buffer_mem_data[i][7:0]}
                                funct3s[i] <= 3'b010;
                                end
                                else if(funct3s[i] == 3'b001) begin
                                buffer_mem_addr[i] <= {mem_data[31:16], buffer_mem_data[i][15:0]}
                                funct3s[current_block] <= 3'b010;
                                end
                            
                            end else if (funct3 == 3'b001) begin
                                if(funct3s[i] == 3'b000) begin
                                    buffer_mem_addr[i] <= {mem_data[31:8], buffer_mem_data[i][7:0]}
                                end
                            end
                        end
                    end
                end

        
     
            end else if (memread) begin
                load_valid <= 3'b000;
                load_done_out <= 1'b1;

                for (i = 0; i < SIZE; i = i + 1) begin
                    if (buffer_mem_addr[i] == mem_addr) begin
                        if(buffer_inst_num[i] > inst_num) begin
                            exception_flag <= 1'b1;
                        end
                        load_data <= buffer_mem_data[i];
                        load_valid <= 3'b111;
                        if (funct3 == 3'b000) begin 
                            load_data <= {{24{buffer_mem_data[i][7]}}, buffer_mem_data[i][7:0]}; // LB
                        end else if (funct3 == 3'b001) begin //LH
                            load_data <= {{16{buffer_mem_data[i][15]}}, buffer_mem_data[i][15:0]}; // LH
                            if(funct3s[i] == 3'b000) begin //하위 8바이트만 맞음
                                load_valid <= 3'b001;
                            end

                        end else if (funct3 == 3'b010) begin //하위 16바이트만 맞음
                            load_data <= buffer_mem_data[i]; // LW
                                if(funct3s[i] == 3'b000) begin
                                    load_valid <= 3'b010;
                                end else if(funct3s[i] == 3'b001) begin
                                    load_valid <= 3'b011;
                            end
                        end
                    end
                end
            end
            current_block <= next_block;
        end   

    end

endmodule
