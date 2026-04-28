module riscv (
    input  logic        clk, 
    input  logic        reset,
    output logic        MemWrite,
    output logic [31:0] Adr, 
    output logic [31:0] WriteData,
    input  logic [31:0] ReadData
);


    logic [1:0] ResultSrc;
    logic [1:0] ALUSrcA;
    logic [1:0] ALUSrcB;
    logic [2:0] ALUControl;
    logic [1:0] ImmSrc;
    logic       RegWrite;
    logic       PCWrite, AdrSrc, IRWrite;
    logic       Zero;
    logic [31:0] Instr;

    controller c (
        .clk(clk),
        .reset(reset),
        .op(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7b5(Instr[30]),
        .zero(Zero),
        .immsrc(ImmSrc),
        .alusrca(ALUSrcA),
        .alusrcb(ALUSrcB),
        .resultsrc(ResultSrc),
        .adrsrc(AdrSrc),
        .alucontrol(ALUControl),
        .irwrite(IRWrite),
        .pcwrite(PCWrite),
        .regwrite(RegWrite),
        .memwrite(MemWrite)
    );


    datapath dp (
        .clk(clk),
        .reset(reset),
        .ResultSrc(ResultSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .PCWrite(PCWrite),
        .AdrSrc(AdrSrc),
        .IRWrite(IRWrite),
        .ReadData(ReadData),
        .Zero(Zero),
        .Instr(Instr),
        .Adr(Adr),
        .WriteData(WriteData)
    );

endmodule