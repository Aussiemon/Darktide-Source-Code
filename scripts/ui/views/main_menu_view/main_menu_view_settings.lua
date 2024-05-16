-- chunkname: @scripts/ui/views/main_menu_view/main_menu_view_settings.lua

local main_menu_view_settings = {
	character_delete_button_hold_time = 3,
	character_delete_button_spacing = 10,
	character_slot_spacing = 10,
	max_num_characters = 5,
	max_party_size = 4,
	character_new_slot_size = {
		100,
		100,
	},
	character_slot_size = {
		100,
		100,
	},
	character_slot_delete_button_size = {
		100,
		30,
	},
	character_slot_delete_button_bar_size = {
		100,
		5,
	},
	grid_size = {
		500,
		480,
	},
	grid_spacing = {
		0,
		0,
	},
}

return settings("MainMenuViewSettings", main_menu_view_settings)
