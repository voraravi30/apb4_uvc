class apb_slave_config_obj extends uvm_object;

    //--------------------------------
    //factory registration
    //--------------------------------
    `uvm_object_utils(apb_slave_config_obj)

    //--------------------------------
    //Required fields for configuration 
    //--------------------------------

    uvm_active_passive_enum is_active;       //Agent is active or passive
    virtual apb_slave_intf APB;             //virtual interface handle for APB BRIDGE

    //--------------------------------
    //Required methods prototype
    //--------------------------------
    extern function new(string name = "");

endclass:apb_slave_config_obj

//class constructor method
function apb_slave_config_obj::new(string name = "");

    super.new(name);

endfunction:new
