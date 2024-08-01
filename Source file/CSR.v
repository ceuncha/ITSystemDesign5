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

  //exception_sig를 받으면 CSR레지스터에 epc와 cause를 저장 하는 코드 (write)
  always @(posedge clk) begin
    if (rst) begin
      CSR_EPC <= 0;
      CSR_CAUSE <= 0;
    end else if (exception_sig) begin
      CSR_EPC <= exception_pc;
      CSR_CAUSE <= excpetion_cause;
    end
  end

  //csr과 관련된 명령어를 받으면 CSR레지스터의 epc와 cause를 읽는 코드 (read)
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
