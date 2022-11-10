module divisor_top #(parameter tamanyo = 32) (test_if.duv bus);

Divisor_Algoritmico #(.tamanyo(tamanyo)) divisor(
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