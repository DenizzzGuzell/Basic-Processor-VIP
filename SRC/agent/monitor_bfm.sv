interface monitor_bfm (
  input logic i_clk,
  input logic i_reset,
  input logic [15:0] i_memData,
  input logic [15:0] o_memData,
  input logic [15:0] o_memAddr,
  input logic o_memWrEnable
);
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import agent_pkg::*;

  agent_config m_cfge;
  monitor proxy;

task run();
  sequence_item cloned_item;
  sequence_item mon_req;
  mon_req = sequence_item::type_id::create("mon_req");
  forever begin
  		if(i_reset) begin
				@(negedge i_reset) begin
					mon_req.r_instruction = i_memData;
				end
				@(negedge i_clk) begin
						mon_req.r_operand1 = i_memData;
				end
		end
		else begin
				mon_req.r_instruction = i_memData;
			end
			@(posedge i_clk) begin
				mon_req.r_operand1    = i_memData;
			end
			@(posedge o_memWrEnable) begin
				@(negedge i_clk) begin
					mon_req.r_operand2 = i_memData;
					mon_req.o_memData  = o_memData;
					mon_req.o_memWrEnable = o_memWrEnable;
			end
			@(posedge i_clk);
			@(posedge i_clk);
  	   end
	$cast(cloned_item, mon_req.clone());
  	proxy.notify_transaction(cloned_item);
  end
endtask: run
endinterface
