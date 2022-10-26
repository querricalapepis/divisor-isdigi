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
	
	initial begin
    CLK = 0;
    forever #(T/2) CLK = !CLK;
	end

	test_if bus();

	// stimulus
	divisor_stim(
		.bus(bus.stimulus)
	);

	//DUV
	Divisor_Algoritmico #(.tamanyo(32)) duv(
		.CLK(bus.duv.clk),
		.RSTa(bus.duv.rst_n),
		.Start(bus.duv.start),
		.Num(bus.duv.numerador),
		.Den(bus.duv.denominador),
		.Coc(bus.duv.conciente),
		.Res(bus.duv.resto),
		.Done(bus.duv.done)
	)
endmodule 