local mission_settings = {
	mission_game_mode_names = table.enum("default", "hub", "hub_singleplay", "coop_complete_objective", "training_grounds"),
	mission_zone_ids = table.enum("hub", "placeholder", "training_grounds", "tank_foundry", "transit", "watertown"),
	main_objective_names = table.enum("demolition_objective", "decode_objective", "control_objective", "kill_objective", "fortification_objective", "default", "luggable_objective")
}

return settings("MissionSettings", mission_settings)
