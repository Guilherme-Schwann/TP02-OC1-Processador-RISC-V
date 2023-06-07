// module teste;
//     wire BranchCtrl_, MemReadCtrl_, MemToRegCtrl_, MemWriteCtrl_, ALUSrcCtrl_, RegWriteCtrl_;
//     wire [1:0] ALUOpCtrl_;
//     reg [6:0] instructionCtrl_;
//     control ctrl(instructionCtrl_, BranchCtrl_, MemReadCtrl_, MemToRegCtrl_, ALUOpCtrl_, MemWriteCtrl_, ALUSrcCtrl_, RegWriteCtrl_);

//     initial begin
//         $dumpfile("test.vcd");
//         $dumpvars(2,teste);
//         #5 instructionCtrl_ <= 7'b0000011;
//         #5 instructionCtrl_ <= 7'b0110011;
//         #5 $finish;
//     end
// endmodule

module control(instructionCtrl, BranchCtrl, MemReadCtrl, MemToRegCtrl,
                ALUOpCtrl, MemWriteCtrl, ALUSrcCtrl, RegWriteCtrl);
    input [6:0] instructionCtrl;
    output BranchCtrl, MemReadCtrl, MemToRegCtrl, MemWriteCtrl, ALUSrcCtrl, RegWriteCtrl;
    output [1:0] ALUOpCtrl;
    reg [7:0] outputCtrl;
    assign {ALUSrcCtrl, MemToRegCtrl, RegWriteCtrl, MemReadCtrl, MemWriteCtrl, BranchCtrl, ALUOpCtrl} = outputCtrl;

    always @(instructionCtrl)
    begin
        case (instructionCtrl)
            7'b0000011: outputCtrl <=  8'b11110000; // lw   - I
            7'b0100011: outputCtrl <=  8'b10001000; // sw   - S
            7'b0110011: outputCtrl <=  8'b00100010; // sub, xor, srl  - R
            7'b0010011: outputCtrl <=  8'b10100000; // addi - I
            7'b1100011: outputCtrl <=  8'b00000101; // beq  - SB
            default: outputCtrl <=  8'bxxxxxxxx;
        endcase
    end
endmodule