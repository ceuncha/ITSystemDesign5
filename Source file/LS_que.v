module LS_que(
input clk,
input reset,
input LS_Memwrite,
input LS_MemRead,
input [31:0] LS_inst_num,
input [7:0] Load_Phy,
input [2:0] func3_LS,
input [31:0] LS_Result,
input [31:0] Operand2_LS,
input LS_on,
output LS_que_MemWrite,
output LS_que_MemRead,
output [31:0] LS_que_inst_num,
output [7:0] LS_que_phy,
output [2:0] LS_que_func3,
output [31:0] LS_que_Address,
output [31:0] LS_que_WriteData,
output LS_que_exception
    );

reg exception;
reg MemWrite [0:31];
reg MemRead [0:31];
reg [31:0] inst_num [0:31]; 
reg [7:0] Phy [0:31];
reg [2:0] func3 [0:31];
reg [31:0] Address [0:31];
reg [31:0] WriteData [0:31];
reg valid [0:31];
reg [4:0] tail;
reg [4:0] head;

integer i;

always @(posedge clk) begin 
 if (reset) begin  //초기화
   for (i = 0; i < 32; i = i + 1) begin
         MemWrite [i] <= 1'b0;
         MemRead [i] <= 1'b0;
         inst_num [i] <= 32'b0;
         Phy [i] <= 8'b0;
         func3 [i] <= 3'b0;
         Address [i] <= 32'b0;
         WriteData [i] <= 32'b0;
         valid [i] <= 1'b0;
   end 
   tail <=4'b0;
   head <=4'b0;
 end
 else begin
  if (valid[head]) begin
   valid [head] <= 1'b0;
   head <= (head+1)%32;
  end
  if (LS_on) begin
   MemWrite [tail] <= LS_Memwrite;
   MemRead [tail] <= LS_MemRead;
   inst_num [tail] <= LS_inst_num;
   Phy [tail] <= Load_Phy;
   func3 [tail] <= func3_LS;
   Address [tail] <= LS_Result;
   WriteData [tail] <= Operand2_LS;
   valid [tail] <= 1'b1;
   tail <= (tail +1) %32;
   end
 end
 end
always @(*) begin 
 exception = 1'b0;
 for (i = 0; i < 32; i = i + 1) begin
      if (Address[i] == Address[head] && !valid[i] && MemRead[head] != MemRead[i] && MemWrite[head] != MemWrite[i]) begin
        exception = 1'b1;
      end 
  end
end
assign LS_que_MemWrite = MemWrite [head];
assign LS_que_MemRead = MemRead [head];
assign LS_que_inst_num = inst_num [head];
assign LS_que_phy = Phy[head];
assign LS_que_func3 = func3 [head];
assign LS_que_Address = Address [head];
assign LS_que_WriteData = WriteData [head];
assign LS_que_exception = exception;
endmodule
