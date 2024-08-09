module mem_buffer(
    input wire clk,
    input wire LS_MemWrite,
    input wire LS_MemRead,

    input wire [2:0] func3_LS,
    input wire [31:0] LS_Result, //mem addr
    input wire [7:0] Load_Phy,  
    input wire [31:0] LS_inst_num,  
    
    input wire [31:0] Operand2_LS,  //Write_data
    input wire [31:0] mem_addr_rob, //mem addr from rob
    input wire [31:0] inst_num_rob, //inst num from rob

    output reg LS_MemWrite_buff,
    output reg LS_MemRead_buff,
    output reg [2:0] func3_LS_buff,
    output reg [31:0] LS_Result_buff, //mem addr
    output reg [7:0] Load_Phy_buff,
    output reg [31:0] LS_inst_num_buff,  
    output reg [31:0] Operand2_LS_buff,  //Write_data

    output reg memwrite_rob,    
    output reg [31:0] mem_addr_rob_buff, //mem addr from rob
    output reg [31:0] inst_num_rob_buff //inst num from rob
);


always @(posedge clk) begin
    LS_MemWrite_buff <= LS_MemWrite;
    LS_MemRead_buff <= LS_MemRead;
    func3_LS_buff <= func3_LS;
    LS_Result_buff <= LS_Result;
    Load_Phy_buff <= Load_Phy;
    LS_inst_num_buff <= LS_inst_num;
    Operand2_LS_buff <= Operand2_LS;
    mem_addr_rob_buff <= mem_addr_rob;
    inst_num_rob_buff <= inst_num_rob;
    memwrite_rob_buff <= memwrite_rob;
end

endmodule
