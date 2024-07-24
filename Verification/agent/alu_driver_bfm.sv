import alu_agent_pkg::*;
`include "alu_macros.svh"

interface alu_driver_bfm(alu_interface intf);

  `alu_DRIVER_STRUCT alu_driver_s driver_struct;

  alu_agent_config drv_cfg;

  alu_agent_pkg::alu_driver proxy;

	tri i_clk;
	tri i_rst;
	reg [15:0] i_memData;
	tri [15:0] o_memData;
	tri [15:0] o_memAddr;
	tri o_memWrEnable;

	assign i_clk 	 	        = intf.i_clk;
	assign i_rst 	 	        = intf.i_rst;
	assign intf.i_memData   = i_memData;
	assign o_memData 	      = intf.o_memData;
	assign o_memAddr 	      = intf.o_memAddr;
	assign o_memWrEnable    = intf.o_memWrEnable;

  always @(posedge i_rst) begin
       i_memData <= 'h0;
  end 

  task wait_for_reset();                                                                     
        wait (i_rst === 0);                                                                             
  endtask 

  task drive(input alu_driver_s alu_driver_struct);
      wait_for_reset();
      driver_struct = alu_driver_struct;
      i_memData = alu_driver_struct.i_memData;
      @(posedge i_clk);
  endtask: drive

endinterface: alu_driver_bfm
