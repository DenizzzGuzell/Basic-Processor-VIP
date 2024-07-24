module hdl_top;

  import uvm_pkg::*;
  import alu_test_lib_pkg::*;
  import util_pkg::*;
  `include "timescale.sv"

  //Instantiation
  logic i_clk;
  logic i_rst;

  initial begin
      i_clk = 0;
      #9ns;
      forever #5 i_clk = ~i_clk;
  end

  initial begin
      i_rst = 1; 
      #189ns;
      i_rst = 0; 
  end

  alu_interface intf(.i_clk(i_clk),.i_rst(i_rst));

  alu_driver_bfm drv_bfm(intf.driver_port);

  alu_monitor_bfm mon_bfm(intf.monitor_port);

  simple_ALU dut(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_memData(intf.i_memData),
    .o_memData(intf.o_memData),
    .o_memAddr(intf.o_memAddr),
    .o_memWrEnable(intf.o_memWrEnable)
  );

  bind simple_ALU : dut alu_assertions sva (.*);

  //Interface Setting
  initial begin
  import uvm_pkg::uvm_config_db;
    uvm_config_db #(virtual alu_driver_bfm) ::set(null, "uvm_test_top", "drv_bfm", drv_bfm);
    uvm_config_db #(virtual alu_monitor_bfm)::set(null, "uvm_test_top", "mon_bfm", mon_bfm);
  end

  //Maximum Simulation Time
  initial begin
    #10ms;
    $display("Clock cycles DONE!");
    $finish();
  end

endmodule: hdl_top
