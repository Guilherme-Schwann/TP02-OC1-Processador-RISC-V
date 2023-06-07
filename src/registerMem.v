`timescale 1ns/1ps
// module registerMem_tb;
//     reg _clock, _regWrite;
//     reg [4:0] _readReg1, _readReg2, _writeRegId;
//     reg [31:0] _writeData;
//     wire [31:0] _readData1, _readData2;
//     registerMem rm(_clock, _regWrite, _readReg1, _readReg2, _writeRegId, _writeData, _readData1, _readData2);

//     initial begin 
//         _clock <= 0; _regWrite = 1;
//     end

//     always #1 _clock <=(!_clock);

//     initial begin
//         #10 _regWrite = 1; _writeRegId = 5; _writeData = 50; 
//         #10 _readReg1 = 5; _regWrite = 0;
//         #100 $finish;
//     end
//
// endmodule

module registerMem(
    clock, regWrite, readReg1, readReg2, writeRegId, writeData,
    readData1, readData2
    );
    input clock, regWrite;
    input [4:0] readReg1, readReg2, writeRegId;
    input [31:0] writeData;
    output reg [31:0] readData1, readData2;
    reg [31:0] registradores [0:31];

    integer i;

    initial begin
        for (i = 0; i < 32; i = i +1) begin
            registradores[i] = 0;
        end
    end

    always @(registradores[0]) registradores[0] = 0;

    always @(posedge clock) begin
        if (regWrite == 1) registradores[writeRegId] <= writeData;
    end

    always @(readReg1, registradores[readReg1]) 
    begin
        readData1 <= registradores[readReg1];
    end

    always @(readReg2, registradores[readReg1])
    begin
        readData2 <= registradores[readReg2];
    end

endmodule