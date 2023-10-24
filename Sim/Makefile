dirs := agent sequences env test tb design
dir_agents := ../SRC/agent
dir_sequences := ../SRC/sequences
dir_env := ../SRC/env
dir_test := ../SRC/test
dir_tb := ../SRC/top
dir_design := ../SRC/design
dir_assertion := ../SRC/assertions

COVERAGE ?= yes

#UVM_LIB_PATH = ${VCS_HOME}/etc/uvm-1.1
#SIMULATOR = VCS

VLOG = vlogan
VLOG_OPTS = -nc -sverilog -full64 -ntb_opts uvm-1.1 +define+UVM_HDL_MAX_WIDTH=128

VCS = vcs
VCS_OPTS = -nc -full64 -sverilog -ntb_opts uvm-1.1 -debug_access+all+f -lca -Mdir=LIBS/csrc +warn=all +lint=all,noVCDE,noNS +vcs+vcdpluson -sva_bind_enable

TEST_NAME = i_test

ifeq ($(COVERAGE),yes)
	VCS_OPTS+=-cm line
	SIMV_OPTS+=-cm line
endif

all : clean AN elab run

AN:
	mkdir LIBS
	$(VLOG) $(VLOG_OPTS) $(dir_design)/design.sv
	$(VLOG) $(VLOG_OPTS)
	$(VLOG) $(VLOG_OPTS) +incdir+$(dir_agents) $(dir_agents)/agent_pkg.sv
	$(VLOG) $(VLOG_OPTS) +incdir+$(dir_env) $(dir_env)/env_pkg.sv
	$(VLOG) $(VLOG_OPTS) +incdir+$(dir_test) $(dir_test)/test_lib_pkg.sv
	$(VLOG) $(VLOG_OPTS) $(dir_tb)/interface.sv
	$(VLOG) $(VLOG_OPTS) $(dir_agents)/driver_bfm.sv
	$(VLOG) $(VLOG_OPTS) $(dir_agents)/monitor_bfm.sv
	$(VLOG) $(VLOG_OPTS) $(dir_assertion)/assertion_ALU.sv
	$(VLOG) $(VLOG_OPTS) -timescale=1ns/10ps ${dir_tb}/testbench.sv

elab:
	$(VCS) $(VCS_OPTS) top -l comp.log

#comp:
#	vlogan -sverilog -ntb_opts uvm-1.1
#	vlogan -sverilog -ntb_opts uvm-1.1 $(dir_agents)/clk_rst_agent_pkg.sv $(dir_env)/clk_rst_env_pkg.sv $(dir_test)/clk_rst_test_lib_pkg.sv \
#	${dir_tb}/hld_top.sv ${dir_test}/clk_rst_default_test.svh -kdb +incdir+$(dir_agents) +incdir+$(dir_env) +incdir+$(dir_test) +incdir+$(dir_tb)	vcs -sverilog -timescale=1ns/1ps -debug_access+all +vpi -ntb_opts uvm-1.1 work.tb work.test -l comp_log

run: test

test:
	 ./simv -gui +UVM_NO_RELNOTES +ntb_random_seed_automatic +UVM_TESTNAME=i_test $(SIMV_OPTS) -l simv.log

clean:
	rm -rf AN.DB csrc simv* ucli* LIBS *.log 64






