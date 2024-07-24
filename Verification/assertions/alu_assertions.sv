module alu_assertions (
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

	property final_state_check;
		@(posedge i_clk)
		disable iff (i_rst) $fell(o_memWrEnable) |-> (i_memData == 0);
	endproperty

	property instr_addr_check;
		@(posedge i_clk)
		disable iff (i_rst) $fell(o_memWrEnable) && (o_memAddr != 'h1) |-> ($past(o_memAddr, 4) == o_memAddr - 1);
	endproperty

	property instr_addr_overflow_check;
		@(posedge i_clk)
		disable iff (i_rst) $fell(o_memWrEnable) && (o_memAddr == 'h1) |-> ($past(o_memAddr, 4) == 'h40) or ($past(o_memAddr, 4) == 'h0);
	endproperty

	property r1_addr_check;
		@(posedge i_clk)
		disable iff (i_rst) $fell(o_memWrEnable) |=> (o_memAddr == i_memData [11:6]) and (i_memData [11:6] > 31);
	endproperty

	property r2_addr_check;
		@(posedge i_clk)
		disable iff (i_rst) $fell(o_memWrEnable) ##1 (i_memData [15] == 0) |-> (i_memData [5:0] > 31);
	endproperty

	property after_reset_r1_addr_check;
		@(posedge i_clk) $fell(i_rst) |-> (o_memAddr == i_memData [11:6]) and (i_memData [11:6] > 31);
	endproperty

	property after_reset_r2_addr_check;
		@(posedge i_clk) $fell(i_rst) && (i_memData [15] == 0) |-> (i_memData [5:0] > 31);
	endproperty

	a_o_Data_check_0    			: assert property(o_Data_check_0)	  					else $error("Output mem data is not set zero when IDLE at time %0t", $time);
	a_o_Data_check_1    			: assert property(o_Data_check_1)	  					else $error("Output Frame not appropriate at time %0t", $time);
	a_o_memAddr_check   			: assert property(o_memAddr_check)  					else $error("Enable signal and Addr change not appropriate at time %0t", $time);
	a_final_state_check				: assert property(final_state_check)  					else $error("PC state instruction is not zero at time %0t", $time);
	a_instr_addr_check				: assert property(instr_addr_check)  					else $error("Instruction memory read address is not consequtive at time %0t", $time);
	a_instr_addr_overflow_check		: assert property(instr_addr_overflow_check)  			else $error("Instruction memory read address overflow is not expected at time %0t", $time);
	a_r1_addr_check					: assert property(r1_addr_check)  						else $error("Operand 1 Data address cannot be less then 32 at time %0t", $time);
	a_r2_addr_check					: assert property(r2_addr_check)  						else $error("Operand 2 Data address cannot be less then 32 at time %0t", $time);
	a_after_reset_r1_addr_check		: assert property(after_reset_r1_addr_check)  			else $error("After reset Operand 1 Data address cannot be less then 32 at time %0t", $time);
	a_after_reset_r2_addr_check		: assert property(after_reset_r2_addr_check)  			else $error("After reset Operand 2 Data address cannot be less then 32 at time %0t", $time);
endmodule : alu_assertions
