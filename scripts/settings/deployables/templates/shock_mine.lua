-- chunkname: @scripts/settings/deployables/templates/shock_mine.lua

local TalentSettings = require("scripts/settings/talent/talent_settings")
local adamant_talent_settings = TalentSettings.adamant
local shock_mine = {
	stickiness_limit = 5,
	stickiness_time = 1,
	proximity_check_params = {
		proximity_radius = 3
	},
	proximity_shock_init_data = {
		damage_interval = 0.75,
		life_time = 15,
		num_charges = 50
	}
}

return shock_mine
