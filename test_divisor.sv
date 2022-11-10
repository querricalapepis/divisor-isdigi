`timescale 1ns/1ps
localparam T = 10;

localparam SIZE = 32;

`include "interfaces.sv"
`include "Scoreboard.sv"
`include "estimulos_divisor.sv"

module test_divisor();

	logic CLK;
	logic RST_N;
	logic START;
	logic [SIZE-1:0] NUMERADOR;
	logic [SIZE-1:0] DENOMINADOR;

	logic [SIZE-1:0] COC;
	logic [SIZE-1:0] RES;
	logic DONE;
	
	always begin
    	CLK = 0;
   		#(T/2) CLK = !CLK;
	end

	initial begin
		RST_N = 1;
	end

	test_if #(.SIZE(SIZE)) bus(.clk(CLK));

	// stimulus
	estimulos_divisor #(.SIZE(SIZE)) estimulos(
		.bus(bus.stimulus)
	);

	//DUV
	divisor_top #(.tamanyo(SIZE)) duv (
		.bus(bus.duv)
	);

	//Scoreboard
	Scoreboard #(.SIZE(SIZE)) scoreboard;
	initial begin
		scoreboard = new(bus.monitor);
		fork
			scoreboard.monitor_input;
			scoreboard.monitor_output;
		join_none
	end
endmodule 