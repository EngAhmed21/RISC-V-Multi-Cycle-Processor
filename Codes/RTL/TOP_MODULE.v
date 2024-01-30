module TOP_MODULE (
    input clk, rstn, 
    output [31:0] test
);
    // Internal Signals
    wire memWrite, AdrSrc, regWrite, zero, IRWrite, PCWrite;
    wire [2:0] funct3, immSrc, load;
    wire [3:0] ALU_control;
    wire [1:0] OP_f7, resultSrc, aluSrcA, aluSrcB, store;
    wire [31:0] instr, mem_RD, mem_RD_reg, memAddr, mem_WD;
    wire [6:0] opcode;

    // INSTR
    assign opcode  = instr[6:0];
    assign funct3  = instr [14:12];
    assign OP_f7   = {opcode[5], instr[30]};
   
    // Data Path
    data_path DATA_PATH (.clk(clk), .rstn(rstn), .AdrSrc(AdrSrc), .IRWrite(IRWrite), .PCWrite(PCWrite), .resultSrc(resultSrc), 
     .aluSrcA(aluSrcA), .aluSrcB(aluSrcB), .regWrite(regWrite), .aluControl(ALU_control), .immSrc(immSrc), .instr(instr),
     .load(load), .store(store), .mem_RD(mem_RD_reg), .memAddr(memAddr), .mem_WD(mem_WD), .zero(zero));

    // Control Unit
    control_unit CONTROL_UNIT (.clk(clk), .rstn(rstn), .opcode(opcode), .funct3(funct3), .OP_f7(OP_f7), .zero(zero), .AdrSrc(AdrSrc), 
     .IRWrite(IRWrite), .resultSrc(resultSrc), .memWrite(memWrite), .aluSrcA(aluSrcA), .aluSrcB(aluSrcB), .regWrite(regWrite),
     .immSrc(immSrc), .PCWrite(PCWrite), .load(load), .store(store), .ALU_control(ALU_control));

    // Data Memory
    data_mem #(.DATA(32), .ADDR(32), .MEM_DEPTH(512)) DATA_MEM (.clk(clk), .WE(memWrite), .WD(mem_WD), .A(memAddr), .RD(mem_RD), .test(test));
    D_FF #(.SIZE(32)) MEM_RD_FF (.clk(clk), .rstn(rstn), .en(1), .D(mem_RD), .Q(mem_RD_reg));
    D_FF #(.SIZE(32)) INSTR_FF (.clk(clk), .rstn(rstn), .en(IRWrite), .D(mem_RD), .Q(instr));
endmodule