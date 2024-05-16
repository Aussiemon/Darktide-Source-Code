-- chunkname: @scripts/ui/constant_elements/elements/stay_in_party/constant_element_stay_in_party_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ready_slot_size = {
	30,
	30,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bottom_panel = UIWorkspaceSettings.bottom_panel,
	pivot = {
		horizontal_alignment = "left",
		parent = "bottom_panel",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			150,
			-20,
			900,
		},
	},
	outline_rect = {
		horizontal_alignment = "right",
		parent = "pivot",
		vertical_alignment = "bottom",
		size = {
			100,
			100,
		},
		position = {
			0,
			0,
			1,
		},
	},
	vote_count_rect = {
		horizontal_alignment = "center",
		parent = "outline_rect",
		vertical_alignment = "center",
		size = {
			96,
			96,
		},
		position = {
			0,
			0,
			1,
		},
	},
	vote_count_text = {
		horizontal_alignment = "center",
		parent = "vote_count_rect",
		vertical_alignment = "center",
		size = {
			150,
			100,
		},
		position = {
			0,
			0,
			1,
		},
	},
	vote_caption = {
		horizontal_alignment = "left",
		parent = "pivot",
		vertical_alignment = "bottom",
		size = {
			600,
			30,
		},
		position = {
			20,
			-40,
			1,
		},
	},
	warning_text = {
		horizontal_alignment = "left",
		parent = "outline_rect",
		vertical_alignment = "bottom",
		size = {
			900,
			30,
		},
		position = {
			0,
			-112,
			1,
		},
	},
}
local vote_count_text_style = table.clone(UIFontSettings.header_1)

vote_count_text_style.text_color = Color.white(255, true)
vote_count_text_style.font_size = 45
vote_count_text_style.font_type = "proxima_nova_medium"
vote_count_text_style.text_vertical_alignment = "center"
vote_count_text_style.text_horizontal_alignment = "center"

local vote_caption_style = table.clone(UIFontSettings.header_3)

vote_caption_style.text_color = Color.white(255, true)
vote_caption_style.font_size = 30
vote_caption_style.text_vertical_alignment = "bottom"
vote_caption_style.text_horizontal_alignment = "left"

local warning_text_style = table.clone(UIFontSettings.header_3)

warning_text_style.text_color = Color.orange_red(255, true)
warning_text_style.font_size = 26
warning_text_style.text_vertical_alignment = "bottom"
warning_text_style.text_horizontal_alignment = "left"

local widget_definitions = {
	outline_rect = UIWidget.create_definition({
		{
			content_id = "frame",
			pass_type = "rect",
			style_id = "frame",
			style = {
				color = Color.white(255, true),
			},
		},
	}, "outline_rect"),
	vote_count_rect = UIWidget.create_definition({
		{
			content_id = "frame",
			pass_type = "rect",
			style_id = "frame",
			style = {
				color = Color.black(255, true),
			},
		},
	}, "vote_count_rect"),
	vote_count_text = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "0/0",
			value_id = "text",
			style = vote_count_text_style,
		},
	}, "vote_count_text"),
	vote_caption = UIWidget.create_definition({
		{
			pass_type = "text",
			value_id = "text",
			value = Managers.localization:localize("loc_stay_in_kill_team_caption"),
			style = vote_caption_style,
		},
	}, "vote_caption"),
	warning_text = UIWidget.create_definition({
		{
			pass_type = "text",
			value_id = "text",
			value = Managers.localization:localize("loc_stay_in_kill_team_warning"),
			style = warning_text_style,
		},
	}, "warning_text", {
		visible = false,
	}),
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_eor_stay_in_party_yes",
		input_action = "hotkey_menu_special_1",
		key = "stay_in_party",
		on_pressed_callback = "cb_on_stay_in_party_pressed",
	},
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
