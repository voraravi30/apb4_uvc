module apb_top;
    
    import uvm_pkg::*;           //import the uvm package library
    import apb_test_pkg::*;      //import the apb_test package 

    `include "apb_config.svh"

    `include "apb_bridge_intf.sv";
    `include "apb_slave_intf.sv";

    logic PCLK;
    logic PRESETn;

    apb_bridge_intf bridge_intf(PCLK,PRESETn);
    apb_slave_intf  slave_intf(PCLK,PRESETn);

    initial begin
        PCLK = 0;
        PRESETn = 0;
        repeat(102)
            #5 PCLK = ~PCLK;
        PRESETn = 1;
        forever 
            #5 PCLK = ~PCLK;
    end

    initial begin

        uvm_config_db#(int)::set(null,"uvm_test_top","NO_OF_SLAVE_ON_BUS",`NO_OF_SLAVE_ON_BUS);
        uvm_config_db#(virtual apb_bridge_intf)::set(null,"uvm_test_top","apb_bridge_intf",bridge_intf);
        uvm_config_db#(virtual apb_slave_intf)::set(null,"uvm_test_top","apb_slave_intf",slave_intf);

        run_test();
    end

    //slave select signal
    assign slave_intf.PSELx[0]    = bridge_intf.PSELx[0];

    //bus signals
    assign slave_intf.PADDR    = bridge_intf.PADDR;
    assign slave_intf.PPROT    = bridge_intf.PPROT;
    assign slave_intf.PWRITE   = bridge_intf.PWRITE;
    assign slave_intf.PENABLE  = bridge_intf.PENABLE;
    assign slave_intf.PWDATA   = bridge_intf.PWDATA;
    assign slave_intf.PSTRB    = bridge_intf.PSTRB;
    assign bridge_intf.PREADY  = slave_intf.PREADY;
    assign bridge_intf.PRDATA  = slave_intf.PRDATA;
    assign bridge_intf.PSLVERR = slave_intf.PSLVERR;

endmodule:apb_top
