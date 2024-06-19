
module RAT (
    input wire clk,
    input wire reset,

    input wire save_state,    
    input wire restore_state, 
    input wire [2:0] save_page,     
    input wire [2:0] restore_page,  
    input wire [4:0] logical_addr1, 
    input wire [4:0] logical_addr2, 
    input wire [4:0] rd_logical_addr, 
    input wire [7:0] free_phy_addr,  
    input wire if_id_flush, 

    input wire [6:0] opcode,

    output reg [7:0] phy_addr_out1,   
    output reg [7:0] phy_addr_out2,   
    output reg [7:0] rd_phy_out,


    output reg [7:0] free_phy_addr_out 
);

    
    reg [7:0] phy_addr_table [0:31]; 

    
    wire [7:0] shadow_data_out [0:7][0:31];
    reg [7:0] shadow_data_in [0:7][0:31];
    reg shadow_write_enable [0:7];
    reg [4:0] shadow_addr;

    genvar i, j;
    generate                                                                //branch 경우 해당 매핑정보 저장을 위한 shadow rat 모듈. 
                                                                            // 8개의 페이지가 존재한다.
        for (i = 0; i < 8; i = i + 1) begin : shadow_RAT_reg_array
            for (j = 0; j < 32; j = j + 1) begin : shadow_RAT_regs
                shadow_RAT_register u_shadow_RAT_register (
    
                    .reset(reset),
                    .addr(j[4:0]),  
                    .data_in(shadow_data_in[i][j]),
                    .data_out(shadow_data_out[i][j]),
                    .write_enable(shadow_write_enable[i])
                );
            end
        end
    endgenerate

    integer k;

   
    always @(posedge reset) begin                   //초기값 설정.
        if (reset) begin
            for (k = 0; k < 32; k = k + 1) begin
                phy_addr_table[k] <= k;
            end
            free_phy_addr_out <= 8'b10100001; 
            rd_phy_out <= 8'b11111111; 
            phy_addr_out1 <= 8'b11111110;
            phy_addr_out2 <= 8'b11111110;
        end
    end

    
    always @(posedge save_state) begin          //branch 가 들어오면 BB가 Save_State 신호를 RAT로 전송해주고, 이 신호를 받으면
                                                    // 당시의 매핑정보 shadow rat로 전송. page number은 BB와 RAT가 동기화 되어 있다.

            for (k = 0; k < 32; k = k + 1) begin
                shadow_data_in[save_page][k] <= phy_addr_table[k];
            end
            shadow_write_enable[save_page] <= 1;


    end
    
        always @(negedge save_state) begin      //branch 신호가 들어오지 않는 평소의 상황일때는 shadow register에 저장하지 않음.

            shadow_write_enable[save_page] <= 0;
      

    end
    
        always @(posedge restore_state) begin       // 분기가 실행되면 당시의 매핑정보 복구. BB로부터 해당 브랜치 매핑정보가 들어있는  페이지 넘버와 restore state 신호를 받으면
                                                    // 매핑 정보를 다시 복구해준다.

            for (k = 0; k < 32; k = k + 1) begin
                phy_addr_table[k] <= shadow_data_out[restore_page][k];
            end

    end


    
    always @(posedge clk) begin     // 평소의 상황 rat의 작동
        if(!reset) begin
        if(if_id_flush) begin
                free_phy_addr_out <= free_phy_addr; 
 
        end
        
        if(!if_id_flush) begin
        
       
           
            case (opcode)       
                7'b1100111, 7'b0000011, 7'b0010011: begin  // jalr, load, i-type 의 경우 r1을 이용하지 않기때문에 프리리스트에 존재하지 않는 물리주소인 254번지 값을 적어줌,
                    phy_addr_out1 <= phy_addr_table[logical_addr1];
                    phy_addr_out2 <= 8'b11111110;
                end
                7'b0110111, 7'b0010111, 7'b1101111: begin // lui, auipc, jal 의 경우 r1, r2을 이용하지 않기때문에 프리리스트에 존재하지 않는 물리주소인 255번지 값을 적어줌,
                    phy_addr_out1 <= 8'b11111110;
                    phy_addr_out2 <= 8'b11111110;
                end
                default: begin
                    phy_addr_out1 <= phy_addr_table[logical_addr1];     // 평소의 명령어의 경우 rat에 매핑되어 있는 물리주소 값을 전송
                    phy_addr_out2 <= phy_addr_table[logical_addr2];
                end
            endcase

            // 2. Rd 
            if ((opcode != 7'b1100011) && (opcode != 7'b0100011)&&(rd_phy_out!=0)) begin  //  조건분기 명령어, store 명령어가 모두 아닌경우에는 rd에 해당되는 번지수의 매핑정보를 변환. 프리리스트로부터 온 물리주소 값으로 변환해준다.
                
                free_phy_addr_out <= phy_addr_table[rd_logical_addr]; 
                phy_addr_table[rd_logical_addr] <= free_phy_addr; 
                rd_phy_out <= free_phy_addr;
   
            end else begin              // beq, store need no Rd. 그러므로 매핑정보 변환하지 않고 그대로 유지. 프리리스트로부터 온 물리주소는 그대로 프리리스트로 다시 반환.
                free_phy_addr_out <= free_phy_addr; 
                rd_phy_out <= 8'b11111111;   
            end
        end
        end
end

endmodule

module shadow_RAT_register(         //branch 시에 이용하는 shadow register code. rat로부터 write enable 신호가 들어오면 페이지에 매핑 정보를 백업시켜주고, 
                                    // 페이지 넘버를 받아서 복구가 필요할때는 rat로 정보를 전송해 복구해준다.

    input wire reset,
    input wire [4:0] addr,    
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire write_enable
);
    reg [7:0] registers [0:31];  
    integer l;
    
    always @(posedge reset) begin
        if (reset) begin
            for (l = 0; l < 32; l = l + 1) begin
                registers[l] <= 8'b0;
            end

    end
end

    always @(posedge write_enable) begin
        registers[addr] <= data_in;
    end

    always @(*) begin
        data_out = registers[addr];

    end
endmodule
