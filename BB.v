module BB(
    input wire clk,                      // Clock signal
    input wire rst,                      // Reset signal
    input wire [6:0] opcode,             // Input opcode
    input wire PCSrc,                    // Branch decision signal
    input wire [31:0] branch_PC,         // Branch index in ROB
    input wire [31:0] PC,                // Current PC value (expanded to 32 bits)
    input wire RS_EX_Branch,            //
    input wire RS_EX_Jump,
    input wire exception_sig,
    input wire mret_sig,
    output reg [4:0] tail_num,           // Output value
    output reg Copy_RAT,                 // Output register destination extracted from instr[11:7]
    output reg [4:0] head_num,           // Output RegWrite signal to indicate a register write operation
    output reg Paste_RAT
);

// ROB memory
reg [31:0] BB_entry [0:31];          
reg ready [0:31];                       // Ready flag array for ROB entries
integer i;
integer j;
reg [4:0] head;
reg [4:0] tail;
reg Paste_RAT_set;                    // ?逾�?�삋域�? �빊遺�?

// Reset BB entries
task reset_bb_entries;  //?釉녘린? �겫袁㏓┛揶�? 筌욊쑵六�?由븝쭖?, ?�뵠?�뜎?�벥 �겫袁㏓┛ ?�젟癰귣��뮉 �눧�똻�벥沃섎챸釉�野�? ?由븃첋?嚥�? bb�몴? �뜮袁⑹뜖餓�??�뼄.
    begin
        head <= 0;
        tail <= 0;
        for (i = 0; i < 32; i = i + 1) begin
            BB_entry[i] <= 32'b0;     // Reset ROB entry with all fields set to 0
            ready[i] <= 1'b0;         // Reset ready flag
        end
    end
endtask

// BB control logic
always @(posedge clk) begin
    if (rst|exception_sig|mret_sig) begin          
        reset_bb_entries();
    end else begin
        // Check for jump or branch opcode
        if (opcode == 7'b1100011 || opcode == 7'b1101111 || opcode == 7'b1100111) begin // branch 筌뤿굝議�?堉긷첎? inst memory?肉�?苑� ?援�?�궎野�? ?由븝쭖? 
                                                                                           //counter ?�떭?�쁽?? 
                                                                                           //?�읂?�뵠筌�? ?苑녻린袁�?? BB?肉� ???�삢?鍮먧빳??�뼄. �굜遺얜굡?肉�?�뮉 pc?�뵬��? 
                                                                                           // ?�읅???�뿳筌�?筌�? counter ?�떭?�쁽�몴? ?�뿯?�젾獄쏆룆�뮉?�뼄.
            BB_entry[tail] <= PC;    // Store the current PC value in ROB at tail position
            ready[tail] <= 1'b0;     // Set ready flag to 0
            tail_num <= tail;        //
            Copy_RAT <= 1;
            tail <= (tail + 1) % 32;        // Increment the tail pointer
        end else begin
            Copy_RAT <= 0;
        end

        // Compare branch_PC with head's PC and check PCSrc
    if (RS_EX_Branch || RS_EX_Jump) begin                   /*branch?肉�?苑� �겫袁㏓┛ 筌뤿굝議�?�뵠 ?�땾?六�?由븝쭖?, BB嚥�? �겫袁㏓┛筌뤿굝議�?�뵠 ?�뻻?六�?由�?肉�?�뼄?�뮉 ?�뻿?�깈??  counter number?�뵠 ?�읈?�꽊?留�?�뼄.
                                                            BB?�뮉 ?�읅???�뿳?�쐲 Branch ?�뻿?�깈?諭�?�벥 counter ?�떭?�쁽?? branch嚥≪뮆??苑� ?�궔 counter ?�떭?�쁽�몴? ?�뵠?�뒠?鍮�?苑� ?鍮�?�뼣 ?肉�?�뱜�뵳�딆벥 ready�몴? 1嚥�? 癰�?野껋�鍮먧빳??�뼄,
                                                            筌띾슣鍮� head?肉� ?�맄燁살꼹釉� 筌뤿굝議�?堉�?�벥 �겫袁㏓┛?�뻿?�깈揶�? ?諭�?堉�?�넅?�뼄筌�?, 癰귢쑬猷�?�벥 ready bit ?苑�?�젟 ?毓�?�뵠 獄쏅뗀以� 癰귣벀�럡 ?�뻿?�깈�몴? rat?? freelist嚥�? ?�읈?�꽊?鍮먧빳??�뼄. */
        if (BB_entry[head] == branch_PC) begin              // head?肉� ?�맄燁살꼹釉� �겫袁㏓┛ ?�뻿?�깈揶�? ?諭�?堉�?�넅?�뱽?釉�
            if (PCSrc == 1'b1) begin
                Paste_RAT <= 1;      // Set Paste_RAT to 1
                Paste_RAT_set <= 1;  // ?逾�?�삋域�? ?苑�?�젟
                head_num <= head;
                reset_bb_entries();  // Reset BB entries
            end else begin
                head <= (head + 1)% 32;    // Increment head
                Paste_RAT <= 0;      // Reset Paste_RAT to 0
                Paste_RAT_set <= 0;  // ?逾�?�삋域�? �뵳�딅��
            end
        end
        for (i = 0; i < 32; i = i + 1) begin
            if (BB_entry[i] == branch_PC) begin //head?肉� ?�맄燁살꼹釉�筌�? ?釉�?? �겫袁㏓┛?�뻿?�깈揶�? ?諭�?堉�?�넅?�뱽?釉�
                if (PCSrc == 1'b1) begin
                ready[i] <= 1'b1;   // Set the ready flag to 1
                Paste_RAT <= 1;      // Set Paste_RAT to 1
                Paste_RAT_set <= 1;  // ?逾�?�삋域�? ?苑�?�젟
                head_num <= i;
                tail <= i;
                    for (j = i; j < 32; j = j + 1) begin
                        BB_entry[j] <= 32'b0;     // Reset ROB entry with all fields set to 0
                        ready[j] <= 1'b0;         // Reset ready flag
                    end

                end
            end
        end

    end



        // Check if the head is ready
        if (ready[head] == 1'b1) begin    //head揶�? 癰�??釉�???�뱽?釉� ready bit揶�? 1?�뵠筌�?, 癰귣벀�럡 ?�뻿?�깈�몴? ?�읈?�꽊?鍮먧빳??�뼄.

            reset_bb_entries();  // Reset BB entries
        end

        // ?逾�?�삋域밸챶?? ?�넇?�뵥?釉�?肉� Paste_RAT �뵳�딅��
        if (Paste_RAT_set == 1) begin
            Paste_RAT <= 0;
            Paste_RAT_set <= 0;
        end
    end
end

endmodule
