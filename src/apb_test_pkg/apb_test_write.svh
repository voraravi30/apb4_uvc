class apb_test_write extends apb_test_base;

    //factory registration
    `uvm_component_utils(apb_test_write)

    //virtual sequence
    apb_virtual_seqc_write main_seqc;
    
    //transaction handle
    apb_bridge_seq_item item;

    //variable to select the slave
    bit [7:0] SLAVE_SELECT;

    //methods
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);

endclass:apb_test_write

//new
function apb_test_write::new(string name, uvm_component parent);

    super.new(name,parent);

endfunction:new

function void apb_test_write::build_phase(uvm_phase phase);

    super.build_phase(phase);
    
endfunction:build_phase

task apb_test_write::main_phase(uvm_phase phase);

    SLAVE_SELECT = 0;
    factory.print(2);
    main_seqc = apb_virtual_seqc_write::type_id::create("main_seqc");

    uvm_config_db #(bit [7:0])::set(this,"apb_env.bridge_agent.bridge_seqr.bridge_seqc","SLAVE_SELECT",SLAVE_SELECT);

    phase.raise_objection(this, "phase objection raised by apb_write_test");
    main_seqc.start(apb_env.apb_vseqr);
    phase.drop_objection(this, "phase objection dropped by apb_write_test");

endtask:main_phase
