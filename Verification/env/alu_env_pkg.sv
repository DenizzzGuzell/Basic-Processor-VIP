package alu_env_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`uvm_analysis_imp_decl(_alu_pred_ae)

	import alu_agent_pkg::*;
	`include "alu_coverage.svh"
	`include "alu_env_config.svh"
	`include "alu_scoreboard.svh"
	`include "alu_env.svh"

endpackage: alu_env_pkg
