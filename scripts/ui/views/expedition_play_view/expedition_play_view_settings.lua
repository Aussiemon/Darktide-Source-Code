-- chunkname: @scripts/ui/views/expedition_play_view/expedition_play_view_settings.lua

local tutorial_window_size = {
	900,
	576,
}
local tutorial_grid_size = {
	tutorial_window_size[1] - 420,
	tutorial_window_size[2] - 225,
}
local expedition_play_view_settings = {
	tooltip_fade_delay = 0.3,
	tooltip_fade_speed = 7,
	tutorial_window_size = tutorial_window_size,
	tutorial_grid_size = tutorial_grid_size,
	tutorial_popup_pages = {
		{
			button_1 = "loc_game_mode_expedition_menu_tutorial_skip_button_label",
			button_2 = "loc_next",
			header = "loc_game_mode_expedition_menu_tutorial_header_1",
			image = "content/ui/materials/backgrounds/expedition/onboarding/expedition_menu_onboarding_01",
			text = "loc_game_mode_expedition_menu_tutorial_body_1",
		},
		{
			button_1 = "loc_view_back",
			button_2 = "loc_next",
			header = "loc_game_mode_expedition_menu_tutorial_header_2",
			image = "content/ui/materials/backgrounds/expedition/onboarding/expedition_menu_onboarding_02",
			text = "loc_game_mode_expedition_menu_tutorial_body_2",
		},
		{
			button_1 = "loc_view_back",
			button_2 = "loc_game_mode_expedition_menu_tutorial_final_button_label",
			header = "loc_game_mode_expedition_menu_tutorial_header_3",
			image = "content/ui/materials/backgrounds/expedition/onboarding/expedition_menu_onboarding_03",
			text = "loc_game_mode_expedition_menu_tutorial_body_3",
		},
	},
	node_map_size = {
		775,
		650,
	},
	node_size = {
		150,
		90,
	},
}

return settings("ExpeditionPlayViewSettings", expedition_play_view_settings)
