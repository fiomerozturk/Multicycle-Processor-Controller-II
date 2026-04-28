module controller (
    input  logic       clk, reset,
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic       funct7b5,
    input  logic       zero,
    output logic [1:0] immsrc,
    output logic [1:0] alusrca, alusrcb, resultsrc,
    output logic       adrsrc,
    output logic [2:0] alucontrol,
    output logic       irwrite, pcwrite, regwrite, memwrite
);
    logic [1:0] aluop;
    logic branch, pcupdate;

    // Main FSM 
    mainfsm fsm (clk, reset, op, alusrca, alusrcb, resultsrc, adrsrc, irwrite, pcupdate, regwrite, memwrite, aluop);

    assign branch = (op == 7'b1100011); 

    // ALU Decoder connection
    aludec ad (op[5], funct3, funct7b5, aluop, alucontrol);

    // Instr Decoder connection (for ImmSrc) 
    instrdec id (op, immsrc);

    // PCWrite logic 
    assign pcwrite = pcupdate | (branch & zero);

endmodule