class i_test extends test_base;
  `uvm_component_utils(i_test)

  //Constructor
  function new(string name = "i_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase

  //Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase

  //Run Phase
  task run_phase (uvm_phase phase);
  	 base_sequence b_seq = base_sequence::type_id::create("b_seq");
    super.run_phase(phase);
    phase.raise_objection(this, "i_test");
    	b_seq.start(m_top_env.agt.seqr);
    phase.drop_objection(this, "i_test");

  endtask: run_phase

endclass: i_test
