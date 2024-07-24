`define alu_MONITOR_STRUCT typedef struct packed  { \
bit [15:0] r_instruction ; \
bit [15:0] r_operand1 ; \
bit [15:0] r_operand2 ; \
bit [15:0] data_out ; \
bit [15:0] r_operand1_addr ; \
bit [15:0] r_operand2_addr ; \
bit we ; \
int pc ; \
   } alu_monitor_s;\

`define alu_TO_MONITOR_STRUCT_FUNCTION \
virtual function alu_monitor_s to_monitor_struct();\
    alu_monitor_struct = \
            { \
            this.r_instruction , \
            this.r_operand1 , \
            this.r_operand2 , \
            this.data_out , \
            this.r_operand1_addr, \
            this.r_operand2_addr, \
            this.we , \
            this.pc  \
            };\
    return ( alu_monitor_struct);\
endfunction\

`define alu_FROM_MONITOR_STRUCT_FUNCTION \
virtual function void from_monitor_struct(alu_monitor_s alu_monitor_struct);\
          {\
            this.r_instruction , \
            this.r_operand1 , \
            this.r_operand2 , \
            this.data_out , \
            this.r_operand1_addr, \
            this.r_operand2_addr, \
            this.we , \
            this.pc  \
          } = alu_monitor_struct;\
endfunction\


`define alu_DRIVER_STRUCT typedef struct packed  { \
bit [15:0] i_memData; \
   } alu_driver_s; \

`define alu_TO_DRIVER_STRUCT_FUNCTION \
virtual function alu_driver_s to_driver_struct();\
    alu_driver_struct = \
        {\
            this.i_memData \
        };\
    return ( alu_driver_struct);\
endfunction\

`define alu_FROM_DRIVER_STRUCT_FUNCTION \
virtual function void from_driver_struct(alu_driver_s alu_driver_struct);\
         {\
            this.i_memData \
         } = alu_driver_struct;\
endfunction \

