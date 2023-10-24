class driver extends uvm_driver#(sequence_item, sequence_item);
  `uvm_component_utils(driver)

	virtual driver_bfm drv_bfm;
	agent_config m_cfge;

  //Constructor
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  //Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `get_config(agent_config, m_cfge, "agent_config")
     drv_bfm = m_cfge.cfg_drv_bfm;
  endfunction: build_phase

  //Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase

  //Run Phase
  task run_phase (uvm_phase phase);
  	  forever begin
        sequence_item drv_req;
        drv_bfm.drv_cfg = m_cfge;
        seq_item_port.get_next_item(drv_req);
        drv_bfm.drive(drv_req);
        seq_item_port.item_done();
     end
  endtask: run_phase

endclass: driver
