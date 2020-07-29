class apb_bridge_seq_item extends uvm_sequence_item;

    //factory registration
    `uvm_object_utils(apb_bridge_seq_item)

    //Fields of APB_BRIDGE_SEQUENCE_ITEM

    rand tr_type_e tr_type;              //which type of transfer?... APB_WRITE or APB_READ

    bit [7:0] SELECT_SLAVE;              //SLAVE number to which bridge wants to issue the transfer
                                         //maximum of 256 slaves can be supported

    rand bit [`ADDR_BUS_WIDTH-1 :0] PADDR;

    rand bit [2:0]                  PPROT;
    
    rand bit [`NO_OF_SLAVE_ON_BUS-1 :0]  PSELx;
    
    rand bit PWRITE;
    
    bit PENABLE;
    
    rand bit [(`DATA_BUS_BYTES*8)-1 :0] PWDATA;
    
    rand bit [`DATA_BUS_BYTES-1 :0]     PSTRB;
    
    bit  PREADY;
    
    bit [(`DATA_BUS_BYTES*8)-1 :0] PRDATA;
    
    bit  PSLVERR;


    //Required methods prototype
    extern function new(string name = "");
    extern function void post_randomize();
    extern function void do_copy(uvm_object rhs);
    extern function uvm_object clone();
    extern function string convert2string();
    extern function string output2string();

endclass:apb_bridge_seq_item

//class constructor method
function apb_bridge_seq_item::new(string name = "");

    super.new(name);

endfunction:new

//post_randomize
function void apb_bridge_seq_item::post_randomize();
    
    for(int i=0; i<`NO_OF_SLAVE_ON_BUS;i++) begin 
        if(i == SELECT_SLAVE)
            this.PSELx[i] = 1'b1;
        else
            this.PSELx[i] = 1'b0;
    end
    
endfunction:post_randomize

//do_copy method
function void apb_bridge_seq_item::do_copy(uvm_object rhs);


    apb_bridge_seq_item rhs_;
    $cast(rhs_,rhs);

    this.tr_type = rhs_.tr_type;
    this.SELECT_SLAVE = rhs_.SELECT_SLAVE;
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
function uvm_object apb_bridge_seq_item::clone();

    apb_bridge_seq_item rhs_;
    rhs_ = apb_bridge_seq_item::type_id::create("rhs_");

    rhs_.copy(this);

    return rhs_;

endfunction:clone

//convert2string method
function string apb_bridge_seq_item::convert2string();

    string s;
    s = super.convert2string();

    if(this.PWRITE) begin
        
        $display("----------------------------------------------");
        $display("SLAVE ID :%0d",this.SELECT_SLAVE);
        $display("WRITE OPERATION\nPADDR :%0h\nPPROT :%0h\nPWDATA :%0h\nPSTRB :%0h",this.PADDR,this.PPROT,this.PWDATA,this.PSTRB);
        $display("----------------------------------------------");
    
    end

    if(!this.PWRITE) begin
        
        $display("----------------------------------------------");
        $display("SLAVE ID :%0d",this.SELECT_SLAVE);
        $display("READ OPERATION\nPADDR :%0h\n",this.PADDR);
        $display("----------------------------------------------");
    
    end

endfunction:convert2string

//output2string method
function string apb_bridge_seq_item::output2string();

    return $sformatf("SLAVE ID :%0d\nPWRITE :%0b\nPADDR :%0h\nPWDATA :%0h\nPRDATA :%0h",this.PSELx,this.PWRITE,this.PADDR,this.PWDATA,this.PRDATA,);

endfunction:output2string
