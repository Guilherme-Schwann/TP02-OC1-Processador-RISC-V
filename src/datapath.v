`timescale 1ns/1ps

module datapath_tb;
    reg clockDP_, resetDP_;
    reg [8*25:0] nomeArquivoInstDP_;
    integer error;
    integer i;
    reg signed [31:0] valorReg;
    wire endFile;

    datapathR5 dpR5(clockDP_, resetDP_, nomeArquivoInstDP_, endFile);

    initial begin
        nomeArquivoInstDP_ = "inputDP2.txt";
        $dumpfile("dpteste.vcd");
        $dumpvars(3, datapath_tb);
    end

    initial clockDP_ <= 0;
    always #1 clockDP_ <=(!clockDP_);

    always #1 begin
        if (endFile) begin
            for (i = 0; i < 32; i = i + 1) begin
                valorReg = dpR5.regMem.registradores[i];
                if (valorReg[31])
                    $display("Register [%2d]: %15d (decimal)| %b (binario)", i, valorReg, valorReg);
                else
                    $display("Register [%2d]: %15d (decimal)| %b (binario)", i, valorReg, valorReg);
            end
            $finish;
        end
    end

    initial begin
        resetDP_ <= 0;
        #5 resetDP_ <= 1;
        #100 resetDP_ <= 0;
    end

endmodule

module datapathR5(clockDP, resetDP, nomeArquivoDP, endFile);
    input [8*25:0] nomeArquivoDP;
    input clockDP, resetDP;

    wire [31:0] pcInDP, pcOutDP, instructionDP, immGenOutDP, add4OutDP,
     addBranchDP, readData1DP, readData2DP, muxAluOutDP, aluOutDP, readMemDP, writeRegDataDP;
    wire branchDP, memReadDP, memToRegDP, memWriteDP, aluSrcDP, regWriteDP,
     aluZeroDP, andOutDP;
    wire [1:0] aluOpDP;
    wire [3:0] aluCtrlDP;
    wire [3:0] f3f7AluCtrlDP;
    output endFile;

    assign andOutDP = branchDP & aluZeroDP;
    assign f3f7AluCtrlDP = {instructionDP[30], instructionDP[14:12]};

    pc pcDP(pcInDP, pcOutDP, clockDP, resetDP);
    instructionMemory insMem(pcOutDP, nomeArquivoDP, instructionDP, endFile); // 
    control ctrlDP(instructionDP[6:0], branchDP, memReadDP, memToRegDP, aluOpDP,
     memWriteDP, aluSrcDP, regWriteDP);
    registerMem regMem(clockDP, regWriteDP, instructionDP[19:15], instructionDP[24:20],
     instructionDP[11:7], writeRegDataDP, readData1DP, readData2DP); //
    immGen immGen(instructionDP, immGenOutDP); //
    aluControl aluControl(f3f7AluCtrlDP, aluOpDP, aluCtrlDP); //
    add add4(32'h4, pcOutDP, add4OutDP);
    add addBranch(pcOutDP, immGenOutDP, addBranchDP);
    alu alu(readData1DP, muxAluOutDP, aluCtrlDP, aluOutDP, aluZeroDP);
    dataMemory dataMem(clockDP, memReadDP, memWriteDP, aluOutDP, readData2DP, readMemDP);
    mux2In muxAdds(add4OutDP, addBranchDP, pcInDP, andOutDP);
    mux2In muxAlu(readData2DP, immGenOutDP, muxAluOutDP, aluSrcDP);
    mux2In muxDataMem(aluOutDP, readMemDP, writeRegDataDP, memToRegDP);

endmodule