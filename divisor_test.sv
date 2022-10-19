localparam size = 32;

`timescale 1ns/1ps

localparam T = 10;
module prueba_denominador();

	logic CLK;
	wire RSTn;
	wire START;
	wire [size-1:0] numerador;
	wire [size-1:0] denominador;

	wire [size-1:0] COC;
	wire [size-1:0] RES;
	wire DONE;
	
	initial begin
    CLK = 0;
    forever #(T/2) CLK = !CLK;
	end

	// stimulus
	denominador_stim(CLK,START,RSTn,DIVIDEN,denominador);

	//DUV
	
endmodule 