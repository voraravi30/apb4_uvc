class apb_slave_seqc extends uvm_sequence #(apb_slave_seq_item);

    //factory registration
    `uvm_object_utils(apb_slave_seqc)
    
    //declare the p_sequencer
    `uvm_declare_p_sequencer(apb_slave_sequencer)

    //fields
    apb_slave_seq_item req;

    //methods prototype
    extern function new(string name="");
    extern task body();

endclass:apb_slave_seqc

//new
function apb_slave_seqc::new(string name="");

    super.new(name);

endfunction:new

task apb_slave_seqc::body();

    forever begin

        req = apb_slave_seq_item::type_id::create("req");

        //set_up_phase
        start_item(req);
        finish_item(req);

        if(req.PWRITE) begin

            `uvm_info(get_type_name(),$sformatf("SLAVE SEQC ACCEPTED THE PADDR %0h for PWDATA : %0h",req.PADDR,req.PWDATA),UVM_LOW)
            p_sequencer.storage.write(req.PADDR,req.PWDATA);

        end

        //access_phase
        start_item(req);

        if(!req.PWRITE) begin

            if(!p_sequencer.storage.mem.exists(req.PADDR)) begin
                p_sequencer.storage.write(req.PADDR,32'hfa_fa_fa_fa);
            end

            if(!req.randomize() with { PRDATA == p_sequencer.storage.read(req.PADDR); }) begin 
                `uvm_fatal("SLAVE SEQUENCE","FAILED TO RANDOMIZE THE READ DATA")
            end
            `uvm_info(get_full_name(),$sformatf("GENERATED RESPONSE FOR PADDR %0h for PWDATA : %0h",req.PADDR,req.PWDATA),UVM_LOW)
        
        end

        req.PSLVERR = 1'b0;

        finish_item(req);

    end

endtask:body
