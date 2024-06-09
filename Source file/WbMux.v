module WbMux (
    input [31:0] Address,
    input [31:0] RData,
    input wm2reg,
    input [2:0] MEM_WB_funct3,
    output reg [31:0] mem_out
);

always @(*) begin
    if (wm2reg == 1) begin
        case (MEM_WB_funct3)
            3'b000: begin // LB (Load Byte)
                case (Address[1:0])
                    2'b00: mem_out <= {{24{RData[7]}}, RData[7:0]};   // 바이트 0
                    2'b01: mem_out <= {{24{RData[15]}}, RData[15:8]}; // 바이트 1
                    2'b10: mem_out <= {{24{RData[23]}}, RData[23:16]}; // 바이트 2
                    2'b11: mem_out <= {{24{RData[31]}}, RData[31:24]}; // 바이트 3
                endcase
            end
            3'b001: begin // LH (Load Halfword)
                if (Address[1] == 1'b0) begin
                    mem_out <= {{16{RData[15]}}, RData[15:0]};  // 하위 2바이트
                end else begin
                    mem_out <= {{16{RData[31]}}, RData[31:16]}; // 상위 2바이트
                end
            end
            3'b010: mem_out <= RData; // LW (Load Word)
            3'b100: begin // LBU (Load Byte Unsigned)
                case (Address[1:0])
                    2'b00: mem_out <= {24'b0, RData[7:0]};   // 바이트 0
                    2'b01: mem_out <= {24'b0, RData[15:8]}; // 바이트 1
                    2'b10: mem_out <= {24'b0, RData[23:16]}; // 바이트 2
                    2'b11: mem_out <= {24'b0, RData[31:24]}; // 바이트 3
                endcase
            end
            3'b101: begin // LHU (Load Halfword Unsigned)
                if (Address[1] == 1'b0) begin
                    mem_out <= {16'b0, RData[15:0]};  // 하위 2바이트
                end else begin
                    mem_out <= {16'b0, RData[31:16]}; // 상위 2바이트
                end
            end
            default: mem_out <= 32'd0; // 기본값
        endcase
    end else begin
        mem_out <= Address;
    end
end

endmodule
