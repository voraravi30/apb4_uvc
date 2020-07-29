class apb_environment extends uvm_env;

    //factory registration
    `uvm_component_utils(apb_environment)

    //Agents handles
    apb_bridge_agent bridge_agent;
    apb_slave_agent  slave_agent[];

    //scoreboard handle
    apb_scoreboard   apb_scb;

    //function coverage component handle
    apb_coverage     apb_cov;

    //bus monitor handle
    apb_bus_monitor  bus_monitor;

    //virtual sequencer handle
    apb_virtual_sequencer apb_vseqr;

    //configuration object handle
    apb_env_config config_obj;

    //methods prototype
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass:apb_environment

//new
function apb_environment::new(string name, uvm_component parent);

    super.new(name,parent);

endfunction:new

//build_phase
function void apb_environment::build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db#(apb_env_config)::get(this,"","env_config",config_obj)) begin

        `uvm_fatal(get_type_name(),"ENVIRONMENT CONFIGURATION OBJECT NOT SET PROPERLY IN CONFIGURATION SPACE")

    end

    bridge_agent = apb_bridge_agent::type_id::create("bridge_agent",this);

    if(config_obj.has_scoreboard) begin
    
        apb_scb = apb_scoreboard::type_id::create("apb_scb",this);
    
    end
    
    if(config_obj.has_coverage) begin

        apb_cov = apb_coverage::type_id::create("apb_cov",this);
    
    end

    if(config_obj.NO_OF_SLAVE_ON_BUS == 0) begin
        `uvm_fatal("ENVIRONMENT BUILD PHASE","NO OF SLAVES ON BUS IS ZERO, MAKE IT MORE!")
    end
    else begin
        slave_agent = new[config_obj.NO_OF_SLAVE_ON_BUS];
        for(int i=0; i<config_obj.NO_OF_SLAVE_ON_BUS;i++) begin

            slave_agent[i] = apb_slave_agent::type_id::create($sformatf("slave_agent[%0d]",i),this);  //creates the slave agents equals to number of slave on bus
        end
    end

    bus_monitor = apb_bus_monitor::type_id::create("bus_monitor",this);

    apb_vseqr = apb_virtual_sequencer::type_id::create("apb_vseqr",this);

    uvm_config_db#(apb_bridge_config_obj)::set(this,"bridge_agent*","bridge_config",config_obj.bridge_config);
    uvm_config_db#(apb_slave_config_obj)::set(this,"slave_agent*","slave_config",config_obj.slave_config);

endfunction:build_phase

function void apb_environment::connect_phase(uvm_phase phase);

    bus_monitor.APB = config_obj.bridge_config.APB;  //assign interfce handle


    if(config_obj.has_scoreboard) begin
    
        bus_monitor.ap.connect(apb_scb.axp_out);
        bridge_agent.ap.connect(apb_scb.axp_in);
        
    end
    
    if(config_obj.has_coverage) begin

        bus_monitor.ap.connect(apb_cov.analysis_export);

    end
    //handles of target sequncer are assigned
    
    if(config_obj.bridge_config.is_active) begin
        apb_vseqr.bridge_seqr = bridge_agent.bridge_seqr;    //apb_bridge/master's sequencer assigned
    end

    for(int i=0;i<config_obj.NO_OF_SLAVE_ON_BUS;i++) begin
        
        if(config_obj.slave_config.is_active) begin
            apb_vseqr.slave_seqr[i] = slave_agent[i].slave_seqr;   //apb_slaves's sequencer assigned
        end

    end
endfunction:connect_phase
