DEPTH                 = ..

INTERFACE_HOME        = ../apb_intf
CFG                   = ../apb_test_pkg/apb_config_.svh

BUS_bridge_AGNT_HOME  = $(DEPTH)/apb_bridge_pkg
BUS_bridge_AGNT_FILES  = $(BUS_bridge_AGNT_HOME)/apb_bridge_agent_pkg.sv
BUS_SLAVE_AGNT_HOME   = $(DEPTH)/apb_slave_pkg
BUS_SLAVE_AGNT_FILES  = $(BUS_SLAVE_AGNT_HOME)/apb_slave_agent_pkg.sv

BUS_ENV_HOME          = $(DEPTH)/apb_environment_pkg
BUS_ENV_FILES         = $(BUS_ENV_HOME)/apb_environment_pkg.sv

BUS_TEST_HOME         = $(DEPTH)/apb_test_pkg
BUS_TEST_FILES        = $(BUS_TEST_HOME)/apb_test_pkg.sv

BUS_TOP_HOME          = $(DEPTH)/apb_top
BUS_TOP_FILES         = $(BUS_TOP_HOME)/apb_top.sv

lib:
	vlib work


comp:
	 vlog\
		  +incdir+$(INTERFACE_HOME) \
		  +incdir+$(BUS_bridge_AGNT_HOME) \
		  +incdir+$(BUS_SLAVE_AGNT_HOME) \
		  +incdir+$(BUS_ENV_HOME) \
		  +incdir+$(BUS_TEST_HOME) \
		  +incdir+$(BUS_TOP_HOME) \
		  $(BUS_bridge_AGNT_FILES) \
		  $(BUS_SLAVE_AGNT_FILES) \
		  $(BUS_ENV_FILES) \
		  $(BUS_TEST_FILES)\
		  $(BUS_TOP_FILES)
#------------------------------------------		  
#fixed transaction
#------------------------------------------		  

apb_write:
	vsim -novopt apb_top -c -do "run -all;exit" +UVM_TESTNAME=apb_test_write +UVM_VERBOSITY=UVM_LOW +UVM_OBJECTION_TRACE +UVM_PHASE_TRACE
gui_write:
	vsim -novopt apb_top +UVM_TESTNAME=apb_test_write +UVM_VERBOSITY=UVM_LOW
