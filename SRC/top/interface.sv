interface s_interface(input logic i_clk, input logic i_rst);

  logic [15:0] i_memData;
  logic [15:0] o_memData;
  logic [15:0] o_memAddr;
  logic o_memWrEnable;

endinterface: s_interface
