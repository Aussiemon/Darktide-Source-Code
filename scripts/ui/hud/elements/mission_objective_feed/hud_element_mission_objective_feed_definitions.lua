-- chunkname: @scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_definitions.lua

local HudElementMissionObjectiveFeedSettings = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local header_size = HudElementMissionObjectiveFeedSettings.header_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	area = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			header_size[1],
			200,
		},
		position = {
			-50,
			100,
			1,
		},
	},
	background = {
		horizontal_alignment = "right",
		parent = "area",
		vertical_alignment = "top",
		size = {
			header_size[1],
			50,
		},
		position = {
			0,
			0,
			1,
		},
	},
	pivot = {
		horizontal_alignment = "right",
		parent = "background",
		vertical_alignment = "top",
		size = {
			header_size[1],
			50,
		},
		position = {
			10,
			0,
			1,
		},
	},
}

local function color_copy(target, source, alpha)
	target[1] = alpha or source[1]
	target[2] = source[2]
	target[3] = source[3]
	target[4] = source[4]

	return target
end

local alert_size = {
	header_size[1] - 10,
	30,
}
local alert_text_style = table.clone(UIFontSettings.hud_body)

alert_text_style.horizontal_alignment = "left"
alert_text_style.vertical_alignment = "bottom"
alert_text_style.text_horizontal_alignment = "center"
alert_text_style.text_vertical_alignment = "center"
alert_text_style.font_size = 20
alert_text_style.offset = {
	0,
	-1,
	7,
}
alert_text_style.size = alert_size
alert_text_style.text_color = {
	255,
	70,
	38,
	0,
}
alert_text_style.drop_shadow = true

local function create_mission_objective(scenegraph_id)
	local header_font_settings = UIFontSettings.hud_body
	local drop_shadow = true
	local header_font_color = HudElementMissionObjectiveFeedSettings.base_color
	local icon_size = {
		32,
		32,
	}
	local bar_icon_size = {
		24,
		24,
	}
	local icon_offset = 10
	local side_offset = 10
	local bar_offset = {
		icon_size[1] + side_offset + icon_offset,
		1,
		0,
	}
	local bar_size = {
		header_size[1] - (bar_offset[1] + icon_offset + side_offset * 2),
		10,
	}
	local pass_definitions = {
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/objectives/bonus",
			value_id = "icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = icon_size,
				offset = {
					icon_offset,
					0,
					6,
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
		{
			pass_type = "text",
			style_id = "header_text",
			value = "<header_text>",
			value_id = "header_text",
			style = {
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					bar_offset[1],
					0,
					6,
				},
				default_offset = {
					bar_offset[1],
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					header_size[1] - (side_offset * 2 + icon_size[1] * 2),
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "bar_background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					6,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					6,
				},
				size = bar_size,
				color = {
					150,
					0,
					0,
					0,
				},
			},
			visibility_function = function (content)
				return content.show_bar
			end,
		},
		{
			pass_type = "texture",
			style_id = "bar",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					7,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					7,
				},
				size = bar_size,
				default_length = bar_size[1],
			},
			visibility_function = function (content)
				return content.show_bar
			end,
		},
		{
			pass_type = "texture",
			style_id = "bar_icon",
			value = "content/ui/materials/icons/objectives/bonus",
			value_id = "bar_icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					8,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					8,
				},
				size = bar_icon_size,
				color = UIHudSettings.color_tint_main_1,
			},
			visibility_function = function (content)
				return content.bar_icon and content.show_bar
			end,
		},
		{
			pass_type = "text",
			style_id = "counter_text",
			value = "",
			value_id = "counter_text",
			style = {
				horizontal_alignment = "right",
				text_horizontal_alignment = "right",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					-(side_offset * 2),
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					bar_size[1],
				},
			},
		},
		{
			pass_type = "text",
			style_id = "timer_text",
			value = "",
			value_id = "timer_text",
			style = {
				font_size = 26,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					0,
					0,
					6,
				},
				default_offset = {
					header_size[1] - side_offset * 2,
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					header_size[1],
				},
			},
		},
	}

	return UIWidget.create_definition(pass_definitions, scenegraph_id, nil, header_size)
end

local function create_mission_objective_overarching(scenegraph_id)
	local header_font_settings = UIFontSettings.hud_body
	local drop_shadow = false
	local header_font_color = HudElementMissionObjectiveFeedSettings.base_color
	local icon_size = {
		32,
		32,
	}
	local bar_icon_size = {
		24,
		24,
	}
	local icon_offset = 10
	local side_offset = 10
	local bar_offset = {
		icon_size[1] + side_offset + icon_offset,
		1,
		0,
	}
	local bar_size = {
		header_size[1] - (bar_offset[1] + icon_offset + side_offset * 2),
		10,
	}
	local pass_definitions = {
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/objectives/bonus",
			value_id = "icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = icon_size,
				offset = {
					icon_offset,
					0,
					6,
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
		{
			pass_type = "text",
			style_id = "header_text",
			value = "<header_text>",
			value_id = "header_text",
			style = {
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					bar_offset[1],
					0,
					6,
				},
				default_offset = {
					bar_offset[1],
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					header_size[1] - (side_offset * 2 + icon_size[1] * 2),
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "bar_background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					6,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					6,
				},
				size = bar_size,
				color = {
					150,
					0,
					0,
					0,
				},
			},
			visibility_function = function (content)
				return content.show_bar
			end,
		},
		{
			pass_type = "texture",
			style_id = "bar",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					7,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					7,
				},
				size = bar_size,
				default_length = bar_size[1],
			},
			visibility_function = function (content)
				return content.show_bar
			end,
		},
		{
			pass_type = "texture",
			style_id = "bar_icon",
			value = "content/ui/materials/icons/objectives/bonus",
			value_id = "bar_icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					8,
				},
				default_offset = {
					bar_offset[1],
					bar_offset[2],
					8,
				},
				size = bar_icon_size,
				color = UIHudSettings.color_tint_main_1,
			},
			visibility_function = function (content)
				return content.bar_icon and content.show_bar
			end,
		},
		{
			pass_type = "text",
			style_id = "counter_text",
			value = "",
			value_id = "counter_text",
			style = {
				text_horizontal_alignment = "right",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					bar_offset[1],
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					bar_size[1],
				},
			},
		},
		{
			pass_type = "text",
			style_id = "timer_text",
			value = "",
			value_id = "timer_text",
			style = {
				font_size = 26,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "top",
				offset = {
					0,
					0,
					6,
				},
				default_offset = {
					header_size[1] - side_offset * 2,
					0,
					6,
				},
				font_type = header_font_settings.font_type,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					bar_size[1],
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value_id = "alert_text",
			value = Utf8.upper(Localize("loc_objective_op_train_alert_header")),
			style = alert_text_style,
			visibility_function = function (content)
				return content.show_alert
			end,
		},
		{
			pass_type = "rect",
			style_id = "alert_background",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					1,
				},
				size = alert_size,
				color = {
					230,
					255,
					151,
					29,
				},
			},
			visibility_function = function (content)
				return content.show_alert
			end,
		},
		{
			pass_type = "texture",
			style_id = "hazard_above",
			value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
			style = {
				offset = {
					0,
					0,
					1,
				},
				size = {
					alert_size[1],
					15,
				},
				base_color = UIHudSettings.color_tint_main_2,
			},
		},
		{
			pass_type = "texture",
			style_id = "hazard_below",
			value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					1,
				},
				size = {
					alert_size[1],
					15,
				},
				color = UIHudSettings.color_tint_main_2,
			},
			visibility_function = function (content)
				return content.category == "overarching" and not content.show_alert
			end,
		},
		{
			pass_type = "texture",
			style_id = "overarching_background",
			value = "content/ui/materials/hud/backgrounds/terminal_background_weapon",
			style = {
				size = {
					alert_size[1],
				},
				color = UIHudSettings.color_tint_main_2,
				offset = {
					0,
					0,
					0,
				},
			},
		},
	}

	return UIWidget.create_definition(pass_definitions, scenegraph_id, nil, header_size)
end

local function create_mission_objective_warning(scenegraph_id)
	local pass_definitions = {
		{
			pass_type = "texture",
			style_id = "hazard_above",
			value = "content/ui/materials/patterns/diagonal_lines_pattern_01",
			style = {
				offset = {
					0,
					0,
					1,
				},
				size = {
					alert_size[1],
				},
				color = UIHudSettings.color_tint_main_2,
			},
		},
	}

	return UIWidget.create_definition(pass_definitions, scenegraph_id, nil, {
		header_size[1],
		15,
	})
end

local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/hud/backgrounds/terminal_background_weapon",
			style = {
				vertical_alignment = "top",
				color = Color.terminal_background_gradient(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "ground_emitter",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					4,
				},
				offset = {
					0,
					0,
					5,
				},
				color = Color.terminal_corner_hover(nil, true),
			},
		},
	}, "background"),
}
local animations = {}
local objective_definition_default = create_mission_objective("pivot")
local objective_definition_overarching = create_mission_objective_overarching("pivot")
local objective_definition_warning = create_mission_objective_warning("pivot")

return {
	animations = animations,
	objective_definitions = {
		default = objective_definition_default,
		side_mission = objective_definition_default,
		overarching = objective_definition_overarching,
		warning = objective_definition_warning,
	},
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
