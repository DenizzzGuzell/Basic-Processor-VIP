class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  uvm_analysis_imp #(sequence_item, scoreboard) scoreboard_port;

  agent_config scr_cfg;
  sequence_item transactions[$];

	logic [15:0] actual_o_memData;
	logic [15:0] expected_o_memData;

	logic [15:0] actual_instruction;
	logic [15:0] expected_instruction;

	logic [3:0] actual_OpCode;
	logic [3:0] expected_OpCode;

	logic actual_o_memWrEnable;
	logic expected_o_memWrEnable;

	logic [15:0] actual_operand1;
	logic [15:0] expected_operand1;

	logic [15:0] actual_operand2;
	logic [15:0] expected_operand2;

	logic [15:0] actual_i_memData;
	logic [5:0]  actual_immediate;

  //Constructor
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (! uvm_config_db #(agent_config) :: get(this, "", "agent_config", scr_cfg)) begin
       `uvm_fatal (get_type_name(), "Didn't get CFG object at Scoreboard!")
    end
    scoreboard_port = new("scoreboard_port", this);
  endfunction: build_phase

  //Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase

  //Write Method
  function void write(sequence_item item);
    transactions.push_back(item);
  endfunction: write

  //Run Phase
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
      sequence_item curr_trans;
      wait((transactions.size() != 0));
      curr_trans = transactions.pop_front();
		actual_o_memData     	  = curr_trans.o_memData;
    expected_o_memData		  = 0;
    actual_instruction		  = curr_trans.r_instruction;
    actual_OpCode				  = curr_trans.r_instruction[15:12];
    actual_o_memWrEnable	  = curr_trans.o_memWrEnable;
    actual_operand1			  = curr_trans.r_operand1;
    actual_operand2			  = curr_trans.r_operand2;
	 actual_i_memData			  = curr_trans.i_memData;
	 actual_immediate			  = curr_trans.r_instruction[5:0];
    case(actual_OpCode)
     4'b0000: //ADD
       expected_o_memData = actual_operand1 + actual_operand2;

     4'b0001: //SUB
       expected_o_memData = actual_operand1 - actual_operand2;

     4'b0010: //SRA
       expected_o_memData = $signed(actual_operand1) >>> actual_operand2;

     4'b0011: //SRL
       expected_o_memData = actual_operand1 >> actual_operand2;

     4'b0100: //SLL
       expected_o_memData = actual_operand1 << actual_operand2;

     4'b0101: //AND
       expected_o_memData = actual_operand1 & actual_operand2;

     4'b0110: //OR
       expected_o_memData = actual_operand1 | actual_operand2;

     4'b0111: //XOR
       expected_o_memData = actual_operand1 ^ actual_operand2;

     4'b1000: //ADDi
       expected_o_memData = actual_operand1 + actual_immediate;

     4'b1001: //SUBi
       expected_o_memData = actual_operand1 - actual_immediate;

     4'b1010: //SRAi
       expected_o_memData = $signed(actual_operand1) >>> actual_immediate;

     4'b1011: //SRLi
       expected_o_memData = actual_operand1 >> actual_immediate;

     4'b1100: //SLLi
       expected_o_memData = actual_operand1 << actual_immediate;

     4'b1101: //ANDi
       expected_o_memData = actual_operand1 & actual_immediate;

     4'b1110: //ORi
       expected_o_memData = actual_operand1 | actual_immediate;

     4'b1111: //XORi
       expected_o_memData = actual_operand1 ^ actual_immediate;
 	  endcase

     if(actual_o_memData != expected_o_memData) begin
       if(actual_OpCode < 8) begin
       `uvm_error("COMPARE", $sformatf("Transaction failed ! Instruction=%b, Op_Code=%b, TYPE = R, Operand1=0x%h , Operand2=0x%h, Actual Result=0x%h, Expected Result=0x%h", actual_instruction, actual_OpCode, actual_operand1, actual_operand2, actual_o_memData, expected_o_memData))
       end
       else begin
       `uvm_error("COMPARE", $sformatf("Transaction failed ! Instruction=%b, Op_Code=%b, TYPE = I, Operand1=0x%h , Immediate Value=0x%h, Actual Result=0x%h, Expected Result=0x%h", actual_instruction, actual_OpCode, actual_operand1, actual_immediate, actual_o_memData, expected_o_memData))
       end
     end
     else begin
       if(actual_OpCode < 8) begin
       `uvm_info("COMPARE", $sformatf("Transaction Passed! Instruction=%b, Op_Code=%b, TYPE = R, Operand1=0x%h , Operand2=0x%h, Actual Result=0x%h, Expected Result=0x%h", actual_instruction, actual_OpCode, actual_operand1, actual_operand2, actual_o_memData, expected_o_memData), UVM_LOW)
       end
       else begin
       `uvm_info("COMPARE", $sformatf("Transaction Passed! Instruction=%b, Op_Code=%b, TYPE = I, Operand1=0x%h , Immediate Value=0x%h, Actual Result=0x%h, Expected Result=0x%h", actual_instruction, actual_OpCode, actual_operand1, actual_immediate, actual_o_memData, expected_o_memData), UVM_LOW)
       end
     end
    end
  endtask: run_phase
endclass: scoreboard
