class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual alu_monitor_bfm mon_bfm;
  alu_agent_config m_cfge;

  uvm_analysis_port #(alu_sequence_item) mon_ap;

  alu_sequence_item trans;

  `alu_MONITOR_STRUCT alu_monitor_s alu_monitor_struct;

  //Constructor
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  //Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("monitor_port", this);
  endfunction: build_phase

  //Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `get_config(alu_agent_config, m_cfge, "alu_agent_config")
	  mon_bfm = m_cfge.cfg_mon_bfm;
    mon_bfm.proxy = this;
  endfunction: connect_phase

  //Run Phase
  task run_phase (uvm_phase phase);
     mon_bfm.start_monitoring();
  endtask: run_phase

  protected virtual function void analyze(alu_sequence_item trans);
        mon_ap.write(trans);
        `uvm_info(get_type_name(), trans.convert2string(), UVM_DEBUG);
  endfunction

	virtual function void notify_transaction(input alu_monitor_s alu_monitor_struct);
        trans = new("trans");                                 
        trans.from_monitor_struct(alu_monitor_struct);
        analyze(trans);                                                                         
  endfunction  

endclass: monitor
