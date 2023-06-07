// module immGen_tb;
//     reg [31:0] instructionImmGen_;
//     wire [31:0] immediateImmGen_;

//     immGen imG(instructionImmGen_, immediateImmGen_);

//     initial begin
//         $dumpfile("teste.vcd");
//         $dumpvars(2, immGen_tb);
//         instructionImmGen_ <= 32'h03052283;
//         #5 instructionImmGen_ <= 32'h00552023;
//         #5 instructionImmGen_ <= 32'h00552823;
//         #5 instructionImmGen_ <= 32'h80230293;
//         #5 instructionImmGen_ <= 32'b01111111100001001000111111100011;
//         #5 instructionImmGen_ <= 32'b11111111100001001000111111100011;
//         #5 $finish;
//     end
// endmodule

module immGen(instructionImmGen, immediateImmGen);
    input [31:0] instructionImmGen;
    output reg [31:0] immediateImmGen;

    always @(instructionImmGen)
    begin
        case (instructionImmGen[6:0])
            7'b0000011: immediateImmGen <= {{21{instructionImmGen[31]}}, instructionImmGen[30:20]}; // lw - I
            7'b0100011: immediateImmGen <= {{21{instructionImmGen[31]}}, instructionImmGen[30:25], instructionImmGen[11:7]}; // sw - S
            7'b0010011: immediateImmGen <= {{21{instructionImmGen[31]}}, instructionImmGen[30:20]}; // addi - I
            7'b1100011: immediateImmGen <= {{20{instructionImmGen[31]}}, instructionImmGen[7], instructionImmGen[30:25], instructionImmGen[11:8], {1{1'b0}}}; // beq - SB
            default: immediateImmGen <= 32'bx;
        endcase
    end
endmodule