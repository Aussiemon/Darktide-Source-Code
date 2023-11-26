-- chunkname: @scripts/ui/constant_elements/elements/stay_in_party/constant_element_stay_in_party_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ready_slot_size = {
	30,
	30
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bottom_panel = UIWorkspaceSettings.bottom_panel,
	pivot = {
		vertical_alignment = "bottom",
		parent = "bottom_panel",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			150,
			-20,
			900
		}
	},
	outline_rect = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "right",
		size = {
			100,
			100
		},
		position = {
			0,
			0,
			1
		}
	},
	vote_count_rect = {
		vertical_alignment = "center",
		parent = "outline_rect",
		horizontal_alignment = "center",
		size = {
			96,
			96
		},
		position = {
			0,
			0,
			1
		}
	},
	vote_count_text = {
		vertical_alignment = "center",
		parent = "vote_count_rect",
		horizontal_alignment = "center",
		size = {
			150,
			100
		},
		position = {
			0,
			0,
			1
		}
	},
	vote_caption = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "left",
		size = {
			600,
			30
		},
		position = {
			20,
			-40,
			1
		}
	},
	warning_text = {
		vertical_alignment = "bottom",
		parent = "outline_rect",
		horizontal_alignment = "left",
		size = {
			900,
			30
		},
		position = {
			0,
			-112,
			1
		}
	}
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
			style_id = "frame",
			pass_type = "rect",
			content_id = "frame",
			style = {
				color = Color.white(255, true)
			}
		}
	}, "outline_rect"),
	vote_count_rect = UIWidget.create_definition({
		{
			style_id = "frame",
			pass_type = "rect",
			content_id = "frame",
			style = {
				color = Color.black(255, true)
			}
		}
	}, "vote_count_rect"),
	vote_count_text = UIWidget.create_definition({
		{
			value = "0/0",
			value_id = "text",
			pass_type = "text",
			style = vote_count_text_style
		}
	}, "vote_count_text"),
	vote_caption = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			value = Managers.localization:localize("loc_stay_in_kill_team_caption"),
			style = vote_caption_style
		}
	}, "vote_caption"),
	warning_text = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			value = Managers.localization:localize("loc_stay_in_kill_team_warning"),
			style = warning_text_style
		}
	}, "warning_text", {
		visible = false
	})
}
local legend_inputs = {
	{
		input_action = "hotkey_menu_special_1",
		key = "stay_in_party",
		display_name = "loc_eor_stay_in_party_yes",
		alignment = "left_alignment",
		on_pressed_callback = "cb_on_stay_in_party_pressed"
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
