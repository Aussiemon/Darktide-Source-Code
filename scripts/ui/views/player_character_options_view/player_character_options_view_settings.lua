local window_size = {
	1400,
	500
}
local image_size = {
	window_size[1] * 0.5,
	window_size[2] + 200
}
local content_size = {
	window_size[1] * 0.5,
	window_size[2]
}
local player_character_options_view_settings = {
	window_size = window_size,
	image_size = image_size,
	content_size = content_size,
	animation_event_by_archetype = {
		veteran = "human_veteran_inspect_pose",
		psyker = "human_psyker_inspect_pose",
		zealot = "human_zealot_inspect_pose",
		ogryn = "ogryn_inspect_pose"
	},
	archetype_badge_texture_by_name = {
		psyker = "content/ui/textures/icons/class_badges/psyker_01_01",
		veteran = "content/ui/textures/icons/class_badges/veteran_01_01",
		zealot = "content/ui/textures/icons/class_badges/zealot_01_01",
		ogryn = "content/ui/textures/icons/class_badges/ogryn_01_01"
	}
}

return settings("PlayerCharacterOptionsViewSettings", player_character_options_view_settings)
