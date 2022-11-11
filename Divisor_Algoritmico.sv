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
typedef enum  { D0 = 0, D1 = 2, D2 = 4, D3 = 8 } e_state;
e_state state, next_state;

// Update state
always_ff@(posedge CLK or negedge RSTa) begin
	if(!RSTa)
		state <= D0;
	else
		state <= next_state;
end


//Calculate next state
always_ff@(posedge CLK or negedge RSTa) begin
	if(!RSTa)
		next_state <= D0;
	else
		case (state)
		D0:
			begin
				if (Start)
					next_state <= D1;
				else
					next_state <= D0;
			end
		D1:
			begin
				next_state <= D2;
			end
		D2:
			begin
			if(CONT == 0)
				next_state <= D3;
			else
				next_state <= D1;
			end
		D3: begin
				next_state <= D0;
			end
		endcase

end


// Update variables
always_comb begin
	if(~RSTa) begin
		ACCU = '0;
		CONT = '0;
		SignNum = '0;
		SignDen = '0;
		Q = '0;
		M = '0;
		fin = '0;
		end
	else
		case (state)
		D0:
			begin
				fin = '0;
				if (Start) begin
					ACCU = '0;
					CONT = tamanyo-1;
					SignNum = Num[tamanyo-1];
					SignDen = Den[tamanyo-1];
					Q = Num[tamanyo-1] ? (~Num+1) : Num;
					M = Den[tamanyo-1] ? (~Den+1) : Den;
				end
			end
		D1:
			begin
				{ACCU,Q} = {ACCU[tamanyo-2:0], Q, 1'b0};
			end
		D2:
			begin
			CONT = CONT-1;
			if (ACCU >= M) begin
				Q = Q + 1;
				ACCU = ACCU - M;
			end
			end
		D3: begin
				fin = 1'b1;
				Coc = (SignNum^SignDen) ? (~Q+1) : Q;
				Res = SignNum ? (~ACCU+1) : ACCU;
			end
		endcase

	end


assign Done = fin;
//ASERCION DIVIDIR ENTRE 0
// si done activo  y cociente y resto es 0 y los valores de entrada son distintos de 0
// si haces una division y 32 cclos despues no tienes resultado
// comprobar reseteo, si al resetear las señales de despues no van bien



// i haces una division con un positivo y un negativo el cociente tiene que ser negativo a no ser que el numerador sea 0
assert property (@(posedge CLK) (Num[tamanyo-1] or Den[tamanyo-1])  |-> ##32 Coc[tamanyo-1] ) else $error(“No realiza correctamente la operación con signo”);
// si estas en estado 0 las funciones estén en 0
assert property (@(posedge CLK) (state == 0)  |-> (ACCU = '0 and CONT = tamanyo-1) ) else $error(“No inicializas correctamente”);
// si start es uno que pase al siguiente estado ()
assert property (@(posedge CLK) Start |=> (state==2) else $error(“No empieza a desplazar”);


endmodule