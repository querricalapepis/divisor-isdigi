class RandomInputGenerator #(parameter SIZE = 32);
	randc logic [SIZE-1:0]  numerador;
	randc logic [SIZE-1:0] denominador;

	// constraint zeroRemainder {numerador % denominador == 0;}
	// constraint notZeroRemainder {numerador % denominador != 0;}

    // constraint numeradorPositive {numerador[SIZE-1] == 0;}
    // constraint numeradorNegative {numerador[SIZE-1] == 1;}
    	
   	// constraint denominadorPositive {denominador[SIZE-1] == 0;}
   	// constraint denominadorNegative {denominador[SIZE-1] == 1;}

	function new();
	begin
	end
	endfunction
endclass

program estimulos_divisor #(parameter SIZE = 32) (
    test_if.stimulus bus
);

RandomInputGenerator #(.SIZE(SIZE)) randomInput;

initial begin
	randomInput = new();
	init();
    zeroRemainderDivisions();
    notZeroRemainderDivisions();
    positiveDivision1();
    positiveDivision2();
    negativeDivision1();
    negativeDivision2();
	$stop;
end

task init();
    bus.stimulus_cb.start <= 0;
    bus.stimulus_cb.numerador <= 0;
    bus.stimulus_cb.denominador <= 0;
    reset();
endtask

task reset();
	bus.stimulus_cb.rst_n <= 0;
	@(bus.stimulus_cb) bus.stimulus_cb.rst_n <= 1;
endtask

task divide();
	bus.stimulus_cb.start <= 1;
	@(bus.stimulus_cb) bus.stimulus_cb.start <= 0;
endtask

task newDivision();
    assert(randomInput.randomize()); 
    bus.stimulus_cb.numerador <= randomInput.numerador;
    bus.stimulus_cb.denominador <= randomInput.denominador;
    @(bus.stimulus_cb) divide();
endtask

task zeroRemainderDivisions();
    //randomInput.notZeroRemainder.constraint_mode(0);
    //randomInput.zeroRemainder.constraint_mode(1);
    repeat(100) begin
        newDivision();
    end
endtask

task notZeroRemainderDivisions();
    // randomInput.notZeroRemainder.constraint_mode(1);
    // randomInput.zeroRemainder.constraint_mode(0);
    repeat(100) begin
        newDivision();
    end
endtask

task positiveDivision1();
    // randomInput.numeradorPositive.constraint_mode(1);
    // randomInput.denominadorPositive.constraint_mode(1);
    // randomInput.numeradorNegative.constraint_mode(0);
    // randomInput.denominadorNegative.constraint_mode(0);
    repeat(100) begin
       newDivision();
    end
endtask

task positiveDivision2();
    // randomInput.numeradorPositive.constraint_mode(0);
    // randomInput.denominadorPositive.constraint_mode(0);
    // randomInput.numeradorNegative.constraint_mode(1);
    // randomInput.denominadorNegative.constraint_mode(1);
    repeat(100) begin
       newDivision();
    end
endtask


task negativeDivision1();
    // randomInput.numeradorPositive.constraint_mode(1);
    // randomInput.denominadorPositive.constraint_mode(0);
    // randomInput.numeradorNegative.constraint_mode(0);
    // randomInput.denominadorNegative.constraint_mode(1);
    repeat(100) begin
        newDivision();
    end
endtask

task negativeDivision2();
    // randomInput.numeradorPositive.constraint_mode(0);
    // randomInput.denominadorPositive.constraint_mode(1);
    // randomInput.numeradorNegative.constraint_mode(1);
    // randomInput.denominadorNegative.constraint_mode(0);
    repeat(100) begin
        newDivision();
    end
endtask

endprogram : estimulos_divisor