all:
	iverilog -o outdp pc.v add.v alu.v aluControl.v control.v dataMemory.v datapath.v immGen.v instructionMem.v mux.v registerMem.v

run:
	vvp outdp

gtk:
	gtkwave dpteste.vcd