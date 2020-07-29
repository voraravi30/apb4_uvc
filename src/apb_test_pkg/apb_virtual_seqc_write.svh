class apb_virtual_seqc_write extends apb_virtual_seqc;

    //factory registration
    `uvm_object_utils(apb_virtual_seqc_write)

    //method
    extern function new(string name="");
    extern task body();

endclass:apb_virtual_seqc_write

//new
function apb_virtual_seqc_write::new(string name="");

    super.new(name);

endfunction:new

//body
task apb_virtual_seqc_write::body();

    super.body();

    //create the bridge and slave sequences
    bridge_seqc = apb_bridge_seqc::type_id::create("bridge_seqc");

    //for each slave on the bus sequence is created
    for(int i=0; i <`NO_OF_SLAVE_ON_BUS;i++) begin
        slave_seqc[i]  = apb_slave_seqc::type_id::create($sformatf("slave_seqc[%0d]",i));
    end


    //start the sequences
    fork

        bridge_seqc.start(bridge_seqr);

        //if multiple apb slaves on the bus, then each slaves started
        for(int i=0; i <`NO_OF_SLAVE_ON_BUS;i++) fork
        
            slave_seqc[i].start(slave_seqr[i]);

        join
        
 
    join_any

endtask:body
