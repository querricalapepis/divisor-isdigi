


class Result #(parameter SIZE = 32);
     logic signed [SIZE-1:0] cociente;
     logic signed [SIZE-1:0] resto;

    function new(bit [SIZE-1:0] cociente, bit [SIZE-1:0] resto);
        this.cociente = cociente;
        this.resto = resto;
    endfunction

endclass

class Scoreboard #(parameter SIZE = 32, DUV_TYPE = 0);
    Result #(.SIZE(SIZE)) cola_targets[$];
    virtual test_if.monitor #(.SIZE(SIZE)) mports;

    function new(virtual test_if.monitor #(.SIZE(SIZE)) mports);
    begin
        this.mports = mports;
    end
    endfunction

    task monitor_input();
    begin
        while(1)
        begin
            if(DUV_TYPE == 0) begin
            @(posedge mports.monitor_cb.start);
                    save_input();   
            end else if(DUV_TYPE == 1) begin
            @(mports.monitor_cb);
                if(mports.monitor_cb.start  == 1)
                begin
                    save_input();
                end
            end                   
        end  
    end
    endtask

    task save_input(); 
    begin
        bit[SIZE-1:0] cocienteCorrecto = mports.monitor_cb.numerador / mports.monitor_cb.denominador;
        bit[SIZE-1:0] restoCorrecto = mports.monitor_cb.numerador % mports.monitor_cb.denominador;
        Result #(.SIZE(SIZE)) result;
        result = new(cocienteCorrecto,restoCorrecto);
        cola_targets.push_back(result);
    end
    endtask

    task monitor_output();
    begin
        while(1)
        begin
            if(DUV_TYPE == 0) begin
                @(posedge mports.monitor_cb.done) begin
                display_result();
                end
            end else if(DUV_TYPE == 1) begin
                @(mports.monitor_cb);
                if(mports.monitor_cb.done  == 1)
                begin
                    display_result();
                end
            end
                  
        end
    end
    endtask

    task display_result();
    begin
        Result #(.SIZE(SIZE)) want = cola_targets.pop_front();
        $display("GOLDEN: cociente: %d, resto: %d. CASERO: cociente: %d, resto:%d", want.cociente,want.resto,mports.monitor_cb.cociente,mports.monitor_cb.resto);
        assert(want.cociente == mports.monitor_cb.cociente)
        else $error("error cociente de %d entre %d: quiero %d tengo %d", mports.monitor_cb.numerador, mports.monitor_cb.denominador, want.cociente, mports.monitor_cb.cociente);
        assert(want.resto == mports.monitor_cb.resto)
        else $error("error resto de %d entre %d: quiero %d tengo %d", mports.monitor_cb.numerador, mports.monitor_cb.denominador, want.resto, mports.monitor_cb.resto);
    end
    endtask
endclass
