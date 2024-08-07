module exception_address_unit(
    input clk,
    input [31:0] address,


    output reg address_exception
);

    
    // Reset logic
    always @(posedge clk) begin


            address_exception <=0;

             if (address > 2047) begin
                address_exception <= 1'b1;
             end
             
        end

endmodule
