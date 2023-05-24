// module teste_tb;
//     reg [31:0] _readAddress;
//     reg [8*25:0] _nomeArquivo;
//     wire [31:0] _instruction;
//     instructionMemory im(_readAddress, _nomeArquivo, _instruction);

//     initial begin
//         _nomeArquivo = "testetxt.txt";
//         _readAddress = 8;
//     end

// endmodule

module instructionMemory(readAddress, nomeArquivo, instruction);
    input [31:0] readAddress;
    input [8*25:0] nomeArquivo;
    output reg [31:0] instruction;

    integer arquivo;
    integer error;
    reg [31:0] linha;

    always @(nomeArquivo)
    begin
        arquivo = $fopen(nomeArquivo, "r");
    end

    always @(readAddress)
    begin
        error = $fseek(arquivo, readAddress*8, 0);
        error = $fscanf(arquivo, "%b", linha);
        if (error != -1) instruction = linha;
        else instruction = 0;
    end
endmodule