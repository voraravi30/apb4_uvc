class apb_bridge_driver extends uvm_driver #(apb_bridge_seq_item);

    //-------------------------------
    //factory registration
    //-------------------------------
    `uvm_component_utils(apb_bridge_driver)

    //-------------------------------
    //Fields
    //-------------------------------

    //virtual interface handle of apb bridge interface
    virtual apb_bridge_intf.drv_mp APB;

    //seq_item handle to drive request on bus
    apb_bridge_seq_item req;

    //seq_item handle to send response back to sequence
    apb_bridge_seq_item rsp;

    //-------------------------------
    //Required methods prototype
    //-------------------------------
    extern function new(string name,uvm_component parent);
    extern task run_phase(uvm_phase phase);
    extern task drive(apb_bridge_seq_item req,output apb_bridge_seq_item rsp);
    extern task set_up_phase(apb_bridge_seq_item req);
    extern task access_phase(apb_bridge_seq_item req,output apb_bridge_seq_item rsp);

endclass:apb_bridge_driver

//class constructor method
function apb_bridge_driver::new(string name,uvm_component parent);

    super.new(name,parent);

endfunction

//apb_bridge_driver's run_phase method
task apb_bridge_driver::run_phase(uvm_phase phase);
    
    forever begin

        fork

            begin:rst

                wait(!APB.PRESETn);
                disable drv;
                @(posedge APB.PRESETn);

            end

            begin:drv

                wait(APB.drv_cb.PRESETn);

                seq_item_port.get_next_item(req);
                drive(req,rsp);
                
                disable rst;

            end

        join

        seq_item_port.item_done();
        seq_item_port.put_response(rsp);

    end
endtask:run_phase

task apb_bridge_driver:: drive(apb_bridge_seq_item req, output apb_bridge_seq_item rsp);

    set_up_phase(req);        //Set up phase of APB

    access_phase(req,rsp);    //Access Phase of APB just after the Set up phase on next clock

endtask

task apb_bridge_driver::set_up_phase(apb_bridge_seq_item req);

    `uvm_info(get_type_name(),"START OF APB SET UP PHASE",UVM_LOW)

    APB.drv_cb.PSELx  <= req.PSELx;      //select the proper slave by asserting proper PSELx

    APB.drv_cb.PADDR  <= req.PADDR;      //drives the address 

    if(req.tr_type == APB_WRITE) begin
        
        APB.drv_cb.PWRITE <= 1'b1;          //write transfer
        APB.drv_cb.PWDATA <= req.PWDATA;   //provide write data
        APB.drv_cb.PSTRB  <= req.PSTRB;    //strobe value to indicate which byte lane holds valid data
    
    end

    else if(req.tr_type == APB_READ) begin

        APB.drv_cb.PWRITE <= 1'b0;         //read transfer

    end

    else begin

        `uvm_fatal(get_type_name(),"UNSUPPORTED type of transfer is issued by the bridge driver")

    end

    @(posedge APB.PCLK);

    `uvm_info(get_type_name(),"END OF APB SET UP PHASE",UVM_LOW)

endtask:set_up_phase

task apb_bridge_driver::access_phase(input apb_bridge_seq_item req, output apb_bridge_seq_item rsp);

    `uvm_info(get_type_name(),"START OF APB BRIDGE ACCESS PHASE",UVM_LOW)

    APB.drv_cb.PENABLE <= 1'b1;

    @(posedge APB.PCLK);

    wait(APB.drv_cb.PREADY);

    $cast(rsp,req.clone());
    rsp.set_id_info(req);
    
    if(req.tr_type == APB_READ) begin        //samples the read data
        
        req.PRDATA  = APB.drv_cb.PRDATA;
    
    end
    req.PSLVERR = APB.drv_cb.PSLVERR;      //samples the response

    APB.drv_cb.PENABLE <= 1'b0;
    APB.drv_cb.PSELx   <= `NO_OF_SLAVE_ON_BUS'd0; 

    wait(!APB.drv_cb.PREADY);

    `uvm_info(get_type_name(),"END OF APB BRIDGE ACCESS PHASE",UVM_LOW)

endtask:access_phase
