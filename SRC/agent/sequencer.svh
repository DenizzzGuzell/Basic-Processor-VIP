class sequencer extends uvm_sequencer#(sequence_item);
  `uvm_component_utils(sequencer)

  //Constructor
  function new(string name = "sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction: new

endclass: sequencer
