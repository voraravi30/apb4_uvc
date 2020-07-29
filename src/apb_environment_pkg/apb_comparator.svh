class apb_comparator extends uvm_component;

    //factory registration
    `uvm_component_utils(apb_comparator)

    //fields
    int VECT_CNT, PASS_CNT ,ERROR_CNT;

    //analysis port for axp_in and axp_out
    uvm_analysis_export #(apb_bridge_seq_item) axp_in;
    uvm_analysis_export #(apb_bridge_seq_item) axp_out;

    uvm_tlm_analysis_fifo #(apb_bridge_seq_item) exp_fifo;  //fifo for expected output of input stimuls
    uvm_tlm_analysis_fifo #(apb_bridge_seq_item) out_fifo;       //fifo for actual output for input stimuls

    //methods
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    extern function bit sb_compare(apb_bridge_seq_item exp_tr, apb_bridge_seq_item out_tr);
    extern function void PASS();
    extern function void FAILS();

endclass:apb_comparator

//new
function apb_comparator::new(string name, uvm_component parent);

    super.new(name,parent);

endfunction:new

//build_phase
function void apb_comparator::build_phase(uvm_phase phase);

    super.build_phase(phase);

    axp_in  = new("axp_in",this);
    axp_out = new("axp_out",this);

    exp_fifo = new("exp_fifo",this);
    out_fifo = new("out_fifo",this);

endfunction:build_phase

//connect_phase
function void apb_comparator::connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    axp_in.connect(exp_fifo.analysis_export);
    axp_out.connect(out_fifo.analysis_export);

endfunction:connect_phase

//run_phase
task apb_comparator::run_phase(uvm_phase phase);

    apb_bridge_seq_item exp_tr;
    apb_bridge_seq_item  out_tr;

    forever begin

        `uvm_info("COMPARATOR RUN TASK","WAITING FOR AN EXPECTED OUTPUT",UVM_LOW)

        exp_fifo.get(exp_tr);

        `uvm_info("COMPARATOR RUN TASK","WAITING FOR AN ACTUAL OUTPUT",UVM_LOW)

        out_fifo.get(out_tr);

        if(sb_compare(exp_tr,out_tr)) begin

            `uvm_info("PASS",$sformatf("\n************\nActual = %s\nExpected = %s\n************",out_tr.output2string(),exp_tr.output2string),UVM_LOW)
            PASS();

        end

        else begin

            `uvm_error("FAILS",$sformatf("\n************\nActual = %s\nExpected = %s\n************",out_tr.output2string(),exp_tr.output2string))
            FAILS();

        end

    end

endtask:run_phase

//report_phase
function void apb_comparator::report_phase(uvm_phase phase);

    super.report_phase(phase);

    if(VECT_CNT && !ERROR_CNT) begin
        
        `uvm_info("REPORT PHASE",$sformatf("\n\n\n*** TEST PASSED - %0d vectors ran, %0d vectors passed ***\n",VECT_CNT, PASS_CNT), UVM_LOW)

    end

    else begin

        `uvm_info("REPORT PHASE",$sformatf("\n\n\n*** TEST FAILD - %0d vectors ran, %0d vectors passed, %0d vectors failed ***\n",VECT_CNT, PASS_CNT,ERROR_CNT), UVM_LOW)

    end
endfunction:report_phase

//compare method
function bit apb_comparator::sb_compare(apb_bridge_seq_item exp_tr, apb_bridge_seq_item out_tr);

    if(!exp_tr.PWRITE)
        return (exp_tr.PRDATA == out_tr.PRDATA);
    else
        return (exp_tr.PWDATA == out_tr.PWDATA);

endfunction:sb_compare

function void apb_comparator::PASS();

    VECT_CNT++;
    PASS_CNT++;

endfunction:PASS

function void apb_comparator::FAILS();

    VECT_CNT++;
    ERROR_CNT++;

endfunction:FAILS
