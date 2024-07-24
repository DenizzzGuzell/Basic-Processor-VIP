import alu_agent_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "alu_macros.svh"

interface alu_monitor_bfm (alu_interface intf);

	`alu_MONITOR_STRUCT alu_monitor_s alu_monitor_struct;

	alu_agent_pkg::monitor proxy;

	tri i_clk;
	tri i_rst;
	tri [15:0] i_memData;
	tri [15:0] o_memData;
	tri [15:0] o_memAddr;
	tri o_memWrEnable;

	assign i_clk 	 	 = intf.i_clk;
	assign i_rst 	 	 = intf.i_rst;
	assign i_memData 	 = intf.i_memData;
	assign o_memData 	 = intf.o_memData;
	assign o_memAddr 	 = intf.o_memAddr;
	assign o_memWrEnable = intf.o_memWrEnable;

	int pc = 0;

    task wait_for_reset();                                                                
        wait ( i_rst === 0 );                                                                           
    endtask    

    task wait_for_num_clocks(input int unsigned count); 
        @(posedge i_clk);                             
        repeat (count-1) @(posedge i_clk);                                                    
    endtask  

    event go;                                                                                 
    function void start_monitoring();   
      -> go;
    endfunction    

    initial begin                                                                             
        @go;                                                                                   
        forever begin                                                                        
          @(posedge i_clk);  
          do_monitor( alu_monitor_struct );
        end                                                                                    
    end       

    task do_monitor(output alu_monitor_s alu_monitor_struct);
		if (i_rst) begin                                                               
           wait_for_reset();                                                                
        end else begin
			alu_monitor_struct.r_instruction = i_memData;
			alu_monitor_struct.r_operand1_addr = o_memAddr;
			@(posedge i_clk);
			alu_monitor_struct.r_operand1 = i_memData;
			if (!(alu_monitor_struct.r_instruction[15])) alu_monitor_struct.r_operand2_addr = o_memAddr;
			else 										 alu_monitor_struct.r_operand2_addr = 'h0;
			@(posedge i_clk);
			if (!(alu_monitor_struct.r_instruction[15])) alu_monitor_struct.r_operand2 = i_memData;
			else 										 alu_monitor_struct.r_operand2 = 'h0;
			alu_monitor_struct.we = o_memWrEnable;
			alu_monitor_struct.data_out = o_memData;
			@(posedge i_clk);
			alu_monitor_struct.pc = pc;
			pc++;
            proxy.notify_transaction(alu_monitor_struct);
        end
	endtask
endinterface
