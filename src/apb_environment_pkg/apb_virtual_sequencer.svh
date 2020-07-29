class apb_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

    //factory registration
    `uvm_component_utils(apb_virtual_sequencer)

    //sequencer handles
    apb_bridge_sequencer bridge_seqr;       //sequencer handle of apb bridge/bus_master
    apb_slave_sequencer  slave_seqr[int];    //slave agents sequncer handles

    //methods
    extern function new(string name, uvm_component parent);

endclass:apb_virtual_sequencer

//new
function apb_virtual_sequencer::new(string name, uvm_component parent);

    super.new(name,parent);

endfunction:new
