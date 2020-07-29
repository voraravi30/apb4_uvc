class apb_bridge_seqc extends uvm_sequence #(apb_bridge_seq_item);
    
    //factory registration
    `uvm_object_utils(apb_bridge_seqc)

    //fields
    rand int unsigned no_of_iteration = 10;
    apb_bridge_seq_item item;
    apb_bridge_seq_item req;

    //to store address while writing the slave
    bit [`ADDR_BUS_WIDTH-1 :0] addr[$];

    //slave select variable
    bit [7:0] SLAVE_SELECT;

    //methods
    extern function new(string name="");
    extern task body();

endclass:apb_bridge_seqc

//new
function apb_bridge_seqc::new(string name="");

    super.new(name);

endfunction:new

//body
task apb_bridge_seqc::body();

    if(!uvm_config_db #(bit [7:0])::get(null,get_full_name(),"SLAVE_SELECT",SLAVE_SELECT))
        `uvm_fatal(get_full_name(),"SLAVE SELECT NOT SET IN CONFIGURATIION SPACE")

    repeat(no_of_iteration) begin
        
        req = apb_bridge_seq_item::type_id::create("item");
    
        start_item(req);

        if(!req.randomize() with {PWRITE == 1'b1;PSTRB == 4'hf;tr_type == APB_WRITE;}) begin
            `uvm_fatal(get_full_name(),"RANDOMIZATION FAILS IN BRIDGE SEQC FOR WRITE")
        end
        addr.push_back(req.PADDR);

        finish_item(req);
        get_response(req);
    end

    foreach(addr[i]) begin

        req = apb_bridge_seq_item::type_id::create("item");
    
        start_item(req);

        if(!req.randomize() with {PWRITE == 1'b0; PADDR == local::addr[i];tr_type == APB_READ;}) begin
            `uvm_fatal(get_full_name(),"RANDOMIZATION FAILS IN BRIDGE SEQC FOR READ")
        end

        finish_item(req);
        get_response(req);
    end

endtask
