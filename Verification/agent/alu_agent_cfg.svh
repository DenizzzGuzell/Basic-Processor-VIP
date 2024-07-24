class alu_agent_config extends uvm_object;
 `uvm_object_utils(alu_agent_config)

//Configuration variables
  virtual alu_driver_bfm    cfg_drv_bfm;  // virtual alu_driver BFM
  virtual alu_monitor_bfm   cfg_mon_bfm;  // virtual monitor BFM

function new(string name="alu_agent_config");
  super.new(name);
endfunction

function alu_agent_config get_config( uvm_component c );
  alu_agent_config t;
  if (!uvm_config_db #(alu_agent_config)::get(c, "", "alu_agent_config", t) )
     `uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration t from uvm_config_db. Have you set() it?"))
  return t;
endfunction

virtual task wait_for_reset();
    cfg_mon_bfm.wait_for_reset();
endtask

virtual task wait_for_num_clocks(int clocks);
    cfg_mon_bfm.wait_for_num_clocks(clocks);
endtask

endclass: alu_agent_config
