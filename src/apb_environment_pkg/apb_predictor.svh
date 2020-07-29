class apb_predictor extends uvm_subscriber #(apb_bridge_seq_item);

    //factory registration
    `uvm_component_utils(apb_predictor)

    //storage element 
    //---DATA_BUS_SIZE wide---         --- slave id---    --address-- 
    bit [(`DATA_BUS_BYTES*8)-1 :0] predict_mem [int]         [int];

    //analysis_port to send predicted transaction to comparator
    uvm_analysis_port #(apb_bridge_seq_item) results_ap;

    //methods
    extern function new(string name,uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void write(apb_bridge_seq_item t);
    extern function apb_bridge_seq_item sb_predict_exp(apb_bridge_seq_item tr);

endclass:apb_predictor

//new
function apb_predictor::new(string name, uvm_component parent);

    super.new(name,parent);

endfunction:new

//build
function void apb_predictor::build_phase(uvm_phase phase);

    super.build_phase(phase);
    results_ap = new("results_ap",this);

endfunction:build_phase

function void apb_predictor::write(apb_bridge_seq_item t);

    apb_bridge_seq_item exp_tr;  //handle to store expected output

    exp_tr = sb_predict_exp(t); //predictes the output for input stimuls

    results_ap.write(exp_tr);    //sent to the apb_comparator

endfunction:write


function apb_bridge_seq_item apb_predictor::sb_predict_exp(apb_bridge_seq_item tr);

    int lower_byte_lane;
    int upper_byte_lane;
    
    apb_bridge_seq_item exp_tr;

    if(tr.PWRITE) begin

        for(int i=0; i < `DATA_BUS_BYTES; i++) begin        //calculate the byte lanes that holds valid write data

            if(tr.PSTRB[i] == 1'b1) begin

                lower_byte_lane = i;
            
                for(int j=i; j < `DATA_BUS_BYTES; j++) begin

                    if(tr.PSTRB[j] == 1'b0) begin
                        break;
                    end
                    i=j;
                end

                upper_byte_lane = i-1;

            end

        end

        predict_mem[tr.PSELx][tr.PADDR] = tr.PWDATA;

    end

    if(!tr.PWRITE) begin

        if(!predict_mem[tr.PSELx].exists(tr.PADDR)) begin    //if not written... write default value 32'hfafafafa

            predict_mem[tr.PSELx][tr.PADDR] = 32'hfa_fa_fa_fa;

        end

        tr.PRDATA = predict_mem[tr.PSELx][tr.PADDR];

    end

    $cast(exp_tr,tr.clone());
  
    return exp_tr;       //return updated transaction

endfunction:sb_predict_exp
