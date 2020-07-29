class apb_slave_agent extends uvm_agent;

    //-----------------------------------
    //factory registration
    //-----------------------------------
    `uvm_component_utils(apb_slave_agent)
    //------------------------------------
    //Handles of APB slave driver,sequencer,storage component
    //agent configuration object and analysis port
    //------------------------------------

    apb_slave_driver      slave_drv;
    apb_slave_sequencer   slave_seqr;
    apb_storage_component storage; 
    apb_slave_config_obj  config_obj;

    //------------------------------------
    //required methods prototype
    //------------------------------------
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass:apb_slave_agent


//class constructor function
function apb_slave_agent::new(string name,uvm_component parent);

    super.new(name,parent);

endfunction:new

//build_phase method of APB slave agent class
function void apb_slave_agent::build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db#(apb_slave_config_obj)::get(this,"","slave_config",config_obj)) begin   //get the slave agent configuration object
        
        `uvm_fatal(get_type_name,"FATAL WHILE TRYING TO GET THE APB slave AGENT CONFIGURATION OBJECT")
    
    end
    
    if(config_obj.is_active == UVM_ACTIVE) begin              //APB slave driver and sequencer only if agent is active type
        
        slave_drv = apb_slave_driver::type_id::create("slave_drv",this);
        slave_seqr = apb_slave_sequencer::type_id::create("slave_seqr",this);
        storage   = apb_storage_component::type_id::create("storage",this);
    
    end

endfunction:build_phase

//connect_phase method of APB slave agent class
function void apb_slave_agent::connect_phase(uvm_phase phase);

    super.connect_phase(phase);


    if(config_obj.is_active == UVM_ACTIVE) begin            //if active then connect the driver's seq_item_port to sequencer seq_item_export

        slave_drv.seq_item_port.connect(slave_seqr.seq_item_export);
        slave_seqr.storage = storage;
        slave_drv.APB = config_obj.APB;

    end

endfunction:connect_phase
