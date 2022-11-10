module divisor_top #(.tamanyo(size)) (test_if.duv bus);

Divisor_Algoritmico #(.tamanyo(size)) divisor(
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