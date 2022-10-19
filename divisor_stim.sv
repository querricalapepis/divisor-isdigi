program divisor_stim(
    //PARAMETROS?
    input clk
    output start
    output rst_n
    output [7:0] dividend
    output [7:0] divisor
);

class Bus;
	randc logic [size-1:0] dividend;
	randc logic [size-1:0] divisor;

	constraint withRemainder {dividend % divisor != 0};
endclass

Bus busInst = new;

initial begin
		start = 0;
		dividend = 0;
		divisor = 0;
		reset(clk,rst_n);
		
        for(integer i = 0; i < 300; i++) begin
            if(count < 100)
			begin
				busInst.withRemainder.constraint_mode(0);
			end
		 	else if(count < 200)
			begin
				busInst.withRemainder.constraint_mode(1);
			end 
			busInst.randomize();
			dividend = busInst.dividend;
			divisor = busInst.divisor;
			divide(clk, start);
        end
end

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

endprogram : divisor_stim