class Result #(parameter SIZE = 32);
     bit [SIZE-1:0] cociente;
     bit [SIZE-1:0] resto;

    function new(bit [SIZE-1:0] cociente, bit [SIZE-1:0] resto);
        this.cociente = cociente;
        this.resto = resto;
    endfunction

endclass

class Scoreboard #(parameter SIZE = 32);
    Result cola_targets[$];
    virtual test_if.monitor mports;

    function new(virtual test_if.monitor mports);
    begin
        this.mports = mports;
    end
    endfunction

    task monitor_input();
    begin
        while(1)
        begin
            @(mports.monitor_cb); begin
                if(mports.monitor_cb.start == 1)
                begin
                    bit[SIZE-1:0] cocienteCorrecto = mports.monitor_cb.numerador / mports.monitor_cb.denominador;
                    bit[SIZE-1:0] restoCorrecto = mports.monitor_cb.numerador % mports.monitor_cb.denominador;
                    Result #(.SIZE(SIZE)) result;
                    result = new(cocienteCorrecto,restoCorrecto);
                    cola_targets.push_back(result);
                end    
            end            
        end  
    end
    endtask

    task monitor_output();
    begin
        while(1)
        begin
            @(mports.monitor_cb) begin
                if(mports.monitor_cb.done == 1)
                begin
                    Result want = cola_targets.pop_front();
                    $display("GOLDEN: cociente: %d, resto: %d. CASERO: cociente: %d, resto:%d", want.cociente,want.resto,mports.monitor_cb.cociente,mports.monitor_cb.resto);
                    assert(want.cociente == mports.monitor_cb.cociente)
                    else $error("error cociente de %d entre %d: quiero %d tengo %d", mports.monitor_cb.numerador, mports.monitor_cb.denominador, want.cociente, mports.monitor_cb.cociente);
                    assert(want.resto == mports.monitor_cb.resto)
                    else $error("error resto de %d entre %d: quiero %d tengo %d", mports.monitor_cb.numerador, mports.monitor_cb.denominador, want.resto, mports.monitor_cb.resto); 
                end
            end      
        end
    end
    endtask
endclass
