`timescale 1ns/1ps

`include "interfaces.sv"
`include "estimulos_divisor.sv"
`include "divisor_segmentado_top.sv"

module test_divisor_no_segmentado();
	localparam T = 10;
	localparam SIZE = 8;

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
		RST_N = 0;
		#(T)
		RST_N = 1;
	end

	test_if #(.SIZE(SIZE)) interfaces(.clk(CLK), .rst_n(RST_N));

	// stimulus
	estimulos_divisor #(.SIZE(SIZE), .DUV_TYPE(1)) estimulos(
		.testar (interfaces.stimulus),
		.monitorizar (interfaces.monitor)
	);

	//DUV
	 divisor_top #(.tamanyo(SIZE)) duv (
	 	.bus(interfaces.duv)
	 );



endmodule
