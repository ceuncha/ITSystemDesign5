module BB(
    input wire clk,                      // Clock signal
    input wire rst,                      // Reset signal
    input wire [6:0] opcode,             // Input opcode
    input wire PCSrc,                    // Branch decision signal
    input wire [31:0] branch_PC,         // Branch index in ROB
    input wire [31:0] PC,                // Current PC value (expanded to 32 bits)
    input wire RS_EX_Branch,            //
    input wire RS_EX_Jump,
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
reg Paste_RAT_set;                    // ?뵆?옒洹? 異붽?

// Reset BB entries
task reset_bb_entries;  //?븳踰? 遺꾧린媛? 吏꾪뻾?릺硫?, ?씠?썑?쓽 遺꾧린 ?젙蹂대뒗 臾댁쓽誘명븯寃? ?릺誘?濡? bb瑜? 鍮꾩썙以??떎.
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
    if (rst) begin          
        reset_bb_entries();
    end else begin
        // Check for jump or branch opcode
        if (opcode == 7'b1100011 || opcode == 7'b1101111 || opcode == 7'b1100111) begin // branch 紐낅졊?뼱媛? inst memory?뿉?꽌 ?굹?삤寃? ?릺硫? 
                                                                                           //counter ?닽?옄?? 
                                                                                           //?럹?씠吏? ?꽆踰꾨?? BB?뿉 ???옣?빐以??떎. 肄붾뱶?뿉?뒗 pc?씪怨? 
                                                                                           // ?쟻???엳吏?留? counter ?닽?옄瑜? ?엯?젰諛쏅뒗?떎.
            BB_entry[tail] <= PC;    // Store the current PC value in ROB at tail position
            ready[tail] <= 1'b0;     // Set ready flag to 0
            tail_num <= tail;        //
            Copy_RAT <= 1;
            tail <= (tail + 1) % 32;        // Increment the tail pointer
        end else begin
            Copy_RAT <= 0;
        end

        // Compare branch_PC with head's PC and check PCSrc
    if (RS_EX_Branch || RS_EX_Jump) begin                   /*branch?뿉?꽌 遺꾧린 紐낅졊?씠 ?닔?뻾?릺硫?, BB濡? 遺꾧린紐낅졊?씠 ?떆?뻾?릺?뿀?떎?뒗 ?떊?샇??  counter number?씠 ?쟾?넚?맂?떎.
                                                            BB?뒗 ?쟻???엳?뜕 Branch ?떊?샇?뱾?쓽 counter ?닽?옄?? branch濡쒕??꽣 ?삩 counter ?닽?옄瑜? ?씠?슜?빐?꽌 ?빐?떦 ?뿏?듃由ъ쓽 ready瑜? 1濡? 蹂?寃쏀빐以??떎,
                                                            留뚯빟 head?뿉 ?쐞移섑븳 紐낅졊?뼱?쓽 遺꾧린?떊?샇媛? ?뱾?뼱?솕?떎硫?, 蹂꾨룄?쓽 ready bit ?꽕?젙 ?뾾?씠 諛붾줈 蹂듦뎄 ?떊?샇瑜? rat?? freelist濡? ?쟾?넚?빐以??떎. */
        if (BB_entry[head] == branch_PC) begin              // head?뿉 ?쐞移섑븳 遺꾧린 ?떊?샇媛? ?뱾?뼱?솕?쓣?븣
            if (PCSrc == 1'b1) begin
                Paste_RAT <= 1;      // Set Paste_RAT to 1
                Paste_RAT_set <= 1;  // ?뵆?옒洹? ?꽕?젙
                head_num <= head;
                reset_bb_entries();  // Reset BB entries
            end else begin
                head <= (head + 1)% 32;    // Increment head
                Paste_RAT <= 0;      // Reset Paste_RAT to 0
                Paste_RAT_set <= 0;  // ?뵆?옒洹? 由ъ뀑
            end
        end
        for (i = 0; i < 32; i = i + 1) begin
            if (BB_entry[i] == branch_PC) begin //head?뿉 ?쐞移섑븯吏? ?븡?? 遺꾧린?떊?샇媛? ?뱾?뼱?솕?쓣?븣
                if (PCSrc == 1'b1) begin
                ready[i] <= 1'b1;   // Set the ready flag to 1
                Paste_RAT <= 1;      // Set Paste_RAT to 1
                Paste_RAT_set <= 1;  // ?뵆?옒洹? ?꽕?젙
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
        if (ready[head] == 1'b1) begin    //head媛? 蹂??븯???쓣?븣 ready bit媛? 1?씠硫?, 蹂듦뎄 ?떊?샇瑜? ?쟾?넚?빐以??떎.

            reset_bb_entries();  // Reset BB entries
        end

        // ?뵆?옒洹몃?? ?솗?씤?븯?뿬 Paste_RAT 由ъ뀑
        if (Paste_RAT_set == 1) begin
            Paste_RAT <= 0;
            Paste_RAT_set <= 0;
        end
    end
end

endmodule
