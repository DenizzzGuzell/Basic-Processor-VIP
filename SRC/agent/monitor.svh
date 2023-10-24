class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual monitor_bfm mon_bfm;
  agent_config m_cfge;

  uvm_analysis_port #(sequence_item) mon_data;

  //Constructor
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  //Build Phase
  function void build_phase(uvm_phase phase);
    mon_data = new("monitor_port", this);
   `get_config(agent_config, m_cfge, "agent_config")
	 mon_bfm = m_cfge.cfg_mon_bfm;
    mon_bfm.proxy = this;
  endfunction: build_phase

  //Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase


  //Run Phase
  task run_phase (uvm_phase phase);
     mon_bfm.run();
  endtask: run_phase

	function void notify_transaction(sequence_item item);
		mon_data.write(item);
	endfunction : notify_transaction
endclass: monitor
