interface apb_slave_intf(input logic PCLK, logic PRESETn);

    logic [31 :0] PADDR;
    logic [2 :0]  PPROT;
    logic PSELx;
    logic PENABLE;
    logic PWRITE;
    logic [31 :0] PWDATA;
    logic [3 :0]  PSTRB;
    logic PREADY;
    logic [31 :0] PRDATA;
    logic PSLVERR;

    clocking drv_cb @(posedge PCLK);
       
        default input #0 output #1;
        input PRESETn;
        input PADDR;
        input PPROT;
        input PSELx;
        input PENABLE;
        input PWRITE;
        input PWDATA;
        input PSTRB;
        output PREADY;
        output PRDATA;
        output PSLVERR;
    
    endclocking

    clocking mon_cb @(posedge PCLK);

        default input #0;
        input PRESETn;
        input PADDR;
        input PPROT;
        input PSELx;
        input PENABLE;
        input PWRITE;
        input PWDATA;
        input PSTRB;
        input PREADY;
        input PRDATA;
        input PSLVERR;

    endclocking

    modport drv_mp(clocking drv_cb,PCLK,PRESETn);
    modport mon_mp(clocking mon_cb,PCLK,PRESETn);

endinterface
