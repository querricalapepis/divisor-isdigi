`timescale 1ns/1ps



`include "interfaces.sv"
`include "Scoreboard.sv"
`include "estimulos_divisor.sv"

module test_divisor();
	localparam T = 10;
	localparam SIZE = 32;

	logic CLK;
	logic RST_N;
	logic START;
	logic [SIZE-1:0] NUMERADOR;
	logic [SIZE-1:0] DENOMINADOR;

	logic [SIZE-1:0] COC;
	logic [SIZE-1:0] RES;
	logic DONE;
	
	initial
	begin
		CLK = 0;
		forever  #(T/2) CLK=!CLK;
	end 

	initial begin
		RST_N = 1;
	end

	test_if #(.SIZE(SIZE)) interfaces(.clk(CLK), .rst_n(RST_N));

	// stimulus
	estimulos_divisor #(.SIZE(SIZE)) estimulos(
		.bus(interfaces.stimulus)
	);

	//DUV
	divisor_top #(.tamanyo(SIZE)) duv (
		.bus(interfaces.duv)
	);

	//Scoreboard
	// Scoreboard #(.SIZE(SIZE)) scoreboard;
	// initial begin
	// 	scoreboard = new(bus.monitor);
	// 	fork
	// 		scoreboard.monitor_input();
	// 		scoreboard.monitor_output();
	// 	join_none
	// end
endmodule 