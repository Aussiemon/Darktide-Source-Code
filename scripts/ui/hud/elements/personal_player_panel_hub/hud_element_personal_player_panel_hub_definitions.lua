﻿-- chunkname: @scripts/ui/hud/elements/personal_player_panel_hub/hud_element_personal_player_panel_hub_definitions.lua

local HudElementTeamPanelHandlerSettings = require("scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler_settings")
local HudElementPersonalPlayerPanelHubSettings = require("scripts/ui/hud/elements/personal_player_panel_hub/hud_element_personal_player_panel_hub_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local panel_size = HudElementPersonalPlayerPanelHubSettings.size
local panel_offset = HudElementTeamPanelHandlerSettings.panel_offset
local icon_size = HudElementPersonalPlayerPanelHubSettings.icon_size
local insignia_icon_size = HudElementPersonalPlayerPanelHubSettings.insignia_icon_size
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
	respawn_timer = {
		horizontal_alignment = "left",
		parent = "player_icon",
		vertical_alignment = "center",
		size = panel_size,
		position = {
			0,
			0,
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

local widget_definitions = {
	player_name = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<player_name>",
			value_id = "text",
			style = {
				default_font_size = 24,
				drop_shadow = true,
				font_size = 24,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "bottom",
				offset = {
					icon_size[1] + 40,
					-45,
					3,
				},
				font_type = hud_body_font_settings.font_type,
				text_color = UIHudSettings.color_tint_main_1,
				default_text_color = UIHudSettings.color_tint_main_1,
				dead_text_color = {
					200,
					80,
					80,
					80,
				},
			},
		},
	}, "panel_background"),
	character_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = {
				default_font_size = 24,
				drop_shadow = true,
				font_size = 18,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "bottom",
				offset = {
					icon_size[1] + 40,
					-25,
					3,
				},
				font_type = hud_body_font_settings.font_type,
				text_color = Color.terminal_text_body(255, true),
				default_text_color = Color.terminal_text_body(255, true),
				dead_text_color = {
					200,
					80,
					80,
					80,
				},
			},
		},
	}, "panel_background"),
	character_text = UIWidget.create_definition({
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
					icon_size[1] + 40,
					25,
					3,
				},
				font_type = hud_body_font_settings.font_type,
				font_size = hud_body_font_settings.font_size,
				default_font_size = hud_body_font_settings.font_size,
				text_color = Color.terminal_text_body_sub_header(255, true),
			},
		},
	}, "panel_background"),
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
				vertical_alignment = "bottom",
				color = Color.terminal_background_gradient(178.5, true),
				size_addition = {
					-150,
					0,
				},
				offset = {
					110,
					0,
					0,
				},
			},
		},
	}, "panel_background"),
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
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "insignia",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "insignia",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = insignia_icon_size,
				offset = {
					-40,
					0,
					1,
				},
				material_values = {
					columns = 1,
					grid_index = 1,
					rows = 1,
					use_placeholder_texture = 1,
				},
				color = {
					0,
					255,
					255,
					255,
				},
			},
		},
	}, "player_icon"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
