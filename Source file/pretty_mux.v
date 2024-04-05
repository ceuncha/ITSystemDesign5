module pretty_mux(
    input wire [31:0] mem_out,          
    input wire [31:0] MEM_WB_Rd_data,   
    input wire MEM_WB_RWSet,            
    output reg [31:0] Write_Data       
);

    always @(*) begin
        if (MEM_WB_RWSet == 1'b0) begin
            Write_Data = mem_out;       
        end else if (MEM_WB_RWSet == 1'b1) begin
            Write_Data = MEM_WB_Rd_data;
        end
    end

endmodule
