module DataMemory(
    input wire ROB_MemWrite,
    input wire [31:0] ROB_memadress,
    input wire [2:0] ROB_funct3,
    input wire clk,
    input wire reset,
    input wire [2:0] func3_LS,
    input wire [31:0] out_value,
    input wire [31:0] LS_result,
    input wire LS_MemRead,
    
    input wire ROB_MemRead,  // 08.07 new update
    output reg exception_datamem,
    output reg [31:0] Data_memory_out
);
reg [31:0]load_data;   //08.07 new update
integer i;
reg [31:0] memory [0:2047];
    always @(posedge clk) begin                       
   if (reset) begin
       for (i = 0; i < 2047; i = i + 1) begin
            memory[i] <= i+3;
        end

    end
    if (ROB_MemWrite) begin
        case (ROB_funct3)
            3'b000: memory[ROB_memadress][7:0] <= out_value[7:0]; // SB
            3'b001: memory[ROB_memadress][15:0] <= out_value[15:0]; // SH
            3'b010: memory[ROB_memadress] <= out_value; // SW
            default: ; // No operation (NOP) for other funct3 values, explicitly defined
        endcase
    end
    // Default value for RData, ensures it is always assigned
    Data_memory_out = 32'd0; // if MemRead is false
    if (LS_MemRead) begin
        case (func3_LS)
            3'b000: Data_memory_out = {{24{memory[LS_result][31]}}, memory[LS_result][7:0]}; // LB
            3'b001: Data_memory_out = {{16{memory[LS_result][31]}}, memory[LS_result][15:0]}; // LH
            3'b010: Data_memory_out = memory[LS_result]; // LW
            3'b100: Data_memory_out = {{24{1'b0}}, memory[LS_result][7:0]}; // LBU
            3'b101: Data_memory_out = {{16{1'b0}}, memory[LS_result][15:0]}; // LHU
            default: Data_memory_out = 32'd0; // Default value assignment to handle cases when MemRead is false
        endcase
    end
  end


   always @(*) begin
    exception_datamem=0;
    
    if (ROB_MemRead ) begin  // 08.07 new update
    case (ROB_funct3)
            3'b000: load_data = {{24{memory[ROB_memadress][31]}}, memory[ROB_memadress][7:0]}; // LB
            3'b001: load_data = {{16{memory[ROB_memadress][31]}}, memory[ROB_memadress][15:0]}; // LH
            3'b010: load_data = memory[ROB_memadress]; // LW
            3'b100: load_data = {{24{1'b0}}, memory[ROB_memadress][7:0]}; // LBU
            3'b101: load_data = {{16{1'b0}}, memory[ROB_memadress][15:0]}; // LHU
            default: load_data = 32'd0; // Default value assignment to handle cases when MemRead is false
        endcase
        if (load_data != out_value) begin
        exception_datamem = 1;
        end else begin
        exception_datamem=0;
        end
        end else begin
        exception_datamem=0;
        end
  end

endmodule
