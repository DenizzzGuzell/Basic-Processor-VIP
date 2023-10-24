class base_sequence extends uvm_sequence #(sequence_item);
  `uvm_object_utils(base_sequence)

  sequence_item req;

  //Constructor
  function new(string name= "base_sequence");
    super.new(name);
  endfunction

  //Body Task
  task body();
	 repeat(500) begin
	   req = sequence_item::type_id::create("req");
     	start_item(req);
    	req.randomize();
    	finish_item(req);
	 end
  endtask: body

endclass: base_sequence
