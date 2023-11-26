-- chunkname: @scripts/settings/deployables/medical_crate.lua

local DamageSettings = require("scripts/settings/damage/damage_settings")
local medical_crate = {
	proximity_radius = 3,
	unit_template = "medical_crate_deployable",
	stickiness_limit = 5,
	stickiness_time = 1,
	proximity_heal_init_data = {
		knock_down_player_heal_cost_multiplier = 0.3,
		knock_down_player_heal_speed_multiplier = 0.1,
		fx_intervall = 0.6,
		optional_heal_time = 300,
		heal_rate_percentage = 0.06,
		optional_heal_reserve = 500,
		optional_buff = "medical_crate_healing_modifier",
		heal_type = DamageSettings.heal_types.medkit
	}
}

return medical_crate
