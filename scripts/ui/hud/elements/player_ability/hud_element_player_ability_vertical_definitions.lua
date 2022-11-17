local HudElementPlayerAbilityHandlerSettings = require("scripts/ui/hud/elements/player_ability_handler/hud_element_player_ability_handler_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ability_size = HudElementPlayerAbilityHandlerSettings.ability_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	slot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = ability_size,
		position = {
			0,
			0,
			0
		}
	}
}
local counter_text_style = table.clone(UIFontSettings.hud_body)
counter_text_style.horizontal_alignment = "center"
counter_text_style.vertical_alignment = "center"
counter_text_style.text_horizontal_alignment = "center"
counter_text_style.text_vertical_alignment = "center"
counter_text_style.size = {
	50,
	50
}
counter_text_style.font_size = 24
counter_text_style.offset = {
	0,
	-(ability_size[1] * 0.5 + 15),
	2
}
counter_text_style.drop_shadow = false
local input_text_style = table.clone(UIFontSettings.hud_body)
input_text_style.horizontal_alignment = "center"
input_text_style.vertical_alignment = "top"
input_text_style.text_horizontal_alignment = "center"
input_text_style.text_vertical_alignment = "top"
input_text_style.size = {
	60,
	50
}
input_text_style.font_size = 20
input_text_style.offset = {
	0,
	ability_size[1] - 5,
	2
}
input_text_style.drop_shadow = false
input_text_style.text_color = {
	255,
	100,
	100,
	100
}
local widget_definitions = {
	ability = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = counter_text_style,
			visibility_function = function (content, style)
				local text = content.text

				return text ~= nil
			end
		},
		{
			value_id = "input_text",
			style_id = "input_text",
			pass_type = "text",
			value = "<n/a>",
			style = input_text_style,
			visibility_function = function (content, style)
				local input_text = content.input_text

				return input_text ~= nil
			end
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/talents/hud/combat_container",
			style = {
				material_values = {
					progress = 0
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local duration_progress = content.duration_progress
				style.material_values.progress = duration_progress
			end
		},
		{
			value = "content/ui/materials/icons/talents/hud/combat_frame_inner",
			style_id = "frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					128,
					128
				}
			}
		},
		{
			value = "content/ui/materials/effects/hud/combat_talent_glow",
			style_id = "frame_glow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					4
				},
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					128,
					128
				}
			}
		}
	}, "slot")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
