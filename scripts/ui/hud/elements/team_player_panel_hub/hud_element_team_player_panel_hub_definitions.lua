-- chunkname: @scripts/ui/hud/elements/team_player_panel_hub/hud_element_team_player_panel_hub_definitions.lua

local HudElementTeamPanelHandlerSettings = require("scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler_settings")
local HudElementTeamPlayerPanelHubSettings = require("scripts/ui/hud/elements/team_player_panel_hub/hud_element_team_player_panel_hub_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local panel_size = HudElementTeamPanelHandlerSettings.panel_size
local panel_offset = HudElementTeamPanelHandlerSettings.panel_offset
local bar_size = HudElementTeamPlayerPanelHubSettings.size
local icon_size = HudElementTeamPlayerPanelHubSettings.icon_size
local insignia_icon_size = HudElementTeamPlayerPanelHubSettings.insignia_icon_size
local icon_bar_spacing = HudElementTeamPlayerPanelHubSettings.icon_bar_spacing
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
		parent = "background",
		vertical_alignment = "top",
		size = bar_size,
		position = {
			112,
			36,
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

local function color_copy(target, source, alpha)
	target[1] = alpha or source[1]
	target[2] = source[2]
	target[3] = source[3]
	target[4] = source[4]

	return target
end

local hud_body_font_setting_name = "hud_body"
local hud_body_font_settings = UIFontSettings[hud_body_font_setting_name]
local hud_body_font_color = UIHudSettings.color_tint_main_2
local rich_presence_font_settings = table.clone(UIFontSettings.hud_body)
local rich_presence_font_color = UIHudSettings.color_tint_main_2
local widget_definitions = {
	player_name = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<player_name>",
			value_id = "text",
			style = {
				text_horizontal_alignment = "left",
				text_vertical_alignment = "bottom",
				offset = {
					0,
					-bar_size[2] - 12,
					4,
				},
				default_offset = {
					0,
					-bar_size[2] - 12,
					2,
				},
				size = {
					panel_size[1],
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
	}, "bar"),
	character_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = {
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				offset = {
					0,
					-7,
					4,
				},
				size = {
					bar_size[1] * 1.5,
					bar_size[2],
				},
				font_type = rich_presence_font_settings.font_type,
				font_size = rich_presence_font_settings.font_size - 2,
				default_font_size = rich_presence_font_settings.font_size - 2,
				text_color = rich_presence_font_color,
				default_text_color = rich_presence_font_color,
				dead_text_color = {
					200,
					80,
					80,
					80,
				},
			},
		},
	}, "bar"),
	rich_presence = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<rich_presence>",
			value_id = "text",
			style = {
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				offset = {
					0,
					bar_size[2] + 4,
					4,
				},
				size = {
					bar_size[1] * 1.5,
					bar_size[2],
				},
				font_type = rich_presence_font_settings.font_type,
				font_size = rich_presence_font_settings.font_size - 2,
				default_font_size = rich_presence_font_settings.font_size - 2,
				text_color = rich_presence_font_color,
				default_text_color = rich_presence_font_color,
				dead_text_color = {
					200,
					80,
					80,
					80,
				},
			},
		},
	}, "bar"),
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
				offset = {
					100,
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
					-insignia_icon_size[1],
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
