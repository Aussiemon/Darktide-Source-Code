-- chunkname: @scripts/settings/level_prop/props/minigame_interface.lua

local prop_data = {
	minigame_angle_check = false,
	name = "minigame_interface",
	unit_name = "content/environment/gameplay/decoder_stations/decoder_device_05/decoder_device_05",
	unit_template_name = "level_prop",
	mutator_on_minigame_complete = "mutator_communication_hack_event",
	game_object_type = "level_prop",
	is_side_mission_prop = true
}

return prop_data
