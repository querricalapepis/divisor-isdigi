class Result #(parameter SIZE = 32);
    logic [SIZE-1:0] cociente;
    logic [SIZE-1:0] resto;
endclass

class Scoreboard #(SIZE = 32);
    Result cola_targets[$];
    virtual test_if.monitor mports;

    function new(virtual test_if.monitor mports);
    begin
        this.mports = mports;
    end
    endfunction

    task monitor_input;
    begin
        while(1)
        begin
            @(posedge mports.monitor.start);
            begin
                cocienteCorrecto = mports.monitor_cb.numerador / mports.monitor_cb.denominador;
                restoCorrecto = mports.monitor_cb.numerador % mports.monitor_cb.denominador;
                Result #(.SIZE(SIZE)) result;
                result.cociente = cocienteCorrecto;
                result.resto = restoCorrecto;
            end
        end  
    end
    endtask

    task monitor_output;
    begin
        while(1)
        begin
            @(posedge mports.monitor.done)
            begin
                want = cola_targets.pop_front()
                assert(want.cociente == mports.monitor.cociente) 
                else $error("error cociente de %d entre %d: quiero %d tengo %d", mports.monitor.numerador, mports.monitor.denominador, want.cociente, mports.monitor.cociente) 
                assert(want.resto == mports.monitor.resto) 
                else $error("error resto de %d entre %d: quiero %d tengo %d", mports.monitor.numerador, mports.monitor.denominador, want.resto, mports.monitor.resto) 
            end
        end
    end
endclass