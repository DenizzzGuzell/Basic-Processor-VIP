interface driver_bfm(
  input  logic i_clk,
  output logic [15:0] i_memData
);
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import agent_pkg::*;

  agent_config drv_cfg;

  task clear_signals(sequence_item drv_req);
	 i_memData = 16'h0000;
  endtask

  task drive(sequence_item drv_req);
			@(posedge i_clk) begin
        i_memData = drv_req.i_memData;
   	  end
endtask: drive

endinterface: driver_bfm
