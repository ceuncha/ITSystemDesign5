module Mem_data_selector(
    input [2:0] load_data_sel,
    input [31:0] store_buffer_data,
    input [31:0] memory_data,
    output reg [31:0] load_data
    
);
always @(*) begin
if(load_data_sel == 3'b000) begin
    load_data = memory_data;
end else if (load_data_sel == 3'b001) begin
    load_data = memory_data;
    load_data = {{16{memory_data[15]}}, memory_data[15:8], store_buffer_data[7:0]}; // LB
end else if (load_data_sel == 3'b010) begin
    load_data = {memory_data[31:16], store_buffer_data[7:0]}; // LB
end else if(load_data_sel == 3'b011) begin
     load_data = {memory_data[31:16], store_buffer_data[15:0]}; // LB
end else begin
    load_data = store_buffer_data;
end
end
endmodule
