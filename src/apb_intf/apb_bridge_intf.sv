interface apb_bridge_intf(input logic PCLK, logic PRESETn);

    logic [31 :0] PADDR;
    logic [2 :0]  PPROT;
    logic [`NO_OF_SLAVE_ON_BUS-1 :0]      PSELx;
    logic PWRITE;
    logic PENABLE;
    logic [31 :0] PWDATA;
    logic [3 :0]  PSTRB;
    logic PREADY;
    logic [31 :0] PRDATA;
    logic PSLVERR;

    clocking drv_cb @(posedge PCLK);

        default input #0 output #1;
        //input all the signals that come from the AHB master
        //here only signals that goes to APB slave are defined

        input PRESETn;
        output PADDR;
        output PPROT;
        output PSELx;
        output PWRITE;
        output PENABLE;
        output PWDATA;
        output PSTRB;
        input PREADY;
        input PRDATA;
        input PSLVERR;

    endclocking

    clocking mon_cb @(posedge PCLK);

        default input #0 output #1;
        //input all the signals come from the AHB master
        //here only signals that goes to APB slave are defined

        input PRESETn;
        input PADDR;
        input PPROT;
        input PSELx;
        input PWRITE;
        input PENABLE;
        input PWDATA;
        input PSTRB;
        input PREADY;
        input PRDATA;
        input PSLVERR;

    endclocking

    modport drv_mp(clocking drv_cb,PCLK,PRESETn);
    modport mon_mp(clocking mon_cb,PCLK,PRESETn);

endinterface
