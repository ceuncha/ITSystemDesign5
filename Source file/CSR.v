module CSR (
  input wire clk,
  input wire reset,
  input wire exception_sig,
  input wire [31:0] exception_pc,
  input wire [1:0] exception_cause,
  input wire [11:0] ID_CSR_Address,

  input wire CSR_done,
  input wire [31:0] CSR_Result,
  input wire [11:0] RS_CSR_Address,
  
  output reg [31:0] epc,
  output reg [31:0] cause,
  output reg [31:0] csr_out
);
  reg [11:0] address [0:2];
  reg [31:0] CSR_EPC;
  reg [31:0] CSR_CAUSE;
  reg [31:0] CSR_WRITE;
  
  //exception_sig瑜? 諛쏆쑝硫? CSR?젅吏??뒪?꽣?뿉 epc?? cause瑜? ???옣 ?븯?뒗 肄붾뱶 (write)
  always @(posedge clk) begin
    if (reset) begin
      CSR_WRITE <=0;
      CSR_EPC <= 0;
      CSR_CAUSE <= 0;
      address[0][11:0] <= 12'b000000000000; //CSR_WRITE
      address[1][11:0] <= 12'b000000000001; //CSR_CAUSE
      address[2][11:0] <= 12'b000000000010; //CSR_EPC
    end else if (exception_sig) begin
      CSR_EPC <= exception_pc;
      CSR_CAUSE <= {30'b0,exception_cause};
    end
    if (CSR_done) begin
      if(RS_CSR_Address == address[0]) begin
        CSR_WRITE <= CSR_Result; 
      end
      if(RS_CSR_Address == address[1]) begin //exception ?썝?씤 ?젅吏??뒪?꽣?뒗 ?듅?젙紐⑹쟻?쇅?뿉?뒗 ?젒洹쇳븯吏?留먭쾬*
        CSR_CAUSE <= CSR_Result; 
      end
      if(RS_CSR_Address == address[2]) begin //exception 諛쒖깮 二쇱냼 ?젅吏??뒪?꽣?뒗 ?듅?젙紐⑹쟻?쇅?뿉?뒗 ?젒洹쇳븯吏?留먭쾬*
        CSR_EPC <= CSR_Result;
      end
    end
  end

  //csr怨? 愿??젴?맂 紐낅졊?뼱瑜? 諛쏆쑝硫? CSR?젅吏??뒪?꽣?쓽 epc?? cause瑜? ?씫?뒗 肄붾뱶 (read)
  always @(*) begin
      if(ID_CSR_Address == address[0]) begin
        csr_out = CSR_WRITE;
      end else if(ID_CSR_Address == address[1]) begin
        csr_out = CSR_CAUSE;
      end else if(ID_CSR_Address == address[2]) begin
        csr_out = CSR_EPC;
      end else begin
        csr_out = 0;
      end
    epc = CSR_EPC;
    cause = CSR_CAUSE;
  end
  
  endmodule
