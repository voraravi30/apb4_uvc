class apb_bridge_agent extends uvm_agent;

    //-----------------------------------
    //factory registration
    //-----------------------------------
    `uvm_component_utils(apb_bridge_agent)
    //------------------------------------
    //Handles of APB bridge driver,monitor,sequencer,
    //agent configuration object and analysis port
    //------------------------------------
    apb_bridge_driver    bridge_drv;
    apb_bridge_monitor   bridge_mon;
    apb_bridge_sequencer bridge_seqr;
    apb_bridge_config_obj config_obj;
    uvm_analysis_port    #(apb_bridge_seq_item) ap;

    //------------------------------------
    //required methods prototype
    //------------------------------------
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass:apb_bridge_agent


//class constructor function
function apb_bridge_agent::new(string name,uvm_component parent);

    super.new(name,parent);

endfunction:new

//build_phase method of APB bridge agent class
function void apb_bridge_agent::build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db#(apb_bridge_config_obj)::get(this,"","bridge_config",config_obj)) begin   //get the bridge agent configuration object
        
        `uvm_fatal(get_type_name,"FATAL WHILE TRYING TO GET THE APB BRIDGE AGENT CONFIGURATION OBJECT")
    
    end

    bridge_mon = apb_bridge_monitor::type_id::create("bridge_mon",this);
    
    if(config_obj.is_active == UVM_ACTIVE) begin              //APB bridge driver and sequencer only if agent is active type
        
        bridge_drv = apb_bridge_driver::type_id::create("bridge_drv",this);
        bridge_seqr = apb_bridge_sequencer::type_id::create("bridge_seqr",this);
    
    end

endfunction:build_phase

//connect_phase method of APB bridge agent class
function void apb_bridge_agent::connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    bridge_drv.APB = config_obj.APB;             //virtual interface set by the configuration object
    bridge_mon.APB = config_obj.APB;

    ap = bridge_mon.ap;                          //assign handles of analysis port of APB bridge monitor to agents analysis port 
                                                 //through which transction are published

    if(config_obj.is_active == UVM_ACTIVE) begin            //if active then connect the driver's seq_item_port to sequencer seq_item_export

        bridge_drv.seq_item_port.connect(bridge_seqr.seq_item_export);

    end
endfunction:connect_phase
