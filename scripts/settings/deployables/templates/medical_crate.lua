-- chunkname: @scripts/settings/deployables/templates/medical_crate.lua

local DamageSettings = require("scripts/settings/damage/damage_settings")
local medical_crate = {
	proximity_radius = 3,
	stickiness_limit = 5,
	stickiness_time = 1,
	unit_template = "medical_crate_deployable",
	proximity_init_data = {
		fx_interval = 0.6,
		heal_rate_percentage = 0.06,
		knock_down_player_heal_cost_multiplier = 0.3,
		knock_down_player_heal_speed_multiplier = 0.1,
		optional_buff = "medical_crate_healing_modifier",
		optional_heal_reserve = 500,
		optional_heal_time = 300,
		heal_type = DamageSettings.heal_types.medkit,
	},
}

return medical_crate
