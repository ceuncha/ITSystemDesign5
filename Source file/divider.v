module divider (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [7:0] Physical_address_in, 
    input wire [31:0] PC_in,
    input wire [3:0] divider_op_in,
    output reg divide_zero_exception,
    output reg [31:0] Result,
    output reg done,
    output reg [7:0] Physical_address_out,
    output reg [31:0] PC_out
);

    // 내부 레지스터
    reg [63:0] temp_dividend[0:31];
    reg [31:0] divisor[0:31];
    reg [7:0] Physical_address_reg[0:31];
    reg [31:0] PC_reg[0:31];
    reg [3:0] divider_op_reg[0:31];
    reg done_reg[0:31];
    reg divide_zero_reg[0:31];
    reg [63:0] temp_dividend_cal0;
    reg [63:0] temp_dividend_cal1;
    reg [63:0] temp_dividend_cal2;
    reg [63:0] temp_dividend_cal3;
    reg [63:0] temp_dividend_cal4;
    reg [63:0] temp_dividend_cal5;
    reg [63:0] temp_dividend_cal6;
    reg [63:0] temp_dividend_cal7;
    reg [63:0] temp_dividend_cal8;
    reg [63:0] temp_dividend_cal9;
    reg [63:0] temp_dividend_cal10;
    reg [63:0] temp_dividend_cal11;
    reg [63:0] temp_dividend_cal12;
    reg [63:0] temp_dividend_cal13;
    reg [63:0] temp_dividend_cal14;
    reg [63:0] temp_dividend_cal15;
    reg [63:0] temp_dividend_cal16;
    reg [63:0] temp_dividend_cal17;
    reg [63:0] temp_dividend_cal18;
    reg [63:0] temp_dividend_cal19;
    reg [63:0] temp_dividend_cal20;
    reg [63:0] temp_dividend_cal21;
    reg [63:0] temp_dividend_cal22;
    reg [63:0] temp_dividend_cal23;
    reg [63:0] temp_dividend_cal24;
    reg [63:0] temp_dividend_cal25;
    reg [63:0] temp_dividend_cal26;
    reg [63:0] temp_dividend_cal27;
    reg [63:0] temp_dividend_cal28;
    reg [63:0] temp_dividend_cal29;
    reg [63:0] temp_dividend_cal30;
    reg [63:0] temp_dividend_cal31;
    reg [63:0] temp_dividend_cal0_shift;
reg [63:0] temp_dividend_cal1_shift;
reg [63:0] temp_dividend_cal2_shift;
reg [63:0] temp_dividend_cal3_shift;
reg [63:0] temp_dividend_cal4_shift;
reg [63:0] temp_dividend_cal5_shift;
reg [63:0] temp_dividend_cal6_shift;
reg [63:0] temp_dividend_cal7_shift;
reg [63:0] temp_dividend_cal8_shift;
reg [63:0] temp_dividend_cal9_shift;
reg [63:0] temp_dividend_cal10_shift;
reg [63:0] temp_dividend_cal11_shift;
reg [63:0] temp_dividend_cal12_shift;
reg [63:0] temp_dividend_cal13_shift;
reg [63:0] temp_dividend_cal14_shift;
reg [63:0] temp_dividend_cal15_shift;
reg [63:0] temp_dividend_cal16_shift;
reg [63:0] temp_dividend_cal17_shift;
reg [63:0] temp_dividend_cal18_shift;
reg [63:0] temp_dividend_cal19_shift;
reg [63:0] temp_dividend_cal20_shift;
reg [63:0] temp_dividend_cal21_shift;
reg [63:0] temp_dividend_cal22_shift;
reg [63:0] temp_dividend_cal23_shift;
reg [63:0] temp_dividend_cal24_shift;
reg [63:0] temp_dividend_cal25_shift;
reg [63:0] temp_dividend_cal26_shift;
reg [63:0] temp_dividend_cal27_shift;
reg [63:0] temp_dividend_cal28_shift;
reg [63:0] temp_dividend_cal29_shift;
reg [63:0] temp_dividend_cal30_shift;


    wire divide_zero;
    integer i;
    
  assign divide_zero= (A!=0) && (B==0);
    // 초기화 및 시작
    always @(posedge clk ) begin
       if (start&!divide_zero) begin
            temp_dividend[0] <= {31'b0, A, 1'b0};
            divisor[0] <= B;
            Physical_address_reg[0] <= Physical_address_in;
            PC_reg[0] <= PC_in;
            divider_op_reg[0] <= divider_op_in;
            done_reg[0] <= 1'd1;
            divide_zero_reg [0]<= 1'b0;
        end
        else if (divide_zero) begin
            temp_dividend[0] <= 0;
            divisor[0] <= 0;
            Physical_address_reg[0] <= Physical_address_in;
            PC_reg[0] <= PC_in;
            divider_op_reg[0] <= 0;
            done_reg[0] <= 1'b1;
            divide_zero_reg [0]<= 1'b1;
        end
        else begin
            temp_dividend[0] <= 0;
            divisor[0] <= 0;
            Physical_address_reg[0] <= 0;
            PC_reg[0] <= 0;
            divider_op_reg[0] <= 0;
            done_reg[0] <= 0;
            divide_zero_reg [0]<= 1'b0;
    end
end
    // 32 스테이지 생성


            always @(posedge clk ) begin
              
                if (reset) begin
                for (i = 0; i < 31; i = i + 1) begin
                    temp_dividend[1] <= 64'd0;
    temp_dividend[2] <= 64'd0;
    temp_dividend[3] <= 64'd0;
    temp_dividend[4] <= 64'd0;
    temp_dividend[5] <= 64'd0;
    temp_dividend[6] <= 64'd0;
    temp_dividend[7] <= 64'd0;
    temp_dividend[8] <= 64'd0;
    temp_dividend[9] <= 64'd0;
    temp_dividend[10] <= 64'd0;
    temp_dividend[11] <= 64'd0;
    temp_dividend[12] <= 64'd0;
    temp_dividend[13] <= 64'd0;
    temp_dividend[14] <= 64'd0;
    temp_dividend[15] <= 64'd0;
    temp_dividend[16] <= 64'd0;
    temp_dividend[17] <= 64'd0;
    temp_dividend[18] <= 64'd0;
    temp_dividend[19] <= 64'd0;
    temp_dividend[20] <= 64'd0;
    temp_dividend[21] <= 64'd0;
    temp_dividend[22] <= 64'd0;
    temp_dividend[23] <= 64'd0;
    temp_dividend[24] <= 64'd0;
    temp_dividend[25] <= 64'd0;
    temp_dividend[26] <= 64'd0;
    temp_dividend[27] <= 64'd0;
    temp_dividend[28] <= 64'd0;
    temp_dividend[29] <= 64'd0;
    temp_dividend[30] <= 64'd0;
    temp_dividend[31] <= 64'd0;
                    divisor[i+1] <= 32'd0;
                    Physical_address_reg[i+1] <= 8'd0;
                    PC_reg[i+1] <= 32'd0;
                    divider_op_reg [i+1] <=1'd0; 
                    done_reg[i+1] <= 1'd0;
                    divide_zero_reg[i+1] <= 1'b0;                   
                end 
                end else begin
                for (i = 0; i < 31; i = i + 1) begin
                    temp_dividend[1] <= temp_dividend_cal0_shift;
                    temp_dividend[2] <= temp_dividend_cal1_shift;
                    temp_dividend[3] <= temp_dividend_cal2_shift;
temp_dividend[4] <= temp_dividend_cal3_shift;
temp_dividend[5] <= temp_dividend_cal4_shift;
temp_dividend[6] <= temp_dividend_cal5_shift;
temp_dividend[7] <= temp_dividend_cal6_shift;
temp_dividend[8] <= temp_dividend_cal7_shift;
temp_dividend[9] <= temp_dividend_cal8_shift;
temp_dividend[10] <= temp_dividend_cal9_shift;
temp_dividend[11] <= temp_dividend_cal10_shift;
temp_dividend[12] <= temp_dividend_cal11_shift;
temp_dividend[13] <= temp_dividend_cal12_shift;
temp_dividend[14] <= temp_dividend_cal13_shift;
temp_dividend[15] <= temp_dividend_cal14_shift;
temp_dividend[16] <= temp_dividend_cal15_shift;
temp_dividend[17] <= temp_dividend_cal16_shift;
temp_dividend[18] <= temp_dividend_cal17_shift;
temp_dividend[19] <= temp_dividend_cal18_shift;
temp_dividend[20] <= temp_dividend_cal19_shift;
temp_dividend[21] <= temp_dividend_cal20_shift;
temp_dividend[22] <= temp_dividend_cal21_shift;
temp_dividend[23] <= temp_dividend_cal22_shift;
temp_dividend[24] <= temp_dividend_cal23_shift;
temp_dividend[25] <= temp_dividend_cal24_shift;
temp_dividend[26] <= temp_dividend_cal25_shift;
temp_dividend[27] <= temp_dividend_cal26_shift;
temp_dividend[28] <= temp_dividend_cal27_shift;
temp_dividend[29] <= temp_dividend_cal28_shift;
temp_dividend[30] <= temp_dividend_cal29_shift;
temp_dividend[31] <= temp_dividend_cal30_shift;
                    divisor[i+1] <= divisor[i];
                    Physical_address_reg[i+1] <= Physical_address_reg[i];
                    PC_reg[i+1] <= PC_reg[i];
                    divider_op_reg [i+1] <= divider_op_reg [i];
                    done_reg[i+1] <= done_reg[i];
                    divide_zero_reg[i+1] <= divide_zero_reg[i];
                end
            end
        end

     

    
    
    

    always @(*) begin
  
          if (temp_dividend[0][63:32] >= divisor[0]) begin
            temp_dividend_cal0[63:32] = temp_dividend[0][63:32] - divisor[0];
            temp_dividend_cal0[31:0] = {temp_dividend[0][31:1], 1'b1};
            temp_dividend_cal0_shift= temp_dividend_cal0 <<1;
        end else begin
            temp_dividend_cal0 = {temp_dividend[0][63:1], 1'b0};
            temp_dividend_cal0_shift= temp_dividend_cal0 <<1;
        end

        if (temp_dividend[1][63:32] >= divisor[1]) begin
            temp_dividend_cal1[63:32] = temp_dividend[1][63:32] - divisor[1];
            temp_dividend_cal1[31:0] = {temp_dividend[1][31:1], 1'b1};
            temp_dividend_cal1_shift= temp_dividend_cal1 <<1;
        end else begin
            temp_dividend_cal1 = {temp_dividend[1][63:1], 1'b0};
            temp_dividend_cal1_shift= temp_dividend_cal1 <<1;
        end

        if (temp_dividend[2][63:32] >= divisor[2]) begin
            temp_dividend_cal2[63:32] = temp_dividend[2][63:32] - divisor[2];
            temp_dividend_cal2[31:0] = {temp_dividend[2][31:1], 1'b1};
            temp_dividend_cal2_shift= temp_dividend_cal2 <<1;
        end else begin
            temp_dividend_cal2 = {temp_dividend[2][63:1], 1'b0};
            temp_dividend_cal2_shift= temp_dividend_cal2 <<1;
        end

        if (temp_dividend[3][63:32] >= divisor[3]) begin
            temp_dividend_cal3[63:32] = temp_dividend[3][63:32] - divisor[3];
            temp_dividend_cal3[31:0] = {temp_dividend[3][31:1], 1'b1};
            temp_dividend_cal3_shift= temp_dividend_cal3 <<1;
        end else begin
            temp_dividend_cal3 = {temp_dividend[3][63:1], 1'b0};
            temp_dividend_cal3_shift= temp_dividend_cal3 <<1;
        end

        if (temp_dividend[4][63:32] >= divisor[4]) begin
            temp_dividend_cal4[63:32] = temp_dividend[4][63:32] - divisor[4];
            temp_dividend_cal4[31:0] = {temp_dividend[4][31:1], 1'b1};
            temp_dividend_cal4_shift= temp_dividend_cal4 <<1;
        end else begin
            temp_dividend_cal4 = {temp_dividend[4][63:1], 1'b0};
            temp_dividend_cal4_shift= temp_dividend_cal4 <<1;
            
        end

        if (temp_dividend[5][63:32] >= divisor[5]) begin
            temp_dividend_cal5[63:32] = temp_dividend[5][63:32] - divisor[5];
            temp_dividend_cal5[31:0] = {temp_dividend[5][31:1], 1'b1};
            temp_dividend_cal5_shift= temp_dividend_cal5 <<1;
        end else begin
            temp_dividend_cal5 = {temp_dividend[5][63:1], 1'b0};
            temp_dividend_cal5_shift= temp_dividend_cal5 <<1;
        end

        if (temp_dividend[6][63:32] >= divisor[6]) begin
            temp_dividend_cal6[63:32] = temp_dividend[6][63:32] - divisor[6];
            temp_dividend_cal6[31:0] = {temp_dividend[6][31:1], 1'b1};
            temp_dividend_cal6_shift= temp_dividend_cal6 <<1;
        end else begin
            temp_dividend_cal6 = {temp_dividend[6][63:1], 1'b0};
            temp_dividend_cal6_shift= temp_dividend_cal6 <<1;
        end

        if (temp_dividend[7][63:32] >= divisor[7]) begin
            temp_dividend_cal7[63:32] = temp_dividend[7][63:32] - divisor[7];
            temp_dividend_cal7[31:0] = {temp_dividend[7][31:1], 1'b1};
            temp_dividend_cal7_shift= temp_dividend_cal7 <<1;
        end else begin
            temp_dividend_cal7 = {temp_dividend[7][63:1], 1'b0};
            temp_dividend_cal7_shift= temp_dividend_cal7 <<1;
        end

        if (temp_dividend[8][63:32] >= divisor[8]) begin
            temp_dividend_cal8[63:32] = temp_dividend[8][63:32] - divisor[8];
            temp_dividend_cal8[31:0] = {temp_dividend[8][31:1], 1'b1};
            temp_dividend_cal8_shift= temp_dividend_cal8 <<1;
        end else begin
            temp_dividend_cal8 = {temp_dividend[8][63:1], 1'b0};
            temp_dividend_cal8_shift= temp_dividend_cal8 <<1;
        end

        if (temp_dividend[9][63:32] >= divisor[9]) begin
            temp_dividend_cal9[63:32] = temp_dividend[9][63:32] - divisor[9];
            temp_dividend_cal9[31:0] = {temp_dividend[9][31:1], 1'b1};
            temp_dividend_cal9_shift= temp_dividend_cal9 <<1;
        end else begin
            temp_dividend_cal9 = {temp_dividend[9][63:1], 1'b0};
            temp_dividend_cal9_shift= temp_dividend_cal9 <<1;
        end

        if (temp_dividend[10][63:32] >= divisor[10]) begin
            temp_dividend_cal10[63:32] = temp_dividend[10][63:32] - divisor[10];
            temp_dividend_cal10[31:0] = {temp_dividend[10][31:1], 1'b1};
            temp_dividend_cal10_shift= temp_dividend_cal10 <<1;
        end else begin
            temp_dividend_cal10 = {temp_dividend[10][63:1], 1'b0};
            temp_dividend_cal10_shift= temp_dividend_cal10 <<1;
        end

        if (temp_dividend[11][63:32] >= divisor[11]) begin
            temp_dividend_cal11[63:32] = temp_dividend[11][63:32] - divisor[11];
            temp_dividend_cal11[31:0] = {temp_dividend[11][31:1], 1'b1};
            temp_dividend_cal11_shift= temp_dividend_cal11 <<1;
        end else begin
            temp_dividend_cal11 = {temp_dividend[11][63:1], 1'b0};
            temp_dividend_cal11_shift= temp_dividend_cal11 <<1;
        end

        if (temp_dividend[12][63:32] >= divisor[12]) begin
            temp_dividend_cal12[63:32] = temp_dividend[12][63:32] - divisor[12];
            temp_dividend_cal12[31:0] = {temp_dividend[12][31:1], 1'b1};
            temp_dividend_cal12_shift= temp_dividend_cal12 <<1;
        end else begin
            temp_dividend_cal12 = {temp_dividend[12][63:1], 1'b0};
            temp_dividend_cal12_shift= temp_dividend_cal12 <<1;
        end

        if (temp_dividend[13][63:32] >= divisor[13]) begin
            temp_dividend_cal13[63:32] = temp_dividend[13][63:32] - divisor[13];
            temp_dividend_cal13[31:0] = {temp_dividend[13][31:1], 1'b1};
            temp_dividend_cal13_shift= temp_dividend_cal13 <<1;
        end else begin
            temp_dividend_cal13 = {temp_dividend[13][63:1], 1'b0};
            temp_dividend_cal13_shift= temp_dividend_cal13 <<1;
        end

        if (temp_dividend[14][63:32] >= divisor[14]) begin
            temp_dividend_cal14[63:32] = temp_dividend[14][63:32] - divisor[14];
            temp_dividend_cal14[31:0] = {temp_dividend[14][31:1], 1'b1};
            temp_dividend_cal14_shift= temp_dividend_cal14 <<1;
        end else begin
            temp_dividend_cal14 = {temp_dividend[14][63:1], 1'b0};
            temp_dividend_cal14_shift= temp_dividend_cal14 <<1;
        end

        if (temp_dividend[15][63:32] >= divisor[15]) begin
            temp_dividend_cal15[63:32] = temp_dividend[15][63:32] - divisor[15];
            temp_dividend_cal15[31:0] = {temp_dividend[15][31:1], 1'b1};
            temp_dividend_cal15_shift= temp_dividend_cal15 <<1;
        end else begin
            temp_dividend_cal15 = {temp_dividend[15][63:1], 1'b0};
            temp_dividend_cal15_shift= temp_dividend_cal15 <<1;
        end

        if (temp_dividend[16][63:32] >= divisor[16]) begin
            temp_dividend_cal16[63:32] = temp_dividend[16][63:32] - divisor[16];
            temp_dividend_cal16[31:0] = {temp_dividend[16][31:1], 1'b1};
            temp_dividend_cal16_shift= temp_dividend_cal16 <<1;
        end else begin
            temp_dividend_cal16 = {temp_dividend[16][63:1], 1'b0};
            temp_dividend_cal16_shift= temp_dividend_cal16 <<1;
        end

        if (temp_dividend[17][63:32] >= divisor[17]) begin
            temp_dividend_cal17[63:32] = temp_dividend[17][63:32] - divisor[17];
            temp_dividend_cal17[31:0] = {temp_dividend[17][31:1], 1'b1};
            temp_dividend_cal17_shift= temp_dividend_cal17 <<1;
        end else begin
            temp_dividend_cal17 = {temp_dividend[17][63:1], 1'b0};
            temp_dividend_cal17_shift= temp_dividend_cal17 <<1;
        end

        if (temp_dividend[18][63:32] >= divisor[18]) begin
            temp_dividend_cal18[63:32] = temp_dividend[18][63:32] - divisor[18];
            temp_dividend_cal18[31:0] = {temp_dividend[18][31:1], 1'b1};
            temp_dividend_cal18_shift= temp_dividend_cal18 <<1;
        end else begin
            temp_dividend_cal18 = {temp_dividend[18][63:1], 1'b0};
            temp_dividend_cal18_shift= temp_dividend_cal18 <<1;
        end

        if (temp_dividend[19][63:32] >= divisor[19]) begin
            temp_dividend_cal19[63:32] = temp_dividend[19][63:32] - divisor[19];
            temp_dividend_cal19[31:0] = {temp_dividend[19][31:1], 1'b1};
            temp_dividend_cal19_shift= temp_dividend_cal19 <<1;
        end else begin
            temp_dividend_cal19 = {temp_dividend[19][63:1], 1'b0};
            temp_dividend_cal19_shift= temp_dividend_cal19 <<1;
        end

        if (temp_dividend[20][63:32] >= divisor[20]) begin
            temp_dividend_cal20[63:32] = temp_dividend[20][63:32] - divisor[20];
            temp_dividend_cal20[31:0] = {temp_dividend[20][31:1], 1'b1};
            temp_dividend_cal20_shift= temp_dividend_cal20 <<1;
        end else begin
            temp_dividend_cal20 = {temp_dividend[20][63:1], 1'b0};
            temp_dividend_cal20_shift= temp_dividend_cal20 <<1;
        end

        if (temp_dividend[21][63:32] >= divisor[21]) begin
            temp_dividend_cal21[63:32] = temp_dividend[21][63:32] - divisor[21];
            temp_dividend_cal21[31:0] = {temp_dividend[21][31:1], 1'b1};
            temp_dividend_cal21_shift= temp_dividend_cal21 <<1;
        end else begin
            temp_dividend_cal21 = {temp_dividend[21][63:1], 1'b0};
            temp_dividend_cal21_shift= temp_dividend_cal21 <<1;
        end

        if (temp_dividend[22][63:32] >= divisor[22]) begin
            temp_dividend_cal22[63:32] = temp_dividend[22][63:32] - divisor[22];
            temp_dividend_cal22[31:0] = {temp_dividend[22][31:1], 1'b1};
            temp_dividend_cal22_shift= temp_dividend_cal22 <<1;
        end else begin
            temp_dividend_cal22 = {temp_dividend[22][63:1], 1'b0};
            temp_dividend_cal22_shift= temp_dividend_cal22 <<1;
        end

        if (temp_dividend[23][63:32] >= divisor[23]) begin
            temp_dividend_cal23[63:32] = temp_dividend[23][63:32] - divisor[23];
            temp_dividend_cal23[31:0] = {temp_dividend[23][31:1], 1'b1};
            temp_dividend_cal23_shift= temp_dividend_cal23 <<1;
        end else begin
            temp_dividend_cal23 = {temp_dividend[23][63:1], 1'b0};
            temp_dividend_cal23_shift= temp_dividend_cal23 <<1;
        end

        if (temp_dividend[24][63:32] >= divisor[24]) begin
            temp_dividend_cal24[63:32] = temp_dividend[24][63:32] - divisor[24];
            temp_dividend_cal24[31:0] = {temp_dividend[24][31:1], 1'b1};
            temp_dividend_cal24_shift= temp_dividend_cal24 <<1;
        end else begin
            temp_dividend_cal24 = {temp_dividend[24][63:1], 1'b0};
            temp_dividend_cal24_shift= temp_dividend_cal24 <<1;
        end

        if (temp_dividend[25][63:32] >= divisor[25]) begin
            temp_dividend_cal25[63:32] = temp_dividend[25][63:32] - divisor[25];
            temp_dividend_cal25[31:0] = {temp_dividend[25][31:1], 1'b1};
            temp_dividend_cal25_shift= temp_dividend_cal25 <<1;
        end else begin
            temp_dividend_cal25 = {temp_dividend[25][63:1], 1'b0};
            temp_dividend_cal25_shift= temp_dividend_cal25 <<1;
        end

        if (temp_dividend[26][63:32] >= divisor[26]) begin
            temp_dividend_cal26[63:32] = temp_dividend[26][63:32] - divisor[26];
            temp_dividend_cal26[31:0] = {temp_dividend[26][31:1], 1'b1};
            temp_dividend_cal26_shift= temp_dividend_cal26 <<1;
        end else begin
            temp_dividend_cal26 = {temp_dividend[26][63:1], 1'b0};
            temp_dividend_cal26_shift= temp_dividend_cal26 <<1;
        end

        if (temp_dividend[27][63:32] >= divisor[27]) begin
            temp_dividend_cal27[63:32] = temp_dividend[27][63:32] - divisor[27];
            temp_dividend_cal27[31:0] = {temp_dividend[27][31:1], 1'b1};
            temp_dividend_cal27_shift= temp_dividend_cal27 <<1;
        end else begin
            temp_dividend_cal27 = {temp_dividend[27][63:1], 1'b0};
            temp_dividend_cal27_shift= temp_dividend_cal27 <<1;
        end

        if (temp_dividend[28][63:32] >= divisor[28]) begin
            temp_dividend_cal28[63:32] = temp_dividend[28][63:32] - divisor[28];
            temp_dividend_cal28[31:0] = {temp_dividend[28][31:1], 1'b1};
            temp_dividend_cal28_shift= temp_dividend_cal28 <<1;
        end else begin
            temp_dividend_cal28 = {temp_dividend[28][63:1], 1'b0};
            temp_dividend_cal28_shift= temp_dividend_cal28 <<1;
        end

        if (temp_dividend[29][63:32] >= divisor[29]) begin
            temp_dividend_cal29[63:32] = temp_dividend[29][63:32] - divisor[29];
            temp_dividend_cal29[31:0] = {temp_dividend[29][31:1], 1'b1};
            temp_dividend_cal29_shift= temp_dividend_cal29 <<1;
        end else begin
            temp_dividend_cal29 = {temp_dividend[29][63:1], 1'b0};
            temp_dividend_cal29_shift= temp_dividend_cal29 <<1;
        end

        if (temp_dividend[30][63:32] >= divisor[30]) begin
            temp_dividend_cal30[63:32] = temp_dividend[30][63:32] - divisor[30];
            temp_dividend_cal30[31:0] = {temp_dividend[30][31:1], 1'b1};
            temp_dividend_cal30_shift= temp_dividend_cal30 <<1;
        end else begin
            temp_dividend_cal30 = {temp_dividend[30][63:1], 1'b0};
            temp_dividend_cal30_shift= temp_dividend_cal30 <<1;
        end

        if (temp_dividend[31][63:32] >= divisor[31]) begin
            temp_dividend_cal31[63:32] = temp_dividend[31][63:32] - divisor[31];
            temp_dividend_cal31[31:0] = {temp_dividend[31][31:1], 1'b1};
        end else begin
            temp_dividend_cal31 = {temp_dividend[31][63:1], 1'b0};
        end
    end
   
  

    // 결과 설정
   always @(*) begin 
                if(divider_op_reg[31]==4'b0001) begin
                Result = temp_dividend_cal31[31:0];
                Physical_address_out = Physical_address_reg[31];
                PC_out = PC_reg[31];
                done = done_reg[31]; 
                divide_zero_exception = divide_zero_reg[31];              
                end
                else begin
                Result = temp_dividend_cal31[63:32];
                Physical_address_out = Physical_address_reg[31];
                PC_out = PC_reg[31];
                done = done_reg[31];
                divide_zero_exception = divide_zero_reg[31];  
                end
                end
                
               
endmodule
