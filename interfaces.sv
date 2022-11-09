interface test_if #(parameter size) (input bit clk);

    logic start
    logic rst_n
    logic [size-1:0] numerador
    logic [size-1:0] denominador
    logic [size-1:0] cociente
    logic [size-1:0] resto
    logic done

    clocking monitor_cb @(posedge clk);
    default input #1ns
    input start
    input rst_n
    input numerador
    input denominador
    input cociente
    input resto
    input done
    endclocking : monitor_cb;

    clocking stimulus_cb @(posedge clk);
    default output #1ns
    output start
    output rst_n
    output numerador
    output denominador
    endclocking : stimulus_cb;

    modport monitor(clocking monitor_cb);
    modport stimulus(clocking stimulus_cb);

    modport duv (
        input   clk,
        input   start,
        input   rst_n,
        input   numerador,
        input   denominador,
        output  cociente,
        output  resto,
        output  done
    );
endinterface : test_if