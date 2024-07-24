class alu_agent extends uvm_component;
  `uvm_component_utils(alu_agent)

  uvm_analysis_port#(alu_sequence_item) mon_ap;
  
  alu_driver drv;
  monitor mon;
  uvm_sequencer #(alu_sequence_item) seqr;
  alu_agent_config m_cfge;

  //Constructor
  function new(string name = "alu_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  //Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	  `get_config(alu_agent_config, m_cfge, "alu_agent_config")
    drv = alu_driver::type_id::create("drv", this);
    drv.m_cfge = m_cfge;
    mon = monitor::type_id::create("mon", this);
    mon.m_cfge = m_cfge;
	  seqr = uvm_sequencer#(alu_sequence_item)::type_id::create("seqr",this);
    mon_ap = new("mon_ap",this);
  endfunction: build_phase

  //Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mon.mon_ap.connect(mon_ap);
    mon_ap = mon.mon_ap;
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction: connect_phase

endclass: alu_agent
