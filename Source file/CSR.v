module CSR (
  input wire clk,
  input wire reset,
  input wire exception_sig,
  input wire [31:0] exception_pc,
  input wire [4:0] exception_cause,
  input wire [11:0] ID_CSR_Address,
  
  input wire CSR_done,
  input wire [31:0] CSR_Result,
  input wire [11:0] RS_CSR_Address,
  
  output reg [31:0] epc,
  output reg [1:0] cause,
  output reg [31:0] csr_out
);
  reg [11:0] address [0:2];
  reg [31:0] CSR_EPC;
  reg [1:0] CSR_CAUSE;
  reg [31:0] CSR_WRITE;
  
  //exception_sig를 받으면 CSR레지스터에 epc와 cause를 저장 하는 코드 (write)
  always @(posedge clk) begin
    if (rst) begin
      CSR_EPC <= 0;
      CSR_CAUSE <= 0;
      address[0][11:0] <= 12'b000000000000; //CSR_WRITE
      address[1][11:0] <= 12'b000000000001; //CSR_CAUSE
      address[2][11:0] <= 12'b000000000010; //CSR_EPC
    end else if (exception_sig) begin
      CSR_EPC <= exception_pc;
      CSR_CAUSE <= excpetion_cause;
    end
    if (CSR_done) begin
      if(RS_CSR_Address == address[0]) begin
        CSR_WRITE <= CSR_Result; 
      end
      if(RS_CSR_Address == address[1]) begin //exception 원인 레지스터는 특정목적외에는 접근하지말것*
        CSR_=CAUSE <= CSR_Result; 
      end
      if(RS_CSR_Address == address[2]) begin //exception 발생 주소 레지스터는 특정목적외에는 접근하지말것*
        CSR_EPC <= CSR_Result;
      end
    end
  end

  //csr과 관련된 명령어를 받으면 CSR레지스터의 epc와 cause를 읽는 코드 (read)
  always @(*) begin
    if(ID_CSR_Address == address[0]) begin
       csr_out = CSR_WRITE;
    end
    if(ID_CSR_Address == address[1]) begin
      csr_out = CSR_CAUSE;
    end
    if(ID_CSR_Address == address[2]) begin
      csr_out = CSR_EPC;
    end
  end
  
  endmodule
