class agent extends uvm_component;
  `uvm_component_utils(agent)

  uvm_analysis_port#(sequence_item) mon_data;
  driver drv;
  monitor mon;
  sequencer seqr;

  //Constructor
  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  //Build Phase
  function void build_phase(uvm_phase phase);
    agent_config m_cfge;
	 `get_config(agent_config, m_cfge, "agent_config")
    drv = driver::type_id::create("drv", this);
    drv.m_cfge = m_cfge;
    mon = monitor::type_id::create("mon", this);
    mon.m_cfge = m_cfge;
	 seqr = sequencer::type_id::create("seqr", this);
  endfunction: build_phase

  //Connect Phase
  function void connect_phase(uvm_phase phase);
    mon_data = mon.mon_data;
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction: connect_phase

  //Run Phase
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

endclass: agent
