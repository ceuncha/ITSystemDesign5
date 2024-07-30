module EPC(
  input wire exception_sig,
  input wire mret_sig,
  input wire EPC,
  output reg [31:0] Return_PC
  
);

  reg [31:0] register;
  always @(posedge clk) begin
    if (exception_sig) begin
      register <= EPC;
    end
    if (mret_sig) begin
      Return_PC <= register;
    end
  end
  

endmodule
