module datapath(
    input  logic        clk, reset,
    input  logic [1:0]  ResultSrc,
    input  logic [1:0]  ALUSrcA,
    input  logic [1:0]  ALUSrcB,
    input  logic [2:0]  ALUControl,
    input  logic [1:0]  ImmSrc,
    input  logic        RegWrite,
    input  logic        PCWrite,
    input  logic        AdrSrc,
    input  logic        IRWrite,
    input  logic [31:0] ReadData,
    output logic        Zero,
    output logic [31:0] Instr,
    output logic [31:0] Adr,
    output logic [31:0] WriteData
);

    logic [31:0] PC, OldPC;
    logic [31:0] Data;
    logic [31:0] RD1, RD2;
    logic [31:0] A, B;
    logic [31:0] ImmExt;
    logic [31:0] SrcA, SrcB;
    logic [31:0] ALUResult, ALUOut;
    logic [31:0] Result;

    // 1. PC Enable
    flopenr #(32) pcreg (.clk(clk), .reset(reset), .en(PCWrite), .d(Result), .q(PC));

    // 2. Adress Mux
    mux2 #(32) adrmux (.d0(PC), .d1(Result), .s(AdrSrc), .y(Adr));

    // 3. (Instr) and OldPC Enable
    flopenr #(32) instrreg (.clk(clk), .reset(reset), .en(IRWrite), .d(ReadData), .q(Instr));
    flopenr #(32) oldpcreg (.clk(clk), .reset(reset), .en(IRWrite), .d(PC), .q(OldPC));

    // 4. Data reg
    flopr #(32) datareg (.clk(clk), .reset(reset), .d(ReadData), .q(Data));

    // 5. Register File
    regfile rf (
        .clk(clk), .we3(RegWrite), 
        .a1(Instr[19:15]), .a2(Instr[24:20]), .a3(Instr[11:7]), 
        .wd3(Result), .rd1(RD1), .rd2(RD2)
    );

    // 6. A and B reg
    flopr #(32) areg (.clk(clk), .reset(reset), .d(RD1), .q(A));
    flopr #(32) breg (.clk(clk), .reset(reset), .d(RD2), .q(B));
    
    assign WriteData = B;

    // 7. extend
    extend ext (.instr(Instr[31:7]), .immsrc(ImmSrc), .immext(ImmExt));

    // 8. ALU Mux
    mux3 #(32) srcamux (.d0(PC), .d1(OldPC), .d2(A), .s(ALUSrcA), .y(SrcA));
    mux3 #(32) srcbmux (.d0(B), .d1(ImmExt), .d2(32'd4), .s(ALUSrcB), .y(SrcB));

    // 9. ALU
    alu alu_inst (.a(SrcA), .b(SrcB), .alucontrol(ALUControl), .result(ALUResult), .zero(Zero));

    // 10. ALUOut reg 
    flopr #(32) aluoutreg (.clk(clk), .reset(reset), .d(ALUResult), .q(ALUOut));

    // 11. Result Mux
    mux3 #(32) resultmux (.d0(ALUOut), .d1(Data), .d2(ALUResult), .s(ResultSrc), .y(Result));

endmodule