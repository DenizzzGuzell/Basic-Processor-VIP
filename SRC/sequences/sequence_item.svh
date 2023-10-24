class sequence_item extends uvm_sequence_item;
  `uvm_object_utils(sequence_item)

  rand logic [15:0] i_memData;
  logic [15:0]      o_memData;
  logic        	  o_memWrEnable;
  logic [15:0] 	  r_instruction;
  logic [15:0] 	  r_operand1;
  logic [15:0] 	  r_operand2;

  function new(string name = "sequence_item");
    super.new(name);
  endfunction: new

  function void do_copy(uvm_object rhs);
	 sequence_item dc;
    if(!$cast(dc, rhs)) begin
    	uvm_report_error("seq_item -> do_copy:", "Cast failed");
      return;
 	 end
    super.do_copy(rhs);
    i_memData      = dc.i_memData     ;
    o_memData      = dc.o_memData     ;
    o_memWrEnable  = dc.o_memWrEnable ;
    r_instruction  = dc.r_instruction ;
    r_operand1     = dc.r_operand1    ;
    r_operand2     = dc.r_operand2    ;
  endfunction : do_copy

  function string convert2string();
  	  string contents;
  	  contents = super.convert2string();
  	     $sformat(contents, "%s i_memData      = 0x%0h", contents, i_memData);
  	     $sformat(contents, "%s o_memData      = 0x%0h", contents, o_memData);
  	     $sformat(contents, "%s o_memWrEnable  = %b", contents,    o_memWrEnable);
  	     $sformat(contents, "%s Instruction    = 0x%0h", contents, r_instruction);
  	     $sformat(contents, "%s Operand1       = 0x%0h", contents, r_operand1);
  	     $sformat(contents, "%s Operand2       = 0x%0h", contents, r_operand2);
  	  return contents;
   endfunction : convert2string

endclass: sequence_item
