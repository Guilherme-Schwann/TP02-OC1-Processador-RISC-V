// module teste_tb;
//     reg _memReadDM, _memWriteDM;
//     reg _clock;
//     reg [31:0] _addressDM, _writeDataDM;
//     wire [31:0] _readDataDM;
//     dataMemory dm(_clock, _memReadDM, _memWriteDM, _addressDM, _writeDataDM, _readDataDM);

//     initial _clock = 0;
//     always #5 _clock <= !(_clock);
//     initial begin
//         $dumpfile("test.vcd");
//         $dumpvars(2,teste_tb);
//         $dumpvars(0,dm.memoriaDeDados[0]);
//         $dumpvars(0,dm.memoriaDeDados[1]);
//         $dumpvars(0,dm.memoriaDeDados[2]);
//         _memReadDM <= 0; _memWriteDM = 1;
//         _addressDM = 0;
//         _writeDataDM = 32'b1101;
//         #10
//         _addressDM = 4;
//         _writeDataDM = 32'b111;
//         #10 
//         _memReadDM = 1; _memWriteDM = 0; 
//         _addressDM = 0;
//         #10
//         $display("%b", _readDataDM);
//         _addressDM = 4;
//         #10
//         $display("%b", _readDataDM);
//         #200 $finish;
//     end

// endmodule

module dataMemory(clock, memReadDM, memWriteDM, addressDM, writeDataDM, readDataDM);
    input clock, memReadDM, memWriteDM;
    input [31:0] addressDM, writeDataDM;
    output reg [31:0] readDataDM;
    reg [31:0] memoriaDeDados [0:512];

    always @(*)
    begin
        if (memReadDM) readDataDM = memoriaDeDados[addressDM[31:2]];
    end

    always @(negedge clock)
    begin
        if (memWriteDM) memoriaDeDados[addressDM[31:2]] <= writeDataDM;
    end
    
endmodule