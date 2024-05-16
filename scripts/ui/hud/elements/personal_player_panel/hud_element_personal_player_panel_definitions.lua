-- chunkname: @scripts/ui/hud/elements/personal_player_panel/hud_element_personal_player_panel_definitions.lua

local HudElementTeamPanelHandlerSettings = require("scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler_settings")
local HudElementPersonalPlayerPanelSettings = require("scripts/ui/hud/elements/personal_player_panel/hud_element_personal_player_panel_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local panel_size = HudElementPersonalPlayerPanelSettings.size
local panel_offset = HudElementTeamPanelHandlerSettings.panel_offset
local bar_size = HudElementPersonalPlayerPanelSettings.bar_size
local icon_size = HudElementPersonalPlayerPanelSettings.icon_size
local icon_bar_spacing = HudElementPersonalPlayerPanelSettings.icon_bar_spacing
local toughness_bar_size = {
	bar_size[1],
	8,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = panel_size,
		position = panel_offset,
	},
	panel_background = {
		horizontal_alignment = "left",
		parent = "background",
		vertical_alignment = "center",
		size = panel_size,
		position = {
			0,
			0,
			0,
		},
	},
	player_icon = {
		horizontal_alignment = "left",
		parent = "background",
		vertical_alignment = "center",
		size = icon_size,
		position = {
			33,
			0,
			2,
		},
	},
	bar = {
		horizontal_alignment = "left",
		parent = "panel_background",
		vertical_alignment = "center",
		size = bar_size,
		position = {
			128,
			18,
			2,
		},
	},
	toughness_bar = {
		horizontal_alignment = "left",
		parent = "bar",
		vertical_alignment = "center",
		size = toughness_bar_size,
		position = {
			0,
			-20,
			2,
		},
	},
	respawn_timer = {
		horizontal_alignment = "left",
		parent = "player_icon",
		vertical_alignment = "center",
		size = bar_size,
		position = {
			icon_size[1] + icon_bar_spacing[1] * 2 + bar_size[1],
			icon_bar_spacing[2],
			3,
		},
	},
}
local hud_body_font_setting_name = "hud_body"
local hud_body_font_settings = UIFontSettings[hud_body_font_setting_name]
local hud_body_font_color = UIHudSettings.color_tint_main_2

local function color_copy(target, source, alpha)
	target[1] = alpha or source[1]
	target[2] = source[2]
	target[3] = source[3]
	target[4] = source[4]

	return target
end

local value_text_style = {
	drop_shadow = true,
	font_size = 18,
	font_type = "machine_medium",
	horizontal_alignment = "left",
	text_horizontal_alignment = "right",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	text_color = UIHudSettings.color_tint_main_2,
	offset = {
		0,
		0,
		2,
	},
}
local widget_definitions = {
	player_name = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<player_name>",
			value_id = "text",
			style = {
				drop_shadow = true,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "bottom",
				offset = {
					0,
					-(bar_size[2] + 5),
					2,
				},
				size = {
					bar_size[1] * 1.5,
					bar_size[2],
				},
				font_type = hud_body_font_settings.font_type,
				font_size = hud_body_font_settings.font_size,
				default_font_size = hud_body_font_settings.font_size,
				text_color = hud_body_font_color,
				default_text_color = hud_body_font_color,
				dead_text_color = {
					200,
					80,
					80,
					80,
				},
			},
		},
	}, "toughness_bar"),
	respawn_timer = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<0.0>",
			value_id = "text",
			style = {
				drop_shadow = true,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				offset = {
					0,
					0,
					2,
				},
				size = {
					bar_size[1] * 1.5,
					bar_size[2],
				},
				font_type = hud_body_font_settings.font_type,
				font_size = hud_body_font_settings.font_size,
				default_font_size = hud_body_font_settings.font_size,
				text_color = UIHudSettings.color_tint_main_1,
				default_text_color = UIHudSettings.color_tint_main_1,
			},
		},
	}, "bar"),
	toughness = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					4,
				},
				size = toughness_bar_size,
				color = UIHudSettings.color_tint_6,
			},
		},
	}, "toughness_bar"),
	toughness_ghost = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					3,
				},
				size = toughness_bar_size,
				color = {
					255,
					90,
					90,
					90,
				},
			},
		},
	}, "toughness_bar"),
	toughness_bar_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				size = toughness_bar_size,
				color = UIHudSettings.color_tint_0,
			},
		},
	}, "toughness_bar"),
	voice_indicator = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/hud/icons/speaker",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					32,
					32,
				},
				offset = {
					-8,
					0,
					6,
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
	}, "panel_background"),
	panel_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/hud/backgrounds/terminal_background_team_panels",
			style = {
				horizontal_alignment = "left",
				color = Color.terminal_background_gradient(178.5, true),
				size_addition = {
					0,
					0,
				},
				offset = {
					110,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "hit_indicator",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = color_copy({}, UIHudSettings.color_tint_6, 0),
				size_addition = {
					20,
					20,
				},
				default_size_addition = {
					20,
					20,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "hit_indicator_armor_break",
			value = "content/ui/materials/frames/inner_shadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = color_copy({}, UIHudSettings.color_tint_6, 0),
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "panel_background"),
	health_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text_3",
			value = "0",
			value_id = "text_3",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 3,
				text_color = UIHudSettings.color_tint_main_1,
				default_color = UIHudSettings.color_tint_main_1,
				dimmed_color = UIHudSettings.color_tint_main_3,
				offset = {
					40,
				},
			}),
		},
		{
			pass_type = "text",
			style_id = "text_2",
			value = "0",
			value_id = "text_2",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 2,
				text_color = UIHudSettings.color_tint_main_1,
				default_color = UIHudSettings.color_tint_main_1,
				dimmed_color = UIHudSettings.color_tint_main_3,
				offset = {
					28,
				},
			}),
		},
		{
			pass_type = "text",
			style_id = "text_1",
			value = "0",
			value_id = "text_1",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 1,
				text_color = UIHudSettings.color_tint_main_1,
				default_color = UIHudSettings.color_tint_main_1,
				dimmed_color = UIHudSettings.color_tint_main_3,
				offset = {
					16,
				},
			}),
		},
	}, "bar"),
	toughness_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text_3",
			value = "0",
			value_id = "text_3",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 3,
				text_color = UIHudSettings.color_tint_6,
				default_color = UIHudSettings.color_tint_6,
				dimmed_color = UIHudSettings.color_tint_7,
				offset = {
					40,
				},
			}),
		},
		{
			pass_type = "text",
			style_id = "text_2",
			value = "0",
			value_id = "text_2",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 2,
				text_color = UIHudSettings.color_tint_6,
				default_color = UIHudSettings.color_tint_6,
				dimmed_color = UIHudSettings.color_tint_7,
				offset = {
					28,
				},
			}),
		},
		{
			pass_type = "text",
			style_id = "text_1",
			value = "0",
			value_id = "text_1",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 1,
				text_color = UIHudSettings.color_tint_6,
				default_color = UIHudSettings.color_tint_6,
				dimmed_color = UIHudSettings.color_tint_7,
				offset = {
					16,
				},
			}),
		},
	}, "toughness_bar"),
	bonus_toughness_text = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "+",
			value_id = "plus_sign",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 3,
				text_color = UIHudSettings.color_tint_10,
				default_color = UIHudSettings.color_tint_10,
				dimmed_color = UIHudSettings.color_tint_7,
				offset = {
					55,
				},
			}),
		},
		{
			pass_type = "text",
			style_id = "text_1",
			value = "0",
			value_id = "text_1",
			style = table.merge_recursive(table.clone(value_text_style), {
				horizontal_alignment = "center",
				index = 1,
				text_color = UIHudSettings.color_tint_6,
				default_color = UIHudSettings.color_tint_6,
				dimmed_color = UIHudSettings.color_tint_7,
				offset = {
					80,
				},
			}),
		},
	}, "toughness_bar"),
	player_icon = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/base/ui_portrait_frame_base",
			value_id = "texture",
			style = {
				material_values = {
					columns = 1,
					grid_index = 1,
					rows = 1,
					use_placeholder_texture = 1,
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
	}, "player_icon"),
	status_icon = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/icons/player_states/dead",
			value_id = "texture",
			style = {
				color = UIHudSettings.color_tint_main_1,
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "player_icon"),
}
local health_bar_segment_definition = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			offset = {
				0,
				0,
				2,
			},
			size = bar_size,
			color = UIHudSettings.color_tint_0,
		},
	},
	{
		pass_type = "texture",
		style_id = "health",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			offset = {
				0,
				0,
				4,
			},
			size = bar_size,
			color = UIHudSettings.color_tint_main_1,
		},
	},
	{
		pass_type = "texture",
		style_id = "ghost",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			offset = {
				0,
				0,
				3,
			},
			size = bar_size,
			color = {
				255,
				90,
				90,
				90,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "corruption",
		value = "content/ui/materials/hud/backgrounds/player_health_fill",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			offset = {
				0,
				0,
				5,
			},
			size = bar_size,
			color = UIHudSettings.color_tint_8,
		},
	},
}, "bar", nil, bar_size)

return {
	health_bar_segment_definition = health_bar_segment_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
