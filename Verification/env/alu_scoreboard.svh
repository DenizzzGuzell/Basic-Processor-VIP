class alu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_scoreboard)
  
  uvm_analysis_imp #(alu_sequence_item, alu_scoreboard) scoreboard_port;

  alu_agent_config scr_cfg;
  alu_sequence_item transactions[$];
  alu_sequence_item curr_trans;

	logic [15:0] instruction;
  logic [3:0]  opcode;
	logic [15:0]  operand1;
	logic [15:0]  operand2;
	logic [5:0]  immediate;

  logic [5:0] actual_operand1_addr;
  logic [5:0] actual_operand2_addr;
  logic [5:0] expected_operand1_addr;
  logic [5:0] expected_operand2_addr;

  logic [15:0] actual_o_memData;
  logic [15:0] expected_o_memData;

  //Constructor
  function new(string name = "alu_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (! uvm_config_db #(alu_agent_config) :: get(this, "", "alu_agent_config", scr_cfg)) begin
       `uvm_fatal (get_type_name(), "Didn't get CFG object at Scoreboard!")
    end
    scoreboard_port = new("scoreboard_port", this);
  endfunction: build_phase

  //Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase

  //Write Method
  function void write(alu_sequence_item item);
    transactions.push_back(item);
  endfunction: write

  //Run Phase
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
      wait((transactions.size() != 0));
      curr_trans = transactions.pop_front();
      compare(curr_trans);
    end
  endtask: run_phase

  task compare (input alu_sequence_item curr_trans);

    instruction   = curr_trans.r_instruction;
    opcode        = curr_trans.r_instruction[15:12];
    operand1      = curr_trans.r_operand1;
    operand2      = curr_trans.r_operand2;

    expected_operand1_addr = curr_trans.r_instruction[11:6];

    if (~(instruction[15])) begin 
      expected_operand2_addr = curr_trans.r_instruction [5:0];
      immediate              = 0;
    end else begin                         
      immediate              = curr_trans.r_instruction [5:0];
      expected_operand2_addr = 0;
    end

    actual_operand1_addr = curr_trans.r_operand1_addr [5:0];
    actual_operand2_addr = curr_trans.r_operand2_addr [5:0];

    if (actual_operand1_addr != expected_operand1_addr) `uvm_error(get_type_name(), $sformatf("Operand1 address mismatch Actual : 0x%0h Expected : 0x%0h", actual_operand1_addr, expected_operand1_addr))
    if (actual_operand2_addr != expected_operand2_addr) `uvm_error(get_type_name(), $sformatf("Operand2 address mismatch Actual : 0x%0h Expected : 0x%0h", actual_operand2_addr, expected_operand2_addr))

    actual_o_memData = curr_trans.data_out;

    case (opcode)
      4'b0000: expected_o_memData = operand1 + operand2;
      4'b1000: expected_o_memData = operand1 + immediate;
      4'b0001: expected_o_memData = operand1 - operand2;
      4'b1001: expected_o_memData = operand1 - immediate;
      4'b0010: expected_o_memData = $signed(operand1) >>> operand2;
      4'b1010: expected_o_memData = $signed(operand1) >>> immediate;
      4'b0011: expected_o_memData = operand1 >> operand2;
      4'b1011: expected_o_memData = operand1 >> immediate;
      4'b0100: expected_o_memData = operand1 << operand2;
      4'b1100: expected_o_memData = operand1 << immediate;
      4'b0101: expected_o_memData = operand1 & operand2;
      4'b1101: expected_o_memData = operand1 & immediate;
      4'b0110: expected_o_memData = operand1 | operand2;
      4'b1110: expected_o_memData = operand1 | immediate;
      4'b0111: expected_o_memData = operand1 ^ operand2;
      4'b1111: expected_o_memData = operand1 ^ immediate;
      default: `uvm_fatal(get_type_name(), "Not possible")
    endcase

    `uvm_info("SCB", $sformatf("SCB instr : 0x%0h, opcode : 0x%0h, operand1 : 0x%0h, operand2 : 0x%0h, immediate : 0x%0h", instruction,opcode,operand1, operand2, immediate), UVM_DEBUG)

    if (actual_o_memData != expected_o_memData) `uvm_error(get_type_name(), $sformatf("Data out mismatch Actual : 0x%0h Expected : 0x%0h", actual_o_memData, expected_o_memData))
    else                                        `uvm_info(get_type_name(), "Data out transaction passed", UVM_MEDIUM)

  endtask
endclass: alu_scoreboard
