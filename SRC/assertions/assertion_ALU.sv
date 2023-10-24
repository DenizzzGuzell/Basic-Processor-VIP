module assertion_ALU (
	input [15:0] i_memData, o_memData, o_memAddr,
	input i_clk, i_rst, o_memWrEnable
);

	property o_Data_check_0;
		@(posedge i_clk)
		disable iff (i_rst) o_memData > 0 |-> $past(o_memData, 3) == 0 and  $past(o_memData, 2) == 0 and $past(o_memData, 1) == 0;
	endproperty

	property o_Data_check_1;
		@(posedge i_clk)
		disable iff (i_rst) o_memData > 0 |-> ##1 o_memData == 0[*3];
	endproperty

	property o_memAddr_check;
		@(posedge i_clk)
		disable iff (i_rst) $rose(o_memWrEnable) |-> (o_memAddr == $past(o_memAddr, 2));
	endproperty

	a_o_Data_check_0    : assert property(o_Data_check_0)	  	else $error("Output mem data is not set zero when IDLE at time %0t", $time);
	a_o_Data_check_1    : assert property(o_Data_check_1)	  	else $error("Output Frame not appropriate at time %0t", $time);
	a_o_memAddr_check   : assert property(o_memAddr_check)  	else $error("Enable signal and Addr change not appropriate at time %0t", $time);

endmodule : assertion_ALU
