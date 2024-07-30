module EPC(
  input wire exception_sig,
  input wire [31:0] EPC,
  output reg [31:0] Return_PC
  
);

  reg [31:0] register;
  always @(posedge clk) begin
    if (exception_sig) begin
      Return_PC <= EPC;
    end
  end
  

endmodule
