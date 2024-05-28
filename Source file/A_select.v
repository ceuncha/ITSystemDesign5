module A_select(
input [31:0] A,
input [31:0] B,
input ID_EX_jump,
input ALUSrc,
output reg [31:0] y
);
always@(*) begin
if(ID_EX_jump&&(~ALUSrc)) begin
y=A;
end 
else begin
y=B;
end
end
endmodule
