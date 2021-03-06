package apb_bridge_agent_pkg;

    typedef enum bit {APB_READ, APB_WRITE} tr_type_e;
    import uvm_pkg::*;

    `include "uvm_macros.svh"
    `include "apb_config.svh"
    `include "apb_bridge_config_obj.svh"
    `include "apb_bridge_seq_item.svh"
    `include "ext_item.svh"
    `include "apb_bridge_driver.svh"
    `include "apb_bridge_monitor.svh"
    `include "apb_bridge_sequencer.svh"
    `include "apb_bridge_agent.svh"

endpackage
