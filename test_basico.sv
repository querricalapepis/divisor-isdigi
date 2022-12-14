localparam SIZE = 32;
`timescale 1ns/1ps

module test_basico();

	logic CLK;
	logic RSTn;
	logic START;
	logic signed [SIZE-1:0] NUM;
	logic signed [SIZE-1:0] DEN;

	logic signed [SIZE-1:0] COC;
	logic signed [SIZE-1:0] RES;
	logic DONE;
Divisor_Algoritmico DUV(CLK, RSTn, START, NUM, DEN, COC, RES, DONE);
defparam DUV.tamanyo = SIZE;

localparam T = 10;


initial begin
CLK = 0;
forever #(T/2) CLK = !CLK;
end

initial 
begin
	START = 0;
	NUM = -2;
	DEN = 2;
	reset(CLK,RSTn);
	divide(CLK, START);
    @(DONE);
    #(T*2);
 	NUM = 2;
	DEN = 2;
	divide(CLK, START);
	@(DONE);
    #(T*2)
    $stop;
	
end
	
	
task automatic  reset(ref CLK, ref RESET);
	@(negedge CLK)
		RESET = 0;
	@(negedge CLK)
		RESET = 1;
endtask

task automatic  divide(ref CLK, ref START);
	@(negedge CLK)
		START = 1;
	@(negedge CLK)
		START = 0;
endtask

endmodule 
