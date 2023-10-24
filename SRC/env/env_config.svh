class env_config extends uvm_object;

	localparam string s_my_config_id = "env_config";
	`uvm_object_utils(env_config)

	agent_config m_cfge;

	extern function new(string name = "env_config");
	extern static function env_config get_config(uvm_component c);

endclass: env_config

function env_config::new(string name = "env_config");
	super.new(name);
endfunction: new

function env_config env_config::get_config(uvm_component c);
	env_config t;

	if(!uvm_config_db #(env_config)::get(c, "", s_my_config_id, t))
		`uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", s_my_config_id))

	return t;
endfunction: get_config
