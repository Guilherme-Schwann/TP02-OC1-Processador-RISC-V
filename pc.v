module pc(pcIn, pcOut, clock, reset);
    input [31:0] pcIn;
    input clock, reset;
    output [31:0] pcOut;
    reg [31:0] pcOut;
    
    always @(posedge clock)
        if (!reset) pcOut <= 0;
        else pcOut <= pcIn;
endmodule