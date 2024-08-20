module divider
(
    input              clk,
    input              reset,

    input  [31:0]    A,
    input  [31:0]    B,
    input              start,
    
    input [7:0] Physical_address_in,
    input [31:0] PC_in,
    input divider_op_in,
    
    output reg divide_zero_exception,
    output reg [31:0] Result,
    output reg [7:0] Physical_address_out,
    output reg [31:0] PC_out,
    
    output reg             done
);
 localparam                      XLEN          = 32;
 localparam [31:0]               STAGE_LIST    = 32'b01010101010101010101010101010101;
    
   reg  [7:0]        Physical_address_in_reg [XLEN:0]; 
   reg [31:0]        PC_in_reg [XLEN:0];
   reg [3:0]         divider_op_in_reg [XLEN:0];
   reg               divide_zero_exception_reg [XLEN:0];
   reg               ready    [XLEN:0];
   reg [31:0]        dividend [XLEN:0];  
   reg [31:0]        divisor  [XLEN:0];
   reg [31:0]        quotient [XLEN:0];     
   wire [31:0]       quo, rem;

    always@(*) begin
        Physical_address_in_reg[0] = Physical_address_in;
        PC_in_reg[0] = PC_in;
        divider_op_in_reg[0] = divider_op_in;
        divide_zero_exception_reg[0] = (A != 0) && (B == 0);
        ready[0]    = start;    
        dividend[0] = A;
        divisor[0]  = B;
        quotient[0] = 0;
    end   

    generate
        genvar i;
        for (i = 0; i < XLEN; i = i + 1) begin: gen_div

            wire [i:0] m = dividend[i] >> (XLEN-i-1);
            wire [i:0] n = divisor[i];
            wire q = (|(divisor[i] >> (i+1))) ? 1'b0 : (m >= n);
            wire [i:0] t = q ? (m - n) : m;
            wire [XLEN-1:0] u = dividend[i] << (i+1);
            wire [XLEN+i:0] d = {t, u} >> (i+1);

            if (STAGE_LIST[XLEN-i-1]) begin: gen_ff
                always @ (posedge clk) begin
                    if (reset) begin
                        Physical_address_in_reg[i+1] <= 0;
                        PC_in_reg[i+1] <= 0;
                        divider_op_in_reg[i+1] <= 0;
                        divide_zero_exception_reg[i+1] <= 0;
                        ready[i+1] <= 0;
                        dividend[i+1] <= 0;
                        divisor[i+1] <= 0;
                        quotient[i+1] <= 0;
                    end else begin
                        Physical_address_in_reg[i+1] <= Physical_address_in_reg[i];
                        PC_in_reg[i+1] <= PC_in_reg[i];
                        divider_op_in_reg[i+1] <= divider_op_in_reg[i];
                        divide_zero_exception_reg[i+1] <= divide_zero_exception_reg[i];
                        ready[i+1] <= ready[i];
                        dividend[i+1] <= d;
                        divisor[i+1] <= divisor[i];
                        quotient[i+1] <= quotient[i] | (q << (XLEN-i-1));
                    end
                end
            end else begin: gen_comb
                always @* begin
                    Physical_address_in_reg[i+1] = Physical_address_in_reg[i];
                    PC_in_reg[i+1] = PC_in_reg[i];
                    divider_op_in_reg[i+1] = divider_op_in_reg[i];
                    divide_zero_exception_reg[i+1] = divide_zero_exception_reg[i];
                    ready[i+1]    = ready[i];
                    dividend[i+1] = d;
                    divisor[i+1]  = divisor[i];
                    quotient[i+1] = quotient[i] | (q << (XLEN-i-1));                  
                end
            end
        end
    endgenerate
    
    always @* begin
        Result = (divider_op_in_reg[XLEN] == 4'b0001) ? quo : rem;
        divide_zero_exception = divide_zero_exception_reg[XLEN];
        Physical_address_out = Physical_address_in_reg[XLEN];
        PC_out = PC_in_reg[XLEN];
        done = ready[XLEN];
    end

    assign quo = quotient[XLEN];
    assign rem = dividend[XLEN];

endmodule
