local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local DefaultPassTemplates = {}

local function create_font_settings_text_pass(font_settings_name)
	local font_settings = UIFontSettings[font_settings_name]
	local style = table.clone(font_settings)
	local text_pass = {
		value_id = "text",
		pass_type = "text",
		style = style
	}

	return text_pass
end

DefaultPassTemplates.header_text = {
	create_font_settings_text_pass("header_1")
}
DefaultPassTemplates.header_1_text = {
	create_font_settings_text_pass("header_1"),
	{
		value = "content/ui/materials/dividers/skull_left_02",
		pass_type = "texture",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			offset = {
				0,
				0,
				0
			},
			size = {
				571,
				12
			},
			color = Color.ui_brown_medium(255, true)
		}
	}
}
DefaultPassTemplates.header_2_text = {
	create_font_settings_text_pass("header_2")
}
DefaultPassTemplates.header_2_text = {
	create_font_settings_text_pass("header_2"),
	{
		value = "content/ui/materials/dividers/skull_left_02",
		pass_type = "texture",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			offset = {
				0,
				4,
				0
			},
			size = {
				576,
				22
			},
			color = Color.ui_brown_medium(255, true)
		}
	}
}
DefaultPassTemplates.header_3_text = {
	create_font_settings_text_pass("header_3")
}
DefaultPassTemplates.body_text = {
	create_font_settings_text_pass("body")
}
local simple_button_font_setting_name = "button_medium"
local simple_button_font_settings = UIFontSettings[simple_button_font_setting_name]
local simple_button_font_color = simple_button_font_settings.text_color
DefaultPassTemplates.simple_button = {
	{
		pass_type = "hotspot",
		content_id = "hotspot"
	},
	{
		pass_type = "rect",
		style = {
			color = {
				200,
				160,
				160,
				160
			}
		}
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

return DefaultPassTemplates
