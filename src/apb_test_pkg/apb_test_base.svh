class apb_test_base extends uvm_test;

    //factory registration
    `uvm_component_utils(apb_test_base)

    //fields

    apb_environment   apb_env;
    apb_env_config    env_config;
    apb_bridge_config_obj bridge_config;
    apb_slave_config_obj  slave_config;

    bit [31:0] fin;

    //methods
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
endclass:apb_test_base

//new
function apb_test_base::new(string name, uvm_component parent);

    super.new(name,parent);

endfunction:new

//build_phase
function void apb_test_base::build_phase(uvm_phase phase);

    super.build_phase(phase);

    env_config = apb_env_config::type_id::create("env_config");

    //bridge configuration
    bridge_config = apb_bridge_config_obj::type_id::create("bridge_config");
    if(!uvm_config_db#(virtual apb_bridge_intf)::get(this,"","apb_bridge_intf",bridge_config.APB))
        `uvm_fatal("APB_TEST_BASE,BUILD_PHASE","INTERFACE OF APB BRIDGE IS NOT IN CONFIGURATION SPACE")
    bridge_config.is_active = UVM_ACTIVE;

    //slave configuration
    slave_config = apb_slave_config_obj::type_id::create("slave_config");
    if(!uvm_config_db#(virtual apb_slave_intf)::get(this,"","apb_slave_intf",slave_config.APB))
        `uvm_fatal("APB_TEST_BASE,BUILD_PHASE","INTERFACE OF APB SLAVE IS NOT IN CONFIGURATION SPACE")
    slave_config.is_active = UVM_ACTIVE;

    //environment configuration
    if(!uvm_config_db#(int)::get(this,"","NO_OF_SLAVE_ON_BUS",env_config.NO_OF_SLAVE_ON_BUS))
        `uvm_fatal("APB_TEST_BASE,BUILD_PHASE","VALUE FOR NUMBER OF SLAVES ON BUS NOT SET BY TOP")

    env_config.has_scoreboard = 1'b1;
    env_config.has_coverage   = 1'b0;
    env_config.bridge_config = bridge_config;
    env_config.slave_config = slave_config;

    //set the evironment configuration object 
    uvm_config_db#(apb_env_config)::set(this,"apb_env","env_config",env_config);

    apb_env = apb_environment::type_id::create("apb_env",this);

endfunction:build_phase

function void apb_test_base::end_of_elaboration_phase(uvm_phase phase);

    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();

endfunction:end_of_elaboration_phase
