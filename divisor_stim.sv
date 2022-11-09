program estimulos_divisor #(parameter size = 32) (
    test_if.stimulus bus
);

class Bus;
	randc logic [size-1:0] numerador;
	randc logic [size-1:0] denominador;

	constraint zeroRemainder {numerador % denominador == 0};
	constraint notZeroRemainder {numerador % denominador != 0};

    constraint numeradorPositive {numerador[size-1] == 0}
    constraint numeradorNegative {numerador[size-1] == 1}
    
    constraint denominadorPositive {denominador[size-1] == 0}
    constraint denominadorNegative {denominador[size-1] == 1}
endclass

Bus busInst = new;

initial begin
		init(bus.clk, bus.rst_n, bus.start, bus.numerador, bus.denominador);
        zeroRemainderDivisons(bus.clk, bus.start);
        notZeroRemainderDivisions(bus.clk, bus.start);
        positiveDivision1(bus.clk, bus.start);
        positiveDivision2(bus.clk, bus.start);
        negativeDivision1(bus.clk, bus.start);
        negativeDivision2(bus.clk, bus.start);
end

automatic task init(ref clk, ref rst_n, ref start, ref num, ref den);
    start = 0;
    num = 0;
    den = 0;
    reset(clk,rst_n);
endtask

automatic task reset(ref clk, ref rst_n);
	@(negedge clk)
		rst_n <= 0;
	@(negedge clk)
		rst_n <= 1;
endtask

automatic task divide(ref clk, ref start);
	@(negedge clk)
		start = 1;
	@(negedge clk)
		start = 0;
endtask

automatic task newDivison(ref clk, ref start);
    busInst.randomize(); 
    numerador = busInst.numerador;
	denominador = busInst.denominador;
    divide(clk, start);
endtask

automatic task zeroRemainderDivisions(ref clk, ref start);
    busInst.notZeroRemainder.constraint_mode(1);
    busInst.zeroRemainder.constraint_mode(0);
    repeat(100) begin
        newDivision(clk, start);
    end
endtask

automatic task notZeroRemainderDivisions(ref clk, ref start);
    busInst.notZeroRemainder.constraint_mode(0);
    busInst.zeroRemainder.constraint_mode(1);
    repeat(100) begin
        newDivision(clk, start);
    end
endtask

automatic task positiveDivision1(ref clk, ref start);
    busInst.numeradorPositive.constraint_mode(1);
    busInst.denominadorPositive.constraint_mode(1);
    busInst.numeradorNegative.constraint_mode(0);
    busInst.denominadorNegative.constraint_mode(0);
    repeat(100) begin
       newDivison(clk, start);
    end
endtask

automatic task positiveDivision2(ref clk, ref start);
    busInst.numeradorPositive.constraint_mode(0);
    busInst.denominadorPositive.constraint_mode(0);
    busInst.numeradorNegative.constraint_mode(1);
    busInst.denominadorNegative.constraint_mode(1);
    repeat(100) begin
       newDivison(clk, start);
    end
endtask


automatic task negativeDivision1(ref clk, ref start);
    busInst.numeradorPositive.constraint_mode(1);
    busInst.denominadorPositive.constraint_mode(0);
    busInst.numeradorNegative.constraint_mode(0);
    busInst.denominadorNegative.constraint_mode(1);
    repeat(100) begin
        newDivison(clk, start);
    end
endtask

automatic task negativeDivision2(ref clk, ref start);
    busInst.numeradorPositive.constraint_mode(0);
    busInst.denominadorPositive.constraint_mode(1);
    busInst.numeradorNegative.constraint_mode(1);
    busInst.denominadorNegative.constraint_mode(0);
    repeat(100) begin
        newDivison(clk, start);
    end
endtask

endprogram : denominador_stim