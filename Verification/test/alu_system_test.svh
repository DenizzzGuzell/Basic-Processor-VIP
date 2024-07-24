class alu_system_test extends alu_test_base;
  `uvm_component_utils(alu_system_test)

  function new(string name = "alu_system_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    repeat_count = 10000;
  endfunction: build_phase
  
endclass: alu_system_test
