class apb_storage_component extends uvm_component;
    
    //factory registration
    `uvm_component_utils(apb_storage_component)

    //storage element
    bit  [`DATA_BUS_BYTES*8-1 :0] mem [int];

    //API to access the storage element
    extern function bit [`DATA_BUS_BYTES*8-1 :0] read( bit [`ADDR_BUS_WIDTH-1 :0] addr);
    extern function void write(bit [`ADDR_BUS_WIDTH-1 :0] addr, bit [(`DATA_BUS_BYTES*8)-1 :0] data);

    //constructor method
    extern function new(string name, uvm_component parent);

endclass:apb_storage_component

//constructor method
function apb_storage_component::new(string name, uvm_component parent);

    super.new(name,parent);

endfunction:new

//read memory API
function bit [`DATA_BUS_BYTES*8-1 :0] apb_storage_component::read( bit [`ADDR_BUS_WIDTH-1 :0] addr);

    return mem[addr];

endfunction:read

//write memory API
function void apb_storage_component::write(bit [`ADDR_BUS_WIDTH-1 :0] addr, bit [(`DATA_BUS_BYTES*8)-1 :0] data);

    mem[addr] = data;

endfunction:write
