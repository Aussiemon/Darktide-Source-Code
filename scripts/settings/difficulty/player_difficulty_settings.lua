-- chunkname: @scripts/settings/difficulty/player_difficulty_settings.lua

local player_difficulty_settings = {}

player_difficulty_settings.archetype_wounds = {
	none = {
		1,
		1,
		1,
		1,
		1
	},
	adamant = {
		4,
		3,
		3,
		2,
		2
	},
	ogryn = {
		5,
		4,
		4,
		3,
		3
	},
	psyker = {
		4,
		3,
		3,
		2,
		2
	},
	veteran = {
		4,
		3,
		3,
		2,
		2
	},
	zealot = {
		4,
		3,
		3,
		2,
		2
	}
}

return settings("PlayerDifficultySettings", player_difficulty_settings)
