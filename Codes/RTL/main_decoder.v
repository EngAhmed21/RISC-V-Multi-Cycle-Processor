module main_decoder (
    input clk, rstn,  
    input [6:0] opcode,
    output reg [1:0] aluOP, resultSrc, aluSrcA, aluSrcB,
    output branch, PC_update, IRWrite, AdrSrc, memWrite, regWrite
);
    // opcode of covered instructions
    localparam LOAD_OP    = 7'b0000011;
    localparam STORE_OP   = 7'b0100011;
    localparam R_Type_OP  = 7'b0110011;
    localparam I_Type_OP  = 7'b0010011;
    localparam SB_Type_OP = 7'b1100011;
    localparam JAL_OP     = 7'b1101111;
    localparam LUI_OP     = 7'b0110111;
    localparam AUIPC_OP   = 7'b0010111;
    localparam JALR_OP    = 7'b1100111;

    // States
    localparam FETCH    = 0;      localparam DECODE    = 1;
    localparam MEM_ADR  = 2 ;     localparam MEM_READ  = 3;
    localparam MEM_WB   = 4;      localparam MEM_WRITE = 5;
    localparam EXCUTE_R = 6;      localparam ALU_WB    = 7;
    localparam EXCUTE_L = 8;      localparam JAL       = 9;
    localparam SB_TYPE  = 10;     localparam LUI       = 11;
    localparam AUIPC    = 12;     localparam JALR      = 13;

    reg [3:0] ns, cs;

    // FSM_Decoder

    // Next State Logic
    always @(*) begin
        case (cs)
            FETCH:      ns = DECODE;        
            DECODE: 
                case (opcode)
                    LOAD_OP:    ns = MEM_ADR;        
                    STORE_OP:   ns = MEM_ADR;        
                    R_Type_OP:  ns = EXCUTE_R;        
                    SB_Type_OP: ns = SB_TYPE;        
                    I_Type_OP:  ns = EXCUTE_L;        
                    JAL_OP:     ns = JAL;        
                    LUI_OP:     ns = LUI;        
                    AUIPC_OP:   ns = AUIPC;        
                    JALR_OP:    ns = JALR;        
                    default:    ns = FETCH;
                endcase
            MEM_ADR:    ns = (opcode == LOAD_OP) ? MEM_ADR : MEM_WRITE;
            MEM_READ:   ns = MEM_WB;
            MEM_WB:     ns = FETCH;
            MEM_WRITE:  ns = FETCH;
            EXCUTE_R:   ns = ALU_WB;
            ALU_WB:     ns = FETCH;
            EXCUTE_L:   ns = ALU_WB;
            JAL:        ns = ALU_WB;
            SB_TYPE:    ns = FETCH;
            LUI:        ns = ALU_WB;
            AUIPC:      ns = ALU_WB;
            JALR:       ns = ALU_WB;
            default:    ns = FETCH;
        endcase
    end

    // Current State Logic
    always @(posedge clk, negedge rstn) begin
        if (!rstn)
            cs <= FETCH;
        else
            cs <= ns;
    end

    // Output
    always @(*) begin
        case (cs)
            FETCH: begin
                aluOP   = 2'b00;      resultSrc = 2'b10;
                aluSrcA = 2'b10;      aluSrcB = 2'b10;
            end
            DECODE: begin
                aluOP   = 2'b00;      resultSrc = 2'b00;
                aluSrcA = 2'b01;      aluSrcB = 2'b01;
            end
            MEM_ADR: begin
                aluOP   = 2'b00;      resultSrc = 2'b00;
                aluSrcA = 2'b00;      aluSrcB = 2'b01;
            end
            MEM_READ: begin
                aluOP   = 2'b00;      resultSrc = 2'b00;
                aluSrcA = 2'b10;      aluSrcB = 2'b10;
            end
            MEM_WB: begin
                aluOP   = 2'b00;      resultSrc = 2'b01;
                aluSrcA = 2'b10;      aluSrcB = 2'b10;
            end
            MEM_WRITE: begin
                aluOP   = 2'b00;      resultSrc = 2'b00;
                aluSrcA = 2'b10;      aluSrcB = 2'b10;
            end
            EXCUTE_R: begin
                aluOP   = 2'b10;      resultSrc = 2'b00;
                aluSrcA = 2'b00;      aluSrcB = 2'b00;
            end
            ALU_WB: begin
                aluOP   = 2'b00;      resultSrc = 2'b00;
                aluSrcA = 2'b00;      aluSrcB = 2'b00;
            end
            EXCUTE_L: begin
                aluOP   = 2'b10;      resultSrc = 2'b00;
                aluSrcA = 2'b00;      aluSrcB = 2'b01;
            end
            JAL: begin
                aluOP   = 2'b00;      resultSrc = 2'b00;
                aluSrcA = 2'b01;      aluSrcB = 2'b10;
            end
            SB_TYPE: begin
                aluOP   = 2'b01;      resultSrc = 2'b00;
                aluSrcA = 2'b00;      aluSrcB = 2'b00;
            end
            LUI: begin
                aluOP   = 2'b00;      resultSrc = 2'b00;
                aluSrcA = 2'b11;      aluSrcB = 2'b01;
            end
            AUIPC: begin
                aluOP   = 2'b00;      resultSrc = 2'b00;
                aluSrcA = 2'b01;      aluSrcB = 2'b01;
            end
            JALR: begin
                aluOP   = 2'b00;      resultSrc = 2'b00;
                aluSrcA = 2'b00;      aluSrcB = 2'b01;
            end
            default: begin
                aluOP   = 2'b00;      resultSrc = 2'b00;
                aluSrcA = 2'b00;      aluSrcB = 2'b00;
            end
        endcase
    end

    assign branch    = (cs == SB_TYPE);
    assign PC_update = ((cs == FETCH) || (cs == JAL) || (cs == JALR));
    assign IRWrite   = (cs == FETCH); 
    assign AdrSrc    = ((cs == MEM_READ) || (cs == MEM_WRITE));
    assign memWrite  = (cs == MEM_WRITE);
    assign regWrite  = ((cs == MEM_WB) || (cs == ALU_WB));
endmodule