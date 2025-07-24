`timescale 1ns/1ps

module rrc_filter #(
    parameter COEFF = 33
)(
    input logic clk,
    input logic rst,
    input logic signed [15:0] din,
    output logic signed [31:0] dout
);

    logic signed [15:0] taps [0:COEFF-1];
    logic signed [15:0] shift_reg [0:COEFF-1];
    logic signed [31:0] acc_c, acc_n;

    initial begin
        taps[0]  = 16'h0000;
        taps[1]  = 16'hfff1;
        taps[2]  = 16'hfff4;
        taps[3]  = 16'h0000;
        taps[4]  = 16'h000d;
        taps[5]  = 16'h0002;
        taps[6]  = 16'hfffe;
        taps[7]  = 16'h0002;
        taps[8]  = 16'h0000;
        taps[9]  = 16'hffff;
        taps[10] = 16'hfff5;
        taps[11] = 16'hfffa;
        taps[12] = 16'h000a;
        taps[13] = 16'h0021;
        taps[14] = 16'h002c;
        taps[15] = 16'h0017;
        taps[16] = 16'hffe0;
        taps[17] = 16'hffa0;
        taps[18] = 16'hff76;
        taps[19] = 16'hff86;
        taps[20] = 16'hffeb;
        taps[21] = 16'h00a0;
        taps[22] = 16'h01a6;
        taps[23] = 16'h02df;
        taps[24] = 16'h0401;
        taps[25] = 16'h04cc;
        taps[26] = 16'h04ea;
        taps[27] = 16'h0445;
        taps[28] = 16'h02fb;
        taps[29] = 16'h0126;
        taps[30] = 16'hfeef;
        taps[31] = 16'hfc91;
        taps[32] = 16'hfa46;
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            acc_c <= 0;
            for (int i = 0; i < COEFF; i++) begin
                shift_reg[i] <= 0;
            end
        end else begin
            shift_reg[0] <= din;
            for (int i = 1; i < COEFF; i++) begin
                shift_reg[i] <= shift_reg[i-1];
            end
            acc_c <= acc_n;
        end
    end

    always_comb begin
        acc_n = 0;
        for (int i = 0; i < COEFF; i++) begin
            acc_n += shift_reg[i] * taps[i];
        end
    end

    assign dout = acc_c >>> 8;

endmodule

