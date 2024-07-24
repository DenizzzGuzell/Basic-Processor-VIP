interface alu_interface(
  input tri i_clk, 
  input tri i_rst,
  inout tri [15:0] i_memData,
  inout tri [15:0] o_memData,
  inout tri [15:0] o_memAddr,
  inout tri o_memWrEnable
  );

  modport monitor_port(
    input i_clk, 
    input i_rst,
    input i_memData,
    input o_memData,
    input o_memAddr,
    input o_memWrEnable
  );

  modport driver_port(
    input i_clk, 
    input i_rst,
    output i_memData,
    input o_memData,
    input o_memAddr,
    input o_memWrEnable
  );


endinterface: alu_interface
