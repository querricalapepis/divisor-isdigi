module Divisor_Algoritmico_Segmentado
 

#(parameter tamanyo=32, etapas=tamanyo*2+1)           
(input CLK,
input RSTa,
input Start,
input logic [tamanyo-1:0] Num,
input logic [tamanyo-1:0] Den,

output logic [tamanyo-1:0] Coc,
output logic [tamanyo-1:0] Res,
output Done);


//vuestro código

logic [etapas-1:0] START; 
logic [etapas-1:0] [tamanyo-1 : 0] ACCU, Q, M;
//logic [etapas-1:0] [$clog2(tamanyo) - 1 : 0] CONT;
logic [etapas-1:0] SignDen, SignNum;
logic fin;
reg [tamanyo-1:0] CocAux, ResAux;

/* Aquí creamos las variables que vamos a ir modificando dependiendo de la etapa, ha desaparecido el contador CONT, debido a la segmentación*/


always_ff@(posedge CLK or negedge RSTa) begin
	if(~RSTa) begin
//INICIAMOS LA MAYORÍA DE VARIABLES A 0, YA QUE TENEMOS QUE DARLES UN VALOR ORIGINAL, POR SI SE PRODUCEUN RESET, NO TENER GUARDADOS VALORES ANTERIORES O DESCONOCIDOS
        ACCU 		<='0;
        SignNum  	<='0;
        SignDen  	<='0;
		Q  			<='0;
        M 			<='0;
        fin  		<='0;
		START 		<='0;

    end
	else 
    begin
        START [etapas-1] <= Start;
        if (Start)
        begin
			//DESPLAZAMOS LAS VARIABLES A LA SIGUIENTE ETAPA Y REALIZAMOS LAS OPERACIONES PARA CONOCER EL SIGNO DE LA OPRERACIÓN
			SignNum [etapas-1] <= Num[tamanyo-1];
			SignDen [etapas-1] <= Den[tamanyo-1];
			ACCU [etapas-1] <= '0;
			Q [etapas-1] <= Num[tamanyo-1] ? (~Num+1) : Num;
			M [etapas-1] <= Den[tamanyo-1] ? (~Den+1) : Den;

        end
        for (int i = etapas - 2 ; i > -1 ; i = i-1) 
		begin 
			// ESTAMOS DESPLAZANDO EL START, HASTA LA ÚLTIMA ETAPA, CON EL FIN DE SABER EN QUE MOMENTO DEBEMOS HACER UNA OPERACIÓN 

			START[i]<= START[i+1];
			if(START[i+1])begin
				SignNum[i] <= SignNum[i+1];
				SignDen[i] <= SignDen[i+1];
				M[i] <= M[i+1]; 

				if (i%2 == 1)begin 
				{ACCU[i],Q[i]} <= {ACCU[i+1][tamanyo-2:0], Q[i+1], 1'b0};
				end
				else begin
				if (ACCU[i+1] >= M[i+1]) 
				begin
						Q[i] <= Q[i+1] + 1;
						ACCU[i] <= ACCU[i+1] - M[i+1];
				end
				else begin
						Q[i] <= Q[i+1];
						ACCU[i] <= ACCU[i+1];
					end
						
			end 
				
			end
				
		end

    end
end

assign Done = START[0];
always_comb begin
	if (START[0]) // REALMENTE NO ES CONTADOR I==0, ES CUANDO HAYAN PASADO X CICLOS, POR LO QUE EL CONTADOR NO DEBERIAMOS ELIMINARLO??????????, voy a crear un contador por etapa. 
	begin

		Coc = (SignNum[0]^SignDen[0]) ? (~Q[0]+1) : Q[0];
		Res = SignNum[0] ? (~ACCU[0]+1) : ACCU[0];
	end
	else
	begin
		Coc = '0;
		Res = '0;
	end
end


//ASERCIONES
//ASERCION DIVIDIR ENTRE 0 
// si done activo  y cociente y resto es 0 y los valores de entrada son distintos de 0
// si haces una division y 32 cclos despues no tienes resultado
// comprobar reseteo, si al resetear las señales de despues no van bien
// i haces una division con un positivo y un negativo el cociente tiene que ser negativo a no ser que el numerador sea 0
// si start es uno que pase al siguiente estado ()
// si acu es mayo o igual que m, q tiene que ser q+1
//si start no está activado y las salidas son distintas de 0;


endmodule 