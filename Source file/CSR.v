module CSR (
  input wire clk,
  input wire reset,
  input wire exception_sig,
  input wire [31:0] exception_pc,
  input wire [4:0] exception_cause,
  input wire CSR_inst_on,
  
  output reg [31:0] epc,
  output reg [31:0] cause
);

  reg [31:0] CSR_EPC;
  reg [31:0] CSR_CAUSE;
  
  always @(posedge clk) begin
    if (rst) begin
      CSR_EPC <= 0;
      CSR_CAUSE <= 0;
    end else if (exception_sig) begin
      CSR_EPC <= exception_pc;
      CSR_CAUSE <= excpetion_cause;
    end
  end


  always @(*) begin
    if (CSR_inst_in) begin
      epc = CSR_EPC;
      cause = CSR_cause;
    end else begin
      epc = 0;
      cause = 0;
    end
  end
  
  endmodule
