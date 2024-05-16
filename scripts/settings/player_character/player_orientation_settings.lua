-- chunkname: @scripts/settings/player_character/player_orientation_settings.lua

local player_orientation_settings = {}

player_orientation_settings.default = {
	mouse_scale = 0.001,
	min_pitch = -math.pi * 0.45,
	max_pitch = math.pi * 0.45,
}
player_orientation_settings.hub = {
	mouse_scale = 0.001,
	min_pitch = -math.pi * 0.3,
	max_pitch = math.pi * 0.25,
}

return settings("PlayerOrientationSettings", player_orientation_settings)
