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

	// stimulus
	divisor_stim(
		.clk(CLK),
		.rst_n(RSTn),
		.start(START),
		.numerador(NUMERADOR),
		.denominador(DENOMINADOR)
	);

	//DUV
	Divisor_Algoritmico duv(
		.CLK(CLK),
		.RSTa(RSTn),
		.Start(START),
		.Num(NUMERADOR),
		.Den(DENOMINADOR),
		.Coc(COC),
		.Res(RES),
		.Done(DONE)
	)
endmodule 