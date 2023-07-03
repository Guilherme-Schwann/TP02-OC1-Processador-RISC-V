// Copyright (C) 2022  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.


// Generated by Quartus Prime Version 21.1 (Build Build 850 06/23/2022)
// Created on Fri Jun 16 14:42:15 2023

dataMemory dataMemory_inst
(
	.clock(clock_sig) ,	// input  clock_sig
	.memReadDM(memReadDM_sig) ,	// input  memReadDM_sig
	.memWriteDM(memWriteDM_sig) ,	// input  memWriteDM_sig
	.addressDM(addressDM_sig) ,	// input [31:0] addressDM_sig
	.writeDataDM(writeDataDM_sig) ,	// input [31:0] writeDataDM_sig
	.readDataDM(readDataDM_sig) 	// output [31:0] readDataDM_sig
);

