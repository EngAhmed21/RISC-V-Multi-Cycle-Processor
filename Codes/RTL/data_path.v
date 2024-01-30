module data_path (
    input clk, rstn,
    input regWrite, PCWrite, AdrSrc, IRWrite,
    input [2:0] immSrc, load,
    input [3:0] aluControl,
    input [1:0] resultSrc, aluSrcA, aluSrcB, store, 
    input [31:0] instr, mem_RD,
    output [31:0] memAddr,
    output reg [31:0] mem_WD,
    output zero
);  
    localparam LW  = 3'b000;    localparam LH = 3'b001;
    localparam LB  = 3'b010;    localparam LHU = 3'b011;
    localparam LBU = 3'b100;    localparam SW  = 2'b00;
    localparam SH  = 2'b01;     localparam SB  = 2'b10;

    // Internal Signals
    wire zero_flag;
    wire [4:0] r_RA1, r_RA2, r_WA;
    wire [31:0] r_RD1_next, r_RD2_next, alu_result, imm_extend, alu_A, alu_B;
    wire [31:0] r_RD1_reg, r_RD2_reg, alu_result_reg;
    reg [31:0] r_WD, PC_reg, PC_old;

    // Register File
    assign r_RA1 = instr[19:15];
    assign r_RA2 = instr[24:20];
    assign r_WA  = instr[11:7];

    always @(*) begin
        if (resultSrc == 2'b00)
            r_WD = alu_result_reg;
        else if (resultSrc == 2'b01)
            if (load == LB)
                r_WD = {{24{mem_RD[7]}}, mem_RD[7:0]};
            else if (load == LH)
                r_WD = {{16{mem_RD[15]}}, mem_RD[15:0]};
            else if (load == LBU)
                r_WD = {24'd0, mem_RD[7:0]};
            else if (load == LHU)
                r_WD = {16'd0, mem_RD[15:0]};
            else
                r_WD = mem_RD;
        else 
            r_WD = alu_result;
    end

    register_file #(.DATA(32), .ADDR(5)) reg_file (.clk(clk), .rstn(rstn), .WE(regWrite), .WD(r_WD),
    .RA1(r_RA1), .RA2(r_RA2), .WA(r_WA), .RD1(r_RD1_next), .RD2(r_RD2_next));

    // Sign Extend
    sign_extend IMM_SIGN_EXTEND (.instr(instr[31:7]), .sel(immSrc), .out(imm_extend));

    // ALU
    D_FF #(.SIZE(32)) r_RD1_FF (.clk(clk), .rstn(rstn), .en(1), .D(r_RD1_next), .Q(r_RD1_reg));
    D_FF #(.SIZE(32)) r_RD2_FF (.clk(clk), .rstn(rstn), .en(1), .D(r_RD2_next), .Q(r_RD2_reg));
    
    mux_4x1 #(.SIZE(32)) ALU_A_mux (.in1(r_RD1_reg), .in2(PC_old), .in3(PC_reg), .in4(32'd0), .sel(aluSrcA), .out(alu_A));
    mux_4x1 #(.SIZE(32)) ALU_B_mux (.in1(r_RD2_reg), .in2(imm_extend), .in3(32'd4), .in4(32'd0), .sel(aluSrcB), .out(alu_B));

    ALU ALU (.A(alu_A), .B(alu_B), .opcode(aluControl), .ALU_out(alu_result), .zero_flag(zero_flag)); 

    D_FF #(.SIZE(32)) ALU_Result_FF (.clk(clk), .rstn(rstn), .en(1), .D(alu_result), .Q(alu_result_reg));

    // PC
    always @(posedge clk, negedge rstn) begin
        if (!rstn) 
            PC_reg <= 1024; // First instruction
        else if (PCWrite)
            PC_reg <= r_WD;
    end
    always @(posedge clk, negedge rstn) begin
        if (!rstn) 
            PC_old <= 1024; // First instruction
        else if (IRWrite)
            PC_old <= PC_reg;
    end

    // OUTPUT
    always @(*) begin
        if (store == SB)
            mem_WD = {{24{r_RD2_reg[7]}}, r_RD2_reg[7:0]};
        else if (store == SH)
            mem_WD = {{16{r_RD2_reg[15]}}, r_RD2_reg[15:0]};
        else
            mem_WD = r_RD2_reg;
    end
    assign memAddr = (AdrSrc) ? r_WD : (PC_reg >> 2);
    assign zero = zero_flag;
endmodule