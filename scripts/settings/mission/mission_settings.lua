-- chunkname: @scripts/settings/mission/mission_settings.lua

local mission_settings = {}

mission_settings.mission_game_mode_names = table.enum("default", "hub", "hub_singleplay", "coop_complete_objective", "prologue", "prologue_hub", "training_grounds", "shooting_range")
mission_settings.mission_zone_ids = table.enum("dust", "entertainment", "hub", "placeholder", "prologue", "training_grounds", "tank_foundry", "throneside", "transit", "watertown")
mission_settings.main_objective_names = table.enum("demolition_objective", "decode_objective", "control_objective", "kill_objective", "fortification_objective", "default", "luggable_objective")

return settings("MissionSettings", mission_settings)
