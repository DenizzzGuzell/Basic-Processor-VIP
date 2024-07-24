class alu_env_config extends uvm_object;

	localparam string s_my_config_id = "alu_env_config";
	`uvm_object_utils(alu_env_config)

	alu_agent_config m_cfge;

	extern function new(string name = "alu_env_config");
	extern static function alu_env_config get_config(uvm_component c);

endclass: alu_env_config

function alu_env_config::new(string name = "alu_env_config");
	super.new(name);
endfunction: new

function alu_env_config alu_env_config::get_config(uvm_component c);
	alu_env_config t;

	if(!uvm_config_db #(alu_env_config)::get(c, "", s_my_config_id, t))
		`uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", s_my_config_id))

	return t;
endfunction: get_config
