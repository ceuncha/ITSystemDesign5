module store_buffer(
    input clk,
    input reset,
    input exception,
    input memwrite,
    input memread,
    input mret_sig,

    input [2:0] funct3,
    input [7:0] load_phy,
    input [31:0] inst_num,
    input [31:0] mem_addr,
    input [31:0] mem_data,


    output reg [31:0] load_data,
    output reg [7:0] load_phy_out,
    output reg [31:0] inst_num_out,
    output reg [2:0] load_valid,

    output reg load_done_out,
    output reg exception_flag,
    output reg [31:0] store_address_out,

    input memwrite_rob,
    input [31:0] mem_addr_rob,
    input [31:0] inst_num_rob
);
    parameter SIZE = 16;
    
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

        if (reset || exception || mret_sig) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                buffer_inst_num[i] <= 0;
                buffer_mem_addr[i] <= 0;
                buffer_mem_data[i] <= 0;
                entry_val[i] <= 0;
                funct3s [i] <= 0;
            end
            current_block <= 0;
            next_block <= 1;
            load_data <= 0;
            load_valid <= 0;
            load_phy_out <= 0;
            load_done_out <= 0;
            store_address_out <= 0;
            exception_flag <= 0;

        end else begin
            load_done_out <= 0;
            load_phy_out <= load_phy;
            inst_num_out <= inst_num;
            store_address_out <= 0;
            if(memwrite_rob) begin
                for (i = 0; i < SIZE; i = i + 1) begin
                    if(buffer_inst_num[i]==inst_num_rob) begin
                            entry_val[i] <= 0;
                            buffer_inst_num[i] <= 0;
                            buffer_mem_addr[i] <= 0;
                    end
                end
            end
            


            
            if (memwrite) begin
                load_valid <= 3'b111;
                load_done_out <= 1;
                for (i = SIZE-1; i >= 0; i = i - 1) begin
                    if(!entry_val[i] && (i != current_block)&&(i != next_block)) begin
                            next_block <= i;
                    end
                end

                buffer_mem_addr[current_block] <= mem_addr;  
                buffer_inst_num[current_block] <= inst_num; 
                entry_val[current_block] <= 1'b1;
                inst_num_out <= inst_num;
                load_phy_out <= 8'd160;
                store_address_out <= mem_addr;
                load_data <= mem_data;
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
            end


            // Check for existing entry with the same address
                for (i = 0; i < SIZE; i = i + 1) begin
                    if (buffer_mem_addr[i] == mem_addr) begin
                            buffer_inst_num[i] <= 0;
                            buffer_mem_addr[i] <= 0;  
                            entry_val[i] <= 1'b0;
                            funct3s[i] <= 1'b0;
                       
                    end
                end
            current_block <= next_block;
        
     
            if (memread) begin
                load_valid <= 3'b000;
                load_done_out <= 1'b1;
                store_address_out <= mem_addr;
                for (i = 0; i < SIZE; i = i + 1) begin
                    if (buffer_mem_addr[i] == mem_addr) begin 
                        load_valid <= 3'b111;
                        if (funct3 == 3'b000) begin 
                            load_data <= {{24{buffer_mem_data[i][7]}}, buffer_mem_data[i][7:0]}; // LB
                        end else if (funct3 == 3'b001) begin //LH
                            load_data <= {{16{buffer_mem_data[i][15]}}, buffer_mem_data[i][15:0]}; // LH


                        end else if (funct3 == 3'b010) begin //�븯�쐞 16諛붿씠�듃留� 留욎쓬
                            load_data <= buffer_mem_data[i]; // LW
                        end else if (funct3 == 3'b100) begin
                            load_data <= {{24{1'b0}}, buffer_mem_data[i][7:0]}; // LBU
                        end else if (funct3 == 3'b101) begin
                            load_data <= {{16{1'b0}}, buffer_mem_data[i][15:0]}; // LHU
                        end 
                    end
                end
            end
            
        end   
        end


endmodule
