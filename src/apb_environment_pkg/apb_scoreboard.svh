class apb_scoreboard extends uvm_scoreboard;

    //factory registration
    `uvm_component_utils(apb_scoreboard)

    //Predictor and Comparator handles
    apb_predictor prd;
    apb_comparator cmp;

    //analysis exports
    uvm_analysis_export #(apb_bridge_seq_item) axp_in;
    uvm_analysis_export #(apb_bridge_seq_item)  axp_out;

    //methods
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass:apb_scoreboard

//new
function apb_scoreboard::new(string name,uvm_component parent);

    super.new(name,parent);

endfunction:new

//build_phase
function void apb_scoreboard::build_phase(uvm_phase phase);

    super.build_phase(phase);

    axp_in  = new("axp_in",this);
    axp_out = new("axp_out",this);

    prd = apb_predictor::type_id::create("prd",this);
    cmp = apb_comparator::type_id::create("cmp",this);

endfunction:build_phase

//connect_phase
function void apb_scoreboard::connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    axp_in.connect(prd.analysis_export);
    axp_out.connect(cmp.axp_out);
    prd.results_ap.connect(cmp.axp_in);

endfunction:connect_phase
