module top (
    input  logic        clk, 
    input  logic        reset,
    output logic [31:0] WriteData, 
    output logic [31:0] DataAdr,
    output logic        MemWrite
);

    logic [31:0] ReadData; 

    riscv rv (
        .clk(clk), 
        .reset(reset), 
        .MemWrite(MemWrite), 
        .Adr(DataAdr), 
        .WriteData(WriteData), 
        .ReadData(ReadData)
    );
	 
    mem memory (
        .clk(clk), 
        .WE(MemWrite), 
        .A(DataAdr), 
        .WD(WriteData), 
        .RD(ReadData)
    );

endmodule