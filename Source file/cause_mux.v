module cause_mux(
  input wire [1:0] ROB_cause,
  input wire exception_datamem,
  output reg [1:0] Real_cause
);

    always @ (*) begin
      if (exception_datamem) begin
        Real_cause <= ROB_cause;
      end else begin
        Real_cause <= 2'b10;
    end

endmodule
