class apb_bridge_sequencer extends uvm_sequencer #(apb_bridge_seq_item);

    //factory registartion
    `uvm_component_utils(apb_bridge_sequencer)

    //Required methods prototype
    extern function new(string name, uvm_component parent);
endclass:apb_bridge_sequencer

//class constructor methos
function apb_bridge_sequencer::new(string name, uvm_component parent);
    
    super.new(name,parent);

endfunction:new
