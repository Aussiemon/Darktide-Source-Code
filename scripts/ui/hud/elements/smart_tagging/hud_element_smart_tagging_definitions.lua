local HudElementSmartTaggingSettings = require("scripts/ui/hud/elements/smart_tagging/hud_element_smart_tagging_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local get_hud_color = UIHudSettings.get_hud_color
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	line_pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			100,
			100
		},
		position = {
			200,
			-180,
			1
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		size = {
			250,
			250
		},
		position = {
			0,
			0,
			1
		}
	}
}
local hover_color = get_hud_color("color_tint_main_1", 255)
local default_color = get_hud_color("color_tint_main_2", 255)
local icon_hover_color = get_hud_color("color_tint_main_2", 255)
local icon_default_color = get_hud_color("color_tint_main_3", 255)
local default_button_content = {
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_select
}
local simple_button_font_setting_name = "button_medium"
local simple_button_font_settings = UIFontSettings[simple_button_font_setting_name]
local simple_button_font_color = simple_button_font_settings.text_color
local button_pass_template = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = default_button_content
	},
	{
		pass_type = "texture",
		value_id = "icon",
		value = "content/ui/materials/hud/communication_wheel/icons/enemy",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				128,
				128
			},
			offset = {
				0,
				0,
				3
			},
			color = get_hud_color("color_tint_main_2", 255)
		},
		change_function = function (content, style)
			local color = style.color
			local ignore_alpha = false
			local hotspot = content.hotspot
			local anim_hover_progress = hotspot.anim_hover_progress

			ColorUtilities.color_lerp(icon_default_color, icon_hover_color, anim_hover_progress, color, ignore_alpha)
		end
	},
	{
		value = "content/ui/materials/hud/communication_wheel/slice_eighth_line",
		pass_type = "rotated_texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				190,
				140
			},
			offset = {
				0,
				0,
				4
			},
			color = get_hud_color("color_tint_main_1", 255)
		},
		change_function = function (content, style)
			style.angle = math.pi + (content.angle or 0)
			local color = style.color
			local ignore_alpha = false
			local hotspot = content.hotspot
			local anim_hover_progress = hotspot.anim_hover_progress

			ColorUtilities.color_lerp(default_color, hover_color, anim_hover_progress, color, ignore_alpha)
		end
	},
	{
		value = "content/ui/materials/hud/communication_wheel/slice_eighth_highlight",
		pass_type = "rotated_texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				2
			},
			size = {
				190,
				140
			},
			color = {
				150,
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			style.angle = math.pi + (content.angle or 0)
			local hotspot = content.hotspot
			local color = style.color
			local ignore_alpha = false
			local anim_hover_progress = hotspot.anim_hover_progress

			ColorUtilities.color_lerp(icon_default_color, icon_hover_color, anim_hover_progress, color, ignore_alpha)
		end
	},
	{
		value = "content/ui/materials/hud/communication_wheel/slice_eighth",
		pass_type = "rotated_texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				190,
				140
			},
			color = {
				150,
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			style.angle = math.pi + (content.angle or 0)
		end
	},
	{
		pass_type = "rect",
		style = {
			color = {
				200,
				40,
				40,
				40
			},
			offset = {
				0,
				0,
				1
			}
		},
		change_function = function (content, style)
			style.color[1] = math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress) * 255
		end
	},
	{
		value_id = "text",
		pass_type = "text",
		value = "Button",
		style = {
			text_vertical_alignment = "center",
			text_horizontal_alignment = "center",
			offset = {
				0,
				0,
				2
			},
			font_type = simple_button_font_settings.font_type,
			font_size = simple_button_font_settings.font_size,
			text_color = simple_button_font_color,
			default_text_color = simple_button_font_color
		},
		change_function = function (content, style)
			local default_text_color = style.default_text_color
			local text_color = style.text_color
			local progress = 1 - content.hotspot.anim_input_progress * 0.3
			text_color[2] = default_text_color[2] * progress
			text_color[3] = default_text_color[3] * progress
			text_color[4] = default_text_color[4] * progress
		end
	}
}
local wheel_font_style = table.clone(UIFontSettings.hud_body)
wheel_font_style.font_size = 28
wheel_font_style.horizontal_alignment = "center"
wheel_font_style.vertical_alignment = "center"
wheel_font_style.text_horizontal_alignment = "center"
wheel_font_style.text_vertical_alignment = "center"
wheel_font_style.offset = {
	0,
	0,
	4
}
local widget_definitions = {
	wheel_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/communication_wheel/middle_box",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					250,
					64
				},
				offset = {
					0,
					0,
					1
				},
				color = {
					120,
					0,
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return content.force_hover
			end
		},
		{
			value_id = "text",
			pass_type = "text",
			value = "n/a",
			style = wheel_font_style,
			visibility_function = function (content, style)
				return content.force_hover
			end
		},
		{
			value = "content/ui/materials/hud/communication_wheel/middle_circle",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "rotated_texture",
			style_id = "mark",
			value = "content/ui/materials/hud/communication_wheel/arrow",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					20,
					28
				},
				pivot = {
					10,
					147
				},
				offset = {
					0,
					-133,
					6
				},
				color = get_hud_color("color_tint_main_1", 255)
			},
			change_function = function (content, style)
				style.angle = math.pi - (content.angle or 0)
				local color = style.color
				local ignore_alpha = true
				local anim_hover_progress = content.force_hover and 1 or 0

				ColorUtilities.color_lerp(default_color, hover_color, anim_hover_progress, color, ignore_alpha)
			end
		}
	}, "background")
}
local input_interact_text_style = table.clone(UIFontSettings.hud_body)
input_interact_text_style.horizontal_alignment = "left"
input_interact_text_style.vertical_alignment = "top"
input_interact_text_style.text_horizontal_alignment = "left"
input_interact_text_style.text_vertical_alignment = "top"
input_interact_text_style.text_color = {
	255,
	160,
	160,
	160
}
input_interact_text_style.offset = {
	0,
	-28,
	5
}
local description_text_style = table.clone(UIFontSettings.hud_body)
description_text_style.horizontal_alignment = "left"
description_text_style.vertical_alignment = "top"
description_text_style.text_horizontal_alignment = "left"
description_text_style.text_vertical_alignment = "top"
description_text_style.offset = {
	0,
	5,
	5
}
local interaction_line_definition = UIWidget.create_definition({
	{
		value = "content/ui/materials/dividers/faded_line_left_01",
		style_id = "line",
		pass_type = "rotated_texture",
		style = {
			size = {
				100,
				4
			},
			pivot = {
				0,
				2
			},
			color = get_hud_color("color_tint_main_2", 255)
		}
	},
	{
		value = "content/ui/materials/dividers/faded_line_left_01",
		style_id = "background",
		pass_type = "texture",
		style = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			offset = {
				-1,
				0,
				0
			},
			size = {
				400,
				5
			},
			size_addition = {
				0,
				0
			},
			color = get_hud_color("color_tint_main_2", 255)
		}
	},
	{
		value_id = "input_text",
		style_id = "input_text",
		pass_type = "text",
		value = "<input_text>",
		style = input_interact_text_style
	},
	{
		value_id = "description_text",
		style_id = "description_text",
		pass_type = "text",
		value = "<description_text>",
		style = description_text_style
	}
}, "screen")

return {
	interaction_line_definition = interaction_line_definition,
	entry_widget_definition = UIWidget.create_definition(button_pass_template, "pivot"),
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
