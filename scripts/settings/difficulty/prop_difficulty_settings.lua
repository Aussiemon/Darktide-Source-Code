-- chunkname: @scripts/settings/difficulty/prop_difficulty_settings.lua

local prop_difficulty_settings = {}

prop_difficulty_settings.health_scaling = {
	0.4,
	0.6,
	0.75,
	1,
	1,
}

return settings("PropDifficultySettings", prop_difficulty_settings)
