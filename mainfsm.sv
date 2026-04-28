module mainfsm (
    input  logic       clk, reset,
    input  logic [6:0] op,
    output logic [1:0] alusrca, alusrcb, resultsrc,
    output logic       adrsrc, irwrite, pcwrite, regwrite, memwrite,
    output logic [1:0] aluop
);
    
    typedef enum logic [3:0] {
        S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10
    } statetype;

    statetype state, nextstate;

   
    always_ff @(posedge clk or posedge reset)
        if (reset) state <= S0;
        else       state <= nextstate;

   
    always_comb
        case(state)
            S0:  nextstate = S1;
            S1:  case(op)
                    7'b0000011: nextstate = S2; // lw 
                    7'b0100011: nextstate = S2; // sw 
                    7'b0110011: nextstate = S6; // R-type 
                    7'b0010011: nextstate = S8; // I-type ALU 
                    7'b1101111: nextstate = S9; // jal 
                    7'b1100011: nextstate = S10;// beq 
                    default:    nextstate = S0;
                 endcase
            S2:  if (op == 7'b0000011) nextstate = S3; // if lw 
                 else                  nextstate = S5; // if sw 
            S3:  nextstate = S4;
            S6:  nextstate = S7;
            S8:  nextstate = S7;
				S9:  nextstate = S7;
            default: nextstate = S0; // After states S4, S5, S7, S9, S10 turn Fetch
        endcase

    // Output Logic
    always_comb begin
        
        {adrsrc, irwrite, pcwrite, regwrite, memwrite} = 5'b0;
        {alusrca, alusrcb, resultsrc, aluop} = 8'b0;

        case(state)
            S0: begin adrsrc = 0; irwrite = 1; alusrca = 2'b00; alusrcb = 2'b10; aluop = 2'b00; resultsrc = 2'b10; pcwrite = 1; end // Fetch 
            S1: begin alusrca = 2'b01; alusrcb = 2'b01; aluop = 2'b00; end // Decode 
            S2: begin alusrca = 2'b10; alusrcb = 2'b01; aluop = 2'b00; end // MemAdr 
            S3: begin resultsrc = 2'b00; adrsrc = 1; end // MemRead 
            S4: begin resultsrc = 2'b01; regwrite = 1; end // MemWB 
            S5: begin resultsrc = 2'b00; adrsrc = 1; memwrite = 1; end // MemWrite 
            S6: begin alusrca = 2'b10; alusrcb = 2'b00; aluop = 2'b10; end // ExecuteR 
            S7: begin resultsrc = 2'b00; regwrite = 1; end // ALUWB 
            S8: begin alusrca = 2'b10; alusrcb = 2'b01; aluop = 2'b10; end // ExecuteI 
            S9: begin alusrca = 2'b01; alusrcb = 2'b10; aluop = 2'b00; resultsrc = 2'b00; pcwrite = 1; end // JAL 
            S10:begin alusrca = 2'b10; alusrcb = 2'b00; aluop = 2'b01; resultsrc = 2'b00; end 
        endcase
    end
endmodule