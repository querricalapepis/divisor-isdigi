program denominador_stim #(parameter size = 32) (
    //PARAMETROS?
    input clk
    output start
    output rst_n
    output [size-1:0] numerador
    output [size-1:0] denominador
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
		init(clk, rst_n,start,num,den);
        zeroRemainderDivisons(clk, start);
        notZeroRemainderDivisions(clk, start);
        positiveDivision1(clk, start);
        positiveDivision2(clk, start);
        negativeDivision1(clk, start);
        negativeDivision2(clk, start);
end

automatic task init(ref clk, ref rst_n, ref start, ref num, ref den);
    start = 0;
    num = 0;
    den = 0;
    reset(clk,rst_n);
endtask

automatic task reset(ref CLK, ref RESET_N);
	@(negedge CLK)
		RESET_N <= 0;
	@(negedge CLK)
		RESET_N <= 1;
endtask

automatic task divide(ref CLK, ref START);
	@(negedge CLK)
		START = 1;
	@(negedge CLK)
		START = 0;
endtask

automatic task newDivison(ref CLK, ref START);
    busInst.randomize(); 
    numerador = busInst.numerador;
	denominador = busInst.denominador;
    divide(CLK, START);
endtask

automatic task zeroRemainderDivisions(ref CLK, ref START);
    busInst.notZeroRemainder.constraint_mode(1);
    busInst.zeroRemainder.constraint_mode(0);
    repeat(100) begin
        newDivision(CLK, START);
    end
endtask

automatic task notZeroRemainderDivisions(ref CLK, ref START);
    busInst.notZeroRemainder.constraint_mode(0);
    busInst.zeroRemainder.constraint_mode(1);
    repeat(100) begin
        newDivision(CLK, START);
    end
endtask

automatic task positiveDivision1(ref CLK, ref START);
    busInst.numeradorPositive.constraint_mode(1);
    busInst.denominadorPositive.constraint_mode(1);
    busInst.numeradorNegative.constraint_mode(0);
    busInst.denominadorNegative.constraint_mode(0);
    repeat(100) begin
       newDivison(CLK, START);
    end
endtask

automatic task positiveDivision2(ref CLK, ref START);
    busInst.numeradorPositive.constraint_mode(0);
    busInst.denominadorPositive.constraint_mode(0);
    busInst.numeradorNegative.constraint_mode(1);
    busInst.denominadorNegative.constraint_mode(1);
    repeat(100) begin
       newDivison(CLK, START);
    end
endtask


automatic task negativeDivision1(ref CLK, ref START);
    busInst.numeradorPositive.constraint_mode(1);
    busInst.denominadorPositive.constraint_mode(0);
    busInst.numeradorNegative.constraint_mode(0);
    busInst.denominadorNegative.constraint_mode(1);
    repeat(100) begin
        newDivison(CLK, START);
    end
endtask

automatic task negativeDivision2(ref CLK, ref START);
    busInst.numeradorPositive.constraint_mode(0);
    busInst.denominadorPositive.constraint_mode(1);
    busInst.numeradorNegative.constraint_mode(1);
    busInst.denominadorNegative.constraint_mode(0);
    repeat(100) begin
        newDivison(CLK, START);
    end
endtask

endprogram : denominador_stim