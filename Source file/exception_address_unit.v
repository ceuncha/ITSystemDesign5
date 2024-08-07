module exception_address_unit(
    input clk,
    input reset,
    input excetpion_sig,
    input mret_sig,
    input [31:0] address,


    output reg address_exception
);

    
    // Reset logic
    always @(posedge clk) begin

        if (reset || exception_sig || mret_sig) begin
            address_exception <=0;
        end else begin
            address_exception <=0;
             if (address > 2047) begin
                address_exception <= 1'b1;
             end
             
        end

endmodule
