module Hazard_Detection_unit(ID_EX_MemRead,IF_ID_Rs1,IF_ID_Rs2,IF_ID_Rd,ID_EX_Rd,
					PC_Stall,IF_ID_Stall,Control_Sig_Stall);
														 
    input ID_EX_MemRead;
    input [4:0] IF_ID_Rs1;
    input [4:0] IF_ID_Rs2;
    input [4:0] IF_ID_Rd;
    input [4:0] ID_EX_Rd;
    output reg PC_Stall;
    output reg IF_ID_Stall;
    output reg Control_Sig_Stall;
    
    
    initial begin
     PC_Stall = 0;
     IF_ID_Stall = 0;
     Control_Sig_Stall = 0;
        end
        
    always @(*) begin
        PC_Stall = 1'b0;
        IF_ID_Stall = 1'b0;
        Control_Sig_Stall = 1'b0;
        
        // Hazard detection condition
        if ((ID_EX_MemRead && ((ID_EX_Rd == IF_ID_Rs1) ||(ID_EX_Rd == IF_ID_Rs2)))) begin
            PC_Stall = 1'b1;
            IF_ID_Stall = 1'b1;
            Control_Sig_Stall = 1'b1;
        end
    end

endmodule
