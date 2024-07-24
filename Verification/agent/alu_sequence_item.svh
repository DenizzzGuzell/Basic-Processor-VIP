class alu_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(alu_sequence_item)

  //DRV
    rand logic [15:0] i_memData;

  //MON
    bit [15:0] r_instruction ; 
    bit [15:0] r_operand1 ; 
    bit [15:0] r_operand2 ; 
    bit [15:0] data_out ; 
    bit [15:0] r_operand1_addr ; 
    bit [15:0] r_operand2_addr ;
    bit we ; 
    int pc ; 

  `alu_DRIVER_STRUCT
  alu_driver_s alu_driver_struct;
  
  `alu_TO_DRIVER_STRUCT_FUNCTION 

  `alu_FROM_DRIVER_STRUCT_FUNCTION

  `alu_MONITOR_STRUCT
  alu_monitor_s alu_monitor_struct;
  
  `alu_FROM_MONITOR_STRUCT_FUNCTION

  function new(string name = "alu_sequence_item");
    super.new(name);
  endfunction: new

  virtual function string convert2string();
        return $sformatf("r_operand1: 0x%0h r_operand2: 0x%0h data_out: 0x%0h r_instruction: 0x%0h pc: %d", r_operand1, r_operand2, data_out, r_instruction, pc);
    endfunction

  virtual function void do_print(uvm_printer printer);
      $display(convert2string());
  endfunction

  function void do_copy(uvm_object rhs);
	 alu_sequence_item dc;
    if(!$cast(dc, rhs)) begin
    	uvm_report_error("seq_item -> do_copy:", "Cast failed");
      return;
 	 end
    super.do_copy(rhs);
    i_memData       = dc.i_memData        ;
    data_out        = dc.data_out         ;
    we              = dc.we               ;
    r_instruction   = dc.r_instruction    ;
    r_operand1      = dc.r_operand1       ;
    r_operand2      = dc.r_operand2       ;
    r_operand1_addr = dc.r_operand1_addr ;
    r_operand2_addr = dc.r_operand2_addr ;
    pc              = dc.pc               ;
  endfunction : do_copy

endclass: alu_sequence_item
