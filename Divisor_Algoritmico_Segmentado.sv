module Divisor_Algoritmico_Segmentado
 

#(parameter tamanyo=32, etapas=32)           
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

/* Aquí creamos las variables que vamos a ir modificando dependiendo de la etapa, ha desaparecido el contador CONT, debido a la segmentación*/


always_ff@(posedge CLK or negedge RSTa) begin
	if(~RSTa) begin
//INICIAMOS LA MAYORÍA DE VARIABLES A 0, YA QUE TENEMOS QUE DARLES UN VALOR ORIGINAL, POR SI SE PRODUCEUN RESET, NO TENER GUARDADOS VALORES ANTERIORES O DESCONOCIDOS
        ACCU 		<=	'0;
        SignNum  	<= 	'0;
        SignDen  	<= 	'0;
		Q  			<= 	'0;
        M 			<= 	'0;
        fin  		<= 	'0;
		START 		<= 	'0;
		Coc 		<= 	'0;
		Res 		<= 	'0;
    end
	else 
    begin
        fin <= '0;
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
        for (int i = (etapas-2); i >= 0; i = i-1) 
		begin 
			// ESTAMOS DESPLAZANDO EL START, HASTA LA ÚLTIMA ETAPA, CON EL FIN DE SABER EN QUE MOMENTO DEBEMOS HACER UNA OPERACIÓN 
			START[i]<= START[i+1];
			SignNum[i] <= SignNum[i+1];
			SignDen[i] <= SignDen[i+1];
			ACCU[i] <= ACCU[i+1];
			Q[i] <= Q[i+1];
			M[i] <= M[i+1];

			if(START[i]) 
			/*SI EL START DE ESA ETAPA SE CUMPLE, DEBEREMOS REALIZAR LAS OPERACIONES, ESTA SEÑAL NO ES COMO LA ANTERIOR, YA QUE AHORA REALIZAR LA OPERACIÓN IRA ATRAVESANDO NUESTRA RED SEGMENTADA,
			DE MANERA QUE  SOLO CUANDO LA SEÑAL DE START ESTÉ ACTIVADA EN CADA ETAPA SE REAILZARÁ EL PROPIO DESPLAZAMIENTO*/ 
			begin
				{ACCU[i],Q[i]} <= {ACCU[i][tamanyo-2:0], Q[i], 1'b0};

				if (ACCU[i] >= M[i]) 
				begin
						Q[i] <= Q[i] + 1;
						ACCU[i] <= ACCU[i] - M[i];
				end 
				if (i == 0) // REALMENTE NO ES CONTADOR I==0, ES CUANDO HAYAN PASADO X CICLOS, POR LO QUE EL CONTADOR NO DEBERIAMOS ELIMINARLO??????????, voy a crear un contador por etapa. 
				begin
						fin <= 1'b1;
						Coc <= (SignNum[i]^SignDen[i]) ? (~Q[i]+1) : Q[i];
						Res <= SignNum[i] ? (~ACCU[i]+1) : ACCU[i];
				end

			end
				
		end
    end
end

assign Done = fin;


endmodule 