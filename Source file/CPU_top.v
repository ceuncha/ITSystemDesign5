module CPU_top(
    input clk,
    input rst,
    output [31:0] x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15,
    output [31:0] x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31
);

//program counter
(* keep = "true" *)wire first_and_Pcsrc;
(* keep = "true" *)wire Wrong;
(* keep = "true" *)wire hit;
(* keep = "true" *)wire ID_EX_hit;
(* keep = "true" *)wire taken;
(* keep = "true" *)wire PC_taken;
	(* keep = "true" *)wire ID_exception;

//////////IF_ID_Wire    
(* keep = "true" *)wire [31:0] PC, PC_Branch;   
(* keep = "true" *)wire  PCSrc;
(* keep = "true" *)wire [31:0] instOut;
(* keep = "true" *)wire [31:0] inst_num;
(* keep = "true" *)wire [4:0] Rs1 = instOut[19:15];
(* keep = "true" *)wire [4:0] Rs2 = instOut[24:20];
(* keep = "true" *)wire [4:0] Rd =instOut[11:7];
(* keep = "true" *)wire [6:0] instOut_opcode = instOut[6:0];
// ID stage
(* keep = "true" *)wire IF_ID_taken;
(* keep = "true" *)wire IF_ID_hit;
(* keep = "true" *)wire [31:0] IF_ID_instOut;
(* keep = "true" *)wire [31:0] IF_ID_PC;
(* keep = "true" *)wire [31:0] IF_ID_inst_num;
(* keep = "true" *)wire IF_ID_Flush;
    // parse instOut
(* keep = "true" *)wire [6:0] funct7 = IF_ID_instOut[31:25];
(* keep = "true" *)wire [2:0] funct3 = IF_ID_instOut[14:12];
(* keep = "true" *)wire [6:0] opcode = IF_ID_instOut[6:0];

(* keep = "true" *)wire [31:0] RS_alu_inst_num;
(* keep = "true" *)wire [31:0] imm32;
(* keep = "true" *)wire RegWrite;
(* keep = "true" *)wire MemToReg;
(* keep = "true" *)wire MemRead;
(* keep = "true" *)wire MemWrite;
(* keep = "true" *)wire [3:0] ALUOp;
(* keep = "true" *)wire [1:0] ALUSrc;
(* keep = "true" *)wire RWsel;
(* keep = "true" *)wire Jump;
(* keep = "true" *)wire Branch;
(* keep = "true" *)wire ALUSrc1 = ALUSrc[0];
(* keep = "true" *)wire ALUSrc2 = ALUSrc[1];
//RAT to chuchu
(* keep = "true" *)wire [7:0] original_phy_addr;
//chuchu to RAT
(* keep = "true" *)wire [7:0] chuchu_addr;
//RAT to pfile
(* keep = "true" *)wire [7:0] Phy_addr_OP1;
(* keep = "true" *)wire [7:0] Phy_addr_OP2;
(* keep = "true" *)wire [31:0] Operand1_BR;
(* keep = "true" *)wire [31:0] Operand2_BR;
(* keep = "true" *)wire [31:0] Operand1_ALU;
(* keep = "true" *)wire [31:0] Operand2_ALU;
(* keep = "true" *)wire [31:0] Operand1_Mul;
(* keep = "true" *)wire [31:0] Operand2_Mul;
(* keep = "true" *)wire [31:0] Operand1_Div;
(* keep = "true" *)wire [31:0] Operand2_Div;

//pfile to decoder
(* keep = "true" *)wire Valid1;
(* keep = "true" *)wire Valid2;
(* keep = "true" *)wire [1:0] Valid = {Valid2,Valid1};
(* keep = "true" *)wire [31:0] RData1;
(* keep = "true" *)wire [31:0] RData2;
(* keep = "true" *)wire [7:0] Rd_phy;
//BB to RAT and Pfile
(* keep = "true" *)wire save_on;
(* keep = "true" *)wire [4:0] save_page;
(* keep = "true" *)wire restore_on;
(* keep = "true" *)wire [4:0] restore_page;
//Branch unit to BB
(* keep = "true" *)wire [31:0] branch_index;
//forwarding wb
	

/////////////////////RS_EX_decoder wires
    
    (* keep = "true" *)wire [31:0] RS_alu_operand1_data, RS_alu_operand2_data, RS_alu_PC;
    (* keep = "true" *)wire [2:0] RS_alu_funct3;
    (* keep = "true" *)wire RS_alu_MemToReg, RS_alu_MemRead, RS_alu_MemWrite, RS_alu_ALUSrc1, RS_alu_ALUSrc2, RS_alu_Jump, RS_alu_Branch;
    (* keep = "true" *)wire [3:0] RS_alu_ALUOP;
    (* keep = "true" *)wire [7:0] RS_alu_Rd, RS_alu_operand1, RS_alu_operand2;
    (* keep = "true" *)wire [1:0] RS_alu_valid;
    (* keep = "true" *)wire [31:0] RS_alu_immediate;
    (* keep = "true" *)wire RS_alu_start;

    (* keep = "true" *)wire [31:0] RS_mul_operand1_data, RS_mul_operand2_data, RS_mul_inst_num;
    (* keep = "true" *)wire [2:0] RS_mul_funct3;
    (* keep = "true" *)wire RS_mul_MemToReg, RS_mul_MemRead, RS_mul_MemWrite, RS_mul_ALUSrc1, RS_mul_ALUSrc2, RS_mul_Jump, RS_mul_Branch;
    (* keep = "true" *)wire [3:0] RS_mul_ALUOP;
    (* keep = "true" *)wire [7:0] RS_mul_Rd, RS_mul_operand1, RS_mul_operand2;
    (* keep = "true" *)wire [1:0] RS_mul_valid;
    (* keep = "true" *)wire [31:0] RS_mul_immediate;
    (* keep = "true" *)wire RS_mul_start;

    (* keep = "true" *)wire [31:0] RS_div_operand1_data, RS_div_operand2_data, RS_div_inst_num;
    (* keep = "true" *)wire [2:0] RS_div_funct3;
    (* keep = "true" *)wire RS_div_MemToReg, RS_div_MenRead, RS_div_MemWrite, RS_div_ALUSrc1, RS_div_ALUSrc2, RS_div_Jump, RS_div_Branch;
    (* keep = "true" *)wire [3:0] RS_div_ALUOP;
    (* keep = "true" *)wire [7:0] RS_div_Rd, RS_div_operand1, RS_div_operand2;
    (* keep = "true" *)wire [1:0] RS_div_valid;
    (* keep = "true" *)wire [31:0] RS_div_immediate;
   (* keep = "true" *) wire RS_div_start;
   
    (* keep = "true" *)wire LS_MemToReg_out;
    (* keep = "true" *)wire LS_MemRead_out;
    (* keep = "true" *)wire LS_MemWrite_out;
    (* keep = "true" *)wire [3:0] LS_ALUOP_out;
    (* keep = "true" *)wire LS_ALUSrc2_out;
    (* keep = "true" *)wire [7:0] LS_phy_reg_out;
    (* keep = "true" *)wire LS_on_out;
    (* keep = "true" *)wire [7:0] LS_Operand1_phy_out;
    (* keep = "true" *)wire [7:0] LS_Operand2_phy_out;
    (* keep = "true" *)wire [1:0] LS_valid_out;
    (* keep = "true" *)wire [31:0] LS_immediate_out;
    (* keep = "true" *)wire [31:0] LS_inst_num_out;
    (* keep = "true" *)wire [2:0] LS_func3_out;

	(* keep = "true" *) wire [31:0] CSR_data;
       (* keep = "true" *) wire csr_on;
       (* keep = "true" *) wire [7:0] CSR_operand1;
       (* keep = "true" *) wire [3:0] CSR_aluop;
       (* keep = "true" *) wire [7:0] CSR_rd_phy;
       (* keep = "true" *) wire [1:0] CSR_valid;
       (* keep = "true" *) wire [31:0] CSR_instnum;
       (* keep = "true" *) wire [31:0] CSR_immediate;
       (* keep = "true" *) wire CSR_ALUSrc2;
       (* keep = "true" *) wire [11:0] CSR_addr;

  
  /// RS_BR
 (* keep = "true" *) wire RS_br_Jump;
 (* keep = "true" *) wire RS_br_Branch;
 (* keep = "true" *) wire RS_br_IF_ID_hit;
 (* keep = "true" *) wire RS_br_IF_ID_taken;
 (* keep = "true" *) wire [2:0] RS_br_func3;
  (* keep = "true" *)wire [7:0]br_rd_phy_reg;
  (* keep = "true" *)wire RS_br_start;
  (* keep = "true" *)wire [31:0] RS_br_operand1;
  (* keep = "true" *)wire [31:0] RS_br_operand2;
 (* keep = "true" *) wire [7:0] RS_br_operand1_phy;
  (* keep = "true" *)wire [7:0] RS_br_operand2_phy;
 (* keep = "true" *) wire [7:0] RS_br_phy_reg;
 (* keep = "true" *) wire [1:0] RS_br_valid;
 (* keep = "true" *) wire [31:0] RS_br_immediate;
 (* keep = "true" *) wire [31:0] RS_br_inst_num;
 (* keep = "true" *) wire [31:0] RS_br_PC;
  
 (* keep = "true" *) wire RS_BR_Branch,RS_BR_Jump;
 (* keep = "true" *) wire RS_BR_hit;
 (* keep = "true" *) wire [7:0] BR_Phy;
 (* keep = "true" *) wire RS_BR_taken;
 (* keep = "true" *) wire [31:0] RS_BR_inst_num_output;
 (* keep = "true" *) wire [2:0] RS_BR_funct3;
 (* keep = "true" *) wire [31:0] immediate_BR;


  (* keep = "true" *)wire [31:0] PC_BR;
 (* keep = "true" *) wire BR_Done;
  assign BR_Done= RS_BR_Branch|RS_BR_Jump;

  (* keep = "true" *)wire [31:0]PC_Return;

    (* keep = "true" *) wire [7:0] Operand1_BR_phy;
    (* keep = "true" *) wire [7:0] Operand2_BR_phy;
    
    (* keep = "true" *)wire [31:0] pass_pc;
    (* keep = "true" *)wire [3:0] pass_ALUOP;
   (* keep = "true" *) wire pass_ALUSrc1;
    (* keep = "true" *)wire pass_ALUSrc2;
    (* keep = "true" *)wire [7:0] pass_rd_phy_reg;
    (* keep = "true" *)wire pass_rs_on;
    (* keep = "true" *)wire [31:0] pass_Operand1;
    (* keep = "true" *)wire [31:0] pass_Operand2;
    (* keep = "true" *)wire [31:0] pass_immediate;
    (* keep = "true" *)wire [31:0] pass_inst_num;


//PassBuffer wire

  
    (* keep = "true" *)wire [31:0] P_Data;

            // rs_alu_wire

(* keep = "true" *)wire [129:0] result_out_csr;
(* keep = "true" *)wire [31:0] CSR_imm = result_out_csr[31:0];
(* keep = "true" *)wire [11:0] RS_CSR_Address = result_out_csr[43:32];
(* keep = "true" *)wire [31:0] CSR_Data = result_out_csr [75:44];
(* keep = "true" *)wire CSR_src2 = result_out_csr [76];
(* keep = "true" *)wire [3:0] CSR_op = result_out_csr [80:77];
(* keep = "true" *)wire [7:0] CSR_Phy = result_out_csr [88:81];
(* keep = "true" *)wire [31:0] CSR_inst_num = result_out_csr [120:89];
(* keep = "true" *)wire [7:0] CSR_operand_phy = result_out_csr [128:121];
(* keep = "true" *)wire CSR_Done = result_out_csr [129];

(* keep = "true" *)wire [31:0] CSR_B;
(* keep = "true" *)wire [31:0] CSR_Result;
 

 
 




  
   
   



  
  
(* keep = "true" *) wire [126:0] result_out_alu;  // result_out_alu?쓽 鍮꾪듃 ?닔瑜? 127濡? 蹂?寃?
(* keep = "true" *) wire RS_alu_IF_ID_taken;
(* keep = "true" *) wire RS_alu_IF_ID_hit;

(* keep = "true" *) wire [31:0] immediate = result_out_alu[31:0];
(* keep = "true" *) wire RS_EX_ALU_Src1 = result_out_alu[32];
(* keep = "true" *) wire RS_EX_ALU_Src2 = result_out_alu[33];
(* keep = "true" *) wire [3:0] ALUop = result_out_alu[37:34];
(* keep = "true" *) wire [7:0] ALU_Phy = result_out_alu[45:38];
(* keep = "true" *) wire [31:0] RS_EX_PC_ALU = result_out_alu[77:46];
(* keep = "true" *) wire ALU_Done = result_out_alu[78];
(* keep = "true" *) wire [31:0] RS_EX_inst_num = result_out_alu[110:79];
(* keep = "true" *) wire [7:0] Operand1_ALU_phy = result_out_alu[118:111];
(* keep = "true" *) wire [7:0] Operand2_ALU_phy = result_out_alu[126:119];


    // Internal signals for RS_mul wire
  
   (* keep = "true" *) wire [31:0] RS_mul_PC;
   
   (* keep = "true" *) wire Load_Done;
    (* keep = "true" *)wire [31:0] Load_Data;

   
   
   
   
   
  (* keep = "true" *)  wire [31:0] ALU_Data;

   
   (* keep = "true" *) wire [63:0] MUL_Data;
   (* keep = "true" *) wire [7:0] MUL_Phy;
    (* keep = "true" *)wire [31:0] DIV_Data;
    (* keep = "true" *)wire [7:0] DIV_Phy;
   (* keep = "true" *)wire [56:0]result_out_mul;
   (* keep = "true" *)wire [31:0] RS_EX_inst_num_Mul_out;

(* keep = "true" *)wire [7:0] Operand2_Mul_phy = result_out_mul[7:0];
(* keep = "true" *)wire [7:0] Operand1_Mul_phy = result_out_mul[15:8];
(* keep = "true" *)wire [7:0] RS_EX_Mul_Physical_address_in = result_out_mul[23:16];
(* keep = "true" *)wire [31:0] RS_EX_inst_num_Mul_in = result_out_mul[55:24];
(* keep = "true" *)wire  Mul_start_in= result_out_mul[56];
(* keep = "true" *)wire MUL_Done;




  /////////////////////  //RS_div_wire


    
    (* keep = "true" *)wire [31:0] RS_div_PC;
   
    
    
   
    
  
  
    (* keep = "true" *)wire [60:0]result_out_div;

(* keep = "true" *)wire [7:0] Operand2_Div_phy = result_out_div[7:0];
(* keep = "true" *)wire [7:0] Operand1_Div_phy = result_out_div[15:8];
(* keep = "true" *)wire [3:0] divider_op = result_out_div[19:16];
(* keep = "true" *)wire [7:0] RS_EX_Div_Physical_address_in = result_out_div[27:20];
(* keep = "true" *)wire [31:0] RS_EX_Div_inst_num= result_out_div[59:28];
(* keep = "true" *)wire Div_start_in = result_out_div[60];
(* keep = "true" *) wire [174:0] result_out_pass;



(* keep = "true" *)wire [31:0] P_immediate=result_out_pass[31:0];
(* keep = "true" *)wire P_Src1=result_out_pass[32];
(* keep = "true" *)wire P_Src2=result_out_pass[33];
(* keep = "true" *)wire [3:0] P_ALUop=result_out_pass[37:34];
(* keep = "true" *)wire [7:0] P_Phy=result_out_pass[45:38];
(* keep = "true" *)wire [31:0] P_PC=result_out_pass[77:46];
(* keep = "true" *)wire P_Done=result_out_pass[78];
(* keep = "true" *)wire [31:0] P_inst_num=result_out_pass[110:79];
(* keep = "true" *)wire [31:0] P_Operand1=result_out_pass[142:111];
(* keep = "true" *)wire [31:0] P_Operand2=result_out_pass[174:143];

(* keep = "true" *)wire [31:0] P_ALU_A;
(* keep = "true" *)wire [31:0] P_ALU_B;

//ls reservation


(* keep = "true" *) wire [99:0] result_out_ls;
(* keep = "true" *) wire [7:0] Operand2_LS_phy = result_out_ls[99:92];
(* keep = "true" *) wire [7:0] Operand1_LS_phy = result_out_ls[91:84];
(* keep = "true" *) wire [31:0] LS_inst_num = result_out_ls[83:52];
(* keep = "true" *) wire LS_on = result_out_ls[51];
(* keep = "true" *) wire [7:0] Load_Phy = result_out_ls[50:43];
(* keep = "true" *) wire LS_MemToReg = result_out_ls[42];
(* keep = "true" *) wire LS_MemRead = result_out_ls[41];
(* keep = "true" *) wire LS_MemWrite = result_out_ls[40];
(* keep = "true" *) wire [3:0] LS_ALUOP = result_out_ls[39:36];
(* keep = "true" *) wire RS_LS_Src2 = result_out_ls[35];
(* keep = "true" *) wire [2:0] func3_LS = result_out_ls[34:32];
(* keep = "true" *) wire [31:0] immediate_LS = result_out_ls[31:0];

(* keep = "true" *) wire LS_que_MemWrite;
(* keep = "true" *) wire LS_que_MemRead;
(* keep = "true" *) wire [31:0] LS_que_inst_num;
(* keep = "true" *) wire [7:0] LS_que_phy;
(* keep = "true" *) wire [2:0] LS_que_func3;
(* keep = "true" *) wire [31:0] LS_que_Address;
(* keep = "true" *) wire [31:0] LS_que_WriteData;
(* keep = "true" *) wire LS_que_exception;

(* keep = "true" *) wire exception_ld;
(* keep = "true" *) wire exception_address;
(* keep = "true" *) wire exception_sb;
(* keep = "true" *) wire exception_memforward = exception_ld | exception_sb;
//datamemory
(* keep = "true" *)wire [31:0] Operand1_LS;
(* keep = "true" *)wire [31:0] Operand2_LS;
(* keep = "true" *)wire [31:0] LS_B;
(* keep = "true" *)wire [31:0] LS_Result;
assign LS_Result = Operand1_LS + LS_B;
(* keep = "true" *)wire [31:0] Load_inst_num;

//store buffer wire
(* keep = "true" *) wire [31:0] Sb_data_out;
(* keep = "true" *) wire [7:0] Load_phy_out;

(* keep = "true" *) wire [2:0] Load_data_sel;
(* keep = "true" *) wire [31:0] Store_Address;


	//data memory wire

(* keep = "true" *) wire [31:0] Data_Memory_out;
	

	
    ////////////////ex_mem wire
    //////////

   (* keep = "true" *)wire Predict_Result;
   
   (* keep = "true" *)wire RS_Ex_MemToReg;
   
  
 
  
   
   (* keep = "true" *)wire negaive,overflow,zero,carry;
   (* keep = "true" *)wire [31:0] ALU_A;
   (* keep = "true" *)wire [31:0] ALU_B;
   (* keep = "true" *)wire [31:0] ALUResult;


   (* keep = "true" *)wire ALU_done;
  

 

  
 
   (* keep = "true" *)wire [31:0] RS_EX_PC_Mul_in;
   
   (* keep = "true" *)wire [31:0] RS_EX_PC_Mul_out;
   
   
   
   (* keep = "true" *)wire [31:0] RS_EX_PC_Div_in;
   
   (* keep = "true" *)wire [31:0] RS_EX_PC_Div_out;

   (* keep = "true" *)wire [31:0] RS_EX_Div_inst_num_out;
	
// IF_ID
(* keep = "true" *) wire [11:0] ID_CSR_Address = IF_ID_instOut[31:20];
//IVT ouput
 (* keep = "true" *) wire [31:0] EHR_Address;

//CSR output

 (* keep = "true" *) wire [31:0] CSR_epc;
(* keep = "true" *) wire [31:0] CSR_cause;
(* keep = "true" *) wire [31:0] CSR_out;

//control output
(* keep = "true" *) wire mret;

//logical address ouput
(* keep = "true" *) wire mret_restore;

//ROB output

(* keep = "true" *) wire [31:0] ROB_instnum;
(* keep = "true" *) wire [2:0] ROB_funct3;
(* keep = "true" *) wire [31:0] ROB_memaddress;
(* keep = "true" *) wire  ROB_MemWrite;
(* keep = "true" *) wire [31:0] ROB_exception_pc;
(* keep = "true" *) wire [1:0] ROB_cause;
(* keep = "true" *) wire mret_sig;
(* keep = "true" *) wire exception_sig;

//
	(* keep = "true" *) wire [31:0] Operand1_CSR;
	
       //dd////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   
    (* keep = "true" *)wire [31:0] out_value;
    (* keep = "true" *)wire [4:0] out_dest;
    (* keep = "true" *) wire out_reg_write;
    

    (* keep = "true" *) wire [31:0] Branch_index;
    (* keep = "true" *) wire real_taken;
///////////////////////////IF_ID////////////////////////////////////////////////
(* keep_hierarchy = "yes" *)
global_prediction_top u_global_prediction_top(
    .clk(clk),
    .reset(rst),
    .ID_EX_Branch(RS_BR_Branch),
    .Pcsrc(PCSrc),
    .ID_EX_PC(PC_BR),
    .PC_Branch(PC_Branch),
    .ID_EX_Jump(RS_BR_Jump),
    .ID_EX_hit(RS_BR_hit),
    .real_taken(real_taken),
    .CSR_epc(CSR_epc),
    .EHR_Address(EHR_Address),
    .mret_sig(mret_sig),
    .exception_sig(exception_sig),
    .PC(PC),
    .Wrong(Wrong),
    .hit(hit),    
    .PC_taken(PC_taken)
);

(* keep_hierarchy = "yes" *)
BUFF BUFF(
.clk(clk),
    .rst(rst),
    .PC_taken(PC_taken),
    .real_taken(real_taken)
);

(* keep_hierarchy = "yes" *)
ROB_Counter u_ROB_Counter(
    .clk(clk),
    .rst(rst),
    .inst_num(inst_num)
);

(* keep_hierarchy = "yes" *)
Instruction_memory u_Instruction_memory(
    .pc(PC),
    .reset(rst),
    .instOut(instOut)
);

(* keep_hierarchy = "yes" *)
BB u_BB(
    .clk(clk),                      // Clock signal
    .rst(rst),                      // Reset signal
    .opcode(instOut_opcode),             // Input opcode
    .PCSrc(Predict_Result),                    // Branch decision signal
    .branch_PC(Branch_index),         // Branch index in ROB
    .PC(inst_num),                // Current PC value (expanded to 32 bits)
    .tail_num(save_page),           // Output value
    .Copy_RAT(save_on),                 // Output register destination extracted from instr[11:7]
    .head_num(restore_page),           // Output RegWrite signal to indicate a register write operation
    .Paste_RAT(restore_on),
    .RS_EX_Branch(RS_BR_Branch), 
    .RS_EX_Jump(RS_BR_Jump),
    .exception_sig(exception_sig),
    .mret_sig(mret_sig)
);
    
(* keep_hierarchy = "yes" *)
ifid_pipeline_register u_ifid_pipeline_register(
    .clk(clk),
    .reset(rst),
    .instOut(instOut),
    .PC(PC),
    .taken(real_taken),
    .hit(hit),
    .IF_ID_taken(IF_ID_taken),
    .IF_ID_hit(IF_ID_hit),
    .Predict_Result(Predict_Result),
    .IF_ID_instOut(IF_ID_instOut),  
    .inst_num(inst_num),
    .IF_ID_inst_num(IF_ID_inst_num),
    .IF_ID_PC(IF_ID_PC)
);


(* keep_hierarchy = "yes" *)
sign_extend u_sign_extend(
    .inst(instOut),  // ??읈筌?? 筌뤿굝議??堉? ??뿯??젾
    .clk(clk),          // ?寃???뵭 ??뻿??깈 ??뿯??젾
    .Imm(imm32)  // ??뻿??깈 ??넇??삢?留? 筌앸맩?뻻揶?? ?빊?뮆?젾
);


(* keep_hierarchy = "yes" *)
RAT u_RAT(
    .clk(clk),
    .reset(rst),

    .if_id_flush(Predict_Result),
    .save_state(save_on),    // ?沅쀨퉪? ??쟿筌????뮞?苑??肉? ?湲??源? ????삢 ??뻿??깈
    .restore_state(restore_on), // ?沅쀨퉪? ??쟿筌????뮞?苑??肉??苑? ?湲??源? 癰귣벊?뜚 ??뻿??깈
    .save_page(save_page),     // ?湲??源? ????삢??뒠 ?沅쀨퉪? ??쟿筌????뮞?苑? ??읂??뵠筌?? ?苑??源? ??뻿??깈
    .restore_page(restore_page),  // ?湲??源? 癰귣벊?뜚 ??뻿??깈
    .logical_addr1(Rs1), // ??궎??쓠??삏?諭? 1 ??걠?뵳? 雅뚯눘?꺖
    .logical_addr2(Rs2), // ??궎??쓠??삏?諭? 2 ??걠?뵳? 雅뚯눘?꺖
    .rd_logical_addr(Rd), // ?踰먩묾? ??삂?毓???뱽 ?釉???뮉 ??걠?뵳? 雅뚯눘?꺖 (Rd)
    .free_phy_addr(chuchu_addr),   // ?遊썹뵳?됤봺??뮞??뱜嚥≪뮆??苑? 獄쏆룇? ?뜮袁⑸선??뿳??뮉 ?눧?눖?봺 雅뚯눘?꺖
    .opcode(instOut_opcode),

    .phy_addr_out1(Phy_addr_OP1),   // ??궎??쓠??삏?諭? 1 ?눧?눖?봺 雅뚯눘?꺖 ?빊?뮆?젾
    .phy_addr_out2(Phy_addr_OP2),   // ??궎??쓠??삏?諭? 2 ?눧?눖?봺 雅뚯눘?꺖 ?빊?뮆?젾
    .rd_phy_out(Rd_phy),

    .free_phy_addr_out(original_phy_addr), // ?遊썹뵳?됤봺??뮞??뱜嚥?? ?뜮袁⑸선??뿳??뮉 雅뚯눘?꺖 ??읈??꽊
    .exception_sig(exception_sig),
    .mret_sig(mret_sig)
);


(* keep_hierarchy = "yes" *)
physical_register_file u_physical_register_file(
    .clk(clk),
    .reset(rst),
    .Operand1_phy(Phy_addr_OP1),
    .Operand2_phy(Phy_addr_OP2),
    .Rd_phy(Rd_phy), // 筌뤿굝議??堉???벥 Rd 雅뚯눘?꺖

    .ALU_add_Write(ALU_Done),
    .ALU_load_Write(Load_Done),
    .ALU_mul_Write(MUL_Done),
    .ALU_div_Write(DIV_Done),
    .BR_Write(RS_BR_Jump),
    .Pass_done(P_Done),
    .CSR_done(CSR_Done),
    
    .ALU_add_Data(ALU_Data),
    .ALU_load_Data(Load_Data),
    .ALU_mul_Data(MUL_Data[31:0]),
    .ALU_div_Data(DIV_Data),
    .BR_Data(PC_Return),
    .Pass_done_data(P_Data),
    .CSR_done_data(CSR_Data),
    
    .ALU_add_phy(ALU_Phy),
    .ALU_load_phy(Load_phy_out),
    .ALU_mul_phy(MUL_Phy),
    .ALU_div_phy(DIV_Phy),
    .BR_phy(BR_Phy),
    .Pass_done_phy(P_Phy),
    .CSR_done_phy(CSR_Phy),
    
    .Operand1_data(RData1),
    .Operand2_data(RData2),
    .valid1(Valid1),
    .valid2(Valid2),

    .Operand1_phy_ALU(Operand1_ALU_phy),
    .Operand2_phy_ALU(Operand2_ALU_phy),
    .Operand1_phy_MUL(Operand1_Mul_phy),
    .Operand2_phy_MUL(Operand2_Mul_phy),
    .Operand1_phy_DIV(Operand1_Div_phy),
    .Operand2_phy_DIV(Operand2_Div_phy),
    .Operand1_phy_branch(Operand1_BR_phy),
    .Operand2_phy_branch(Operand2_BR_phy),
    .Operand1_phy_LS(Operand1_LS_phy),
    .Operand2_phy_LS(Operand2_LS_phy),
    .Operand1_phy_CSR(Operand1_phy_CSR),

    .Operand1_data_ALU(Operand1_ALU),
    .Operand2_data_ALU(Operand2_ALU),
    .Operand1_data_MUL(Operand1_Mul),
    .Operand2_data_MUL(Operand2_Mul),
    .Operand1_data_DIV(Operand1_Div),
    .Operand2_data_DIV(Operand2_Div),
    .Operand1_data_branch(Operand1_BR),
    .Operand2_data_branch(Operand2_BR),
    .Operand1_data_LS(Operand1_LS),
	.Operand2_data_LS(Operand2_LS),
	.Operand1_data_CSR(Operand1_CSR),
    .exception(exception_sig),
	.mret_sig(mret_sig),
	        .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .x8(x8), .x9(x9), .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14), .x15(x15),
        .x16(x16), .x17(x17), .x18(x18), .x19(x19), .x20(x20), .x21(x21), .x22(x22), .x23(x23),
        .x24(x24), .x25(x25), .x26(x26), .x27(x27), .x28(x28), .x29(x29), .x30(x30), .x31(x31)
);



(* keep_hierarchy = "yes" *)
chuchu u_chuchu(
    .clk(clk),
    .reset(rst),
    .save_state(save_on),          // ?湲??源? ????삢 ??뻿??깈
    .restore_state(restore_on),       // ?湲??源? 癰귣벊?뜚 ??뻿??깈
    .save_page(save_page),     // ?湲??源? ????삢 ??읂??뵠筌?? ?苑??源? ??뻿??깈
    .restore_page(restore_page),  // ?湲??源? 癰귣벊?뜚 ??읂??뵠筌?? ?苑??源? ??뻿??깈
    .rat_data(original_phy_addr),
    .chuchu_out(chuchu_addr)
);


(* keep_hierarchy = "yes" *)
control_unit_top u_control_unit_top(
    .rst(rst),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .RegWrite(RegWrite),
    .MemToReg(MemToReg),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .RWsel(RWsel),
    .Branch(Branch),
	.Jump(Jump),
	.mret(mret),
	.ID_exception(ID_exception)
);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//RS_EX_decoder top Line
    



(* keep_hierarchy = "yes" *)
   RS_EX_decoder rs_ex_decoder_inst (
        .clk(clk),
        .reset(rst),
        .in_opcode(opcode),
        .in_func3(funct3),
        .in_funct7(funct7),
        .in_pc(IF_ID_PC),
        .inst_num(IF_ID_inst_num),
        .MemToReg(MemToReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUOP(ALUOp),
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        .Jump(Jump),
        .Branch(Branch),
        .rd_phy_reg(Rd_phy),
        .Operand1_phy(Phy_addr_OP1),
        .Operand2_phy(Phy_addr_OP2),
        .valid(Valid),
        .immediate(imm32),
        .Operand1_data(RData1),
        .Operand2_data(RData2),
        
        
        .add_alu_pc(RS_alu_PC),
   
        .out_add_ALUOP(RS_alu_ALUOP),
        .out_add_ALUSrc1(RS_alu_ALUSrc1),
        .out_add_ALUSrc2(RS_alu_ALUSrc2),

        .add_rd_phy_reg(RS_alu_Rd),
        .add_rs_on(RS_alu_start),
        .out_add_Operand1_phy(RS_alu_operand1),
        .out_add_Operand2_phy(RS_alu_operand2),
        .out_add_valid(RS_alu_valid),
        .out_add_immediate(RS_alu_immediate),
        .out_add_inst_num(RS_alu_inst_num),

        .mul_alu_func3(RS_mul_funct3),
        .out_mul_inst_num(RS_mul_inst_num),

        .out_mul_ALUOP(RS_mul_ALUOP),


        .mul_rd_phy_reg(RS_mul_Rd),
        .mul_rs_on(RS_mul_start),
        .out_mul_Operand1_phy(RS_mul_operand1),
        .out_mul_Operand2_phy(RS_mul_operand2),
        .out_mul_valid(RS_mul_valid),
        .out_mul_immediate(RS_mul_immediate),
 
        .div_alu_func3(RS_div_funct3),
        .out_div_inst_num(RS_div_inst_num),

        .out_div_ALUOP(RS_div_ALUOP),


        .div_rd_phy_reg(RS_div_Rd),
        .div_rs_on(RS_div_start),
        .out_div_Operand1_phy(RS_div_operand1),
        .out_div_Operand2_phy(RS_div_operand2),
        .out_div_valid(RS_div_valid),
        .out_div_immediate(RS_div_immediate),
        .IF_ID_taken(IF_ID_taken),
        .IF_ID_hit(IF_ID_hit),
        .RS_br_Jump(RS_br_Jump),
        .RS_br_Branch(RS_br_Branch),
        .RS_br_IF_ID_hit(RS_br_IF_ID_hit),
        .RS_br_IF_ID_taken(RS_br_IF_ID_taken),
        .RS_br_func3(RS_br_func3),
        .br_rd_phy_reg(br_rd_phy_reg),
        .RS_br_start(RS_br_start),

       .RS_br_operand1_phy(RS_br_operand1_phy),
       .RS_br_operand2_phy(RS_br_operand2_phy),
        .RS_br_phy_reg(RS_br_phy_reg),
        .RS_br_valid(RS_br_valid),
        .RS_br_immediate(RS_br_immediate),
        .RS_br_inst_num(RS_br_inst_num),
        .RS_br_PC(RS_br_PC),
        
        .LS_func3(LS_func3_out),
        .LS_MemToReg(LS_MemToReg_out),
        .LS_MemRead(LS_MemRead_out),
        .LS_MemWrite(LS_MemWrite_out),
        .LS_ALUOP(LS_ALUOP_out),
        .LS_ALUSrc2(LS_ALUSrc2_out),
        .LS_phy_reg(LS_phy_reg_out),
        .LS_on(LS_on_out),
        .LS_Operand1_phy(LS_Operand1_phy_out),
        .LS_Operand2_phy(LS_Operand2_phy_out),
        .LS_valid(LS_valid_out),
        .LS_immediate(LS_immediate_out),
        .LS_inst_num(LS_inst_num_out),
        
        .pass_pc(pass_pc),
        .pass_ALUOP(pass_ALUOP),
        .pass_ALUSrc1(pass_ALUSrc1),
        .pass_ALUSrc2(pass_ALUSrc2),
        .pass_rd_phy_reg(pass_rd_phy_reg),
        .pass_rs_on(pass_rs_on),
        .pass_Operand1(pass_Operand1),
        .pass_Operand2(pass_Operand2),
        .pass_immediate(pass_immediate),
        .pass_inst_num(pass_inst_num),
        
        .CSR_data(CSR_data),
        .csr_on(csr_on),
        .CSR_operand1(CSR_operand1),
        .CSR_aluop(CSR_aluop),
        .CSR_rd_phy(CSR_rd_phy),
        .CSR_valid(CSR_valid),
        .CSR_instnum(CSR_instnum),
        .CSR_immediate(CSR_immediate),
        .CSR_ALUSrc2(CSR_ALUSrc2),
        .CSR_addr(CSR_addr)

       
        
    );
    
(* keep_hierarchy = "yes" *)
RS_CSR u_RS_CSR(
    .clk(clk),
    .reset(rst),
    .start(csr_on),
    .RS_alu_inst_num(CSR_instnum),
    .Rd(CSR_rd_phy),
    .ALUOP(CSR_aluop),
    .mret_sig(mret_sig),
    .exception_sig(exception_sig),
    .csr_data(CSR_data),
    .EX_MEM_Physical_Address(Load_phy_out),
    .operand1(CSR_operand1),
  
    .valid(CSR_valid),
    .ALU_result_dest(ALU_Phy),
    .ALU_result_valid(ALU_Done),
    .MUL_result_dest(MUL_Phy),
    .MUL_result_valid(MUL_Done),
    .DIV_result_dest(DIV_Phy),
    .DIV_result_valid(DIV_Done),
    .Branch_result_valid(RS_BR_Jump),
    .BR_Phy(BR_Phy),
    .EX_MEM_MemRead(Load_Done),
    .P_Done(P_Done),
    .P_Phy(P_Phy),
    .immediate(CSR_immediate),
    .CSR_addr(CSR_addr),
    .ALUSrc2(CSR_ALUSrc2),

    .CSR_phy(CSR_Phy),
    .CSR_done(CSR_Done),
    .result_out(result_out_csr)
);
 (* keep_hierarchy = "yes" *)
MUX_2input u_CSR_mux(
	.a(Operand1_CSR),
	.b(CSR_imm),
	.sel(CSR_src2),
	.y(CSR_B)
);
(* keep_hierarchy = "yes" *)
 RS_Branch RS_Branch(
.clk(clk),
.reset(rst),
.start(RS_br_start),
.RS_BR_inst_num(RS_br_inst_num),
.PC(RS_br_PC),
.Rd(br_rd_phy_reg),
.Jump(RS_br_Jump),
.Branch(RS_br_Branch),
.funct3(RS_br_func3),
.immediate(RS_br_immediate),
.EX_MEM_MemRead(Load_Done),
.EX_MEM_Physical_Address(Load_phy_out),
.operand1(RS_br_operand1_phy),
.operand2(RS_br_operand2_phy),
.valid(RS_br_valid),
.ALU_result_dest(ALU_Phy),
.ALU_result_valid(ALU_Done),
.MUL_result_dest(MUL_Phy),
.MUL_result_valid(MUL_Done),
.DIV_result_dest(DIV_Phy),
.DIV_result_valid(DIV_Done),
.RS_BR_IF_ID_taken(RS_br_IF_ID_taken),
.RS_BR_IF_ID_hit(RS_br_IF_ID_hit),
.BR_Phy(BR_Phy),
.BR_Done(RS_BR_Jump),
.Predict_Result(Predict_Result),
     .P_Phy(P_Phy),
     .P_Done(P_Done),
.RS_BR_Branch(RS_BR_Branch),
.RS_BR_Jump(RS_BR_Jump),
.RS_BR_Hit(RS_BR_hit),
.RS_BR_taken(RS_BR_taken),
.RS_BR_Phy(BR_Phy),
.RS_BR_inst_num_output(RS_BR_inst_num_output),
.RS_BR_funct3(RS_BR_funct3),
.immediate_BR(immediate_BR),
     .PC_BR(PC_BR),
     .CSR_Done(CSR_Done),
.CSR_Phy(CSR_Phy),
     .Operand1_BR_phy(Operand1_BR_phy),
     .Operand2_BR_phy(Operand2_BR_phy),
     .exception_sig(exception_sig),
    .mret_sig(mret_sig)
);
    (* keep_hierarchy = "yes" *)
    Pass_buffer pass_buffer(
    .clk(clk),
    .reset(rst),
    .start(pass_rs_on),
    .P_inst_num(pass_inst_num),
    .PC(pass_pc),
    .Rd(pass_rd_phy_reg),
    .ALUOP(pass_ALUOP),
    .ALUSrc1(pass_ALUSrc1),
    .ALUSrc2(pass_ALUSrc2),
    .immediate(pass_immediate),
    .operand1(pass_Operand1),
    .operand2(pass_Operand2),
    .result_out(result_out_pass)
    );
    
    

    (* keep_hierarchy = "yes" *)
        RS_ALU rs_alu (
        .clk(clk),
        .reset(rst),
        .start(RS_alu_start),
        .PC(RS_alu_PC),
        .Rd(RS_alu_Rd),
        .RS_alu_inst_num(RS_alu_inst_num),
        .mret_sig(mret_sig),
        .exception_sig(exception_sig),
 
        .ALUOP(RS_alu_ALUOP),
        .ALUSrc1(RS_alu_ALUSrc1),
        .ALUSrc2(RS_alu_ALUSrc2),
    
        .immediate(RS_alu_immediate),
        .EX_MEM_MemRead(Load_Done),
        .EX_MEM_Physical_Address(Load_phy_out),
        .operand1(RS_alu_operand1),
        .operand2(RS_alu_operand2),
        .valid(RS_alu_valid),
        .ALU_result_dest(ALU_Phy),
        .ALU_result_valid(ALU_Done),
        .MUL_result_dest(MUL_Phy),
        .MUL_result_valid(MUL_Done),
        .P_Done(P_Done),
        .DIV_result_dest(DIV_Phy),
        .DIV_result_valid(DIV_Done),
        .Branch_result_valid(RS_BR_Jump),
        .BR_Phy(BR_Phy),
        .P_Phy(P_Phy),
        .CSR_Done(CSR_Done),
        .CSR_Phy(CSR_Phy),
         .result_out(result_out_alu)

    );
    
      (* keep_hierarchy = "yes" *)
        RS_LS rs_ls (
        .clk(clk),
        .reset(rst),
        .start(LS_on_out),
     
        .Rd(LS_phy_reg_out),
        .RS_alu_inst_num(LS_inst_num_out),
        .MemToReg(LS_MemToReg_out),
        .MemRead(LS_MemRead_out),
        .MemWrite(LS_MemWrite_out),
        .ALUOP(LS_ALUOP_out),
        
        .ALUSrc2(LS_ALUSrc2_out),
        .funct3(LS_func3_out),
        .immediate(LS_immediate_out),
        .EX_MEM_MemRead(Load_Done),
        .EX_MEM_Physical_Address(Load_phy_out),
        .operand1(LS_Operand1_phy_out),
        .operand2(LS_Operand2_phy_out),
        .valid(LS_valid_out),
        .ALU_result_dest(ALU_Phy),
        .ALU_result_valid(ALU_Done),
        .MUL_result_dest(MUL_Phy),
        .MUL_result_valid(MUL_Done),
        .DIV_result_dest(DIV_Phy),
        .DIV_result_valid(DIV_Done),
        .Branch_result_valid(RS_BR_Jump),
        .BR_Phy(BR_Phy),
        .P_Done(P_Done),
        .P_Phy(P_Phy),
        .result_out(result_out_ls),
		.exception_sig(exception_sig),
		.CSR_done(CSR_Done),
         .CSR_phy(CSR_Phy),
		.mret_sig(mret_sig)
    );



    

    (* keep_hierarchy = "yes" *)
    RS_Mul rs_mul (
        .clk(clk),
        .reset(rst),
        .RS_mul_start(RS_mul_start),
        .RS_mul_PC(RS_mul_inst_num),
        .RS_mul_Rd(RS_mul_Rd),
        .EX_MEM_MemRead(Load_Done),
        .EX_MEM_Physical_Address(Load_phy_out),
        .RS_mul_operand1(RS_mul_operand1),
        .RS_mul_operand2(RS_mul_operand2),
        .RS_mul_valid(RS_mul_valid),
        .ALU_result_dest(ALU_Phy),
        .ALU_result_valid(ALU_Done),
        .MUL_result_dest(MUL_Phy),
        .MUL_result_valid(MUL_Done),
        .DIV_result_dest(DIV_Phy),
        .DIV_result_valid(DIV_Done),
        .Branch_result_valid(RS_BR_Jump),
        .BR_Phy(BR_Phy),
        .P_Done(P_Done),
        .P_Phy(P_Phy),
        .exception_sig(exception_sig),
        .mret_sig(mret_sig),
        .CSR_done(CSR_Done),
         .CSR_phy(CSR_Phy),
        .result_out(result_out_mul)
    );
 




(* keep_hierarchy = "yes" *)
    RS_Div RS_Div (.clk(clk),.reset(rst),.RS_div_start(RS_div_start),.RS_div_PC(RS_div_inst_num),
                   .RS_div_Rd(RS_div_Rd),.RS_div_ALUOP(RS_div_ALUOP),.EX_MEM_MemRead(Load_Done),
                   .EX_MEM_Physical_Address(Load_phy_out),.RS_div_operand1(RS_div_operand1),
                   .RS_div_operand2(RS_div_operand2),
                   .RS_div_valid(RS_div_valid),
                   .ALU_result_dest(ALU_Phy),.ALU_result_valid(ALU_Done),.MUL_result_dest(MUL_Phy),
                   .MUL_result_valid(MUL_Done),.DIV_result_dest(DIV_Phy),.DIV_result_valid(DIV_Done),
                   .Branch_result_valid(RS_BR_Jump),.BR_Phy(BR_Phy),.P_Done(P_Done),
                    .P_Phy(P_Phy),.CSR_Done(CSR_Done),
                     .CSR_Phy(CSR_Phy),
                   .exception_sig(exception_sig),
                   .mret_sig(mret_sig),
                   .result_out(result_out_div));


(* keep_hierarchy = "yes" *)
  subtractor_32bit subtractor( .A(Operand1_BR),.B(Operand2_BR),.negative(negative),.overflow(overflow),.zero(zero),.carry(carry));

  ////////////ALU
  
     (* keep_hierarchy = "yes" *)
    ALU ALU_pass(.A(P_ALU_A),.B(P_ALU_B),.ALUop(P_ALUop),.Result(P_Data));
    (* keep_hierarchy = "yes" *)
    MUX_2input MUX_pass_A (.a(P_PC),.b(P_Operand1),.sel(P_Src1),.y(P_ALU_A)); 
    (* keep_hierarchy = "yes" *)
    MUX_2input MUX_pass_B (.a(P_Operand2),.b(P_immediate),.sel(P_Src2),.y(P_ALU_B)); 
  (* keep_hierarchy = "yes" *)
    ALU ALU(.A(ALU_A),.B(ALU_B),.ALUop(ALUop),.Result(ALU_Data));
    (* keep_hierarchy = "yes" *)
     BranchUnit branchUnit(.RS_BR_Jump(RS_BR_Jump),.RS_BR_Branch(RS_BR_Branch),.RS_BR_funct3(RS_BR_funct3),.RS_BR_taken(RS_BR_taken),.Predict_Result(Predict_Result),
                         .immediate_BR(immediate_BR),.PC_BR(PC_BR),.ALUNegative(negative),
                         .ALUZero(zero),.ALUOverflow(overflow),.ALUCarry(carry),.PC_Branch(PC_Branch),
                         .branch_index(Branch_index),.PCSrc(PCSrc), .RS_BR_inst_num(RS_BR_inst_num_output),.PC_Return(PC_Return));

    (* keep_hierarchy = "yes" *)
   add4 add4 (.in(PC_BR),.out(PC_Return));
   (* keep_hierarchy = "yes" *)
    MUX_2input MUX_A (.a(RS_EX_PC_ALU),.b(Operand1_ALU),.sel(RS_EX_ALU_Src1),.y(ALU_A)); 
    (* keep_hierarchy = "yes" *)
    MUX_2input MUX_B (.a(Operand2_ALU),.b(immediate),.sel(RS_EX_ALU_Src2),.y(ALU_B)); 
    (* keep_hierarchy = "yes" *)
   multiplier multiplier (.clk(clk),.rst(rst),.start(Mul_start_in),.A(Operand1_Mul),.B(Operand2_Mul),
                          .Physical_address_in(RS_EX_Mul_Physical_address_in),
                          .PC_in(RS_EX_inst_num_Mul_in),.Product(MUL_Data),.done(MUL_Done),.Physical_address_out(MUL_Phy),
                          .PC_out(RS_EX_inst_num_Mul_out));

    (* keep_hierarchy = "yes" *)
    divider divider (.clk(clk),.reset(rst),.start(Div_start_in),.A(Operand1_Div),.B(Operand2_Div),
                     .Physical_address_in(RS_EX_Div_Physical_address_in),
                     .PC_in(RS_EX_Div_inst_num),.Result(DIV_Data),.divider_op_in(divider_op),.done(DIV_Done),
                     .Physical_address_out(DIV_Phy),.PC_out(RS_EX_Div_inst_num_out));

(* keep_hierarchy = "yes" *)
CSR_ALU u_CSR_ALU(
        .A(CSR_Data),
        .B(CSR_B),
        .CSR_ALUop(CSR_op),
        .Result(CSR_Result)
);

////////////////////EX_MEM




    // DataMemory instantiation

 (* keep_hierarchy = "yes" *)
    MUX_2input MUX_LS (.a(Operand2_LS),.b(immediate_LS),.sel(RS_LS_Src2),.y(LS_B)); 


 (* keep_hierarchy = "yes" *)
  Load_buffer Load_buffer (
  .clk(clk),
  .reset(rst),
  .exception_sig(exception_sig),
	  .mret_sig(mret_sig),
  .memwrite(LS_MemWrite),
  .memread(LS_MemRead),
  .inst_num(LS_inst_num),
  .address(LS_Result),
	  .mem_addr_rob(ROB_memaddress),
	  .inst_num_rob(ROB_instnum),
  .Load_exception(exception_ld),
  .address_exception(exception_address)
  );
      // WbMux instantiation
     (* keep_hierarchy = "yes" *)
    store_buffer store_buffer (
        .clk(clk),
        .reset(rst),
        .exception(exception_sig),
	    .mret_sig(mret_sig),
        .memwrite(LS_MemWrite),
        .funct3(func3_LS),
        .memread(LS_MemRead),
        .load_phy(Load_Phy),
 
        .inst_num(LS_inst_num),
        .mem_addr(LS_Result),
        .mem_data(Operand2_LS),
        .memwrite_rob(ROB_MemWrite),
        .mem_addr_rob(ROB_memaddress),
        .inst_num_rob(ROB_instnum),

        .load_data(Sb_data_out),
        .load_phy_out(Load_phy_out),
        .inst_num_out(Load_inst_num),
        .load_valid(Load_data_sel),
       .store_address_out(Store_Address),
       
        .load_done_out(Load_Done),
        .exception_flag(exception_sb)
    );


     (* keep_hierarchy = "yes" *)
    Mem_data_selector Mem_data_selector(
        .load_data_sel(Load_data_sel),
        .store_buffer_data(Sb_data_out),
        .memory_data(Data_Memory_out),
        .load_data(Load_Data)
    );

    



    // ROB instantiation

    (* keep_hierarchy = "yes" *)
    ROB rob (
        .clk(clk),
        .rst(rst),
        .IF_ID_instOut(IF_ID_instOut),
        .reg_write(RegWrite),
        .PC(IF_ID_inst_num),
        .ID_exception(ID_exception),
        .MemWrite(MemWrite),
        .IF_ID_PC(IF_ID_PC),
        .mret_inst(mret),
	    .Address_exception(exception_address),
        .alu_exec_done(ALU_Done),
        .alu_exec_value(ALU_Data),
        .alu_exec_PC(RS_EX_inst_num),

        .mul_exec_done(MUL_Done),
        .mul_exec_value(MUL_Data),
        .mul_exec_PC(RS_EX_inst_num_Mul_out),

	    .div_exception(div_0_exception),
        .div_exec_done(DIV_Done),
        .div_exec_value(DIV_Data),
        .div_exec_PC(RS_EX_Div_inst_num_out),

        .PcSrc(Predict_Result),
        .PC_Return(PC_Return),
        .branch_index(Branch_index),
        .BR_Done(BR_Done),

        .P_Done(P_Done),
        .P_Data(P_Data),
        .P_inst_num(P_inst_num),

	    .LS_exception(exception_memforward),
        .Load_Done(Load_Done),
        .Store_Addr(Store_Address),
        .Load_Data(Load_Data),
        .Load_inst_num(Load_inst_num),

	    .CSR_inst_num(CSR_inst_num),
        .CSR_Done(CSR_Done),
        .CSR_Data(CSR_Data),

        .EPC(ROB_exception_pc),
        .out_value(out_value),
        .out_dest(out_dest),
        .out_reg_write(out_reg_write),
        .out_Addr(ROB_memaddress),
        .out_MemWrite(ROB_MemWrite),
        .exception_sig(exception_sig),
        .mret_sig(mret_sig),
        .exception_cause(ROB_cause),
        .ROB_funct3(ROB_funct3),
        .out_inst_num(ROB_instnum)
    );

        (* keep_hierarchy = "yes" *)
    DataMemory DataMemory(
        .ROB_MemWrite(ROB_MemWrite),
        .ROB_memadress(ROB_memaddress),
        .ROB_funct3(ROB_funct3),
        .clk(clk),
        .reset(reset),
        .func3_LS(func3_LS),
        .LS_result(LS_Result),
        .LS_MemRead(LS_MemRead),
        .Data_memory_out(Data_Memory_out)

    );

(* keep_hierarchy = "yes" *)
IVT u_IVT(
    .rob_cause(ROB_cause),

       .handler_address(EHR_Address)
);

    (* keep_hierarchy = "yes" *)
CSR u_CSR(
        .clk(clk),
        .reset(rst),
        .exception_sig(exception_sig),
        .exception_pc(ROB_exception_pc),
        .exception_cause(ROB_cause),
        .ID_CSR_Address(ID_CSR_Address),

        .CSR_done(CSR_Done),
        .CSR_Result(CSR_Result),
        .RS_CSR_Address(RS_CSR_Address),

        .epc(CSR_epc),
        .cause(CSR_cause),
        .csr_out(CSR_out)
);

    
    // logical_address_register instantiation

    (* keep_hierarchy = "yes" *)
    logical_address_register logical_reg (
        .clk(clk),
        .reset(rst),
        .Reg_write(out_reg_write),
        .logical_address(out_dest),
        .write_data(out_value),
        .exception_sig(exception_sig),
        .mret_sig(mret_sig),

        .mret_restore(mret_restore),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .x6(x6),
        .x7(x7),
        .x8(x8),
        .x9(x9),
        .x10(x10),
        .x11(x11),
        .x12(x12),
        .x13(x13),
        .x14(x14),
        .x15(x15),
        .x16(x16),
        .x17(x17),
        .x18(x18),
        .x19(x19),
        .x20(x20),
        .x21(x21),
        .x22(x22),
        .x23(x23),
        .x24(x24),
        .x25(x25),
        .x26(x26),
        .x27(x27),
        .x28(x28),
        .x29(x29),
        .x30(x30),
        .x31(x31)
    );
endmodule
