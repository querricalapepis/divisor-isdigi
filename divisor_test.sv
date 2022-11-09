localparam size = 32;

`timescale 1ns/1ps

localparam T = 10;
module prueba_denominador();

	logic CLK;
	wire RSTn;
	wire START;
	wire [size-1:0] NUMERADOR;
	wire [size-1:0] DENOMINADOR;

	wire [size-1:0] COC;
	wire [size-1:0] RES;
	wire DONE;

	localparam size = 32;
	
	always begin
    	CLK = 0;
   		#(T/2) CLK = !CLK;
	end

	initial begin
		RSTn = 1;
	end

	test_if bus();

	// stimulus
	estimulos_divisor estim(
		.bus(bus.stimulus)
	);

	//DUV
	Divisor_Algoritmico #(.tamanyo(size)) duv(
		.CLK(bus.duv.clk),
		.RSTa(bus.duv.rst_n),
		.Start(bus.duv.start),
		.Num(bus.duv.numerador),
		.Den(bus.duv.denominador),
		.Coc(bus.duv.conciente),
		.Res(bus.duv.resto),
		.Done(bus.duv.done)
	)

	//Scoreboard
	Scoreboard scoreboard = new(bus.monitor);
	initial begin
		scoreboard.monitor_input;
		scoreboard.monitor_output;
	end
endmodule 