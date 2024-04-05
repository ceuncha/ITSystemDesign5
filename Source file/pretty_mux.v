module pretty_mux (

    input wire [31:0] mem_out,

    input wire [31:0] imm_out,

    input wire [31:0] PC_imm,

    input wire [31:0] MEM_WB_PC_Plus4,

    input wire [1:0] MEM_WB_RWSet,

    output reg [31:0] Write_Data

);



always @(*) begin

    case (MEM_WB_RWSet)

        2'b00: Write_Data = mem_out; // MEM_WB_RWSet이 00이면 mem_out 출력

        2'b01: Write_Data = imm_out; // MEM_WB_RWSet이 01이면 imm_out 출력

        2'b10: Write_Data = PC_imm; // MEM_WB_RWSet이 10이면 PC_imm 출력

        2'b11: Write_Data = MEM_WB_PC_Plus4; // MEM_WB_RWSet이 11이면 MEM_WB_PC_Plus4 출력

        default: Write_Data = 32'b0; // 그 외의 경우에는 기본값으로 0을 출력

    endcase

end



endmodule
