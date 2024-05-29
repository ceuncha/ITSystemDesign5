module A_select(
input [31:0] A,
input [31:0] B,
input sel,
input sel2,
output reg [31:0] y
);
always@(*) begin
if(sel&&!sel2) begin
y=A;
end 
else begin
y=B;
end
end
endmodule
