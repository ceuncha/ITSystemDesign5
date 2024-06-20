module priority_encoder (
    input wire [63:0] ready, // 64鍮꾪듃 ready ?떊?샇
    input wire [6:0] head,
    output reg [63:0] Y // 64鍮꾪듃 Y 異쒕젰
);

always @(*) begin
    // ?슦?꽑?닚?쐞 ?씤肄붾뜑 ?끉由?
    if (ready[(head+0)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000000001;
    else if (ready[(head+1)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000000010;
    else if (ready[(head+2)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000000100;
    else if (ready[(head+3)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000001000;
    else if (ready[(head+4)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000010000;
    else if (ready[(head+5)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000000100000;
    else if (ready[(head+6)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000001000000;
    else if (ready[(head+7)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000010000000;
    else if (ready[(head+8)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000000100000000;
    else if (ready[(head+9)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000001000000000;
    else if (ready[(head+10)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000010000000000;
    else if (ready[(head+11)%64]) Y = 64'b0000000000000000000000000000000000000000000000000000100000000000;
    else if (ready[(head+12)%64]) Y = 64'b0000000000000000000000000000000000000000000000000001000000000000;
    else if (ready[(head+13)%64]) Y = 64'b0000000000000000000000000000000000000000000000000010000000000000;
    else if (ready[(head+14)%64]) Y = 64'b0000000000000000000000000000000000000000000000000100000000000000;
    else if (ready[(head+15)%64]) Y = 64'b0000000000000000000000000000000000000000000000001000000000000000;
    else if (ready[(head+16)%64]) Y = 64'b0000000000000000000000000000000000000000000000010000000000000000;
    else if (ready[(head+17)%64]) Y = 64'b0000000000000000000000000000000000000000000000100000000000000000;
    else if (ready[(head+18)%64]) Y = 64'b0000000000000000000000000000000000000000000001000000000000000000;
    else if (ready[(head+19)%64]) Y = 64'b0000000000000000000000000000000000000000000010000000000000000000;
    else if (ready[(head+20)%64]) Y = 64'b0000000000000000000000000000000000000000000100000000000000000000;
    else if (ready[(head+21)%64]) Y = 64'b0000000000000000000000000000000000000000001000000000000000000000;
    else if (ready[(head+22)%64]) Y = 64'b0000000000000000000000000000000000000000010000000000000000000000;
    else if (ready[(head+23)%64]) Y = 64'b0000000000000000000000000000000000000000100000000000000000000000;
    else if (ready[(head+24)%64]) Y = 64'b0000000000000000000000000000000000000001000000000000000000000000;
    else if (ready[(head+25)%64]) Y = 64'b0000000000000000000000000000000000000010000000000000000000000000;
    else if (ready[(head+26)%64]) Y = 64'b0000000000000000000000000000000000000100000000000000000000000000;
    else if (ready[(head+27)%64]) Y = 64'b0000000000000000000000000000000000001000000000000000000000000000;
    else if (ready[(head+28)%64]) Y = 64'b0000000000000000000000000000000000010000000000000000000000000000;
    else if (ready[(head+29)%64]) Y = 64'b0000000000000000000000000000000000100000000000000000000000000000;
    else if (ready[(head+30)%64]) Y = 64'b0000000000000000000000000000000001000000000000000000000000000000;
    else if (ready[(head+31)%64]) Y = 64'b0000000000000000000000000000000010000000000000000000000000000000;
    else if (ready[(head+33)%64]) Y = 64'b0000000000000000000000000000001000000000000000000000000000000000;
    else if (ready[(head+34)%64]) Y = 64'b0000000000000000000000000000010000000000000000000000000000000000;
    else if (ready[(head+35)%64]) Y = 64'b0000000000000000000000000000100000000000000000000000000000000000;
    else if (ready[(head+36)%64]) Y = 64'b0000000000000000000000000001000000000000000000000000000000000000;
    else if (ready[(head+37)%64]) Y = 64'b0000000000000000000000000010000000000000000000000000000000000000;
    else if (ready[(head+38)%64]) Y = 64'b0000000000000000000000000100000000000000000000000000000000000000;
    else if (ready[(head+39)%64]) Y = 64'b0000000000000000000000001000000000000000000000000000000000000000;
    else if (ready[(head+40)%64]) Y = 64'b0000000000000000000000010000000000000000000000000000000000000000;
    else if (ready[(head+41)%64]) Y = 64'b0000000000000000000000100000000000000000000000000000000000000000;
    else if (ready[(head+42)%64]) Y = 64'b0000000000000000000001000000000000000000000000000000000000000000;
    else if (ready[(head+43)%64]) Y = 64'b0000000000000000000010000000000000000000000000000000000000000000;
    else if (ready[(head+44)%64]) Y = 64'b0000000000000000000100000000000000000000000000000000000000000000;
    else if (ready[(head+45)%64]) Y = 64'b0000000000000000001000000000000000000000000000000000000000000000;
    else if (ready[(head+46)%64]) Y = 64'b0000000000000000010000000000000000000000000000000000000000000000;
    else if (ready[(head+47)%64]) Y = 64'b0000000000000000100000000000000000000000000000000000000000000000;
    else if (ready[(head+48)%64]) Y = 64'b0000000000000001000000000000000000000000000000000000000000000000;
    else if (ready[(head+49)%64]) Y = 64'b0000000000000010000000000000000000000000000000000000000000000000;
    else if (ready[(head+50)%64]) Y = 64'b0000000000000100000000000000000000000000000000000000000000000000;
    else if (ready[(head+51)%64]) Y = 64'b0000000000001000000000000000000000000000000000000000000000000000;
    else if (ready[(head+52)%64]) Y = 64'b0000000000010000000000000000000000000000000000000000000000000000;
    else if (ready[(head+53)%64]) Y = 64'b0000000000100000000000000000000000000000000000000000000000000000;
    else if (ready[(head+54)%64]) Y = 64'b0000000001000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+55)%64]) Y = 64'b0000000010000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+56)%64]) Y = 64'b0000000100000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+57)%64]) Y = 64'b0000001000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+58)%64]) Y = 64'b0000010000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+59)%64]) Y = 64'b0000100000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+60)%64]) Y = 64'b0001000000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+61)%64]) Y = 64'b0010000000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+62)%64]) Y = 64'b0100000000000000000000000000000000000000000000000000000000000000;
    else if (ready[(head+63)%64]) Y = 64'b1000000000000000000000000000000000000000000000000000000000000000;
    else Y = 64'b0; // 紐⑤뱺 議곌굔?뿉 ?빐?떦?븯吏? ?븡?쑝硫? 0?쑝濡? ?꽕?젙
end
endmodule

module RS_Mul (
    input wire clk,
    input wire reset,
    input wire RS_mul_start,
    input wire [31:0] RS_mul_PC,
    input wire [7:0] RS_mul_Rd,
    input wire EX_MEM_MemRead,
    input wire [31:0] RData,
    input wire [7:0] EX_MEM_Physical_Address,
    input wire [7:0] RS_mul_operand1,
    input wire [7:0] RS_mul_operand2,
    input wire [31:0] RS_mul_operand1_data,
    input wire [31:0] RS_mul_operand2_data,
    input wire [1:0] RS_mul_valid,
    input wire [31:0]ALU_result,
    input wire [7:0] ALU_result_dest,
    input wire ALU_result_valid,
    input wire [31:0] MUL_result,
    input wire [7:0] MUL_result_dest,
    input wire MUL_result_valid,
    input wire [31:0] DIV_result,
    input wire [7:0] DIV_result_dest,
    input wire DIV_result_valid,
    output reg [104:0] result_out,
    output reg [7:0] operand1_out_0, operand2_out_0,
  output reg [7:0] operand1_out_1, operand2_out_1,
  output reg [7:0] operand1_out_2, operand2_out_2,
  output reg [7:0] operand1_out_3, operand2_out_3,
  output reg [7:0] operand1_out_4, operand2_out_4,
  output reg [7:0] operand1_out_5, operand2_out_5,
  output reg [7:0] operand1_out_6, operand2_out_6,
  output reg [7:0] operand1_out_7, operand2_out_7,
  output reg [7:0] operand1_out_8, operand2_out_8,
  output reg [7:0] operand1_out_9, operand2_out_9,
  output reg [7:0] operand1_out_10, operand2_out_10,
  output reg [7:0] operand1_out_11, operand2_out_11,
  output reg [7:0] operand1_out_12, operand2_out_12,
  output reg [7:0] operand1_out_13, operand2_out_13,
  output reg [7:0] operand1_out_14, operand2_out_14,
  output reg [7:0] operand1_out_15, operand2_out_15,
  output reg [7:0] operand1_out_16, operand2_out_16,
  output reg [7:0] operand1_out_17, operand2_out_17,
  output reg [7:0] operand1_out_18, operand2_out_18,
  output reg [7:0] operand1_out_19, operand2_out_19,
  output reg [7:0] operand1_out_20, operand2_out_20,
  output reg [7:0] operand1_out_21, operand2_out_21,
  output reg [7:0] operand1_out_22, operand2_out_22,
  output reg [7:0] operand1_out_23, operand2_out_23,
  output reg [7:0] operand1_out_24, operand2_out_24,
  output reg [7:0] operand1_out_25, operand2_out_25,
  output reg [7:0] operand1_out_26, operand2_out_26,
  output reg [7:0] operand1_out_27, operand2_out_27,
  output reg [7:0] operand1_out_28, operand2_out_28,
  output reg [7:0] operand1_out_29, operand2_out_29,
  output reg [7:0] operand1_out_30, operand2_out_30,
  output reg [7:0] operand1_out_31, operand2_out_31,
  output reg [7:0] operand1_out_32, operand2_out_32,
  output reg [7:0] operand1_out_33, operand2_out_33,
  output reg [7:0] operand1_out_34, operand2_out_34,
  output reg [7:0] operand1_out_35, operand2_out_35,
  output reg [7:0] operand1_out_36, operand2_out_36,
  output reg [7:0] operand1_out_37, operand2_out_37,
  output reg [7:0] operand1_out_38, operand2_out_38,
  output reg [7:0] operand1_out_39, operand2_out_39,
  output reg [7:0] operand1_out_40, operand2_out_40,
  output reg [7:0] operand1_out_41, operand2_out_41,
  output reg [7:0] operand1_out_42, operand2_out_42,
  output reg [7:0] operand1_out_43, operand2_out_43,
  output reg [7:0] operand1_out_44, operand2_out_44,
  output reg [7:0] operand1_out_45, operand2_out_45,
  output reg [7:0] operand1_out_46, operand2_out_46,
  output reg [7:0] operand1_out_47, operand2_out_47,
  output reg [7:0] operand1_out_48, operand2_out_48,
  output reg [7:0] operand1_out_49, operand2_out_49,
  output reg [7:0] operand1_out_50, operand2_out_50,
  output reg [7:0] operand1_out_51, operand2_out_51,
  output reg [7:0] operand1_out_52, operand2_out_52,
  output reg [7:0] operand1_out_53, operand2_out_53,
  output reg [7:0] operand1_out_54, operand2_out_54,
  output reg [7:0] operand1_out_55, operand2_out_55,
  output reg [7:0] operand1_out_56, operand2_out_56,
  output reg [7:0] operand1_out_57, operand2_out_57,
  output reg [7:0] operand1_out_58, operand2_out_58,
  output reg [7:0] operand1_out_59, operand2_out_59,
  output reg [7:0] operand1_out_60, operand2_out_60,
  output reg [7:0] operand1_out_61, operand2_out_61,
  output reg [7:0] operand1_out_62, operand2_out_62,
  output reg [7:0] operand1_out_63, operand2_out_63,

  output reg [31:0] operand1_data_out_0, operand2_data_out_0,
output reg [31:0] operand1_data_out_1, operand2_data_out_1,
output reg [31:0] operand1_data_out_2, operand2_data_out_2,
output reg [31:0] operand1_data_out_3, operand2_data_out_3,
output reg [31:0] operand1_data_out_4, operand2_data_out_4,
output reg [31:0] operand1_data_out_5, operand2_data_out_5,
output reg [31:0] operand1_data_out_6, operand2_data_out_6,
output reg [31:0] operand1_data_out_7, operand2_data_out_7,
output reg [31:0] operand1_data_out_8, operand2_data_out_8,
output reg [31:0] operand1_data_out_9, operand2_data_out_9,
output reg [31:0] operand1_data_out_10, operand2_data_out_10,
output reg [31:0] operand1_data_out_11, operand2_data_out_11,
output reg [31:0] operand1_data_out_12, operand2_data_out_12,
output reg [31:0] operand1_data_out_13, operand2_data_out_13,
output reg [31:0] operand1_data_out_14, operand2_data_out_14,
output reg [31:0] operand1_data_out_15, operand2_data_out_15,
output reg [31:0] operand1_data_out_16, operand2_data_out_16,
output reg [31:0] operand1_data_out_17, operand2_data_out_17,
output reg [31:0] operand1_data_out_18, operand2_data_out_18,
output reg [31:0] operand1_data_out_19, operand2_data_out_19,
output reg [31:0] operand1_data_out_20, operand2_data_out_20,
output reg [31:0] operand1_data_out_21, operand2_data_out_21,
output reg [31:0] operand1_data_out_22, operand2_data_out_22,
output reg [31:0] operand1_data_out_23, operand2_data_out_23,
output reg [31:0] operand1_data_out_24, operand2_data_out_24,
output reg [31:0] operand1_data_out_25, operand2_data_out_25,
output reg [31:0] operand1_data_out_26, operand2_data_out_26,
output reg [31:0] operand1_data_out_27, operand2_data_out_27,
output reg [31:0] operand1_data_out_28, operand2_data_out_28,
output reg [31:0] operand1_data_out_29, operand2_data_out_29,
output reg [31:0] operand1_data_out_30, operand2_data_out_30,
output reg [31:0] operand1_data_out_31, operand2_data_out_31,
output reg [31:0] operand1_data_out_32, operand2_data_out_32,
output reg [31:0] operand1_data_out_33, operand2_data_out_33,
output reg [31:0] operand1_data_out_34, operand2_data_out_34,
output reg [31:0] operand1_data_out_35, operand2_data_out_35,
output reg [31:0] operand1_data_out_36, operand2_data_out_36,
output reg [31:0] operand1_data_out_37, operand2_data_out_37,
output reg [31:0] operand1_data_out_38, operand2_data_out_38,
output reg [31:0] operand1_data_out_39, operand2_data_out_39,
output reg [31:0] operand1_data_out_40, operand2_data_out_40,
output reg [31:0] operand1_data_out_41, operand2_data_out_41,
output reg [31:0] operand1_data_out_42, operand2_data_out_42,
output reg [31:0] operand1_data_out_43, operand2_data_out_43,
output reg [31:0] operand1_data_out_44, operand2_data_out_44,
output reg [31:0] operand1_data_out_45, operand2_data_out_45,
output reg [31:0] operand1_data_out_46, operand2_data_out_46,
output reg [31:0] operand1_data_out_47, operand2_data_out_47,
output reg [31:0] operand1_data_out_48, operand2_data_out_48,
output reg [31:0] operand1_data_out_49, operand2_data_out_49,
output reg [31:0] operand1_data_out_50, operand2_data_out_50,
output reg [31:0] operand1_data_out_51, operand2_data_out_51,
output reg [31:0] operand1_data_out_52, operand2_data_out_52,
output reg [31:0] operand1_data_out_53, operand2_data_out_53,
output reg [31:0] operand1_data_out_54, operand2_data_out_54,
output reg [31:0] operand1_data_out_55, operand2_data_out_55,
output reg [31:0] operand1_data_out_56, operand2_data_out_56,
output reg [31:0] operand1_data_out_57, operand2_data_out_57,
output reg [31:0] operand1_data_out_58, operand2_data_out_58,
output reg [31:0] operand1_data_out_59, operand2_data_out_59,
output reg [31:0] operand1_data_out_60, operand2_data_out_60,
output reg [31:0] operand1_data_out_61, operand2_data_out_61,
output reg [31:0] operand1_data_out_62, operand2_data_out_62,
output reg [31:0] operand1_data_out_63, operand2_data_out_63,
  
  output reg valid1_out_0, valid2_out_0,
  output reg valid1_out_1, valid2_out_1,
  output reg valid1_out_2, valid2_out_2,
  output reg valid1_out_3, valid2_out_3,
  output reg valid1_out_4, valid2_out_4,
  output reg valid1_out_5, valid2_out_5,
  output reg valid1_out_6, valid2_out_6,
  output reg valid1_out_7, valid2_out_7,
  output reg valid1_out_8, valid2_out_8,
  output reg valid1_out_9, valid2_out_9,
  output reg valid1_out_10, valid2_out_10,
  output reg valid1_out_11, valid2_out_11,
  output reg valid1_out_12, valid2_out_12,
  output reg valid1_out_13, valid2_out_13,
  output reg valid1_out_14, valid2_out_14,
  output reg valid1_out_15, valid2_out_15,
  output reg valid1_out_16, valid2_out_16,
  output reg valid1_out_17, valid2_out_17,
  output reg valid1_out_18, valid2_out_18,
  output reg valid1_out_19, valid2_out_19,
  output reg valid1_out_20, valid2_out_20,
  output reg valid1_out_21, valid2_out_21,
  output reg valid1_out_22, valid2_out_22,
  output reg valid1_out_23, valid2_out_23,
  output reg valid1_out_24, valid2_out_24,
  output reg valid1_out_25, valid2_out_25,
  output reg valid1_out_26, valid2_out_26,
  output reg valid1_out_27, valid2_out_27,
  output reg valid1_out_28, valid2_out_28,
  output reg valid1_out_29, valid2_out_29,
  output reg valid1_out_30, valid2_out_30,
  output reg valid1_out_31, valid2_out_31,
  output reg valid1_out_32, valid2_out_32,
  output reg valid1_out_33, valid2_out_33,
  output reg valid1_out_34, valid2_out_34,
  output reg valid1_out_35, valid2_out_35,
  output reg valid1_out_36, valid2_out_36,
  output reg valid1_out_37, valid2_out_37,
  output reg valid1_out_38, valid2_out_38,
  output reg valid1_out_39, valid2_out_39,
  output reg valid1_out_40, valid2_out_40,
  output reg valid1_out_41, valid2_out_41,
  output reg valid1_out_42, valid2_out_42,
  output reg valid1_out_43, valid2_out_43,
  output reg valid1_out_44, valid2_out_44,
  output reg valid1_out_45, valid2_out_45,
  output reg valid1_out_46, valid2_out_46,
  output reg valid1_out_47, valid2_out_47,
  output reg valid1_out_48, valid2_out_48,
  output reg valid1_out_49, valid2_out_49,
  output reg valid1_out_50, valid2_out_50,
  output reg valid1_out_51, valid2_out_51,
  output reg valid1_out_52, valid2_out_52,
  output reg valid1_out_53, valid2_out_53,
  output reg valid1_out_54, valid2_out_54,
  output reg valid1_out_55, valid2_out_55,
  output reg valid1_out_56, valid2_out_56,
  output reg valid1_out_57, valid2_out_57,
  output reg valid1_out_58, valid2_out_58,
  output reg valid1_out_59, valid2_out_59,
  output reg valid1_out_60, valid2_out_60,
  output reg valid1_out_61, valid2_out_61,
  output reg valid1_out_62, valid2_out_62,
  output reg valid1_out_63, valid2_out_63  
);

    // Internal storage for reservation station entries
    reg [31:0] PCs [0:63];
    reg [7:0] Rds [0:63];
    reg [3:0] ALUOPs [0:63];
    reg [7:0] operand1s [0:63];
    reg [7:0] operand2s [0:63];
    reg [31:0] operand1_datas [0:63];  // operand1 data
    reg [31:0] operand2_datas [0:63]; // operand2 data
    reg [63:0] valid_entries1;  // operand1?씠 valid?븳吏?
    reg [63:0] valid_entries2; // operand2媛? valid?븳吏?
    reg [104:0] result [0:63];
    reg [5:0] tail;
    reg [63:0] readys;
    wire [63:0] Y;
    integer i;
    reg [6:0] head;
    reg RS_MUL_on[0:63];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tail <= 0;
            for (i = 0; i < 64; i = i + 1) begin
                PCs[i] <= 0;
                Rds[i] <= 0;
                operand1s[i] <= 0;
                operand2s[i] <= 0;
                operand1_datas[i] <= 0;
                operand2_datas[i] <= 0;
                valid_entries1[i] <= 1'b0; // 由ъ뀑 ?떆 珥덇린媛믪쑝濡? 蹂듭썝
                valid_entries2[i] <= 1'b0; // 由ъ뀑 ?떆 珥덇린媛믪쑝濡? 蹂듭썝
                RS_MUL_on[i] <=0;
            end
        end else if (RS_mul_start) begin
            if (RS_mul_operand1 == ALU_result_dest) begin  // ALU?뿉?꽌 operand1?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                operand1_datas[tail] <= ALU_result;
                operand2_datas[tail] <= RS_mul_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_mul_valid[1];
                tail <= (tail + 1) % 64;
                 RS_MUL_on[tail] <=0;
            end else if (RS_mul_operand2 == ALU_result_dest) begin  // ALU?뿉?꽌 operand2?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                operand1_datas[tail] <= RS_mul_operand1_data;
                operand2_datas[tail] <= ALU_result;
                valid_entries1[tail] <= RS_mul_valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;  
                RS_MUL_on[tail] <=0; 
             end else if (RS_mul_operand1 == MUL_result_dest) begin  // MUL?뿉?꽌 operand1?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                operand1_datas[tail] <= MUL_result;
                operand2_datas[tail] <= RS_mul_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_mul_valid[1];
                tail <= (tail + 1) % 64;
                RS_MUL_on[tail] <=0;
             end else if (RS_mul_operand2 == MUL_result_dest) begin  // MUL?뿉?꽌 operand2?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                operand1_datas[tail] <= RS_mul_operand1_data;
                operand2_datas[tail] <= MUL_result;
                valid_entries1[tail] <= RS_mul_valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;
                RS_MUL_on[tail] <=0;
              end else if (RS_mul_operand1 == DIV_result_dest) begin  // DIV?뿉?꽌 operand1?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                operand1_datas[tail] <= DIV_result;
                operand2_datas[tail] <= RS_mul_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_mul_valid[1];
                tail <= (tail + 1) % 64;
                RS_MUL_on[tail] <=0;
              end else if (RS_mul_operand2 == DIV_result_dest) begin  // MUL?뿉?꽌 operand2?쓽 ?뿰?궛?씠 ?걹?궗?쓣?븣
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                operand1_datas[tail] <= RS_mul_operand1_data;
                operand2_datas[tail] <= DIV_result;
                valid_entries1[tail] <= RS_mul_valid[0];
                valid_entries2[tail] <= 1; 
                tail <= (tail + 1) % 64;
                 RS_MUL_on[tail] <=0;
             end else if ( RS_mul_operand1 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                operand1_datas[tail] <= RData;
                operand2_datas[tail] <= RS_mul_operand2_data;
                valid_entries1[tail] <= 1;
                valid_entries2[tail] <= RS_mul_valid[1] ; 
                tail <= (tail + 1) % 64;
                RS_MUL_on[tail] <=0; 
              end else if ( RS_mul_operand2 == EX_MEM_Physical_Address && EX_MEM_MemRead ==1) begin
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                operand1_datas[tail] <= RS_mul_operand1_data;
                operand2_datas[tail] <= RData;
                valid_entries1[tail] <= RS_mul_valid[0];
                valid_entries2[tail] <= 1 ; 
                tail <= (tail + 1) % 64;
                RS_MUL_on[tail] <=0; 
            end else begin
                PCs[tail] <= RS_mul_PC;
                Rds[tail] <= RS_mul_Rd;
                operand1s[tail] <= RS_mul_operand1;
                operand2s[tail] <= RS_mul_operand2;
                operand1_datas[tail] <= RS_mul_operand1_data;
                operand2_datas[tail] <= RS_mul_operand2_data ;
                valid_entries1[tail] <= RS_mul_valid[0];
                valid_entries2[tail] <= RS_mul_valid[1]; 
                tail <= (tail + 1) % 64;
                RS_MUL_on[tail] <=0; 
             end 
             end
            if (ALU_result_valid) begin
                for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == ALU_result_dest) begin
                        operand1_datas[i] <= ALU_result;
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == ALU_result_dest) begin
                        operand2_datas[i] <= ALU_result;
                        valid_entries2[i] <= 1;
                    end
                end
            end
            if (MUL_result_valid) begin
                for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == MUL_result_dest) begin
                        operand1_datas[i] <= MUL_result;
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == MUL_result_dest) begin
                        operand2_datas[i] <= MUL_result;
                        valid_entries2[i] <= 1;
                    end
                end
            end
            if (DIV_result_valid) begin
                for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == DIV_result_dest) begin
                        operand1_datas[i] <= DIV_result;
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == DIV_result_dest) begin
                        operand2_datas[i] <= DIV_result;
                        valid_entries2[i] <= 1;
                    end
                end
            end
           if (EX_MEM_MemRead) begin
           for (i = 0; i < 64; i = i + 1) begin
                    if (!valid_entries1[i] && operand1s[i] == EX_MEM_Physical_Address) begin
                        operand1_datas[i] <= RData;
                        valid_entries1[i] <= 1;
                    end
                    if (!valid_entries2[i] && operand2s[i] == EX_MEM_Physical_Address) begin
                        operand2_datas[i] <= RData;
                        valid_entries2[i] <= 1;
                    end
                end     
            end
            operand1_out_0 <= operand1s[0];
operand2_out_0 <= operand2s[0];
operand1_data_out_0 <= operand1_datas[0];
operand2_data_out_0 <= operand2_datas[0];
valid1_out_0 <= valid_entries1[0];
valid2_out_0 <= valid_entries2[0];

operand1_out_1 <= operand1s[1];
operand2_out_1 <= operand2s[1];
operand1_data_out_1 <= operand1_datas[1];
operand2_data_out_1 <= operand2_datas[1];
valid1_out_1 <= valid_entries1[1];
valid2_out_1 <= valid_entries2[1];

operand1_out_2 <= operand1s[2];
operand2_out_2 <= operand2s[2];
operand1_data_out_2 <= operand1_datas[2];
operand2_data_out_2 <= operand2_datas[2];
valid1_out_2 <= valid_entries1[2];
valid2_out_2 <= valid_entries2[2];

operand1_out_3 <= operand1s[3];
operand2_out_3 <= operand2s[3];
operand1_data_out_3 <= operand1_datas[3];
operand2_data_out_3 <= operand2_datas[3];
valid1_out_3 <= valid_entries1[3];
valid2_out_3 <= valid_entries2[3];

operand1_out_4 <= operand1s[4];
operand2_out_4 <= operand2s[4];
operand1_data_out_4 <= operand1_datas[4];
operand2_data_out_4 <= operand2_datas[4];
valid1_out_4 <= valid_entries1[4];
valid2_out_4 <= valid_entries2[4];

operand1_out_5 <= operand1s[5];
operand2_out_5 <= operand2s[5];
operand1_data_out_5 <= operand1_datas[5];
operand2_data_out_5 <= operand2_datas[5];
valid1_out_5 <= valid_entries1[5];
valid2_out_5 <= valid_entries2[5];

operand1_out_6 <= operand1s[6];
operand2_out_6 <= operand2s[6];
operand1_data_out_6 <= operand1_datas[6];
operand2_data_out_6 <= operand2_datas[6];
valid1_out_6 <= valid_entries1[6];
valid2_out_6 <= valid_entries2[6];

operand1_out_7 <= operand1s[7];
operand2_out_7 <= operand2s[7];
operand1_data_out_7 <= operand1_datas[7];
operand2_data_out_7 <= operand2_datas[7];
valid1_out_7 <= valid_entries1[7];
valid2_out_7 <= valid_entries2[7];

operand1_out_8 <= operand1s[8];
operand2_out_8 <= operand2s[8];
operand1_data_out_8 <= operand1_datas[8];
operand2_data_out_8 <= operand2_datas[8];
valid1_out_8 <= valid_entries1[8];
valid2_out_8 <= valid_entries2[8];

operand1_out_9 <= operand1s[9];
operand2_out_9 <= operand2s[9];
operand1_data_out_9 <= operand1_datas[9];
operand2_data_out_9 <= operand2_datas[9];
valid1_out_9 <= valid_entries1[9];
valid2_out_9 <= valid_entries2[9];

operand1_out_10 <= operand1s[10];
operand2_out_10 <= operand2s[10];
operand1_data_out_10 <= operand1_datas[10];
operand2_data_out_10 <= operand2_datas[10];
valid1_out_10 <= valid_entries1[10];
valid2_out_10 <= valid_entries2[10];

operand1_out_11 <= operand1s[11];
operand2_out_11 <= operand2s[11];
operand1_data_out_11 <= operand1_datas[11];
operand2_data_out_11 <= operand2_datas[11];
valid1_out_11 <= valid_entries1[11];
valid2_out_11 <= valid_entries2[11];

operand1_out_12 <= operand1s[12];
operand2_out_12 <= operand2s[12];
operand1_data_out_12 <= operand1_datas[12];
operand2_data_out_12 <= operand2_datas[12];
valid1_out_12 <= valid_entries1[12];
valid2_out_12 <= valid_entries2[12];

operand1_out_13 <= operand1s[13];
operand2_out_13 <= operand2s[13];
operand1_data_out_13 <= operand1_datas[13];
operand2_data_out_13 <= operand2_datas[13];
valid1_out_13 <= valid_entries1[13];
valid2_out_13 <= valid_entries2[13];

operand1_out_14 <= operand1s[14];
operand2_out_14 <= operand2s[14];
operand1_data_out_14 <= operand1_datas[14];
operand2_data_out_14 <= operand2_datas[14];
valid1_out_14 <= valid_entries1[14];
valid2_out_14 <= valid_entries2[14];

operand1_out_15 <= operand1s[15];
operand2_out_15 <= operand2s[15];
operand1_data_out_15 <= operand1_datas[15];
operand2_data_out_15 <= operand2_datas[15];
valid1_out_15 <= valid_entries1[15];
valid2_out_15 <= valid_entries2[15];

operand1_out_16 <= operand1s[16];
operand2_out_16 <= operand2s[16];
operand1_data_out_16 <= operand1_datas[16];
operand2_data_out_16 <= operand2_datas[16];
valid1_out_16 <= valid_entries1[16];
valid2_out_16 <= valid_entries2[16];

operand1_out_17 <= operand1s[17];
operand2_out_17 <= operand2s[17];
operand1_data_out_17 <= operand1_datas[17];
operand2_data_out_17 <= operand2_datas[17];
valid1_out_17 <= valid_entries1[17];
valid2_out_17 <= valid_entries2[17];

operand1_out_18 <= operand1s[18];
operand2_out_18 <= operand2s[18];
operand1_data_out_18 <= operand1_datas[18];
operand2_data_out_18 <= operand2_datas[18];
valid1_out_18 <= valid_entries1[18];
valid2_out_18 <= valid_entries2[18];

operand1_out_19 <= operand1s[19];
operand2_out_19 <= operand2s[19];
operand1_data_out_19 <= operand1_datas[19];
operand2_data_out_19 <= operand2_datas[19];
valid1_out_19 <= valid_entries1[19];
valid2_out_19 <= valid_entries2[19];

operand1_out_20 <= operand1s[20];
operand2_out_20 <= operand2s[20];
operand1_data_out_20 <= operand1_datas[20];
operand2_data_out_20 <= operand2_datas[20];
valid1_out_20 <= valid_entries1[20];
valid2_out_20 <= valid_entries2[20];

operand1_out_21 <= operand1s[21];
operand2_out_21 <= operand2s[21];
operand1_data_out_21 <= operand1_datas[21];
operand2_data_out_21 <= operand2_datas[21];
valid1_out_21 <= valid_entries1[21];
valid2_out_21 <= valid_entries2[21];

operand1_out_22 <= operand1s[22];
operand2_out_22 <= operand2s[22];
operand1_data_out_22 <= operand1_datas[22];
operand2_data_out_22 <= operand2_datas[22];
valid1_out_22 <= valid_entries1[22];
valid2_out_22 <= valid_entries2[22];

operand1_out_23 <= operand1s[23];
operand2_out_23 <= operand2s[23];
operand1_data_out_23 <= operand1_datas[23];
operand2_data_out_23 <= operand2_datas[23];
valid1_out_23 <= valid_entries1[23];
valid2_out_23 <= valid_entries2[23];

operand1_out_24 <= operand1s[24];
operand2_out_24 <= operand2s[24];
operand1_data_out_24 <= operand1_datas[24];
operand2_data_out_24 <= operand2_datas[24];
valid1_out_24 <= valid_entries1[24];
valid2_out_24 <= valid_entries2[24];

operand1_out_25 <= operand1s[25];
operand2_out_25 <= operand2s[25];
operand1_data_out_25 <= operand1_datas[25];
operand2_data_out_25 <= operand2_datas[25];
valid1_out_25 <= valid_entries1[25];
valid2_out_25 <= valid_entries2[25];

operand1_out_26 <= operand1s[26];
operand2_out_26 <= operand2s[26];
operand1_data_out_26 <= operand1_datas[26];
operand2_data_out_26 <= operand2_datas[26];
valid1_out_26 <= valid_entries1[26];
valid2_out_26 <= valid_entries2[26];

operand1_out_27 <= operand1s[27];
operand2_out_27 <= operand2s[27];
operand1_data_out_27 <= operand1_datas[27];
operand2_data_out_27 <= operand2_datas[27];
valid1_out_27 <= valid_entries1[27];
valid2_out_27 <= valid_entries2[27];

operand1_out_28 <= operand1s[28];
operand2_out_28 <= operand2s[28];
operand1_data_out_28 <= operand1_datas[28];
operand2_data_out_28 <= operand2_datas[28];
valid1_out_28 <= valid_entries1[28];
valid2_out_28 <= valid_entries2[28];

operand1_out_29 <= operand1s[29];
operand2_out_29 <= operand2s[29];
operand1_data_out_29 <= operand1_datas[29];
operand2_data_out_29 <= operand2_datas[29];
valid1_out_29 <= valid_entries1[29];
valid2_out_29 <= valid_entries2[29];

operand1_out_30 <= operand1s[30];
operand2_out_30 <= operand2s[30];
operand1_data_out_30 <= operand1_datas[30];
operand2_data_out_30 <= operand2_datas[30];
valid1_out_30 <= valid_entries1[30];
valid2_out_30 <= valid_entries2[30];

operand1_out_31 <= operand1s[31];
operand2_out_31 <= operand2s[31];
operand1_data_out_31 <= operand1_datas[31];
operand2_data_out_31 <= operand2_datas[31];
valid1_out_31 <= valid_entries1[31];
valid2_out_31 <= valid_entries2[31];

operand1_out_32 <= operand1s[32];
operand2_out_32 <= operand2s[32];
operand1_data_out_32 <= operand1_datas[32];
operand2_data_out_32 <= operand2_datas[32];
valid1_out_32 <= valid_entries1[32];
valid2_out_32 <= valid_entries2[32];

operand1_out_33 <= operand1s[33];
operand2_out_33 <= operand2s[33];
operand1_data_out_33 <= operand1_datas[33];
operand2_data_out_33 <= operand2_datas[33];
valid1_out_33 <= valid_entries1[33];
valid2_out_33 <= valid_entries2[33];

operand1_out_34 <= operand1s[34];
operand2_out_34 <= operand2s[34];
operand1_data_out_34 <= operand1_datas[34];
operand2_data_out_34 <= operand2_datas[34];
valid1_out_34 <= valid_entries1[34];
valid2_out_34 <= valid_entries2[34];

operand1_out_35 <= operand1s[35];
operand2_out_35 <= operand2s[35];
operand1_data_out_35 <= operand1_datas[35];
operand2_data_out_35 <= operand2_datas[35];
valid1_out_35 <= valid_entries1[35];
valid2_out_35 <= valid_entries2[35];

operand1_out_36 <= operand1s[36];
operand2_out_36 <= operand2s[36];
operand1_data_out_36 <= operand1_datas[36];
operand2_data_out_36 <= operand2_datas[36];
valid1_out_36 <= valid_entries1[36];
valid2_out_36 <= valid_entries2[36];

operand1_out_37 <= operand1s[37];
operand2_out_37 <= operand2s[37];
operand1_data_out_37 <= operand1_datas[37];
operand2_data_out_37 <= operand2_datas[37];
valid1_out_37 <= valid_entries1[37];
valid2_out_37 <= valid_entries2[37];

operand1_out_38 <= operand1s[38];
operand2_out_38 <= operand2s[38];
operand1_data_out_38 <= operand1_datas[38];
operand2_data_out_38 <= operand2_datas[38];
valid1_out_38 <= valid_entries1[38];
valid2_out_38 <= valid_entries2[38];

operand1_out_39 <= operand1s[39];
operand2_out_39 <= operand2s[39];
operand1_data_out_39 <= operand1_datas[39];
operand2_data_out_39 <= operand2_datas[39];
valid1_out_39 <= valid_entries1[39];
valid2_out_39 <= valid_entries2[39];

operand1_out_40 <= operand1s[40];
operand2_out_40 <= operand2s[40];
operand1_data_out_40 <= operand1_datas[40];
operand2_data_out_40 <= operand2_datas[40];
valid1_out_40 <= valid_entries1[40];
valid2_out_40 <= valid_entries2[40];

operand1_out_41 <= operand1s[41];
operand2_out_41 <= operand2s[41];
operand1_data_out_41 <= operand1_datas[41];
operand2_data_out_41 <= operand2_datas[41];
valid1_out_41 <= valid_entries1[41];
valid2_out_41 <= valid_entries2[41];

operand1_out_42 <= operand1s[42];
operand2_out_42 <= operand2s[42];
operand1_data_out_42 <= operand1_datas[42];
operand2_data_out_42 <= operand2_datas[42];
valid1_out_42 <= valid_entries1[42];
valid2_out_42 <= valid_entries2[42];

operand1_out_43 <= operand1s[43];
operand2_out_43 <= operand2s[43];
operand1_data_out_43 <= operand1_datas[43];
operand2_data_out_43 <= operand2_datas[43];
valid1_out_43 <= valid_entries1[43];
valid2_out_43 <= valid_entries2[43];

operand1_out_44 <= operand1s[44];
operand2_out_44 <= operand2s[44];
operand1_data_out_44 <= operand1_datas[44];
operand2_data_out_44 <= operand2_datas[44];
valid1_out_44 <= valid_entries1[44];
valid2_out_44 <= valid_entries2[44];

operand1_out_45 <= operand1s[45];
operand2_out_45 <= operand2s[45];
operand1_data_out_45 <= operand1_datas[45];
operand2_data_out_45 <= operand2_datas[45];
valid1_out_45 <= valid_entries1[45];
valid2_out_45 <= valid_entries2[45];

operand1_out_46 <= operand1s[46];
operand2_out_46 <= operand2s[46];
operand1_data_out_46 <= operand1_datas[46];
operand2_data_out_46 <= operand2_datas[46];
valid1_out_46 <= valid_entries1[46];
valid2_out_46 <= valid_entries2[46];

operand1_out_47 <= operand1s[47];
operand2_out_47 <= operand2s[47];
operand1_data_out_47 <= operand1_datas[47];
operand2_data_out_47 <= operand2_datas[47];
valid1_out_47 <= valid_entries1[47];
valid2_out_47 <= valid_entries2[47];

operand1_out_48 <= operand1s[48];
operand2_out_48 <= operand2s[48];
operand1_data_out_48 <= operand1_datas[48];
operand2_data_out_48 <= operand2_datas[48];
valid1_out_48 <= valid_entries1[48];
valid2_out_48 <= valid_entries2[48];

operand1_out_49 <= operand1s[49];
operand2_out_49 <= operand2s[49];
operand1_data_out_49 <= operand1_datas[49];
operand2_data_out_49 <= operand2_datas[49];
valid1_out_49 <= valid_entries1[49];
valid2_out_49 <= valid_entries2[49];

operand1_out_50 <= operand1s[50];
operand2_out_50 <= operand2s[50];
operand1_data_out_50 <= operand1_datas[50];
operand2_data_out_50 <= operand2_datas[50];
valid1_out_50 <= valid_entries1[50];
valid2_out_50 <= valid_entries2[50];

operand1_out_51 <= operand1s[51];
operand2_out_51 <= operand2s[51];
operand1_data_out_51 <= operand1_datas[51];
operand2_data_out_51 <= operand2_datas[51];
valid1_out_51 <= valid_entries1[51];
valid2_out_51 <= valid_entries2[51];

operand1_out_52 <= operand1s[52];
operand2_out_52 <= operand2s[52];
operand1_data_out_52 <= operand1_datas[52];
operand2_data_out_52 <= operand2_datas[52];
valid1_out_52 <= valid_entries1[52];
valid2_out_52 <= valid_entries2[52];

operand1_out_53 <= operand1s[53];
operand2_out_53 <= operand2s[53];
operand1_data_out_53 <= operand1_datas[53];
operand2_data_out_53 <= operand2_datas[53];
valid1_out_53 <= valid_entries1[53];
valid2_out_53 <= valid_entries2[53];

operand1_out_54 <= operand1s[54];
operand2_out_54 <= operand2s[54];
operand1_data_out_54 <= operand1_datas[54];
operand2_data_out_54 <= operand2_datas[54];
valid1_out_54 <= valid_entries1[54];
valid2_out_54 <= valid_entries2[54];

operand1_out_55 <= operand1s[55];
operand2_out_55 <= operand2s[55];
operand1_data_out_55 <= operand1_datas[55];
operand2_data_out_55 <= operand2_datas[55];
valid1_out_55 <= valid_entries1[55];
valid2_out_55 <= valid_entries2[55];

operand1_out_56 <= operand1s[56];
operand2_out_56 <= operand2s[56];
operand1_data_out_56 <= operand1_datas[56];
operand2_data_out_56 <= operand2_datas[56];
valid1_out_56 <= valid_entries1[56];
valid2_out_56 <= valid_entries2[56];

operand1_out_57 <= operand1s[57];
operand2_out_57 <= operand2s[57];
operand1_data_out_57 <= operand1_datas[57];
operand2_data_out_57 <= operand2_datas[57];
valid1_out_57 <= valid_entries1[57];
valid2_out_57 <= valid_entries2[57];

operand1_out_58 <= operand1s[58];
operand2_out_58 <= operand2s[58];
operand1_data_out_58 <= operand1_datas[58];
operand2_data_out_58 <= operand2_datas[58];
valid1_out_58 <= valid_entries1[58];
valid2_out_58 <= valid_entries2[58];

operand1_out_59 <= operand1s[59];
operand2_out_59 <= operand2s[59];
operand1_data_out_59 <= operand1_datas[59];
operand2_data_out_59 <= operand2_datas[59];
valid1_out_59 <= valid_entries1[59];
valid2_out_59 <= valid_entries2[59];

operand1_out_60 <= operand1s[60];
operand2_out_60 <= operand2s[60];
operand1_data_out_60 <= operand1_datas[60];
operand2_data_out_60 <= operand2_datas[60];
valid1_out_60 <= valid_entries1[60];
valid2_out_60 <= valid_entries2[60];

operand1_out_61 <= operand1s[61];
operand2_out_61 <= operand2s[61];
operand1_data_out_61 <= operand1_datas[61];
operand2_data_out_61 <= operand2_datas[61];
valid1_out_61 <= valid_entries1[61];
valid2_out_61 <= valid_entries2[61];

operand1_out_62 <= operand1s[62];
operand2_out_62 <= operand2s[62];
operand1_data_out_62 <= operand1_datas[62];
operand2_data_out_62 <= operand2_datas[62];
valid1_out_62 <= valid_entries1[62];
valid2_out_62 <= valid_entries2[62];

operand1_out_63 <= operand1s[63];
operand2_out_63 <= operand2s[63];
operand1_data_out_63 <= operand1_datas[63];
operand2_data_out_63 <= operand2_datas[63];
valid1_out_63 <= valid_entries1[63];
valid2_out_63 <= valid_entries2[63];
         end
      



    always @(*) begin
        for (i = 0; i < 64; i = i + 1) begin
            if (valid_entries1[i] && valid_entries2[i]) begin
                readys[i] = 1;
                RS_MUL_on[i] =1;
                result[i] = {1'b1, PCs[i], Rds[i], operand1_datas[i], operand2_datas[i]};
            end 
        end
    end

    priority_encoder encoder (
        .ready(readys),
        .head(head),
        .Y(Y)
    );


always @(posedge clk or posedge reset) begin
    if (reset) begin
        result_out <= 0;
        head <= 0;
    end else begin
      if (RS_MUL_on[head]) begin
      head <= (head+1)%64;
      RS_MUL_on[head] <=0;
      end
case (Y)
    64'b0000000000000000000000000000000000000000000000000000000000000001: begin
        result_out <= result[(head+0)%64];
        readys[(head+0)%64] <= 0;
        operand1s[(head+0)%64] <= 0;
        operand2s[(head+0)%64] <= 0;
        operand1_datas[(head+0)%64] <= 0;
        operand2_datas[(head+0)%64] <= 0;
        valid_entries1[(head+0)%64] <= 0;
        valid_entries2[(head+0)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000000000010: begin
        result_out <= result[(head+1)%64];
        readys[(head+1)%64] <= 0;
        operand1s[(head+1)%64] <= 0;
        operand2s[(head+1)%64] <= 0;
        operand1_datas[(head+1)%64] <= 0;
        operand2_datas[(head+1)%64] <= 0;
        valid_entries1[(head+1)%64] <= 0;
        valid_entries2[(head+1)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000000000100: begin
        result_out <= result[(head+2)%64];
        readys[(head+2)%64] <= 0;
        operand1s[(head+2)%64] <= 0;
        operand2s[(head+2)%64] <= 0;
        operand1_datas[(head+2)%64] <= 0;
        operand2_datas[(head+2)%64] <= 0;
        valid_entries1[(head+2)%64] <= 0;
        valid_entries2[(head+2)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000000001000: begin
        result_out <= result[(head+3)%64];
        readys[(head+3)%64] <= 0;
        operand1s[(head+3)%64] <= 0;
        operand2s[(head+3)%64] <= 0;
        operand1_datas[(head+3)%64] <= 0;
        operand2_datas[(head+3)%64] <= 0;
        valid_entries1[(head+3)%64] <= 0;
        valid_entries2[(head+3)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000000010000: begin
        result_out <= result[(head+4)%64];
        readys[(head+4)%64] <= 0;
        operand1s[(head+4)%64] <= 0;
        operand2s[(head+4)%64] <= 0;
        operand1_datas[(head+4)%64] <= 0;
        operand2_datas[(head+4)%64] <= 0;
        valid_entries1[(head+4)%64] <= 0;
        valid_entries2[(head+4)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000000100000: begin
        result_out <= result[(head+5)%64];
        readys[(head+5)%64] <= 0;
        operand1s[(head+5)%64] <= 0;
        operand2s[(head+5)%64] <= 0;
        operand1_datas[(head+5)%64] <= 0;
        operand2_datas[(head+5)%64] <= 0;
        valid_entries1[(head+5)%64] <= 0;
        valid_entries2[(head+5)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000001000000: begin
        result_out <= result[(head+6)%64];
        readys[(head+6)%64] <= 0;
        operand1s[(head+6)%64] <= 0;
        operand2s[(head+6)%64] <= 0;
        operand1_datas[(head+6)%64] <= 0;
        operand2_datas[(head+6)%64] <= 0;
        valid_entries1[(head+6)%64] <= 0;
        valid_entries2[(head+6)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000010000000: begin
        result_out <= result[(head+7)%64];
        readys[(head+7)%64] <= 0;
        operand1s[(head+7)%64] <= 0;
        operand2s[(head+7)%64] <= 0;
        operand1_datas[(head+7)%64] <= 0;
        operand2_datas[(head+7)%64] <= 0;
        valid_entries1[(head+7)%64] <= 0;
        valid_entries2[(head+7)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000000100000000: begin
        result_out <= result[(head+8)%64];
        readys[(head+8)%64] <= 0;
        operand1s[(head+8)%64] <= 0;
        operand2s[(head+8)%64] <= 0;
        operand1_datas[(head+8)%64] <= 0;
        operand2_datas[(head+8)%64] <= 0;
        valid_entries1[(head+8)%64] <= 0;
        valid_entries2[(head+8)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000001000000000: begin
        result_out <= result[(head+9)%64];
        readys[(head+9)%64] <= 0;
        operand1s[(head+9)%64] <= 0;
        operand2s[(head+9)%64] <= 0;
        operand1_datas[(head+9)%64] <= 0;
        operand2_datas[(head+9)%64] <= 0;
        valid_entries1[(head+9)%64] <= 0;
        valid_entries2[(head+9)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000010000000000: begin
        result_out <= result[(head+10)%64];
        readys[(head+10)%64] <= 0;
        operand1s[(head+10)%64] <= 0;
        operand2s[(head+10)%64] <= 0;
        operand1_datas[(head+10)%64] <= 0;
        operand2_datas[(head+10)%64] <= 0;
        valid_entries1[(head+10)%64] <= 0;
        valid_entries2[(head+10)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000000100000000000: begin
        result_out <= result[(head+11)%64];
        readys[(head+11)%64] <= 0;
        operand1s[(head+11)%64] <= 0;
        operand2s[(head+11)%64] <= 0;
        operand1_datas[(head+11)%64] <= 0;
        operand2_datas[(head+11)%64] <= 0;
        valid_entries1[(head+11)%64] <= 0;
        valid_entries2[(head+11)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000001000000000000: begin
        result_out <= result[(head+12)%64];
        readys[(head+12)%64] <= 0;
        operand1s[(head+12)%64] <= 0;
        operand2s[(head+12)%64] <= 0;
        operand1_datas[(head+12)%64] <= 0;
        operand2_datas[(head+12)%64] <= 0;
        valid_entries1[(head+12)%64] <= 0;
        valid_entries2[(head+12)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000010000000000000: begin
        result_out <= result[(head+13)%64];
        readys[(head+13)%64] <= 0;
        operand1s[(head+13)%64] <= 0;
        operand2s[(head+13)%64] <= 0;
        operand1_datas[(head+13)%64] <= 0;
        operand2_datas[(head+13)%64] <= 0;
        valid_entries1[(head+13)%64] <= 0;
        valid_entries2[(head+13)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000000100000000000000: begin
        result_out <= result[(head+14)%64];
        readys[(head+14)%64] <= 0;
        operand1s[(head+14)%64] <= 0;
        operand2s[(head+14)%64] <= 0;
        operand1_datas[(head+14)%64] <= 0;
        operand2_datas[(head+14)%64] <= 0;
        valid_entries1[(head+14)%64] <= 0;
        valid_entries2[(head+14)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000001000000000000000: begin
        result_out <= result[(head+15)%64];
        readys[(head+15)%64] <= 0;
        operand1s[(head+15)%64] <= 0;
        operand2s[(head+15)%64] <= 0;
        operand1_datas[(head+15)%64] <= 0;
        operand2_datas[(head+15)%64] <= 0;
        valid_entries1[(head+15)%64] <= 0;
        valid_entries2[(head+15)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000010000000000000000: begin
        result_out <= result[(head+16)%64];
        readys[(head+16)%64] <= 0;
        operand1s[(head+16)%64] <= 0;
        operand2s[(head+16)%64] <= 0;
        operand1_datas[(head+16)%64] <= 0;
        operand2_datas[(head+16)%64] <= 0;
        valid_entries1[(head+16)%64] <= 0;
        valid_entries2[(head+16)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000000100000000000000000: begin
        result_out <= result[(head+17)%64];
        readys[(head+17)%64] <= 0;
        operand1s[(head+17)%64] <= 0;
        operand2s[(head+17)%64] <= 0;
        operand1_datas[(head+17)%64] <= 0;
        operand2_datas[(head+17)%64] <= 0;
        valid_entries1[(head+17)%64] <= 0;
        valid_entries2[(head+17)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000001000000000000000000: begin
        result_out <= result[(head+18)%64];
        readys[(head+18)%64] <= 0;
        operand1s[(head+18)%64] <= 0;
        operand2s[(head+18)%64] <= 0;
        operand1_datas[(head+18)%64] <= 0;
        operand2_datas[(head+18)%64] <= 0;
        valid_entries1[(head+18)%64] <= 0;
        valid_entries2[(head+18)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000010000000000000000000: begin
        result_out <= result[(head+19)%64];
        readys[(head+19)%64] <= 0;
        operand1s[(head+19)%64] <= 0;
        operand2s[(head+19)%64] <= 0;
        operand1_datas[(head+19)%64] <= 0;
        operand2_datas[(head+19)%64] <= 0;
        valid_entries1[(head+19)%64] <= 0;
        valid_entries2[(head+19)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000000100000000000000000000: begin
        result_out <= result[(head+20)%64];
        readys[(head+20)%64] <= 0;
        operand1s[(head+20)%64] <= 0;
        operand2s[(head+20)%64] <= 0;
        operand1_datas[(head+20)%64] <= 0;
        operand2_datas[(head+20)%64] <= 0;
        valid_entries1[(head+20)%64] <= 0;
        valid_entries2[(head+20)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000001000000000000000000000: begin
        result_out <= result[(head+21)%64];
        readys[(head+21)%64] <= 0;
        operand1s[(head+21)%64] <= 0;
        operand2s[(head+21)%64] <= 0;
        operand1_datas[(head+21)%64] <= 0;
        operand2_datas[(head+21)%64] <= 0;
        valid_entries1[(head+21)%64] <= 0;
        valid_entries2[(head+21)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000010000000000000000000000: begin
        result_out <= result[(head+22)%64];
        readys[(head+22)%64] <= 0;
        operand1s[(head+22)%64] <= 0;
        operand2s[(head+22)%64] <= 0;
        operand1_datas[(head+22)%64] <= 0;
        operand2_datas[(head+22)%64] <= 0;
        valid_entries1[(head+22)%64] <= 0;
        valid_entries2[(head+22)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000000100000000000000000000000: begin
        result_out <= result[(head+23)%64];
        readys[(head+23)%64] <= 0;
        operand1s[(head+23)%64] <= 0;
        operand2s[(head+23)%64] <= 0;
        operand1_datas[(head+23)%64] <= 0;
        operand2_datas[(head+23)%64] <= 0;
        valid_entries1[(head+23)%64] <= 0;
        valid_entries2[(head+23)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000001000000000000000000000000: begin
        result_out <= result[(head+24)%64];
        readys[(head+24)%64] <= 0;
        operand1s[(head+24)%64] <= 0;
        operand2s[(head+24)%64] <= 0;
        operand1_datas[(head+24)%64] <= 0;
        operand2_datas[(head+24)%64] <= 0;
        valid_entries1[(head+24)%64] <= 0;
        valid_entries2[(head+24)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000010000000000000000000000000: begin
        result_out <= result[(head+25)%64];
        readys[(head+25)%64] <= 0;
        operand1s[(head+25)%64] <= 0;
        operand2s[(head+25)%64] <= 0;
        operand1_datas[(head+25)%64] <= 0;
        operand2_datas[(head+25)%64] <= 0;
        valid_entries1[(head+25)%64] <= 0;
        valid_entries2[(head+25)%64] <= 0;
    end
    64'b0000000000000000000000000000000000000100000000000000000000000000: begin
        result_out <= result[(head+26)%64];
        readys[(head+26)%64] <= 0;
        operand1s[(head+26)%64] <= 0;
        operand2s[(head+26)%64] <= 0;
        operand1_datas[(head+26)%64] <= 0;
        operand2_datas[(head+26)%64] <= 0;
        valid_entries1[(head+26)%64] <= 0;
        valid_entries2[(head+26)%64] <= 0;
    end
    64'b0000000000000000000000000000000000001000000000000000000000000000: begin
        result_out <= result[(head+27)%64];
        readys[(head+27)%64] <= 0;
        operand1s[(head+27)%64] <= 0;
        operand2s[(head+27)%64] <= 0;
        operand1_datas[(head+27)%64] <= 0;
        operand2_datas[(head+27)%64] <= 0;
        valid_entries1[(head+27)%64] <= 0;
        valid_entries2[(head+27)%64] <= 0;
    end
    64'b0000000000000000000000000000000000010000000000000000000000000000: begin
        result_out <= result[(head+28)%64];
        readys[(head+28)%64] <= 0;
        operand1s[(head+28)%64] <= 0;
        operand2s[(head+28)%64] <= 0;
        operand1_datas[(head+28)%64] <= 0;
        operand2_datas[(head+28)%64] <= 0;
        valid_entries1[(head+28)%64] <= 0;
        valid_entries2[(head+28)%64] <= 0;
    end
    64'b0000000000000000000000000000000000100000000000000000000000000000: begin
        result_out <= result[(head+29)%64];
        readys[(head+29)%64] <= 0;
        operand1s[(head+29)%64] <= 0;
        operand2s[(head+29)%64] <= 0;
        operand1_datas[(head+29)%64] <= 0;
        operand2_datas[(head+29)%64] <= 0;
        valid_entries1[(head+29)%64] <= 0;
        valid_entries2[(head+29)%64] <= 0;
    end
    64'b0000000000000000000000000000000001000000000000000000000000000000: begin
        result_out <= result[(head+30)%64];
        readys[(head+30)%64] <= 0;
        operand1s[(head+30)%64] <= 0;
        operand2s[(head+30)%64] <= 0;
        operand1_datas[(head+30)%64] <= 0;
        operand2_datas[(head+30)%64] <= 0;
        valid_entries1[(head+30)%64] <= 0;
        valid_entries2[(head+30)%64] <= 0;
    end
    64'b0000000000000000000000000000000010000000000000000000000000000000: begin
        result_out <= result[(head+31)%64];
        readys[(head+31)%64] <= 0;
        operand1s[(head+31)%64] <= 0;
        operand2s[(head+31)%64] <= 0;
        operand1_datas[(head+31)%64] <= 0;
        operand2_datas[(head+31)%64] <= 0;
        valid_entries1[(head+31)%64] <= 0;
        valid_entries2[(head+31)%64] <= 0;
    end
    64'b0000000000000000000000000000000100000000000000000000000000000000: begin
        result_out <= result[(head+32)%64];
        readys[(head+32)%64] <= 0;
        operand1s[(head+32)%64] <= 0;
        operand2s[(head+32)%64] <= 0;
        operand1_datas[(head+32)%64] <= 0;
        operand2_datas[(head+32)%64] <= 0;
        valid_entries1[(head+32)%64] <= 0;
        valid_entries2[(head+32)%64] <= 0;
    end
    64'b0000000000000000000000000000001000000000000000000000000000000000: begin
        result_out <= result[(head+33)%64];
        readys[(head+33)%64] <= 0;
        operand1s[(head+33)%64] <= 0;
        operand2s[(head+33)%64] <= 0;
        operand1_datas[(head+33)%64] <= 0;
        operand2_datas[(head+33)%64] <= 0;
        valid_entries1[(head+33)%64] <= 0;
        valid_entries2[(head+33)%64] <= 0;
    end
    64'b0000000000000000000000000000010000000000000000000000000000000000: begin
        result_out <= result[(head+34)%64];
        readys[(head+34)%64] <= 0;
        operand1s[(head+34)%64] <= 0;
        operand2s[(head+34)%64] <= 0;
        operand1_datas[(head+34)%64] <= 0;
        operand2_datas[(head+34)%64] <= 0;
        valid_entries1[(head+34)%64] <= 0;
        valid_entries2[(head+34)%64] <= 0;
    end
    64'b0000000000000000000000000000100000000000000000000000000000000000: begin
        result_out <= result[(head+35)%64];
        readys[(head+35)%64] <= 0;
        operand1s[(head+35)%64] <= 0;
        operand2s[(head+35)%64] <= 0;
        operand1_datas[(head+35)%64] <= 0;
        operand2_datas[(head+35)%64] <= 0;
        valid_entries1[(head+35)%64] <= 0;
        valid_entries2[(head+35)%64] <= 0;
    end
    64'b0000000000000000000000000001000000000000000000000000000000000000: begin
        result_out <= result[(head+36)%64];
        readys[(head+36)%64] <= 0;
        operand1s[(head+36)%64] <= 0;
        operand2s[(head+36)%64] <= 0;
        operand1_datas[(head+36)%64] <= 0;
        operand2_datas[(head+36)%64] <= 0;
        valid_entries1[(head+36)%64] <= 0;
        valid_entries2[(head+36)%64] <= 0;
    end
    64'b0000000000000000000000000010000000000000000000000000000000000000: begin
        result_out <= result[(head+37)%64];
        readys[(head+37)%64] <= 0;
        operand1s[(head+37)%64] <= 0;
        operand2s[(head+37)%64] <= 0;
        operand1_datas[(head+37)%64] <= 0;
        operand2_datas[(head+37)%64] <= 0;
        valid_entries1[(head+37)%64] <= 0;
        valid_entries2[(head+37)%64] <= 0;
    end
    64'b0000000000000000000000000100000000000000000000000000000000000000: begin
        result_out <= result[(head+38)%64];
        readys[(head+38)%64] <= 0;
        operand1s[(head+38)%64] <= 0;
        operand2s[(head+38)%64] <= 0;
        operand1_datas[(head+38)%64] <= 0;
        operand2_datas[(head+38)%64] <= 0;
        valid_entries1[(head+38)%64] <= 0;
        valid_entries2[(head+38)%64] <= 0;
    end
    64'b0000000000000000000000001000000000000000000000000000000000000000: begin
        result_out <= result[(head+39)%64];
        readys[(head+39)%64] <= 0;
        operand1s[(head+39)%64] <= 0;
        operand2s[(head+39)%64] <= 0;
        operand1_datas[(head+39)%64] <= 0;
        operand2_datas[(head+39)%64] <= 0;
        valid_entries1[(head+39)%64] <= 0;
        valid_entries2[(head+39)%64] <= 0;
    end
    64'b0000000000000000000000010000000000000000000000000000000000000000: begin
        result_out <= result[(head+40)%64];
        readys[(head+40)%64] <= 0;
        operand1s[(head+40)%64] <= 0;
        operand2s[(head+40)%64] <= 0;
        operand1_datas[(head+40)%64] <= 0;
        operand2_datas[(head+40)%64] <= 0;
        valid_entries1[(head+40)%64] <= 0;
        valid_entries2[(head+40)%64] <= 0;
    end
    64'b0000000000000000000000100000000000000000000000000000000000000000: begin
        result_out <= result[(head+41)%64];
        readys[(head+41)%64] <= 0;
        operand1s[(head+41)%64] <= 0;
        operand2s[(head+41)%64] <= 0;
        operand1_datas[(head+41)%64] <= 0;
        operand2_datas[(head+41)%64] <= 0;
        valid_entries1[(head+41)%64] <= 0;
        valid_entries2[(head+41)%64] <= 0;
    end
    64'b0000000000000000000001000000000000000000000000000000000000000000: begin
        result_out <= result[(head+42)%64];
        readys[(head+42)%64] <= 0;
        operand1s[(head+42)%64] <= 0;
        operand2s[(head+42)%64] <= 0;
        operand1_datas[(head+42)%64] <= 0;
        operand2_datas[(head+42)%64] <= 0;
        valid_entries1[(head+42)%64] <= 0;
        valid_entries2[(head+42)%64] <= 0;
    end
    64'b0000000000000000000010000000000000000000000000000000000000000000: begin
        result_out <= result[(head+43)%64];
        readys[(head+43)%64] <= 0;
        operand1s[(head+43)%64] <= 0;
        operand2s[(head+43)%64] <= 0;
        operand1_datas[(head+43)%64] <= 0;
        operand2_datas[(head+43)%64] <= 0;
        valid_entries1[(head+43)%64] <= 0;
        valid_entries2[(head+43)%64] <= 0;
    end
    64'b0000000000000000000100000000000000000000000000000000000000000000: begin
        result_out <= result[(head+44)%64];
        readys[(head+44)%64] <= 0;
        operand1s[(head+44)%64] <= 0;
        operand2s[(head+44)%64] <= 0;
        operand1_datas[(head+44)%64] <= 0;
        operand2_datas[(head+44)%64] <= 0;
        valid_entries1[(head+44)%64] <= 0;
        valid_entries2[(head+44)%64] <= 0;
    end
    64'b0000000000000000001000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+45)%64];
        readys[(head+45)%64] <= 0;
        operand1s[(head+45)%64] <= 0;
        operand2s[(head+45)%64] <= 0;
        operand1_datas[(head+45)%64] <= 0;
        operand2_datas[(head+45)%64] <= 0;
        valid_entries1[(head+45)%64] <= 0;
        valid_entries2[(head+45)%64] <= 0;
    end
    64'b0000000000000000010000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+46)%64];
        readys[(head+46)%64] <= 0;
        operand1s[(head+46)%64] <= 0;
        operand2s[(head+46)%64] <= 0;
        operand1_datas[(head+46)%64] <= 0;
        operand2_datas[(head+46)%64] <= 0;
        valid_entries1[(head+46)%64] <= 0;
        valid_entries2[(head+46)%64] <= 0;
    end
    64'b0000000000000000100000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+47)%64];
        readys[(head+47)%64] <= 0;
        operand1s[(head+47)%64] <= 0;
        operand2s[(head+47)%64] <= 0;
        operand1_datas[(head+47)%64] <= 0;
        operand2_datas[(head+47)%64] <= 0;
        valid_entries1[(head+47)%64] <= 0;
        valid_entries2[(head+47)%64] <= 0;
    end
    64'b0000000000000001000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+48)%64];
        readys[(head+48)%64] <= 0;
        operand1s[(head+48)%64] <= 0;
        operand2s[(head+48)%64] <= 0;
        operand1_datas[(head+48)%64] <= 0;
        operand2_datas[(head+48)%64] <= 0;
        valid_entries1[(head+48)%64] <= 0;
        valid_entries2[(head+48)%64] <= 0;
    end
    64'b0000000000000010000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+49)%64];
        readys[(head+49)%64] <= 0;
        operand1s[(head+49)%64] <= 0;
        operand2s[(head+49)%64] <= 0;
        operand1_datas[(head+49)%64] <= 0;
        operand2_datas[(head+49)%64] <= 0;
        valid_entries1[(head+49)%64] <= 0;
        valid_entries2[(head+49)%64] <= 0;
    end
    64'b0000000000000100000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+50)%64];
        readys[(head+50)%64] <= 0;
        operand1s[(head+50)%64] <= 0;
        operand2s[(head+50)%64] <= 0;
        operand1_datas[(head+50)%64] <= 0;
        operand2_datas[(head+50)%64] <= 0;
        valid_entries1[(head+50)%64] <= 0;
        valid_entries2[(head+50)%64] <= 0;
    end
    64'b0000000000001000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+51)%64];
        readys[(head+51)%64] <= 0;
        operand1s[(head+51)%64] <= 0;
        operand2s[(head+51)%64] <= 0;
        operand1_datas[(head+51)%64] <= 0;
        operand2_datas[(head+51)%64] <= 0;
        valid_entries1[(head+51)%64] <= 0;
        valid_entries2[(head+51)%64] <= 0;
    end
    64'b0000000000010000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+52)%64];
        readys[(head+52)%64] <= 0;
        operand1s[(head+52)%64] <= 0;
        operand2s[(head+52)%64] <= 0;
        operand1_datas[(head+52)%64] <= 0;
        operand2_datas[(head+52)%64] <= 0;
        valid_entries1[(head+52)%64] <= 0;
        valid_entries2[(head+52)%64] <= 0;
    end
    64'b0000000000100000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+53)%64];
        readys[(head+53)%64] <= 0;
        operand1s[(head+53)%64] <= 0;
        operand2s[(head+53)%64] <= 0;
        operand1_datas[(head+53)%64] <= 0;
        operand2_datas[(head+53)%64] <= 0;
        valid_entries1[(head+53)%64] <= 0;
        valid_entries2[(head+53)%64] <= 0;
    end
    64'b0000000001000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+54)%64];
        readys[(head+54)%64] <= 0;
        operand1s[(head+54)%64] <= 0;
        operand2s[(head+54)%64] <= 0;
        operand1_datas[(head+54)%64] <= 0;
        operand2_datas[(head+54)%64] <= 0;
        valid_entries1[(head+54)%64] <= 0;
        valid_entries2[(head+54)%64] <= 0;
    end
    64'b0000000010000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+55)%64];
        readys[(head+55)%64] <= 0;
        operand1s[(head+55)%64] <= 0;
        operand2s[(head+55)%64] <= 0;
        operand1_datas[(head+55)%64] <= 0;
        operand2_datas[(head+55)%64] <= 0;
        valid_entries1[(head+55)%64] <= 0;
        valid_entries2[(head+55)%64] <= 0;
    end
    64'b0000000100000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+56)%64];
        readys[(head+56)%64] <= 0;
        operand1s[(head+56)%64] <= 0;
        operand2s[(head+56)%64] <= 0;
        operand1_datas[(head+56)%64] <= 0;
        operand2_datas[(head+56)%64] <= 0;
        valid_entries1[(head+56)%64] <= 0;
        valid_entries2[(head+56)%64] <= 0;
    end
    64'b0000001000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+57)%64];
        readys[(head+57)%64] <= 0;
        operand1s[(head+57)%64] <= 0;
        operand2s[(head+57)%64] <= 0;
        operand1_datas[(head+57)%64] <= 0;
        operand2_datas[(head+57)%64] <= 0;
        valid_entries1[(head+57)%64] <= 0;
        valid_entries2[(head+57)%64] <= 0;
    end
    64'b0000010000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+58)%64];
        readys[(head+58)%64] <= 0;
        operand1s[(head+58)%64] <= 0;
        operand2s[(head+58)%64] <= 0;
        operand1_datas[(head+58)%64] <= 0;
        operand2_datas[(head+58)%64] <= 0;
        valid_entries1[(head+58)%64] <= 0;
        valid_entries2[(head+58)%64] <= 0;
    end
    64'b0000100000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+59)%64];
        readys[(head+59)%64] <= 0;
        operand1s[(head+59)%64] <= 0;
        operand2s[(head+59)%64] <= 0;
        operand1_datas[(head+59)%64] <= 0;
        operand2_datas[(head+59)%64] <= 0;
        valid_entries1[(head+59)%64] <= 0;
        valid_entries2[(head+59)%64] <= 0;
    end
    64'b0001000000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+60)%64];
        readys[(head+60)%64] <= 0;
        operand1s[(head+60)%64] <= 0;
        operand2s[(head+60)%64] <= 0;
        operand1_datas[(head+60)%64] <= 0;
        operand2_datas[(head+60)%64] <= 0;
        valid_entries1[(head+60)%64] <= 0;
        valid_entries2[(head+60)%64] <= 0;
    end
    64'b0010000000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+61)%64];
        readys[(head+61)%64] <= 0;
        operand1s[(head+61)%64] <= 0;
        operand2s[(head+61)%64] <= 0;
        operand1_datas[(head+61)%64] <= 0;
        operand2_datas[(head+61)%64] <= 0;
        valid_entries1[(head+61)%64] <= 0;
        valid_entries2[(head+61)%64] <= 0;
    end
    64'b0100000000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+62)%64];
        readys[(head+62)%64] <= 0;
        operand1s[(head+62)%64] <= 0;
        operand2s[(head+62)%64] <= 0;
        operand1_datas[(head+62)%64] <= 0;
        operand2_datas[(head+62)%64] <= 0;
        valid_entries1[(head+62)%64] <= 0;
        valid_entries2[(head+62)%64] <= 0;
    end
    64'b1000000000000000000000000000000000000000000000000000000000000000: begin
        result_out <= result[(head+63)%64];
        readys[(head+63)%64] <= 0;
        operand1s[(head+63)%64] <= 0;
        operand2s[(head+63)%64] <= 0;
        operand1_datas[(head+63)%64] <= 0;
        operand2_datas[(head+63)%64] <= 0;
        valid_entries1[(head+63)%64] <= 0;
        valid_entries2[(head+63)%64] <= 0;
    end                                   
           default: begin
                result_out <= 0;
                readys <= 0;
               
            end
        endcase
    end
end

endmodule
