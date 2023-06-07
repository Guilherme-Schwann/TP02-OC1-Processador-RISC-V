module mux2In(input1, input2, out, ctrl);
    input [31:0] input1, input2;
    output [31:0] out;
    input ctrl;

    assign out = (ctrl == 1'b0) ? input1 : input2;
endmodule