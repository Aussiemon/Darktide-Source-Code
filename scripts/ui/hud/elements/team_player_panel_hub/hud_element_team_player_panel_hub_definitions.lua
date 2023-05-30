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
local icon_bar_spacing = HudElementTeamPlayerPanelHubSettings.icon_bar_spacing
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = panel_size,
		position = panel_offset
	},
	panel_background = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "left",
		size = panel_size,
		position = {
			0,
			0,
			0
		}
	},
	player_icon = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "left",
		size = icon_size,
		position = {
			33,
			0,
			2
		}
	},
	bar = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "left",
		size = bar_size,
		position = {
			112,
			36,
			2
		}
	},
	respawn_timer = {
		vertical_alignment = "center",
		parent = "player_icon",
		horizontal_alignment = "left",
		size = bar_size,
		position = {
			icon_size[1] + icon_bar_spacing[1] * 2 + bar_size[1],
			icon_bar_spacing[2],
			3
		}
	}
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
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<player_name>",
			style = {
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "left",
				offset = {
					0,
					-bar_size[2] - 5,
					4
				},
				default_offset = {
					0,
					-bar_size[2] - 5,
					2
				},
				size = {
					panel_size[1],
					bar_size[2]
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
					80
				}
			}
		}
	}, "bar"),
	rich_presence = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<rich_presence>",
			style = {
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				offset = {
					0,
					0,
					4
				},
				size = {
					bar_size[1] * 1.5,
					bar_size[2]
				},
				font_type = rich_presence_font_settings.font_type,
				font_size = rich_presence_font_settings.font_size,
				default_font_size = rich_presence_font_settings.font_size,
				text_color = rich_presence_font_color,
				default_text_color = rich_presence_font_color,
				dead_text_color = {
					200,
					80,
					80,
					80
				}
			}
		}
	}, "bar"),
	voice_indicator = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/player_states/voice_chat_top",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					28,
					28
				},
				offset = {
					25,
					0,
					6
				},
				color = UIHudSettings.color_tint_main_1
			}
		}
	}, "panel_background"),
	panel_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/backgrounds/terminal_background_team_panels",
			style_id = "background",
			pass_type = "texture",
			style = {
				horizontal_alignment = "left",
				color = Color.terminal_background_gradient(178.5, true),
				offset = {
					100,
					0,
					0
				}
			}
		}
	}, "panel_background"),
	player_icon = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_portrait_frame_base",
			style = {
				material_values = {
					use_placeholder_texture = 1,
					rows = 1,
					columns = 1,
					grid_index = 1
				}
			}
		},
		{
			value = "content/ui/materials/base/ui_default_base",
			style_id = "insignia",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					30,
					80
				},
				offset = {
					-40,
					0,
					1
				},
				material_values = {
					use_placeholder_texture = 1,
					rows = 1,
					columns = 1,
					grid_index = 1
				},
				color = {
					0,
					255,
					255,
					255
				}
			}
		}
	}, "player_icon")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
