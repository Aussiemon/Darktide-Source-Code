local ColorUtilities = require("scripts/utilities/ui/colors")
local DefaultPassTemplates = require("scripts/ui/pass_templates/default_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewStyles = require("scripts/ui/views/end_view/end_view_styles")
local _color_lerp = ColorUtilities.color_lerp
local panel_size = ViewStyles.panel_size
local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			306,
			520
		},
		position = {
			0,
			0,
			0
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			306,
			520
		},
		position = {
			0,
			0,
			0
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			320,
			200
		},
		position = {
			0,
			0,
			0
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			320,
			190
		},
		position = {
			0,
			0,
			0
		}
	},
	bottom_center = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			470,
			112
		},
		position = {
			0,
			0,
			0
		}
	},
	title_background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1200,
			200
		},
		position = {
			0,
			0,
			1
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "title_background",
		horizontal_alignment = "center",
		size = {
			1200,
			40
		},
		position = {
			0,
			20,
			60
		}
	},
	panel_pivot = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-120,
			1
		}
	},
	panel = {
		vertical_alignment = "bottom",
		parent = "panel_pivot",
		horizontal_alignment = "center",
		size = panel_size,
		position = {
			0,
			0,
			1
		}
	}
}
local widget_definitions = {}
local player_panel_pass_template = {
	{
		value = "content/ui/materials/base/ui_portrait_frame_base",
		value_id = "character_portrait",
		pass_type = "texture",
		style_id = "character_portrait"
	},
	{
		value = "\ue001",
		value_id = "checkmark",
		pass_type = "text",
		style_id = "checkmark"
	},
	{
		value = "content/ui/materials/nameplates/insignias/default",
		value_id = "character_insignia",
		pass_type = "texture",
		style_id = "character_insignia"
	},
	{
		style_id = "character_name",
		value_id = "character_name",
		pass_type = "text"
	},
	{
		style_id = "character_title",
		value_id = "character_title",
		pass_type = "text"
	},
	{
		value = "\ue004",
		value_id = "party_status",
		pass_type = "text",
		style_id = "party_status"
	},
	{
		value = "content/ui/materials/dividers/faded_line_01",
		value_id = "account_divider",
		pass_type = "texture",
		style_id = "account_divider"
	},
	{
		style_id = "account_name",
		value_id = "account_name",
		pass_type = "text"
	}
}
local game_mode_condition_widget_definitions = {
	victory = {
		static = {
			upper_left = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/victory_upper_left",
					style_id = "corner_decoration",
					pass_type = "texture"
				}
			}, "corner_top_left", nil, nil, ViewStyles.page_corner_decoration),
			upper_right = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/victory_upper_right",
					style_id = "corner_decoration",
					pass_type = "texture"
				}
			}, "corner_top_right", nil, nil, ViewStyles.page_corner_decoration),
			lower_back = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/victory_lower_back",
					style_id = "bottom_decoration",
					pass_type = "texture"
				}
			}, "screen", nil, nil, ViewStyles.page_bottom_decoration),
			lower_center = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/victory_lower_center",
					style_id = "bottom_center_decoration",
					pass_type = "texture"
				}
			}, "bottom_center", nil, nil, ViewStyles.page_bottom_center_decoration),
			lower_left = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/victory_lower_left",
					style_id = "corner_decoration",
					pass_type = "texture"
				},
				{
					value = "content/ui/materials/effects/end_of_round/victory_lower_left_candles",
					style_id = "candles",
					pass_type = "texture"
				}
			}, "corner_bottom_left", nil, nil, ViewStyles.page_corner_decoration),
			lower_right = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/victory_lower_right",
					style_id = "corner_decoration",
					pass_type = "texture"
				},
				{
					value = "content/ui/materials/effects/end_of_round/victory_lower_right_candles",
					style_id = "candles",
					pass_type = "texture"
				}
			}, "corner_bottom_right", nil, nil, ViewStyles.page_corner_decoration)
		},
		dynamic = {
			title_text = UIWidget.create_definition({
				{
					value = "Test title here",
					value_id = "mission_header",
					pass_type = "text",
					style_id = "mission_header"
				},
				{
					value = "content/ui/materials/dividers/faded_line_01",
					value_id = "divider",
					pass_type = "texture",
					style_id = "divider"
				},
				{
					value = "",
					value_id = "mission_sub_header",
					pass_type = "text",
					style_id = "mission_sub_header"
				}
			}, "title_text", nil, nil, ViewStyles.mission_header_victory),
			player_panel = UIWidget.create_definition(player_panel_pass_template, "panel", nil, nil, ViewStyles.player_panel_victory)
		}
	},
	defeat = {
		static = {
			upper_left = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/defeat_upper_left",
					style_id = "corner_decoration",
					pass_type = "texture"
				}
			}, "corner_top_left", nil, nil, ViewStyles.page_corner_decoration),
			upper_right = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/defeat_upper_right",
					style_id = "corner_decoration",
					pass_type = "texture"
				}
			}, "corner_top_right", nil, nil, ViewStyles.page_corner_decoration),
			lower_back = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/defeat_lower_back",
					style_id = "bottom_decoration",
					pass_type = "texture"
				}
			}, "screen", nil, nil, ViewStyles.page_bottom_decoration),
			lower_center = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/defeat_lower_center",
					style_id = "bottom_center_decoration",
					pass_type = "texture"
				}
			}, "bottom_center", nil, nil, ViewStyles.page_bottom_center_decoration),
			lower_left = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/defeat_lower_left",
					style_id = "corner_decoration",
					pass_type = "texture"
				}
			}, "corner_bottom_left", nil, nil, ViewStyles.page_corner_decoration),
			lower_right = UIWidget.create_definition({
				{
					value = "content/ui/materials/frames/end_of_round/defeat_lower_right",
					style_id = "corner_decoration",
					pass_type = "texture"
				}
			}, "corner_bottom_right", nil, nil, ViewStyles.page_corner_decoration),
			overlay = UIWidget.create_definition({
				{
					pass_type = "rect",
					style_id = "overlay"
				}
			}, "screen", nil, nil, ViewStyles.defeat_page_overlay)
		},
		dynamic = {
			title_text = UIWidget.create_definition({
				{
					value = "Test title here",
					value_id = "mission_header",
					pass_type = "text",
					style_id = "mission_header"
				},
				{
					value = "content/ui/materials/dividers/faded_line_01",
					value_id = "divider",
					pass_type = "texture",
					style_id = "divider"
				},
				{
					value_id = "mission_sub_header",
					pass_type = "text",
					style_id = "mission_sub_header",
					value = Utf8.upper(Localize("loc_end_view_mission_sub_header_defeat"))
				}
			}, "title_text", nil, nil, ViewStyles.mission_header_defeat),
			player_panel = UIWidget.create_definition(player_panel_pass_template, "panel", nil, nil, ViewStyles.player_panel_defeat)
		}
	}
}
local legend_inputs = {
	{
		key = "continue",
		input_action = "confirm_pressed",
		display_name = "loc_settings_menu_continue",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_continue_pressed",
		on_init_callback = "cb_on_input_legend_continue_created"
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	game_mode_condition_widget_definitions = game_mode_condition_widget_definitions
}
