class apb_coverage extends uvm_subscriber #(apb_bridge_seq_item);

    //factory registration
    `uvm_component_utils(apb_coverage)

    //methods
    extern function new(string name, uvm_component parent);
    extern function void write(apb_bridge_seq_item t);

endclass:apb_coverage

//new
function apb_coverage::new(string name,uvm_component parent);
    
    super.new(name,parent);

endfunction:new

//write method of analysis port
function void apb_coverage::write(apb_bridge_seq_item t);

    apb_bridge_seq_item tr;

    $cast(tr,t.clone());

    //sample coverage here

endfunction:write
