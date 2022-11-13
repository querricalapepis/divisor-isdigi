


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
        test_if.stimulus testar,
        test_if.monitor monitorizar  
  );

covergroup cg @(testar.stimulus_cb);
    num: coverpoint testar.stimulus_cb.numerador {
        bins pos = { [0:(2^SIZE)/2 -1] };
        bins neg = { [(2^SIZE)/2:$] };
    }
    den: coverpoint testar.stimulus_cb.denominador {
        bins pos = { [0:(2^SIZE)/2 -1] };
        bins neg = { [(2^SIZE)/2:$] };
        illegal_bins ilegal = {0};
    }
    c : cross num, den {  // 16 bins
        bins pos = (binsof(num.pos) && binsof(den.pos)) || (binsof(num.neg) && binsof(den.neg));
        bins neg = (binsof(num.pos) && binsof(den.neg)) || (binsof(num.neg) && binsof(den.pos));
    }
endgroup

typedef enum bit { SIN_SEGMENTAR, SEGMENTADO } e_duv_type;
e_duv_type duv_type = SIN_SEGMENTAR;

`include "Scoreboard.sv"

RandomInputGenerator #(.SIZE(SIZE)) randomInput;
//declaracion de objetos
cg cg_test;
Scoreboard #(.SIZE(SIZE)) sb;
int count;
initial begin
    repeat(2) @(testar.stimulus_cb)
    cg_test = new();
	randomInput = new();
    sb = new(monitorizar, duv_type); 

    disable_constrains();
	init();
    muestrear();
   

    count = 0;
    while(count < 1 /*cg_test.get_coverage()<80*/) begin
        zeroRemainderDivision();
        notZeroRemainderDivision();
        disable_constrains();
        bothPositive();
        bothNegative();
        positiveNumNegativeDen();
        negativeNumPositiveDen();
        count += 1;
    end
    @(testar.stimulus_cb);
	$stop;
end

task disable_constrains;
begin
    randomInput.notZeroRemainder.constraint_mode(0);
    randomInput.zeroRemainder.constraint_mode(0);
    randomInput.numeradorPositive.constraint_mode(0);
    randomInput.denominadorPositive.constraint_mode(0);
    randomInput.numeradorNegative.constraint_mode(0);
    randomInput.denominadorNegative.constraint_mode(0);
end
endtask

task muestrear;
begin
    //lanzamiento de procedimientos de monitorizacion
     fork
      sb.monitor_input(); //lanzo el procedimiento de monitorizacion cambio entrada y calculo del valor target
      sb.monitor_output();//lanzo el procedimiento de monitorizacion cambio salida y comparacion ideal
     join_none
end
endtask  

task init();
    testar.stimulus_cb.start <= 0;
    testar.stimulus_cb.numerador <= 0;
    testar.stimulus_cb.denominador <= 0;
endtask

task newDivision();
    assert(randomInput.randomize());
    testar.stimulus_cb.numerador <= randomInput.numerador;
    testar.stimulus_cb.denominador <= randomInput.denominador;
    if(duv_type == SIN_SEGMENTAR) begin
        @(testar.stimulus_cb) testar.stimulus_cb.start <= 1'b1;
        @(testar.stimulus_cb) testar.stimulus_cb.start <= 1'b0;
        @(posedge testar.stimulus_cb.done);
    end else if(duv_type == SEGMENTADO) begin
        @(testar.stimulus_cb); testar.stimulus_cb.start <= 1'b1;
    end else begin
        $error("El duv_type es incorrecto");
    end

endtask

task zeroRemainderDivision();
    randomInput.notZeroRemainder.constraint_mode(0);
    randomInput.zeroRemainder.constraint_mode(1);

     newDivision();
    
endtask

task notZeroRemainderDivision();
    randomInput.notZeroRemainder.constraint_mode(1);
    randomInput.zeroRemainder.constraint_mode(0);
        newDivision();
endtask

task bothPositive();
    randomInput.numeradorPositive.constraint_mode(1);
    randomInput.denominadorPositive.constraint_mode(1);
    randomInput.numeradorNegative.constraint_mode(0);
    randomInput.denominadorNegative.constraint_mode(0);
    newDivision();
endtask

task bothNegative();
    randomInput.numeradorPositive.constraint_mode(0);
    randomInput.denominadorPositive.constraint_mode(0);
    randomInput.numeradorNegative.constraint_mode(1);
    randomInput.denominadorNegative.constraint_mode(1);
    newDivision();
endtask

task positiveNumNegativeDen();
    randomInput.numeradorPositive.constraint_mode(1);
    randomInput.denominadorPositive.constraint_mode(0);
    randomInput.numeradorNegative.constraint_mode(0);
    randomInput.denominadorNegative.constraint_mode(1);
        newDivision();
endtask

task negativeNumPositiveDen();
    randomInput.numeradorPositive.constraint_mode(0);
    randomInput.denominadorPositive.constraint_mode(1);
    randomInput.numeradorNegative.constraint_mode(1);
    randomInput.denominadorNegative.constraint_mode(0);
        newDivision();
endtask

endprogram : estimulos_divisor
