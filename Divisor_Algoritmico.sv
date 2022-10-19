module Divisor_Algoritmico
 

#(parameter tamanyo=32)           
(input CLK,
input RSTa,
input Start,
input logic [tamanyo-1:0] Num,
input logic [tamanyo-1:0] Den,

output logic [tamanyo-1:0] Coc,
output logic [tamanyo-1:0] Res,
output Done);


//vuestro código


logic [tamanyo-1 : 0] ACCU, Q, M;
logic [$clog2(tamanyo) - 1 : 0] CONT;
logic fin, SignDen, SignNum;

enum int unsigned { D0 = 0, D1 = 2, D2 = 4, D3 = 8 } state;



always_ff@(posedge CLK or negedge RSTa) begin
	if(~RSTa) begin
		state <= D0;
		ACCU <= '0;
		CONT <= '0;
		SignNum <= '0;
		SignDen <= '0;
		Q <= '0;
		M <= '0;
		fin <= '0;
		end
	else 
		case (state)

		D0:
			begin
				fin <= '0;
				if (Start) begin
					state <= D1;
					ACCU <= '0;
					CONT <= tamanyo-1;
					SignNum <= Num[tamanyo-1];
					SignDen <= Den[tamanyo-1];
					Q <= Num[tamanyo-1] ? (~Num+1) : Num;
					M <= Den[tamanyo-1] ? (~Den+1) : Den;
				end
				else begin
					state <= D0;
				end
			end
		D1:
			begin
				state <= D2;
				{ACCU,Q} <= {ACCU[tamanyo-2:0], Q, 1'b0};
			end
		D2:
			begin
			CONT <= CONT-1;
			if (ACCU >= M) begin
				Q <= Q + 1;
				ACCU <= ACCU - M;
			end 
			if(CONT == 0) begin
				state <= D3;

			end else begin
				state <= D1; 
			end
			end
		D3: begin
				state <= D0;
				fin <= 1'b1;
				Coc <= (SignNum^SignDen) ? (~Q+1) : Q;
				Res = SignNum ? (~ACCU+1) : ACCU;
			end
		endcase
		
	end


assign Done = fin;



















endmodule 