local mission_settings = {
	mission_game_mode_names = table.enum("default", "coop_complete_objective", "hub_singleplay", "hub", "prologue_hub", "prologue", "shooting_range", "training_grounds"),
	mission_zone_ids = table.enum("dust", "entertainment", "hub", "placeholder", "prologue", "tank_foundry", "throneside", "training_grounds", "transit", "watertown"),
	main_objective_names = table.enum("default", "control_objective", "decode_objective", "demolition_objective", "fortification_objective", "kill_objective", "luggable_objective")
}

return settings("MissionSettings", mission_settings)
