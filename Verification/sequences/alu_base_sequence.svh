class alu_base_sequence extends uvm_sequence #(alu_sequence_item);
  `uvm_object_utils(alu_base_sequence)

  alu_sequence_item req;

  //Constructor
  function new(string name= "alu_base_sequence");
    super.new(name);
  endfunction

  //Body Task
  task body(); 

    `uvm_do_with (req, {i_memData[11:6] > 31;
                        i_memData[15] == 0 -> i_memData[5:0] > 31;})
    repeat(2) `uvm_do(req)
    `uvm_do_with (req, {i_memData[15:0] == 'h0;})

  endtask: body

endclass: alu_base_sequence
