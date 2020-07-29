class apb_bridge_monitor extends uvm_monitor;
    
    //factory registration
    `uvm_component_utils(apb_bridge_monitor)

    //virtual interface handle of apb bus
    virtual apb_bridge_intf.mon_mp APB;

    //analysis port
    uvm_analysis_port #(apb_bridge_seq_item) ap;

    //seq_item handle
    apb_bridge_seq_item req;

    //------------------------------------
    //Required method's prototype
    //------------------------------------

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task monitor(apb_bridge_seq_item req);

endclass:apb_bridge_monitor

//class constuctor method
function apb_bridge_monitor::new(string name, uvm_component parent);
    
    super.new(name,parent);

endfunction:new

//build_phase method
function void apb_bridge_monitor::build_phase(uvm_phase phase);

    super.build_phase(phase);

    ap = new("ap",this);   //construct the analysis port

endfunction:build_phase


//apb bus monitor's run_phase method
task apb_bridge_monitor::run_phase(uvm_phase phase);

    forever begin

        @(posedge APB.PCLK);
        req = apb_bridge_seq_item::type_id::create("req");

        fork

            begin:rst

                wait(!APB.PRESETn);
                disable mon;
                @(posedge APB.PRESETn);

            end

            begin:mon

                wait(APB.mon_cb.PRESETn);
                monitor(req);
                disable rst;

            end

        join

    end

endtask:run_phase

//monitor method for apb bus
task apb_bridge_monitor::monitor(apb_bridge_seq_item req);

        wait(APB.mon_cb.PSELx);

        req.PADDR  = APB.mon_cb.PADDR;       //samples the signals for set up phase
        req.PPROT  = APB.mon_cb.PPROT;
        req.PWRITE = APB.mon_cb.PWRITE;
        req.PSELx  = APB.mon_cb.PSELx;
        req.PWDATA = APB.mon_cb.PWDATA;
        req.PSTRB  = APB.mon_cb.PSTRB;

        `uvm_info(get_type_name(),"PUBLISHED INITIATOR",UVM_LOW)

        @(posedge APB.PCLK);

        wait(APB.mon_cb.PREADY);            //waits untils the bus transfet completes
                                            //now monitor is free to observe next transfers' set up phase activity

        ap.write(req);                       //publish set up phase information

        wait(!APB.mon_cb.PREADY);            //waits untils the bus transfet completes
        `uvm_info(get_type_name(),"READY TO MONITOR",UVM_LOW)
    

endtask:monitor
