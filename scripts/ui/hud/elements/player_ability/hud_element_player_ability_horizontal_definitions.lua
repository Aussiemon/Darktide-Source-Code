-- chunkname: @scripts/ui/hud/elements/player_ability/hud_element_player_ability_horizontal_definitions.lua

local HudElementPlayerAbilityHandlerSettings = require("scripts/ui/hud/elements/player_ability_handler/hud_element_player_ability_handler_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ability_size = HudElementPlayerAbilityHandlerSettings.ability_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	slot = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = ability_size,
		position = {
			0,
			0,
			0,
		},
	},
}
local counter_text_style = table.clone(UIFontSettings.hud_body)

counter_text_style.horizontal_alignment = "center"
counter_text_style.vertical_alignment = "center"
counter_text_style.text_horizontal_alignment = "center"
counter_text_style.text_vertical_alignment = "center"
counter_text_style.size = {
	50,
	50,
}
counter_text_style.font_size = 24
counter_text_style.offset = {
	-(ability_size[1] * 0.5 + 15),
	0,
	2,
}
counter_text_style.drop_shadow = false

local input_text_style = table.clone(UIFontSettings.hud_body)

input_text_style.horizontal_alignment = "left"
input_text_style.vertical_alignment = "center"
input_text_style.text_horizontal_alignment = "left"
input_text_style.text_vertical_alignment = "center"
input_text_style.size = {
	60,
	50,
}
input_text_style.font_size = 20
input_text_style.offset = {
	ability_size[1] + 5,
	0,
	2,
}
input_text_style.drop_shadow = false
input_text_style.text_color = Color.ui_grey_light(255, true)

local widget_definitions = {
	ability = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<text>",
			value_id = "text",
			style = counter_text_style,
			visibility_function = function (content, style)
				local text = content.text

				return text ~= nil
			end,
		},
		{
			pass_type = "text",
			style_id = "input_text",
			value = "<n/a>",
			value_id = "input_text",
			style = input_text_style,
			visibility_function = function (content, style)
				local input_text = content.input_text

				return input_text ~= nil
			end,
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/icons/abilities/frames/background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					64,
					64,
				},
				offset = {
					0,
					0,
					0,
				},
				color = {
					150,
					102,
					102,
					102,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "background_overlay",
			value = "content/ui/materials/icons/abilities/frames/background_progress",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				material_values = {
					progress = 1,
				},
				size = {
					64,
					64,
				},
				offset = {
					0,
					0,
					1,
				},
				color = {
					150,
					102,
					102,
					102,
				},
			},
			change_function = function (content, style)
				local duration_progress = content.duration_progress

				style.material_values.progress = duration_progress
			end,
			visibility_function = function (content, style)
				local duration_progress = content.duration_progress

				return duration_progress ~= nil
			end,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/abilities/default",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					48,
					48,
				},
				offset = {
					0,
					0,
					3,
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
			style_id = "inner_line_thick",
			value = "content/ui/materials/icons/abilities/frames/inner_line_thick_progress",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				material_values = {
					progress = 1,
				},
				size = {
					64,
					64,
				},
				offset = {
					0,
					0,
					4,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
			change_function = function (content, style)
				local duration_progress = content.duration_progress

				style.material_values.progress = duration_progress
			end,
			visibility_function = function (content, style)
				local duration_progress = content.duration_progress

				return duration_progress ~= nil
			end,
		},
		{
			pass_type = "texture",
			style_id = "inner_line_thin",
			value = "content/ui/materials/icons/abilities/frames/inner_line_thin",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					64,
					64,
				},
				offset = {
					0,
					0,
					4,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
			visibility_function = function (content, style)
				local duration_progress = content.duration_progress

				return not duration_progress or duration_progress <= 0
			end,
		},
		{
			pass_type = "texture",
			style_id = "outer_line",
			value = "content/ui/materials/icons/abilities/frames/outer_line_progress",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				material_values = {
					progress = 1,
				},
				size = {
					64,
					64,
				},
				offset = {
					0,
					0,
					0,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
			change_function = function (content, style)
				local duration_progress = content.duration_progress or 1

				style.material_values.progress = duration_progress
			end,
		},
		{
			pass_type = "texture",
			style_id = "arrows_up",
			value = "content/ui/materials/icons/buffs/frames/direction_arrows",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					24,
					24,
				},
				offset = {
					0,
					-45,
					0,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
			visibility_function = function (content, style)
				local duration_progress = content.duration_progress
				local previous_duration_progress = content.previous_duration_progress

				if not duration_progress or not previous_duration_progress then
					return false
				end

				local visible = previous_duration_progress < duration_progress

				return visible
			end,
		},
	}, "slot"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
