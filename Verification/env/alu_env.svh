class alu_env extends uvm_env;
  `uvm_component_utils(alu_env)

  alu_agent agt;
  alu_scoreboard scb;
  alu_env_config m_cfg;
  alu_coverage cvr;

  //Constructor
  function new(string name = "alu_env", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //Build Phase
  function void build_phase(uvm_phase phase);
	 if(!uvm_config_db #(alu_env_config)::get(this, "", "alu_env_config", m_cfg))
		`uvm_fatal("CONFIG_LOAD", "Cannot get() configuration alu_env_config from uvm_config_db. Have you set() it?")
	  uvm_config_db #(alu_agent_config)::set(this, "agt","alu_agent_config", m_cfg.m_cfge);
    uvm_config_db #(alu_agent_config)::set(this, "scb","alu_agent_config", m_cfg.m_cfge);
    agt = alu_agent::type_id::create("agt", this);
    scb = alu_scoreboard::type_id::create("scb", this);
    cvr = alu_coverage::type_id::create("cvr", this);
  endfunction: build_phase

  //Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.mon_ap.connect(scb.scoreboard_port);
    agt.mon.mon_ap.connect(cvr.analysis_export);
  endfunction: connect_phase

endclass: alu_env
