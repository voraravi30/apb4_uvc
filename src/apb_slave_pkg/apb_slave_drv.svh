class apb_slave_driver extends uvm_driver #(apb_slave_seq_item);

    //-------------------------------
    //factory registration
    //-------------------------------
    `uvm_component_utils(apb_slave_driver)

    //-------------------------------
    //Fields
    //-------------------------------

    //virtual interface handle of apb slave interface
    virtual apb_slave_intf.drv_mp APB;

    //seq_item handle to drive request on bus
    apb_slave_seq_item req;

    //seq_item handle to send response back to sequence
    apb_slave_seq_item rsp;

    //-------------------------------
    //Required methods prototype
    //-------------------------------
    extern function new(string name,uvm_component parent);
    extern task run_phase(uvm_phase phase);
    extern task drive(apb_slave_seq_item req);
    extern task set_up_phase(apb_slave_seq_item req);
    extern task access_phase(apb_slave_seq_item rsp);

endclass:apb_slave_driver

//class constructor method
function apb_slave_driver::new(string name,uvm_component parent);

    super.new(name,parent);

endfunction

//apb_slave_driver's run_phase method
task apb_slave_driver::run_phase(uvm_phase phase);
    
    forever begin

        if(!APB.PRESETn) begin

            APB.drv_cb.PREADY <= 1'b0;
            APB.drv_cb.PSLVERR <= 1'b0;
            @(posedge APB.PRESETn);

        end

        else begin

            wait(APB.drv_cb.PRESETn);
            drive(req);

        end

    end
endtask:run_phase

task apb_slave_driver::drive(apb_slave_seq_item req);

    //set up phase
    seq_item_port.get_next_item(req);

    set_up_phase(req);

    seq_item_port.item_done();

    //access phase
    seq_item_port.get_next_item(rsp);

    access_phase(rsp);

    seq_item_port.item_done();

endtask:drive

//set up phase method
task apb_slave_driver::set_up_phase(apb_slave_seq_item req);

    `uvm_info(get_type_name(),"START OF SET UP PHASE OF SLAVE",UVM_LOW)

    wait(APB.drv_cb.PSELx);  //waits untils the slave selected
       
    `uvm_info(get_type_name(),"SLAVE SELECTED",UVM_LOW)

    //samples the signals for set up phase
    req.PADDR  = APB.drv_cb.PADDR;
    req.PPROT  = APB.drv_cb.PPROT;
    req.PWDATA = APB.drv_cb.PWDATA;
    req.PSTRB  = APB.drv_cb.PSTRB;
    req.PWRITE = APB.drv_cb.PWRITE;

    `uvm_info(get_type_name(),"END OF SET UP PHASE OF SLAVE",UVM_LOW)

endtask:set_up_phase

//access phase method
task apb_slave_driver::access_phase(apb_slave_seq_item rsp);

    `uvm_info(get_type_name(),$sformatf("START OF ACCESS PHASE OF SLAVE WITH WAIT_STATE OF %0d CYCLE",rsp.wait_state),UVM_LOW)

     repeat(rsp.wait_state) begin //wait_state times wait state added before completing the transfer
     
         @(posedge APB.PCLK);
     
     end

     wait(APB.drv_cb.PENABLE);

    APB.drv_cb.PREADY <= 1'b1;    //assert the PREADY to complete the transfer

    if(!rsp.PWRITE) begin          //drive PRDATA if response is for read type transfer

        `uvm_info(get_type_name(),$sformatf("PROVIDING THE READ DATA RESPONSE : %0h",rsp.PRDATA),UVM_LOW)
        APB.drv_cb.PRDATA <= rsp.PRDATA;

    end

    APB.drv_cb.PSLVERR <= rsp.PSLVERR; //drive the status

    @(posedge APB.PCLK);

    APB.drv_cb.PREADY <= 1'b0;
    APB.drv_cb.PSLVERR <= 1'b0;


    wait(!APB.drv_cb.PENABLE);


    `uvm_info(get_type_name(),"END OF ACCESS PHASE OF SLAVE",UVM_LOW)

endtask:access_phase
