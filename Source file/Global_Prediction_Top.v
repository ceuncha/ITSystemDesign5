module global_prediction_top (
    input wire clk,
    input wire reset,
    input wire ID_EX_Branch,
    input wire Pcsrc,
    input wire [31:0] ID_EX_PC,
    input wire [31:0] PC_Branch, // Corrected the bit width
    input wire ID_EX_Jump,
    input wire ID_EX_hit,
    input wire real_taken,
    input wire CSR_epc,
    input wire EHR_Address,
    input wire mret_sig,
    input wire exception_sig,
    output wire [31:0] PC, // Corrected the bit width
    output wire Wrong,
    output wire first_and_Pcsrc, // New output port
    output wire hit,
    output wire PC_taken
);

// Internal signals
(* keep = "true" *)wire [3:0] branch_history; // Corrected the bit width
(* keep = "true" *)wire taken;
(* keep = "true" *)wire PC_taken;
(* keep = "true" *)wire hit;
(* keep = "true" *)wire first; // Internal signal
(* keep = "true" *)wire [31:0] PC_Target; // Corrected the bit width
(* keep = "true" *)wire [31:0] PC_reverse; // Corrected the bit width
(* keep = "true" *)wire Mux_1_sel;
(* keep = "true" *)wire [31:0] Mux_1_out; // Corrected the bit width
(* keep = "true" *)wire [31:0] Mux_2_out; // Corrected the bit width
(* keep = "true" *)wire [31:0] PC_final_next; // Corrected the bit width
(* keep = "true" *)wire [31:0] PC_real_final; // Corrected the bit width
(* keep = "true" *)wire or_gate_out;

// Instantiate the global_branch_history module
(* keep_hierarchy = "yes" *)
Global_History_Register gbh_inst (
    .clk(clk),
    .reset(reset),
    .ID_EX_Branch(ID_EX_Branch),
    .Pcsrc(Pcsrc),
    .branch_history(branch_history)
);

// Instantiate the pattern_history_table module
(* keep_hierarchy = "yes" *)
Pattern_History_Table pht_inst (
    .clk(clk),
    .reset(reset),
    .ID_EX_Branch(ID_EX_Branch),
    .Pcsrc(Pcsrc),
    .gbh(branch_history),
    .taken(taken)
);

// Instantiate the branch_target_buffer module
(* keep_hierarchy = "yes" *)
Branch_Target_Buffer btb_inst (
    .clk(clk),
    .reset(reset),
    .ID_EX_Branch(ID_EX_Branch),
    .ID_EX_PC(ID_EX_PC),
    .Pcsrc(Pcsrc),
    .PC_Branch(PC_Branch),
    .PC(PC), // Connect PC from Program_Counter
    .PC_Target(PC_Target),

    .hit(hit)
);

// Instantiate the branch_correction_buffer module
(* keep_hierarchy = "yes" *)
branch_correction_buffer bcb_inst (
    .clk(clk),
    .reset(reset),
    .hit(hit),
    .PC(PC),
    .PC_Target(PC_Target),
    .taken(real_taken),
    .ID_EX_PC(ID_EX_PC),
    .ID_EX_Branch(ID_EX_Branch),
    .Pcsrc(Pcsrc),
    .PC_reverse(PC_reverse),
    .Wrong(Wrong)
);

// AND gate to generate Mux_1_sel
assign Mux_1_sel = taken && hit;

// Instantiate the Program_Counter module
(* keep_hierarchy = "yes" *)
Program_Counter pc_inst (
    .clk(clk),
    .reset(reset),
    .taken(taken),
    .PC_taken(PC_taken),
    .PC_final_next(PC_final_next),
    .PC(PC)
);

// Mux_1 to select between PC+4 and PC_Target

(* keep = "true" *)assign Mux_1_out = Mux_1_sel ? PC_Target : (PC + 32'd4);

// Output the AND of first and Pcsrc

(* keep = "true" *)assign first_and_Pcsrc = (!ID_EX_hit) && Pcsrc;

// Mux_2 to select between Mux_1_out and PC_reverse

(* keep = "true" *)assign Mux_2_out = Wrong ? PC_reverse : Mux_1_out;

// OR gate for ID_EX_Jump and first_and_Pcsrc

(* keep = "true" *)assign or_gate_out = ID_EX_Jump || first_and_Pcsrc;

// Mux_3 to select between Mux_2_out and PC_Branch

(* keep = "true" *)assign PC_final_next = or_gate_out ? PC_Branch : Mux_2_out;

 (* keep = "true" *)assign PC_real_final = (mret_sig == 1'b0 && exception_sig == 1'b0) ? PC_final_next :
                                           (mret_sig == 1'b1 && exception_sig == 1'b0) ? CSR_EPC :
                                           (mret_sig == 1'b0 && exception_sig == 1'b1) ? EHR_address :
                                            32'b0; // 기본값으로 0을 할당 (다른 모든 경우)
endmodule
