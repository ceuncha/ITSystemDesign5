module data_forwarding_unit(
    input MEM_WB_RegWrite,
    input EX_MEM_RegWrite,
    input [4:0] EX_MEM_Rd,
    input [4:0] ID_EX_Rs1,
    input [4:0] MEM_WB_Rd,
    input [4:0] ID_EX_Rs2,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);

    // EX hazard
    always @(*) begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // Forwarding conditions for EX hazard
        if (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1)) begin
            ForwardA = 2'b10;
        end
        
        if (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2)) begin
            ForwardB = 2'b10;
        end

        // Forwarding conditions for MEM hazard
        if (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && 
            !((EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1))) &&
            (MEM_WB_Rd == ID_EX_Rs1)) begin
            ForwardA = 2'b01;
        end
        
        if (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && 
            !((EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2))) &&
            (MEM_WB_Rd == ID_EX_Rs2)) begin
            ForwardB = 2'b01;
        end
    end

endmodule
