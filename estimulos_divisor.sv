class RandomInputGenerator #(int size = 32);
	randc logic [size-1:0]  numerador;
	randc logic [size-1:0] denominador;

	constraint zeroRemainder {numerador % denominador == 0;}
	constraint notZeroRemainder {numerador % denominador != 0;}

    	constraint numeradorPositive {numerador[size-1] == 0;}
    	constraint numeradorNegative {numerador[size-1] == 1;}
    	
   	constraint denominadorPositive {denominador[size-1] == 0;}
   	constraint denominadorNegative {denominador[size-1] == 1;}

	function new();
	begin
	end
	endfunction
endclass

program estimulos_divisor (
    test_if.stimulus bus
);

RandomInputGenerator #(.size(32)) randomInput;

initial begin
	randomInput = new;
	init(bus.clk, bus.rst_n, bus.start, bus.numerador, bus.denominador);
        zeroRemainderDivisons(bus.clk, bus.start);
        notZeroRemainderDivisions(bus.clk, bus.start);
        positiveDivision1(bus.clk, bus.start);
        positiveDivision2(bus.clk, bus.start);
        negativeDivision1(bus.clk, bus.start);
        negativeDivision2(bus.clk, bus.start);
	$stop;
end

task automatic init(ref clk, ref rst_n, ref start, ref num, ref den);
    start = 0;
    num = 0;
    den = 0;
    reset(clk,rst_n);
endtask

task automatic reset(ref clk, ref rst_n);
	@(negedge clk)
		rst_n = 0;
	@(negedge clk)
		rst_n = 1;
endtask

task automatic divide(ref clk, ref start);
	@(negedge clk)
		start = 1;
	@(negedge clk)
		start = 0;
endtask

task automatic newDivision(ref clk, ref start);
    randomInput.randomize(); 
    bus.numerador = randomInput.numerador;
    bus.denominador = randomInput.denominador;
    divide(clk, start);
endtask

task automatic zeroRemainderDivisions(ref clk, ref start);
    randomInput.notZeroRemainder.constraint_mode(1);
    randomInput.zeroRemainder.constraint_mode(0);
    repeat(100) begin
        newDivision(clk, start);
    end
endtask

task automatic notZeroRemainderDivisions(ref clk, ref start);
    randomInput.notZeroRemainder.constraint_mode(0);
    randomInput.zeroRemainder.constraint_mode(1);
    repeat(100) begin
        newDivision(clk, start);
    end
endtask

task automatic positiveDivision1(ref clk, ref start);
    randomInput.numeradorPositive.constraint_mode(1);
    randomInput.denominadorPositive.constraint_mode(1);
    randomInput.numeradorNegative.constraint_mode(0);
    randomInput.denominadorNegative.constraint_mode(0);
    repeat(100) begin
       newDivision(clk, start);
    end
endtask

task automatic positiveDivision2(ref clk, ref start);
    randomInput.numeradorPositive.constraint_mode(0);
    randomInput.denominadorPositive.constraint_mode(0);
    randomInput.numeradorNegative.constraint_mode(1);
    randomInput.denominadorNegative.constraint_mode(1);
    repeat(100) begin
       newDivision(clk, start);
    end
endtask


task automatic negativeDivision1(ref clk, ref start);
    randomInput.numeradorPositive.constraint_mode(1);
    randomInput.denominadorPositive.constraint_mode(0);
    randomInput.numeradorNegative.constraint_mode(0);
    randomInput.denominadorNegative.constraint_mode(1);
    repeat(100) begin
        newDivision(clk, start);
    end
endtask

task automatic negativeDivision2(ref clk, ref start);
    randomInput.numeradorPositive.constraint_mode(0);
    randomInput.denominadorPositive.constraint_mode(1);
    randomInput.numeradorNegative.constraint_mode(1);
    randomInput.denominadorNegative.constraint_mode(0);
    repeat(100) begin
        newDivision(clk, start);
    end
endtask

endprogram : estimulos_divisor