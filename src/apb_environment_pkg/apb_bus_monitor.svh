class apb_bus_monitor extends uvm_monitor;
    
    //factory registration
    `uvm_component_utils(apb_bus_monitor)

    //virtual interface handle of apb bus
    virtual apb_bridge_intf.mon_mp APB;

    //analysis port
    uvm_analysis_port #(apb_bridge_seq_item) ap;

    //seq_item handle
    apb_bridge_seq_item item;

    //------------------------------------
    //Required method's prototype
    //------------------------------------

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task monitor(apb_bridge_seq_item item);

endclass:apb_bus_monitor

//class constuctor method
function apb_bus_monitor::new(string name, uvm_component parent);
    
    super.new(name,parent);

endfunction:new

//build_phase method
function void apb_bus_monitor::build_phase(uvm_phase phase);

    super.build_phase(phase);

    ap = new("ap",this);   //construct the analysis port

endfunction:build_phase


//apb bus monitor's run_phase method
task apb_bus_monitor::run_phase(uvm_phase phase);

    forever begin

        item = apb_bridge_seq_item::type_id::create("item");

        fork

            begin:rst

                wait(!APB.PRESETn);
                disable mon;
                @(posedge APB.PRESETn);

            end

            begin:mon

                wait(APB.mon_cb.PRESETn);
                monitor(item);
                disable rst;

            end

        join

    end

endtask:run_phase

//monitor method for apb bus
task apb_bus_monitor::monitor(apb_bridge_seq_item item);

    if (APB.mon_cb.PSELx) begin

        item.PADDR  = APB.mon_cb.PADDR;       //samples the signals for set up phase
        item.PPROT  = APB.mon_cb.PPROT;
        item.PWRITE = APB.mon_cb.PWRITE;
        item.PSELx  = APB.mon_cb.PSELx;
        item.PWDATA = APB.mon_cb.PWDATA;
        item.PSTRB  = APB.mon_cb.PSTRB;

        @(posedge APB.PCLK);

        item.PENABLE = APB.mon_cb.PENABLE;

        wait(APB.mon_cb.PREADY);            //waits untils the bus transfet completes

        item.PSLVERR = APB.mon_cb.PSLVERR;
        item.PRDATA  = APB.mon_cb.PRDATA;
        item.PREADY  = APB.mon_cb.PREADY;

        ap.write(item);                     //publish the observed transfer
        `uvm_info(get_type_name(),"PUBLISHED SLAVE",UVM_LOW)
        wait(!APB.mon_cb.PREADY);            //waits untils the bus transfet completes
    
    end

    @(posedge APB.PCLK);

endtask:monitor
