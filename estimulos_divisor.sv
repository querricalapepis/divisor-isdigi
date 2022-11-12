
`include "Scoreboard.sv"

class RandomInputGenerator #(parameter SIZE = 32);
	randc logic [SIZE-1:0]  numerador;
	randc logic [SIZE-1:0] denominador;

	constraint zeroRemainder {numerador % denominador == 0;}
	constraint notZeroRemainder {numerador % denominador != 0;}

    constraint numeradorPositive {numerador[SIZE-1] == 0;}
    constraint numeradorNegative {numerador[SIZE-1] == 1;}
    	
   	constraint denominadorPositive {denominador[SIZE-1] == 0;}
   	constraint denominadorNegative {denominador[SIZE-1] == 1;}
    constraint notZeroDenominator {denominador != 0;}

	function new();
	begin
	end
	endfunction
endclass

program estimulos_divisor #(parameter SIZE = 32) (
        test_if.test testar,
        test_if.monitor monitorizar  
  );

covergroup cg @(bus.stimulus_cb);
    num: coverpoint bus.stimulus_cb.numerador {
        bins pos = { [0:(2^SIZE)/2 -1] };
        bins neg = { [(2^SIZE)/2:$] };
    }
    den: coverpoint bus.stimulus_cb.denominador {
        bins pos = { [0:(2^SIZE)/2 -1] };
        bins neg = { [(2^SIZE)/2:$] };
        illegal_bins ilegal = {0};
    }
    c : cross num, den {  // 16 bins
        bins pos = (binsof(num.pos) && binsof(den.pos)) || (binsof(num.neg) && binsof(den.neg));
        bins neg = (binsof(num.pos) && binsof(den.neg)) || (binsof(num.neg) && binsof(den.pos));
    }
endgroup


RandomInputGenerator #(.SIZE(SIZE)) randomInput;
//declaracion de objetos
cg cg_test;
Scoreboard #(.SIZE(SIZE)) sb;

initial begin
    repeat(2) @(bus.stimulus_cb)
    cg_test = new();
	randomInput = new();
    sb = new(monitorizar); 

    randomInput.notZeroRemainder.constraint_mode(0);
    randomInput.zeroRemainder.constraint_mode(0);
    randomInput.numeradorPositive.constraint_mode(0);
    randomInput.denominadorPositive.constraint_mode(0);
    randomInput.numeradorNegative.constraint_mode(0);
    randomInput.denominadorNegative.constraint_mode(0);
	init();
    muestrear();
   //zeroRemainderDivisions();
    //notZeroRemainderDivisions();

    //while(cg_test.get_coverage()<70) begin 
        positiveDivision1();
        positiveDivision2();
        negativeDivision1();
        negativeDivision2();
    //end
	$stop;
end

task muestrear;
begin
    //lanzamiento de procedimientos de monitorizacion
     fork
      sb.monitor_input; //lanzo el procedimiento de monitorizacion cambio entrada y calculo del valor target
      sb.monitor_output;//lanzo el procedimiento de monitorizacion cambio salida y comparacion ideal
     join_none
end
endtask  

task init();
    bus.stimulus_cb.start <= 0;
    bus.stimulus_cb.numerador <= 0;
    bus.stimulus_cb.denominador <= 0;
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
    @(bus.stimulus_cb.done);
endtask

task zeroRemainderDivision();
    randomInput.notZeroRemainder.constraint_mode(0);
    randomInput.zeroRemainder.constraint_mode(1);

     newDivision();
    
endtask

task notZeroRemainderDivisions();
    randomInput.notZeroRemainder.constraint_mode(1);
    randomInput.zeroRemainder.constraint_mode(0);
        newDivision();
endtask

task positiveDivision1();
    randomInput.numeradorPositive.constraint_mode(1);
    randomInput.denominadorPositive.constraint_mode(1);
    randomInput.numeradorNegative.constraint_mode(0);
    randomInput.denominadorNegative.constraint_mode(0);
    newDivision();
endtask

task positiveDivision2();
    randomInput.numeradorPositive.constraint_mode(0);
    randomInput.denominadorPositive.constraint_mode(0);
    randomInput.numeradorNegative.constraint_mode(1);
    randomInput.denominadorNegative.constraint_mode(1);
       newDivision();
endtask


task negativeDivision1();
    randomInput.numeradorPositive.constraint_mode(1);
    randomInput.denominadorPositive.constraint_mode(0);
    randomInput.numeradorNegative.constraint_mode(0);
    randomInput.denominadorNegative.constraint_mode(1);
        newDivision();
endtask

task negativeDivision2();
    randomInput.numeradorPositive.constraint_mode(0);
    randomInput.denominadorPositive.constraint_mode(1);
    randomInput.numeradorNegative.constraint_mode(1);
    randomInput.denominadorNegative.constraint_mode(0);
        newDivision();
endtask



endprogram : estimulos_divisor
