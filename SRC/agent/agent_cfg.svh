import uvm_pkg::*;
`include "uvm_macros.svh"

class agent_config extends uvm_object;
 `uvm_object_utils(agent_config)

//Configuration variables
  virtual driver_bfm    cfg_drv_bfm;  // virtual driver BFM
  virtual monitor_bfm   cfg_mon_bfm;  // virtual monitor BFM

function new(string name="agent_config");
  super.new(name);
endfunction

function agent_config get_config( uvm_component c );
  agent_config t;
  if (!uvm_config_db #(agent_config)::get(c, "", "agent_config", t) )
     `uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration t from uvm_config_db. Have you set() it?"))
  return t;
endfunction

endclass: agent_config
