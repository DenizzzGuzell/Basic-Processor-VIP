class test_base extends uvm_test;
  `uvm_component_utils (test_base)

function new (string name, uvm_component parent = null);
  super.new(name, parent);
endfunction

  env m_top_env;
  env_config m_env_cfg;
  agent_config m_cfge;

function void build_phase (uvm_phase phase);
  super.build_phase (phase);
  m_env_cfg = env_config::type_id::create("m_env_cfg");
  m_cfge = agent_config::type_id::create("m_cfge");
  m_top_env = env::type_id::create ("m_top_env", this);

  if(!uvm_config_db #(virtual driver_bfm)::get(this, "", "drv_bfm", m_cfge.cfg_drv_bfm))
	`uvm_fatal("VIF CONFIG", "Cannot get() BFM interface drv_bfm from uvm_config_db. Have you set() it?")
  if(!uvm_config_db #(virtual monitor_bfm)::get(this, "", "mon_bfm",m_cfge.cfg_mon_bfm))
	`uvm_fatal("VIF CONFIG", "Cannot get() BFM interface mon_bfm from uvm_config_db. Have you set() it?")

  m_env_cfg.m_cfge = m_cfge;
  uvm_config_db #(env_config)::set(this, "*", "env_config", m_env_cfg);
endfunction

endclass
