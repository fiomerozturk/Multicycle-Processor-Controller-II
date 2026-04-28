module alu(input  logic [31:0] a, b,
           input  logic [ 2:0] alucontrol,
           output logic [31:0] result,
           output logic        zero);
           
    always_comb
        case(alucontrol)
            3'b000: result = a + b;       // Add 
            3'b001: result = a - b;       // Subtract 
            3'b010: result = a & b;       // AND 
            3'b011: result = a | b;       // OR
            3'b101: result = (a < b) ? 32'd1 : 32'd0; // SLT 
            default: result = 32'bx;     
        endcase

    assign zero = (result == 32'b0);    

endmodule