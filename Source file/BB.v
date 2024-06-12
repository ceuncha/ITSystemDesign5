module BB(
    input wire clk,                      // Clock signal
    input wire rst,                      // Reset signal
    input wire [6:0] opcode,             // Input opcode
    input wire PCSrc,                    // Branch decision signal
    input wire [31:0] branch_PC,         // Branch index in ROB
    input wire [31:0] PC,                // Current PC value (expanded to 32 bits)
    input wire RS_EX_Branch,            //
    input wire RS_EX_Jump,
    output reg [2:0] tail_num,           // Output value
    output reg Copy_RAT,                 // Output register destination extracted from instr[11:7]
    output reg [2:0] head_num,           // Output RegWrite signal to indicate a register write operation
    output reg Paste_RAT
);

// ROB memory
reg [31:0] BB_entry [0:7];          
reg ready [0:7];                       // Ready flag array for ROB entries
integer i;
reg [2:0] head;
reg [2:0] tail;
reg Paste_RAT_set;                    // 플래그 추가

// Reset BB entries
task reset_bb_entries;  //한번 분기가 진행되면, 이후의 분기 정보는 무의미하게 되므로 bb를 비워준다.
    begin
        head <= 0;
        tail <= 0;
        for (i = 0; i < 8; i = i + 1) begin
            BB_entry[i] <= 32'b1;     // Reset ROB entry with all fields set to 0
            ready[i] <= 1'b0;         // Reset ready flag
        end
    end
endtask

// BB control logic
always @(posedge clk or posedge rst) begin
    if (rst) begin          
        reset_bb_entries();
    end else begin
        // Check for jump or branch opcode
        if (opcode == 7'b1100011 || opcode == 7'b1101111 || opcode == 7'b1100111) begin // branch 명령어가 inst memory에서 나오게 되면 
                                                                                           //counter 숫자와 
                                                                                           //페이지 넘버를 BB에 저장해준다. 코드에는 pc라고 
                                                                                           // 적혀있지만 counter 숫자를 입력받는다.
            BB_entry[tail] <= PC;    // Store the current PC value in ROB at tail position
            ready[tail] <= 1'b0;     // Set ready flag to 0
            tail_num <= tail;        //
            Copy_RAT <= 1;
            tail <= (tail + 1) % 8;        // Increment the tail pointer
        end else begin
            Copy_RAT <= 0;
        end

        // Compare branch_PC with head's PC and check PCSrc
    if (RS_EX_Branch || RS_EX_Jump) begin                   /*branch에서 분기 명령이 수행되면, BB로 분기명령이 시행되었다는 신호와  counter number이 전송된다.
                                                            BB는 적혀있던 Branch 신호들의 counter 숫자와 branch로부터 온 counter 숫자를 이용해서 해당 엔트리의 ready를 1로 변경해준다,
                                                            만약 head에 위치한 명령어의 분기신호가 들어왔다면, 별도의 ready bit 설정 없이 바로 복구 신호를 rat와 freelist로 전송해준다. */
        if (BB_entry[head] == branch_PC) begin              // head에 위치한 분기 신호가 들어왔을때
            if (PCSrc == 1'b1) begin
                Paste_RAT <= 1;      // Set Paste_RAT to 1
                Paste_RAT_set <= 1;  // 플래그 설정
                head_num <= head;
                reset_bb_entries();  // Reset BB entries
            end else begin
                head <= (head + 1)% 8;    // Increment head
                Paste_RAT <= 0;      // Reset Paste_RAT to 0
                Paste_RAT_set <= 0;  // 플래그 리셋
            end
        end
    end

        for (i = 0; i < 8; i = i + 1) begin
            if (BB_entry[i] == branch_PC) begin //head에 위치하지 않은 분기신호가 들어왔을때
                if (PCSrc == 1'b1) begin
                    ready[i] <= 1'b1;   // Set the ready flag to 1
                end
            end
        end

        // Check if the head is ready
        if (ready[head] == 1'b1) begin    //head가 변하였을때 ready bit가 1이면, 복구 신호를 전송해준다.
            head_num <= head;
            Paste_RAT <= 1;
            Paste_RAT_set <= 1;  // 플래그 설정
            reset_bb_entries();  // Reset BB entries
        end

        // 플래그를 확인하여 Paste_RAT 리셋
        if (Paste_RAT_set == 1) begin
            Paste_RAT <= 0;
            Paste_RAT_set <= 0;
        end
    end
end

endmodule
