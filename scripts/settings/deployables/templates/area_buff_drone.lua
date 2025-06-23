-- chunkname: @scripts/settings/deployables/templates/area_buff_drone.lua

local TalentSettings = require("scripts/settings/talent/talent_settings")
local adamant_talent_settings = TalentSettings.adamant
local drone = {
	stickiness_limit = 5,
	stickiness_time = 1,
	proximity_radius = adamant_talent_settings.blitz_ability.drone.range,
	proximity_shock_init_data = {
		damage_interval = 0.75,
		num_charges = 50,
		life_time = adamant_talent_settings.blitz_ability.drone.duration
	}
}

return drone
