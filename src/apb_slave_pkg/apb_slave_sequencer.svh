class apb_slave_sequencer extends uvm_sequencer #(apb_slave_seq_item);

    //factory registartion
    `uvm_component_utils(apb_slave_sequencer)

    //storage component handle
    apb_storage_component storage;

    //Required methods prototype
    extern function new(string name, uvm_component parent);
endclass:apb_slave_sequencer

//class constructor methos
function apb_slave_sequencer::new(string name, uvm_component parent);
    
    super.new(name,parent);

endfunction:new
