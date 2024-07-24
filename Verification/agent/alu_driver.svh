class alu_driver extends uvm_driver#(alu_sequence_item, alu_sequence_item);
  `uvm_component_utils(alu_driver)

	virtual alu_driver_bfm drv_bfm;
	alu_agent_config m_cfge;

  alu_sequence_item drv_req;

  `alu_DRIVER_STRUCT alu_driver_s driver_struct;

  //Constructor
  function new(string name = "alu_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  //Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `get_config(alu_agent_config, m_cfge, "alu_agent_config")
     
  endfunction: build_phase

  //Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv_bfm = m_cfge.cfg_drv_bfm;
    if (drv_bfm == null) `uvm_fatal(get_type_name(), $sformatf("BFM handle is null"));
    drv_bfm.proxy = this;
  endfunction: connect_phase

  //Run Phase
  task run_phase (uvm_phase phase);
    drv_bfm.drv_cfg = m_cfge;
  	  forever begin
        seq_item_port.get_next_item(drv_req);
        drv_bfm.drive(drv_req.to_driver_struct);
        seq_item_port.item_done();
      end
  endtask: run_phase

endclass: alu_driver
