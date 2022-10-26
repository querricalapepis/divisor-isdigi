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
logic [etapas-1:0] fin, SignDen, SignNum;




always_ff@(posedge CLK or negedge RSTa) begin
	if(~RSTa) begin
        ACCU [etapas-1] <= '0;
        //CONT [etapas-1] <= '0;
        SignNum [etapas-1] <= '0;
        SignDen [etapas-1] <= '0;
		Q [etapas-1] <= '0;
        M [etapas-1] <= '0;
        fin [etapas-1] <= '0;
    end
	else 
    begin
        fin [etapas-1] <= '0;
        START [etapas-1] <= Start;
        if (Start)
            begin
                //CONT [etapas-1] <= tamanyo-'1;
                SignNum [etapas-1] <= Num[tamanyo-1];;
                SignDen [etapas-1] <= Den[tamanyo-1];
		        Q [etapas-1] <= Num[tamanyo-1] ? (~Num+1) : Num;
                M [etapas-1] <= Den[tamanyo-1] ? (~Den+1) : Den;

            end
        for (int i=(etapas-2);i>-1;i=i-1) begin
            START[i]<= START[i+1];
            if(START[i+1])
            begin
                {ACCU[i],Q[i]} <= {ACCU[i+1][tamanyo-2:0], Q[i+1], 1'b0};

                if (ACCU[i] >= M[i]) begin
				Q[i] <= Q[i] + 1;
				ACCU[i] <= ACCU[i] - M[i];

                fin[i] <= 1'b1;
				Coc[i] <= (SignNum[i]^SignDen[i]) ? (~Q[i]+1) : Q[i];
				Res[i] = SignNum[i] ? (~ACCU[i]+1) : ACCU[i];
			end 

            end
            
        end
    end
    /* 
		case (state)

		D0:
			begin
				fin <= '0;
				if (Start) begin
					state <= D1;
					ACCU <= '0;
					CONT <= tamanyo-'1;
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
			CONT <= CONT-'1;
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
		
	*/
end

assign Done = fin[0];


endmodule 