class apb_slave_seq_item extends uvm_sequence_item;

    //factory registration
    `uvm_object_utils(apb_slave_seq_item)

    //fields

    rand bit [2 :0] wait_state;

    bit [`ADDR_BUS_WIDTH-1:0] PADDR;
    
    bit [2 :0] PPROT;

    bit PSELx;

    bit [`DATA_BUS_BYTES*8-1 :0] PWDATA;
    
    bit [`DATA_BUS_BYTES-1 :0]   PSTRB;
    
    bit PWRITE;
    
    bit PENABLE;
    
    bit PREADY;
    
    rand bit [`DATA_BUS_BYTES*8-1 :0] PRDATA;
    
    bit PSLVERR;


    //methods prototype
    extern function new(string name = "");
    extern function void do_copy(uvm_object rhs);
    extern function uvm_object clone();
    extern function string output2string();
endclass:apb_slave_seq_item

//new
function apb_slave_seq_item::new(string name = "");

    super.new(name);

endfunction:new

//do_copy method
function void apb_slave_seq_item::do_copy(uvm_object rhs);

    apb_slave_seq_item rhs_;

    $cast(rhs_,rhs);

    this.wait_state   = rhs_.wait_state;
    this.PADDR        = rhs_.PADDR;
    this.PPROT        = rhs_.PPROT;
    this.PSELx        = rhs_.PSELx;
    this.PENABLE      = rhs_.PENABLE;
    this.PWRITE       = rhs_.PWRITE;
    this.PWDATA       = rhs_.PWDATA;
    this.PSTRB        = rhs_.PSTRB;
    this.PREADY       = rhs_.PREADY;
    this.PRDATA       = rhs_.PRDATA;
    this.PSLVERR      = rhs_.PSLVERR;

endfunction:do_copy

//clone method
function uvm_object apb_slave_seq_item::clone();

    apb_slave_seq_item rhs_;
    rhs_ = apb_slave_seq_item::type_id::create("rhs_");

    rhs_.copy(this);

    return rhs_;

endfunction:clone

//output2string method
function string apb_slave_seq_item::output2string();

    return $sformatf("SLAVE ID :%0d\nPWRITE :%0b\nPADDR :%0h\nPWDATA : %0h\nPRDATA :%0h",this.PSELx,this.PWRITE,this.PADDR,this.PWDATA,this.PRDATA,);

endfunction:output2string
