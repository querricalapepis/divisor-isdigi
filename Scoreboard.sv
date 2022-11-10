class Result #(parameter SIZE = 32);
    bit [SIZE-1:0] cociente;
    bit [SIZE-1:0] resto;
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
            @(posedge mports.monitor_cb.start);
            begin
                bit[SIZE-1:0] cocienteCorrecto = mports.monitor_cb.numerador / mports.monitor_cb.denominador;
                bit[SIZE-1:0] restoCorrecto = mports.monitor_cb.numerador % mports.monitor_cb.denominador;
                Result #(.SIZE(SIZE)) result;
                result.cociente = cocienteCorrecto;
                result.resto = restoCorrecto;
                cola_targets.push_back(result);
            end
        end  
    end
    endtask

    task monitor_output();
    begin
        while(1)
        begin
            @(posedge mports.monitor_cb.done)
            begin
                Result want = cola_targets.pop_front();
                assert(want.cociente == mports.monitor_cb.cociente)
                else $error("error cociente de %d entre %d: quiero %d tengo %d", mports.monitor_cb.numerador, mports.monitor_cb.denominador, want.cociente, mports.monitor_cb.cociente);
                assert(want.resto == mports.monitor_cb.resto)
                else $error("error resto de %d entre %d: quiero %d tengo %d", mports.monitor_cb.numerador, mports.monitor_cb.denominador, want.resto, mports.monitor_cb.resto); 
            end
        end
    end
    endtask
endclass
