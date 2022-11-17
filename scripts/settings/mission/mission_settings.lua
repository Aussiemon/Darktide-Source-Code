local mission_settings = {
	mission_game_mode_names = table.enum("default", "hub", "hub_singleplay", "coop_complete_objective", "prologue", "prologue_hub", "training_grounds", "shooting_range"),
	mission_zone_ids = table.enum("dust", "hub", "placeholder", "prologue", "training_grounds", "tank_foundry", "throneside", "transit", "watertown"),
	main_objective_names = table.enum("demolition_objective", "decode_objective", "control_objective", "kill_objective", "fortification_objective", "default", "luggable_objective")
}

return settings("MissionSettings", mission_settings)
