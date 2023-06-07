// module alu_tb;
//     reg [31:0] aluInput1_, aluInput2_;
//     reg [3:0] aluControlAlu_;
//     wire [31:0] aluResultAlu_;
//     wire zeroAlu_;
//     alu alutb(aluInput1_, aluInput2_, aluControlAlu_, aluResultAlu_, zeroAlu_);

//     initial begin
//         $dumpfile("teste.vcd");
//         $dumpvars(2, alu_tb);
//         #5 aluControlAlu_ <= 4'b0010; aluInput1_ <= 32'hFFFFFFFF; aluInput2_ <= 32'h2;
//         #5 aluControlAlu_ <= 4'b0110; aluInput1_ <= 32'h5; aluInput2_ <= 32'hFFFFFFFF;
//         #5 aluControlAlu_ <= 4'b0011; aluInput1_ <= 32'h0; aluInput2_ <= 32'hFFFFFFFF;
//         #5 aluControlAlu_ <= 4'b0100; aluInput1_ <= 32'hFFFFFFFF; aluInput2_ <= 32'h9;
//         #5 $finish;
//     end
// endmodule

module alu(aluInput1, aluInput2, aluControlAlu, aluResultAlu, zeroAlu);
    input [31:0] aluInput1, aluInput2;
    input [3:0] aluControlAlu;
    output reg [31:0] aluResultAlu;
    output zeroAlu;

    assign zeroAlu = (aluResultAlu == 0) ? 1 : 0;

    always @(*)
    begin
        case (aluControlAlu)
            4'b0010: aluResultAlu <= aluInput1 + aluInput2;// add
            4'b0110: aluResultAlu <= aluInput1 - aluInput2;// sub
            4'b0011: aluResultAlu <= aluInput1 ^ aluInput2;// xor
            4'b0100: aluResultAlu <= aluInput1 >> aluInput2;// srl
            default: aluResultAlu <= 31'bx;
        endcase
    end
endmodule