-- chunkname: @scripts/ui/view_elements/view_element_discard_items/view_element_discard_items_settings.lua

local elements_width = 440
local window_size = {
	elements_width + 60,
	650,
}
local content_size = {
	elements_width,
	window_size[2],
}
local discard_items_settings = {
	window_size = window_size,
	content_size = content_size,
	checkbox_size = {
		440,
		50,
	},
	confirm_button_size = {
		210,
		40,
	},
	animation_event_by_archetype = {
		adamant = "human_adamant_inspect_pose",
		ogryn = "ogryn_inspect_pose",
		psyker = "human_psyker_inspect_pose",
		veteran = "human_veteran_inspect_pose",
		zealot = "human_zealot_inspect_pose",
	},
	archetype_badge_texture_by_name = {
		adamant = "content/ui/textures/icons/class_badges/adamant_01_01",
		ogryn = "content/ui/textures/icons/class_badges/ogryn_01_01",
		psyker = "content/ui/textures/icons/class_badges/psyker_01_01",
		veteran = "content/ui/textures/icons/class_badges/veteran_01_01",
		zealot = "content/ui/textures/icons/class_badges/zealot_01_01",
	},
}

return settings("ViewElementDiscardItems", discard_items_settings)
