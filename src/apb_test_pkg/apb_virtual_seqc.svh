class apb_virtual_seqc extends uvm_sequence #(uvm_sequence_item);
    
    //factory registration
    `uvm_object_utils(apb_virtual_seqc)

    //declare p_sequencer
    `uvm_declare_p_sequencer(apb_virtual_sequencer)

    //handle of transaction
    apb_bridge_seq_item item;
    apb_bridge_seqc bridge_seqc;
    apb_slave_seqc  slave_seqc[int];

    //fields
    apb_bridge_sequencer bridge_seqr;
    apb_slave_sequencer  slave_seqr[int];

    //methods
    extern function new(string name="");
    extern task body();
endclass:apb_virtual_seqc

function apb_virtual_seqc::new(string name="");

    super.new(name);

endfunction:new

task apb_virtual_seqc::body();

    bridge_seqr = p_sequencer.bridge_seqr;

    //for multiple apb slaves are there
    for(int i=0; i<`NO_OF_SLAVE_ON_BUS;i++) begin
        
        slave_seqr[i] = p_sequencer.slave_seqr[i];
    
    end

endtask
