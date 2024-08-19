/////////////////////////////////////////////////////////////////////////////////////
//
//Copyright 2019  Li Xinbing
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
//
/////////////////////////////////////////////////////////////////////////////////////

`define N(n)                       [(n)-1:0]
`define FFx(signal,bits)           always @ ( posedge clk  ) if (   reset   )  signal <= bits;  else



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
    
    output divide_zero_exception,
    output [31:0] Result,
    output [7:0] Physical_address_out,
    output [31:0] PC_out,
    
    output             done
);
 localparam                      XLEN          = 32;
 localparam `N(XLEN)             STAGE_LIST    = 32'b01010101010101010101010101010101;
    
    reg  [7:0]        Physical_address_in_reg `N(XLEN+1); 
    reg [31:0]        PC_in_reg `N(XLEN+1);
    reg [3:0]         divider_op_in_reg `N(XLEN+1);
    reg               divide_zero_exception_reg `N(XLEN+1);
    reg               ready    `N(XLEN+1);
    reg `N(XLEN)      dividend `N(XLEN+1);  
    reg `N(XLEN)      divisor  `N(XLEN+1);
    reg `N(XLEN)      quotient `N(XLEN+1);     
    wire [31:0] quo, rem;

    always@* begin
        Physical_address_in_reg[0] = Physical_address_in;
        PC_in_reg[0] = PC_in;
        divider_op_in_reg[0] = divider_op_in;
        divide_zero_exception_reg[0] = (A!=0) && (B==0);
        ready[0]    = start;    
        dividend[0] = A;
        divisor[0]  = B;
        quotient[0] = 0;
    end   

    generate
    	genvar i;
    	for (i=0;i<XLEN;i=i+1) begin:gen_div

            wire [i:0]      m = dividend[i]>>(XLEN-i-1);
             
            wire [i:0]      n = divisor[i];
     
    	    wire            q = (|(divisor[i]>>(i+1))) ? 1'b0 : ( m>=n );
     
    	    wire [i:0]      t = q ? (m - n) : m;

			wire [XLEN-1:0] u = dividend[i]<<(i+1);
			    
    	    wire [XLEN+i:0] d = {t,u}>>(i+1);

            if (STAGE_LIST[XLEN-i-1]) begin:gen_ff
                `FFx(Physical_address_in_reg[i],0)
                Physical_address_in_reg[i+1] <= Physical_address_in_reg[i];
                
                `FFx(PC_in_reg[i],0)
                PC_in_reg[i+1] <= PC_in_reg[i];
                
                `FFx(divider_op_in_reg[i],0)
                divider_op_in_reg[i+1] <= divider_op_in_reg[i];
                
                `FFx(divide_zero_exception_reg[i],0)
                divide_zero_exception_reg[i+1] <= divide_zero_exception_reg[i];
                
                `FFx(ready[i],0)
                ready[i+1] <= ready[i];

                `FFx(dividend[i],0)
                dividend[i+1] <= d;

                `FFx(divisor[i],0)
                divisor[i+1] <= divisor[i];

                `FFx(quotient[i],0)
                quotient[i+1] <= quotient[i]|(q<<(XLEN-i-1));
               
            end else begin:gen_comb
                always @* begin
                    Physical_address_in_reg[i+1] = Physical_address_in_reg[i];
                    PC_in_reg[i+1] = PC_in_reg[i];
                    divider_op_in_reg[i+1] = divider_op_in_reg[i];
                    divide_zero_exception_reg[i+1] = divide_zero_exception_reg[i];
                	ready[i+1]    = ready[i];
                	dividend[i+1] = d;
                    divisor[i+1]  = divisor[i];
                	quotient[i+1] = quotient[i]|(q<<(XLEN-i-1));                	
                end
            end
        end
    endgenerate
    
    assign Result = (divider_op_in_reg[XLEN]==4'b0001) ? quo : rem ;
    
    assign divide_zero_exception = divide_zero_exception_reg [XLEN];
    
    assign Physical_address_out = Physical_address_in_reg[XLEN];
    
    assign PC_out = PC_in_reg[XLEN];

    assign  quo = quotient[XLEN];

    assign  rem = dividend[XLEN];

    assign done = ready[XLEN];

endmodule
