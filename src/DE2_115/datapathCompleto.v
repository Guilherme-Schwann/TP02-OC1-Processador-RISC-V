module datapath(clockDP, resetDP, pc, readFPGA, regFPGA);
    input clockDP, resetDP;
	 output [31:0] regFPGA, pc;
	 input [4:0] readFPGA;
    wire [31:0] pcInDP, pcOutDP, instructionDP, immGenOutDP, add4OutDP,
     addBranchDP, readData1DP, readData2DP, muxAluOutDP, aluOutDP, readMemDP, writeRegDataDP;
    wire branchDP, memReadDP, memToRegDP, memWriteDP, aluSrcDP, regWriteDP,
     aluZeroDP, andOutDP;
    wire [1:0] aluOpDP;
    wire [3:0] aluCtrlDP;
    wire [3:0] f3f7AluCtrlDP;
	
	 assign pc = pcOutDP;
    assign andOutDP = branchDP & aluZeroDP;
    assign f3f7AluCtrlDP = {instructionDP[30], instructionDP[14:12]};

    pc pcDP(pcInDP, pcOutDP, clockDP, resetDP);
    instructionMemory insMem(clockDP, pcOutDP, instructionDP);
    control ctrlDP(instructionDP[6:0], branchDP, memReadDP, memToRegDP, aluOpDP,
     memWriteDP, aluSrcDP, regWriteDP);
    registerMem regMem(clockDP, regWriteDP, instructionDP[19:15], instructionDP[24:20], readFPGA,
     instructionDP[11:7], writeRegDataDP, readData1DP, readData2DP, regFPGA);
    immGen immGen(instructionDP, immGenOutDP);
    aluControl aluControl(f3f7AluCtrlDP, aluOpDP, aluCtrlDP);
    add add4(32'h4, pcOutDP, add4OutDP);
    add addBranch(pcOutDP, immGenOutDP, addBranchDP);
    alu alu(readData1DP, muxAluOutDP, aluCtrlDP, aluOutDP, aluZeroDP);
    dataMemory dataMem(clockDP, memReadDP, memWriteDP, aluOutDP, readData2DP, readMemDP);
    mux2In muxAdds(add4OutDP, addBranchDP, pcInDP, andOutDP);
    mux2In muxAlu(readData2DP, immGenOutDP, muxAluOutDP, aluSrcDP);
    mux2In muxDataMem(aluOutDP, readMemDP, writeRegDataDP, memToRegDP);
endmodule

module add(a, b, out);
    input[31:0] a, b;
    output[31:0] out;
    assign out = a + b;
endmodule

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

module instructionMemory(clock, readAddress, instruction);
	input clock;
   input [31:0] readAddress;
   output reg [31:0] instruction;
	reg [31:0] memoriaIns [15:0];

	always @(posedge clock)
	begin
		memoriaIns[0] <= 32'b00000000011100000000000100010011;
		memoriaIns[1] <= 32'b00000010000000000000000110010011;
		memoriaIns[2] <= 32'b00000000001100000000001000010011;
		memoriaIns[3] <= 32'b00000000010000011101000110110011;
		memoriaIns[4] <= 32'b00000000001000011010000000100011;
		memoriaIns[5] <= 32'b00000000000000011010000010000011;
		memoriaIns[6] <= 32'b00000000011100001000000010010011;
		memoriaIns[7] <= 32'b00000000011100001000000010010011;
		memoriaIns[8] <= 32'b01000000001000001000000010110011;
		memoriaIns[9] <= 32'b01000000001000001000000010110011;
		memoriaIns[10] <= 32'b00000000001000001000011001100011;
		memoriaIns[11] <= 32'b00000000011100001000000010010011;
		memoriaIns[12] <= 32'b00000000000100000010000000100011;
		memoriaIns[13] <= 32'b00000000000000001100000010110011;
		memoriaIns[14] <= 32'b00000000000100000010000000100011;
		memoriaIns[15] <= 32'b00000000000000000010001010000011;
	end
	
   always @(readAddress)
   begin
       if (readAddress === 32'bx) begin
           instruction = 32'bx;
       end
       else begin
           instruction = memoriaIns[readAddress / 4];
       end
   end
endmodule

module mux2In(input1, input2, out, ctrl);
    input [31:0] input1, input2;
    output [31:0] out;
    input ctrl;

    assign out = (ctrl == 1'b0) ? input1 : input2;
endmodule

module pc(pcIn, pcOut, clock, reset);
    input [31:0] pcIn;
    input clock, reset;
    output [31:0] pcOut;
    reg [31:0] pcOut;
    
    always @(posedge clock)
        if (reset) pcOut <= 32'b0;
        else pcOut <= pcIn;
endmodule


module registerMem(
    clock, reset, regWrite, readReg1, readReg2, readFPGA, writeRegId, writeData,
    readData1, readData2, regFPGA
    );
    input clock, regWrite, reset;
    input [4:0] readReg1, readReg2, writeRegId, readFPGA;
    input [31:0] writeData;
    output reg [31:0] readData1, readData2, regFPGA;
    reg [31:0] registradores [0:31];

    always @(reset) begin
        if (reset) begin
            registradores[0] = 0;
            registradores[1] = 0;
            registradores[2] = 0;
            registradores[3] = 0;
            registradores[4] = 0;
            registradores[5] = 0;
            registradores[6] = 0;
            registradores[7] = 0;
            registradores[8] = 0;
            registradores[9] = 0;
            registradores[10] = 0;
            registradores[11] = 0;
            registradores[12] = 0;
            registradores[13] = 0;
            registradores[15] = 0;
            registradores[16] = 0;
            registradores[17] = 0;
            registradores[18] = 0;
            registradores[19] = 0;
            registradores[20] = 0;
            registradores[21] = 0;
            registradores[22] = 0;
            registradores[23] = 0;
            registradores[24] = 0;
            registradores[25] = 0;
            registradores[26] = 0;
            registradores[27] = 0;
            registradores[28] = 0;
            registradores[29] = 0;
            registradores[30] = 0;
            registradores[31] = 0;
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
	 
	 always @(readFPGA, registradores[readFPGA]) 
    begin
        regFPGA <= registradores[readFPGA];
    end
endmodule

