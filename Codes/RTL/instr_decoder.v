module instr_decoder (
    input [6:0] opcode,
    output reg [2:0] immSrc
);
    localparam LOAD_OP    = 7'b0000011;
    localparam STORE_OP   = 7'b0100011;
    localparam R_Type_OP  = 7'b0110011;
    localparam I_Type_OP  = 7'b0010011;
    localparam SB_Type_OP = 7'b1100011;
    localparam JAL_OP     = 7'b1101111;
    localparam LUI_OP     = 7'b0110111;
    localparam AUIPC_OP   = 7'b0010111;
    localparam JALR_OP    = 7'b1100111;

    always @(*) begin
        case (opcode)
            LOAD_OP:     immSrc = 3'b000;
            STORE_OP:    immSrc = 3'b001;
            R_Type_OP:   immSrc = 3'b000; // 3'bxxx
            SB_Type_OP:  immSrc = 3'b010;
            I_Type_OP:   immSrc = 3'b000;
            JAL_OP:      immSrc = 3'b011;
            LUI_OP:      immSrc = 3'b100;
            AUIPC_OP:    immSrc = 3'b100;
            JALR_OP:     immSrc = 3'b000;
            default:     immSrc = 3'b000;
        endcase
    end
endmodule