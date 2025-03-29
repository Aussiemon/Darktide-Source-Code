-- chunkname: @scripts/settings/difficulty/danger_settings.lua

local DangerSettings = {
	{
		challenge = 1,
		difficulty = 1,
		display_name = "loc_mission_board_danger_lowest",
		is_auric = false,
		name = "sedition",
		resistance = 2,
		unlocks_at = 1,
		color = {
			255,
			169,
			211,
			158,
		},
	},
	{
		challenge = 2,
		difficulty = 2,
		display_name = "loc_mission_board_danger_low",
		is_auric = false,
		name = "uprising",
		resistance = 2,
		unlocks_at = 1,
		color = {
			255,
			169,
			211,
			158,
		},
	},
	{
		challenge = 3,
		difficulty = 3,
		display_name = "loc_mission_board_danger_medium",
		is_auric = false,
		name = "malice",
		resistance = 3,
		unlocks_at = 3,
		color = {
			255,
			228,
			189,
			81,
		},
	},
	{
		challenge = 4,
		difficulty = 4,
		display_name = "loc_mission_board_danger_high",
		is_auric = false,
		name = "heresy",
		resistance = 4,
		unlocks_at = 9,
		color = {
			255,
			228,
			189,
			81,
		},
	},
	{
		challenge = 5,
		difficulty = 5,
		display_name = "loc_mission_board_danger_highest",
		is_auric = false,
		name = "damnation",
		resistance = 4,
		unlocks_at = 15,
		color = {
			255,
			233,
			84,
			84,
		},
	},
}

for i, data in ipairs(DangerSettings) do
	data.index = i
end

return settings("DangerSettings", DangerSettings)
