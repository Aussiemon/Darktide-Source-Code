local trigger_settings = {
	action_targets = table.enum("player_side", "entering_unit", "exiting_unit", "entering_and_exiting_unit", "units_in_volume", "none"),
	machine_targets = table.enum("none", "server", "client", "server_or_client", "server_and_client"),
	only_once = table.enum("none", "only_once_per_unit", "only_once_for_all_units")
}

return settings("TriggerSettings", trigger_settings)
