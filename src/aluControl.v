// module test_tb;
//     wire [3:0] aluCtrlACtrl_;
//     reg [1:0] aluOpACtrl_;
//     reg [3:0] f3f7ACtrl_;
//     aluControl aluControl(f3f7ACtrl_, aluOpACtrl_, aluCtrlACtrl_);

//     initial begin
//         $dumpfile("test.vcd");
//         $dumpvars(2,test_tb);
//         #5 aluOpACtrl_ <= 2'b00; f3f7ACtrl_ <= 4'b1000;
//         #5 aluOpACtrl_ <= 2'b10; f3f7ACtrl_ <= 4'b1101;
//         #5 aluOpACtrl_ <= 2'b01; f3f7ACtrl_ <= 4'b1000;
//         #5 $finish;
//     end
// endmodule

module aluControl(f3f7ACtrl, aluOpACtrl, aluCtrlACtrl);
    output reg [3:0] aluCtrlACtrl;
    input [1:0] aluOpACtrl;
    input [3:0] f3f7ACtrl;
    wire funct7ACtrl;
    wire [2:0] funct3ACtrl;

    assign funct7ACtrl = f3f7ACtrl[3];
    assign funct3ACtrl = f3f7ACtrl[2:0];

    always @(*)
    begin
        case (aluOpACtrl)
            2'b00: aluCtrlACtrl <= 4'b0010; // 00 - add (addi, lw, sw)
            2'b01: aluCtrlACtrl <= 4'b0110; // 01 - sub (beq)
            2'b10: begin
                case (funct3ACtrl)
                    3'b000: aluCtrlACtrl <= 4'b0110; // sub (sub)
                    3'b100: aluCtrlACtrl <= 4'b0011; // xor (xor)
                    3'b101: aluCtrlACtrl <= 4'b0100; // srl (srl)
                endcase
            end
        endcase
    end
endmodule