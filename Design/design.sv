//////////////////////////////////////////////////////////////////////////////////
// Company: YONGATEK
// Engineer:
//
// Create Date: 11/08/2022 11:38:27 AM
// Design Name:
// Module Name: simple_ALU
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

`include "timescale.sv"

module simple_ALU(input i_clk,
				  input i_rst,
				  input logic  [15:0] i_memData,
				  output logic  [15:0]  o_memData,
				  output logic [15:0] o_memAddr,
				  output logic o_memWrEnable);


  typedef enum bit [1:0] {FETCH, DECODE, EXECUTE, PCCOUNTER} state_t;
  state_t state, state_next;

  typedef enum bit [3:0] {ADD, ADDi, SUB, SUBi, SRA, SRAi, SRL, SRLi, SLL, SLLi, AND, ANDi, OR, ORi, XOR, XORi} state_opcode;
  state_opcode state_op, state_op_next;

  logic [5:0] r_programCounter, r_programCounter_next;
  logic [15:0] r_instruction, r_instruction_next;
  logic  [15:0] r_operand1, r_operand1_next;

  always@(posedge i_clk) begin
	r_programCounter	<=  r_programCounter_next;
	r_instruction 		<=  r_instruction_next;
	r_operand1 			<=  r_operand1_next;
    state 				<=  state_next;
    state_op 			<=  state_op_next;
  end


  always@(*) begin
    if(i_rst) begin
    	state_next 				= FETCH;
		state_op_next 			= ADD;
    	r_programCounter_next	= 0;
      	o_memAddr 				= 0;
  		r_instruction_next 		= 0;
		o_memData 				= 0;
		o_memWrEnable 			= 0;
		r_operand1_next 		= 0;
    end
  	else begin
		r_programCounter_next	= r_programCounter;
      	r_instruction_next 		= r_instruction;
		o_memWrEnable 			= 0;
		o_memData 				= 0;
		r_operand1_next 		= r_operand1_next;
      	state_next 				= state;
		state_op_next 			= state_op;
      case(state)
      	FETCH: begin
          r_instruction_next	= i_memData;
          o_memAddr 			= i_memData[11:6];
		  state_next 			= DECODE;
        end

        DECODE: begin
          case(r_instruction[15:12])
          	4'b0000: state_op_next = ADD	;
          	4'b1000: state_op_next = ADDi;
            4'b0001: state_op_next = SUB	;
            4'b1001: state_op_next = SUBi;
            4'b0010: state_op_next = SRA	;
            4'b1010: state_op_next = SRAi;
            4'b0011: state_op_next = SRL	;
            4'b1011: state_op_next = SRLi;
            4'b0100: state_op_next = SLL	;
            4'b1100: state_op_next = SLLi;
            4'b0101: state_op_next = AND	;
            4'b1101: state_op_next = ANDi;
            4'b0110: state_op_next = OR	;
            4'b1110: state_op_next = ORi	;
            4'b0111: state_op_next = XOR	;
            4'b1111: state_op_next = XORi;
			//VCS coverage off
            default: state_op_next = ADD;
			//VCS coverage on
          endcase
			r_operand1_next = i_memData;
			o_memAddr = r_instruction[5:0];
			state_next = EXECUTE;
        end

        EXECUTE: begin
			o_memAddr = r_instruction[11:6];
			o_memWrEnable = 1;
			case(state_op)
				ADD	: 	o_memData = r_operand1 + i_memData;
				ADDi:	o_memData = r_operand1 + r_instruction[5:0];
				SUB	:	o_memData = r_operand1 - i_memData;
				SUBi:	o_memData = r_operand1 - r_instruction[5:0];
				SRA	:	o_memData = $signed(r_operand1) >>> i_memData;
				SRAi:	o_memData = $signed(r_operand1) >>> r_instruction[5:0];
				SRL	:	o_memData = r_operand1 >> i_memData;
				SRLi:	o_memData = r_operand1 >> r_instruction[5:0];
				SLL	:	o_memData = r_operand1 << i_memData;
				SLLi:	o_memData = r_operand1 << r_instruction[5:0];
				AND	:	o_memData = r_operand1 & i_memData;
				ANDi:	o_memData = r_operand1 & r_instruction[5:0];
				OR	:	o_memData = r_operand1 | i_memData;
				ORi	:	o_memData = r_operand1 | r_instruction[5:0];
				XOR	:	o_memData = r_operand1 ^ i_memData;
				XORi:	o_memData = r_operand1 ^ r_instruction[5:0];
				//default : o_memData = 'h0;
			endcase
			state_next = PCCOUNTER;
        end

        PCCOUNTER: begin
			r_programCounter_next	= r_programCounter + 1;
			o_memAddr 				= r_programCounter + 1;
			state_next 				= FETCH;
        end
		default : state_next = FETCH;
   	   endcase
    end
  end
endmodule
