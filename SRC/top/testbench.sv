`timescale 1ps/1fs
//////////////////////////////////////////////
// Engineer: Deniz Güzel
// Create Date: 01/12/2022 11:38:27 AM
// Description: UVM verification of simple ALU
//////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"

//Include Files
import test_lib_pkg::*;
`include "../SRC/assertions/assertion_ALU.sv"

module top;

  //Instantiation
  logic i_clk;
  logic i_rst;

  s_interface intf(.i_clk(i_clk),.i_rst(i_rst));

  driver_bfm drv_bfm(
   .i_clk(i_clk),
	.i_memData(intf.i_memData)
  );

  monitor_bfm mon_bfm(
  	 .i_clk(i_clk),
  	 .i_reset(i_rst),
    .i_memData(intf.i_memData),
    .o_memData(intf.o_memData),
    .o_memAddr(intf.o_memAddr),
    .o_memWrEnable(intf.o_memWrEnable)
  );

  simple_ALU dut(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_memData(intf.i_memData),
    .o_memData(intf.o_memData),
    .o_memAddr(intf.o_memAddr),
    .o_memWrEnable(intf.o_memWrEnable)
  );

  bind simple_ALU : dut assertion_ALU sva (.*);

  //Interface Setting
  initial begin
  import uvm_pkg::uvm_config_db;
    uvm_config_db #(virtual driver_bfm) ::set(null, "uvm_test_top", "drv_bfm", drv_bfm);
    uvm_config_db #(virtual monitor_bfm)::set(null, "uvm_test_top", "mon_bfm", mon_bfm);
  end

  //Start The Test
  initial begin
    run_test("test");
	 #100ns;
  end

  //Reset Generation
  initial begin
    i_rst = 1'b1;
	 #60ns;
	 i_rst <= ~i_rst;
  end

  //Clock Generation
  initial begin
    i_clk = 0;
    forever begin
      i_clk = ~i_clk;
      #2ns;
    end
  end

  //Maximum Simulation Time
  initial begin
    #5000ns;
    $display("Clock cycles DONE!");
    $finish();
  end

  //Generate Waveforms
  initial begin
    $dumpfile("top.vcd");
    $dumpvars(0,top);
  end

endmodule: top
