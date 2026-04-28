module mem (
    input  logic        clk, WE,
    input  logic [31:0] A, WD,
    output logic [31:0] RD
);
    logic [31:0] RAM[63:0]; 

    initial begin
        $readmemh("C:/lab3/code/memfile.txt", RAM);
    end

    assign RD = RAM[A[31:2]]; 

    always_ff @(posedge clk) begin
        if (WE) RAM[A[31:2]] <= WD;
    end
endmodule