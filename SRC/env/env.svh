class env extends uvm_env;
  `uvm_component_utils(env)

  agent agt;
  scoreboard scb;
  env_config m_cfg;

  //Constructor
  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //Build Phase
  function void build_phase(uvm_phase phase);
	 if(!uvm_config_db #(env_config)::get(this, "", "env_config", m_cfg))
		`uvm_fatal("CONFIG_LOAD", "Cannot get() configuration env_config from uvm_config_db. Have you set() it?")
	 uvm_config_db #(agent_config)::set(this, "agt","agent_config", m_cfg.m_cfge);
    uvm_config_db #(agent_config)::set(this, "scb","agent_config", m_cfg.m_cfge);
    agt = agent::type_id::create("agt", this);
    scb  = scoreboard::type_id::create("scb", this);
  endfunction: build_phase

  //Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.mon_data.connect(scb.scoreboard_port);
  endfunction: connect_phase

  //Run Phase
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

endclass: env
