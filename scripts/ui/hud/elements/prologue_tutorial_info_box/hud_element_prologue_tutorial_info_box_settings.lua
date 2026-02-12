-- chunkname: @scripts/ui/hud/elements/prologue_tutorial_info_box/hud_element_prologue_tutorial_info_box_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_prologue_tutorial_info_box_settings = {
	info_box_background_size = {
		460,
		200,
	},
	info_box_title_text_box_size = {
		525,
		50,
	},
	info_box_separator_size = {
		410,
		3,
	},
	info_box_description_text_size = {
		400,
		200,
	},
	info_box_title_text_box_position = {
		35,
		20,
		1,
	},
	info_box_description_text_position = {
		35,
		65,
		5,
	},
	info_box_input_description_size = {
		400,
		50,
	},
	tracker_background_size = {
		400,
		40,
	},
	tracker_entry_size = {
		800,
		55,
	},
	tracker_entry_colors = {
		entry_text = UIHudSettings.color_tint_main_1,
		counter_text = UIHudSettings.color_tint_main_1,
	},
	title_text_style = {
		drop_shadow = true,
		font_size = 32,
		font_type = "proxima_nova_bold",
		line_spacing = 1.2,
		text_horizontal_alignment = "left",
		text_vertical_alignment = "center",
		size = {
			525,
			50,
		},
		offset = {
			35,
			20,
			1,
		},
		text_color = Color.terminal_text_header(255, true),
	},
	description_text_style = {
		drop_shadow = true,
		font_size = 20,
		font_type = "proxima_nova_bold",
		line_spacing = 1.2,
		text_horizontal_alignment = "left",
		text_vertical_alignment = "center",
		vertical_alignment = "top",
		size = {
			400,
			50,
		},
		offset = {
			35,
			80,
			5,
		},
		text_color = Color.terminal_text_body(255, true),
	},
	input_description_text_style = {
		drop_shadow = true,
		font_size = 23,
		font_type = "proxima_nova_bold",
		line_spacing = 1.2,
		text_horizontal_alignment = "left",
		text_vertical_alignment = "top",
		vertical_alignment = "top",
		size = {
			400,
			50,
		},
		offset = {
			35,
			20,
			4,
		},
		text_color = Color.terminal_text_header(255, true),
	},
	counter_text_style = {
		drop_shadow = false,
		font_size = 20,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "center",
		text_vertical_alignment = "center",
		size = {
			60,
			50,
		},
	},
	entry_text_style = {
		drop_shadow = false,
		font_size = 20,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "left",
		text_vertical_alignment = "center",
		size = {
			520,
			50,
		},
	},
	devices = {
		"keyboard",
		"mouse",
	},
	events = {
		{
			"event_player_display_prologue_tutorial_info_box",
			"event_player_display_prologue_tutorial_info_box",
		},
		{
			"event_player_hide_prologue_tutorial_info_box",
			"event_player_hide_prologue_tutorial_info_box",
		},
		{
			"event_player_add_objective_tracker",
			"event_player_add_objective_tracker",
		},
		{
			"event_player_update_objectives_tracker",
			"event_player_update_objectives_tracker",
		},
		{
			"event_player_remove_current_objectives",
			"event_player_remove_current_objectives",
		},
		{
			"event_player_remove_objective",
			"event_player_remove_objective",
		},
	},
}

return settings("HudElementPrologueTutorialInfoBoxSettings", hud_element_prologue_tutorial_info_box_settings)
