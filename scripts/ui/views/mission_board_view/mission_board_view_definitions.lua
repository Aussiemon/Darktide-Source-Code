local ViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local ViewStyles = require("scripts/ui/views/mission_board_view/mission_board_view_styles")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local board_size = ViewSettings.board_size
local background = {
	vertical_alignment = "center",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		1330,
		554
	},
	position = {
		-295,
		180,
		1
	}
}
local corner_top_left = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "left",
	size = {
		172,
		230
	},
	position = {
		0,
		0,
		62
	}
}
local corner_top_right = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "right",
	size = {
		172,
		230
	},
	position = {
		0,
		0,
		62
	}
}
local corner_bottom_left = {
	vertical_alignment = "bottom",
	parent = "screen",
	horizontal_alignment = "left",
	size = {
		220,
		268
	},
	position = {
		0,
		0,
		62
	}
}
local corner_bottom_right = {
	vertical_alignment = "bottom",
	parent = "screen",
	horizontal_alignment = "right",
	size = {
		220,
		268
	},
	position = {
		0,
		0,
		62
	}
}
local header = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "left",
	size = {
		700,
		86
	},
	position = {
		0,
		77,
		3
	}
}
local header_text_top = {
	vertical_alignment = "top",
	parent = "header",
	horizontal_alignment = "left",
	size = {
		header.size[1] - 150,
		18
	},
	position = {
		150,
		7,
		1
	}
}
local header_text_center = {
	vertical_alignment = "center",
	parent = "header",
	horizontal_alignment = "left",
	size = {
		header_text_top.size[1],
		40
	},
	position = {
		header_text_top.position[1],
		15,
		1
	}
}
local header_text_bottom = {
	vertical_alignment = "bottom",
	parent = "header",
	horizontal_alignment = "left",
	size = {
		header_text_top.size[1],
		18
	},
	position = {
		header_text_top.position[1],
		20,
		1
	}
}
local table_rotation_hint = {
	vertical_alignment = "bottom",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		600,
		30
	},
	position = {
		-350,
		-100,
		1
	}
}
local grid_area = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "left",
	size = UIWorkspaceSettings.screen.size,
	position = UIWorkspaceSettings.screen.position
}
local grid_interaction = {
	vertical_alignment = "center",
	parent = "screen",
	horizontal_alignment = "left",
	size = {
		board_size[1],
		board_size[2]
	},
	position = {
		0,
		80,
		0
	}
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = background,
	corner_top_left = corner_top_left,
	corner_top_right = corner_top_right,
	corner_bottom_left = corner_bottom_left,
	corner_bottom_right = corner_bottom_right,
	header = header,
	header_text_top = header_text_top,
	header_text_center = header_text_center,
	header_text_bottom = header_text_bottom,
	table_rotation_hint = table_rotation_hint,
	grid_area = grid_area,
	grid_interaction = grid_interaction
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/mission_board_01_upper",
			style_id = "corner_left",
			pass_type = "texture",
			scenegraph_id = "corner_top_left"
		},
		{
			value = "content/ui/materials/frames/screen/mission_board_01_upper",
			style_id = "corner_right",
			pass_type = "texture_uv",
			scenegraph_id = "corner_top_right"
		},
		{
			value = "content/ui/materials/frames/screen/mission_board_01_lower",
			style_id = "corner_left",
			pass_type = "texture",
			scenegraph_id = "corner_bottom_left"
		},
		{
			value = "content/ui/materials/frames/screen/mission_board_01_lower",
			style_id = "corner_right",
			pass_type = "texture_uv",
			scenegraph_id = "corner_bottom_right"
		}
	}, "background", nil, nil, ViewStyles.background),
	header = UIWidget.create_definition({
		{
			value_id = "center_line",
			style_id = "board_header",
			pass_type = "text",
			scenegraph_id = "header_text_center",
			value = Managers.localization:localize("loc_mission_board_view_header_tertium_hive")
		},
		{
			value = "content/ui/materials/mission_board/frames/headline_background",
			style_id = "background",
			pass_type = "texture"
		}
	}, "header", nil, nil, ViewStyles.header),
	refresh_status = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style = UIFontSettings.mission_board_sub_header
		}
	}, "header_text_top"),
	grid_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "grid_interaction"),
	table_rotation_hint = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style = ViewStyles.legend_text
		}
	}, "table_rotation_hint")
}
local special_widgets_definition = {
	zone_line = UIWidget.create_definition({
		{
			value = "content/ui/materials/mission_board/frames/map_line",
			style_id = "line",
			pass_type = "rotated_texture"
		},
		{
			value = "content/ui/materials/mission_board/frames/map_line_end",
			style_id = "line_end",
			pass_type = "texture"
		}
	}, "screen", nil, {
		22,
		22
	}, ViewStyles.zone_line),
	icon_info = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "info_plate"
		},
		{
			value = "99999 \ue032",
			value_id = "tag_xp",
			pass_type = "text",
			style_id = "tag_xp"
		},
		{
			value = "99999 \ue031",
			value_id = "tag_reward",
			pass_type = "text",
			style_id = "tag_reward"
		},
		{
			pass_type = "rect",
			style_id = "info_plate_divider"
		},
		{
			style_id = "tag_timer",
			value_id = "tag_timer",
			pass_type = "text"
		}
	}, "screen", nil, {
		88,
		83
	}, ViewStyles.icon_info)
}
local animations = {
	show_icon = {
		{
			name = "fade_in_icon",
			start_time = 0,
			end_time = ViewSettings.icon_fade_time,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local icon_widget = params.widget
				icon_widget.alpha_multiplier = 0
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local icon_widget = params.widget
				icon_widget.alpha_multiplier = math.easeCubic(progress)
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local icon_widget = params.widget
				icon_widget.alpha_multiplier = 1
				local content = icon_widget.content
				content.animation_id = nil
			end
		}
	},
	hide_icon = {
		{
			name = "fade_out_icon",
			start_time = 0,
			end_time = ViewSettings.icon_fade_time,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local icon_widget = params.widget
				icon_widget.alpha_multiplier = math.easeCubic(1 - progress)
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local icon_widget = params.widget
				local content = icon_widget.content
				content.animation_id = nil
				icon_widget.visible = false
			end
		}
	}
}
local mission_board_view_definitions = {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	special_widgets_definition = special_widgets_definition
}

return settings("MissionBoardViewDefinitions", mission_board_view_definitions)
