module divisor_top (test_if.duv bus);

Divisor_Algoritmico divisor(
        .CLK(bus.clk),
		.RSTa(bus.rst_n),
		.Start(bus.start),
		.Num(bus.numerador),
		.Den(bus.denominador),
		.Coc(bus.cociente),
		.Res(bus.resto),
		.Done(bus.done)
);
endmodule