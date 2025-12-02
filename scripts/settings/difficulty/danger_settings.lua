-- chunkname: @scripts/settings/difficulty/danger_settings.lua

local DangerSettings = {
	{
		challenge = 2,
		difficulty = 2,
		digital_icon = "content/ui/materials/icons/difficulty/difficulty_skull_uprising",
		display_name = "loc_mission_board_danger_low",
		icon = "content/ui/materials/icons/difficulty/flat/difficulty_skull_uprising",
		is_auric = false,
		name = "uprising",
		resistance = 2,
		unlocks_at = 1,
		color = {
			255,
			151,
			247,
			164,
		},
	},
	{
		challenge = 3,
		difficulty = 3,
		digital_icon = "content/ui/materials/icons/difficulty/difficulty_skull_malice",
		display_name = "loc_mission_board_danger_medium",
		icon = "content/ui/materials/icons/difficulty/flat/difficulty_skull_malice",
		is_auric = false,
		name = "malice",
		resistance = 3,
		unlocks_at = 3,
		color = {
			255,
			76,
			198,
			93,
		},
	},
	{
		challenge = 4,
		difficulty = 4,
		digital_icon = "content/ui/materials/icons/difficulty/difficulty_skull_heresy",
		display_name = "loc_mission_board_danger_high",
		icon = "content/ui/materials/icons/difficulty/flat/difficulty_skull_heresy",
		is_auric = false,
		name = "heresy",
		resistance = 4,
		unlocks_at = 9,
		color = {
			255,
			255,
			193,
			6,
		},
	},
	{
		challenge = 5,
		difficulty = 5,
		digital_icon = "content/ui/materials/icons/difficulty/difficulty_skull_damnation",
		display_name = "loc_mission_board_danger_highest",
		icon = "content/ui/materials/icons/difficulty/flat/difficulty_skull_damnation",
		is_auric = false,
		name = "damnation",
		resistance = 4,
		unlocks_at = 15,
		color = {
			255,
			255,
			134,
			21,
		},
	},
	{
		challenge = 5,
		difficulty = 6,
		digital_icon = "content/ui/materials/icons/difficulty/difficulty_skull_auric",
		display_name = "loc_group_finder_difficulty_auric",
		icon = "content/ui/materials/icons/difficulty/flat/difficulty_skull_auric",
		is_auric = true,
		name = "auric",
		resistance = 5,
		unlocks_at = 30,
		color = {
			255,
			255,
			83,
			44,
		},
	},
}

for i, data in ipairs(DangerSettings) do
	data.index = i
end

return settings("DangerSettings", DangerSettings)
