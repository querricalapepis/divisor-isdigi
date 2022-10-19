localparam size = 32;
class Bus;
	randc logic [size-1:0] dividend;
	randc logic [size-1:0] divisor;

	constraint withRemainder {dividend % divisor != 0};
endclass

`timescale 1ns/1ps

localparam T = 10;
module prueba_divisor();

	logic CLK;
	logic RSTn;
	logic START;
	logic [size-1:0] NUM;
	logic [size-1:0] DEN;

	logic [size-1:0] COC;
	logic [size-1:0] RES;
	logic DONE;

	Bus busInst;

	initial
	begin
		busInst = new;
	end
	
	initial begin
    CLK = 0;
    forever #(T/2) CLK = !CLK;
	end

	initial 
	begin
		START = 0;
		NUM = 0;
		DEN = 0;
		reset(CLK,RSTn);
		int count = 0;
		while(1) {
			if(count < 100)
			begin
				busInst.withRemainder.constraint_mode(0);
			end
		 	else if(count < 200)
			begin
				busInst.withRemainder.constraint_mode(1);
			end 
			busInst.randomize();
			NUM = busInst.dividend;
			DEN = busInst.divisor;
			divide(CLK, START);
		
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

endmodule 