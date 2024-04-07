module PC_Adder(PC, PC_Plus4);
    input [31:0] PC;
    output reg [31:0] PC_Plus4;
    
    initial
    begin
        PC_Plus4 = 32'd4; 
    end
    
    always @ (*)
    begin
        PC_Plus4 [31:0] <= PC [31:0] + 32'd4; 
    end
endmodule
