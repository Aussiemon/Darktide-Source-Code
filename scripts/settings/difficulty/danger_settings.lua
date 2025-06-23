-- chunkname: @scripts/settings/difficulty/danger_settings.lua

local DangerSettings = {
	{
		is_auric = false,
		name = "uprising",
		display_name = "loc_mission_board_danger_low",
		digital_icon = "content/ui/materials/icons/difficulty/difficulty_skull_uprising",
		icon = "content/ui/materials/icons/difficulty/flat/difficulty_skull_uprising",
		resistance = 2,
		unlocks_at = 1,
		challenge = 2,
		difficulty = 2,
		color = {
			255,
			151,
			247,
			164
		}
	},
	{
		is_auric = false,
		name = "malice",
		display_name = "loc_mission_board_danger_medium",
		digital_icon = "content/ui/materials/icons/difficulty/difficulty_skull_malice",
		icon = "content/ui/materials/icons/difficulty/flat/difficulty_skull_malice",
		resistance = 3,
		unlocks_at = 3,
		challenge = 3,
		difficulty = 3,
		color = {
			255,
			76,
			198,
			93
		}
	},
	{
		is_auric = false,
		name = "heresy",
		display_name = "loc_mission_board_danger_high",
		digital_icon = "content/ui/materials/icons/difficulty/difficulty_skull_heresy",
		icon = "content/ui/materials/icons/difficulty/flat/difficulty_skull_heresy",
		resistance = 4,
		unlocks_at = 9,
		challenge = 4,
		difficulty = 4,
		color = {
			255,
			255,
			193,
			6
		}
	},
	{
		is_auric = false,
		name = "damnation",
		display_name = "loc_mission_board_danger_highest",
		digital_icon = "content/ui/materials/icons/difficulty/difficulty_skull_damnation",
		icon = "content/ui/materials/icons/difficulty/flat/difficulty_skull_damnation",
		resistance = 4,
		unlocks_at = 15,
		challenge = 5,
		difficulty = 5,
		color = {
			255,
			255,
			134,
			21
		}
	},
	{
		is_auric = true,
		name = "auric",
		display_name = "loc_group_finder_difficulty_auric",
		digital_icon = "content/ui/materials/icons/difficulty/difficulty_skull_auric",
		icon = "content/ui/materials/icons/difficulty/flat/difficulty_skull_auric",
		resistance = 5,
		unlocks_at = 30,
		challenge = 5,
		difficulty = 5,
		color = {
			255,
			255,
			83,
			44
		}
	}
}

for i, data in ipairs(DangerSettings) do
	data.index = i
end

return settings("DangerSettings", DangerSettings)
