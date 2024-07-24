class alu_coverage extends uvm_subscriber#(alu_sequence_item);
    `uvm_component_utils(alu_coverage)

    logic [15:0] instr ;

    covergroup R_TYPE_CG;
        option.name         = "R_TYPE_INSTRUCTION_CG"             ;
        option.per_instance = 1                                   ;
        option.comment      = "COVERGROUP OF R TYPE INSTRUCTIONS" ;

        CP_OPCODE : coverpoint instr[15:12]{
            bins R_OPERATION_ADD [] = {0}; 
            bins R_OPERATION_SUB [] = {1}; 
            bins R_OPERATION_SRA [] = {2}; 
            bins R_OPERATION_SRL [] = {3}; 
            bins R_OPERATION_SLL [] = {4}; 
            bins R_OPERATION_AND [] = {5}; 
            bins R_OPERATION_OR  [] = {6}; 
            bins R_OPERATION_XOR [] = {7}; 
        }

        CP_OPERAND1_ADDR : coverpoint instr[11:6]{
            bins          R1_AUTO_RANGE [6]    = {[32:$]};
            ignore_bins   EXCLUDE_IM_RANGE      = {[0:31]};
        }

        CP_OPERAND2_ADDR : coverpoint instr[5:0]{
            bins          R1_AUTO_RANGE [6]    = {[32:$]};
            ignore_bins   EXCLUDE_IM_RANGE      = {[0:31]};
        }

        CP_R_TYPE_CROSS  : cross  CP_OPCODE, CP_OPERAND1_ADDR, CP_OPERAND2_ADDR;

    endgroup

    covergroup I_TYPE_CG;
        option.name         = "I_TYPE_INSTRUCTION_CG"             ;
        option.per_instance = 1                                   ;
        option.comment      = "COVERGROUP OF I TYPE INSTRUCTIONS" ;

        CP_OPCODE : coverpoint instr[15:12]{
            bins I_OPERATION_ADDi [] = {8}; 
            bins I_OPERATION_SUBi [] = {9}; 
            bins I_OPERATION_SRAi [] = {10}; 
            bins I_OPERATION_SRLi [] = {11}; 
            bins I_OPERATION_SLLi [] = {12}; 
            bins I_OPERATION_ANDi [] = {13}; 
            bins I_OPERATION_ORi  [] = {14}; 
            bins I_OPERATION_XORi [] = {15}; 
        }

        CP_OPERAND1_ADDR : coverpoint instr[11:6]{
            bins          R1_AUTO_RANGE [6]    = {[32:$]};
            ignore_bins   EXCLUDE_IM_RANGE      = {[0:31]};
        }

        CP_IMMEDIATE : coverpoint instr[5:0]{
            bins          IMM_AUTO_RANGE [6]   = {[0:$]};
        }

        CP_I_TYPE_CROSS  : cross  CP_OPCODE, CP_OPERAND1_ADDR, CP_IMMEDIATE;

    endgroup

    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
        R_TYPE_CG = new();
        I_TYPE_CG = new();
    endfunction 

    virtual function void write (alu_sequence_item t);
        instr = t.r_instruction;
        if (instr[15]) I_TYPE_CG.sample();
        else           R_TYPE_CG.sample();
    endfunction

endclass