class alu_test_base extends uvm_test;
  `uvm_component_utils (alu_test_base)

function new (string name, uvm_component parent = null);
  super.new(name, parent);
endfunction

  alu_env m_top_env;
  alu_env_config m_env_cfg;
  alu_agent_config m_cfge;
  alu_base_sequence b_seq;

  int repeat_count = 1; 

function void build_phase (uvm_phase phase);
  super.build_phase (phase);
  m_env_cfg = alu_env_config::type_id::create("m_env_cfg");
  m_cfge = alu_agent_config::type_id::create("m_cfge");
  m_top_env = alu_env::type_id::create ("m_top_env", this);
  b_seq = alu_base_sequence::type_id::create ("b_seq", this);

  if(!uvm_config_db #(virtual alu_driver_bfm)::get(this, "", "drv_bfm", m_cfge.cfg_drv_bfm))
	`uvm_fatal("VIF CONFIG", "Cannot get() BFM interface drv_bfm from uvm_config_db. Have you set() it?")
  if(!uvm_config_db #(virtual alu_monitor_bfm)::get(this, "", "mon_bfm",m_cfge.cfg_mon_bfm))
	`uvm_fatal("VIF CONFIG", "Cannot get() BFM interface mon_bfm from uvm_config_db. Have you set() it?")

  m_env_cfg.m_cfge = m_cfge;
  uvm_config_db #(alu_env_config)::set(this, "*", "alu_env_config", m_env_cfg);
endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_root r;
        uvm_report_server rs;
        uvm_factory f;
        super.end_of_elaboration_phase(phase);
        if (get_report_verbosity_level() >= int'(UVM_MEDIUM)) begin
            r = uvm_root::get();
            f = uvm_factory::get();
            f.print();
            r.print_topology();
        end
    endfunction

  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this, "Objection raised by alu_system_test");
    repeat(repeat_count) b_seq.start(m_top_env.agt.seqr);
    phase.drop_objection(this, "Objection raised by alu_system_test");
  endtask: run_phase

virtual function void final_phase (uvm_phase phase);
  uvm_report_server svr;

  super.final_phase(phase);

  svr = uvm_report_server::get_server();

  if(svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) $display("////////// TEST FAILED //////////");
  else                                                                          $display("////////// TEST PASSED //////////");
endfunction

endclass
