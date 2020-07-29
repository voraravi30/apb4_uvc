class apb_env_config extends uvm_object;
    
    //factory registration
    `uvm_object_utils(apb_env_config)


    //fields
    int NO_OF_SLAVE_ON_BUS;

    bit has_scoreboard;        //if low then no scoreboard component built
    bit has_coverage;          //if low then no coverage component built

    //agents configuration handles
    apb_bridge_config_obj bridge_config;
    apb_slave_config_obj  slave_config;

    //methods
    extern function new(string name = "");

endclass:apb_env_config

//new
function apb_env_config::new(string name = "");

    super.new(name);

endfunction:new
