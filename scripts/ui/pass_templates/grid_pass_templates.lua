local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local GridPassTemplates = {}
local grid_button_font_setting_name = "button_medium"
local grid_button_font_settings = UIFontSettings[grid_button_font_setting_name]
GridPassTemplates.grid_button = {
	{
		pass_type = "hotspot",
		content_id = "hotspot"
	},
	{
		value = "content/ui/materials/buttons/list_big_hover",
		pass_type = "texture",
		change_function = " style.color[1] = content.hotspot.anim_hover_progress*100 ",
		style = {
			color = {
				255,
				119,
				78,
				45
			},
			offset = {
				0,
				0,
				2
			}
		}
	},
	{
		visibility_function = " content.focused ",
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			color = {
				255,
				197,
				159,
				121
			},
			offset = {
				-5,
				0,
				5
			},
			size = {
				15,
				15
			}
		}
	},
	{
		visibility_function = " content.draw_arrow ",
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			color = {
				255,
				197,
				159,
				121
			},
			offset = {
				-10,
				0,
				5
			},
			size = {
				15,
				15
			}
		}
	},
	{
		value_id = "text",
		pass_type = "text",
		value = "Button",
		style = table.merge_recursive({
			offset = {
				15,
				0,
				3
			}
		}, grid_button_font_settings),
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
GridPassTemplates.grid_rect = {
	{
		pass_type = "hotspot",
		content_id = "hotspot"
	},
	{
		pass_type = "rect",
		style_id = "rect"
	},
	{
		change_function = " style.color[1] = content.hotspot.anim_hover_progress*80 ",
		pass_type = "rect",
		style = {
			color = {
				50,
				50,
				50,
				50
			},
			offset = {
				0,
				0,
				1
			}
		}
	},
	{
		visibility_function = " content.focused ",
		pass_type = "rect",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			color = {
				200,
				255,
				255,
				255
			},
			size = {
				10,
				10
			},
			offset = {
				0,
				0,
				2
			}
		}
	}
}
GridPassTemplates.grid_texture = {
	{
		pass_type = "hotspot",
		content_id = "hotspot"
	},
	{
		pass_type = "texture",
		style_id = "texture"
	},
	{
		change_function = " style.color[1] = content.hotspot.anim_hover_progress*80 ",
		pass_type = "rect",
		style = {
			color = {
				50,
				50,
				50,
				50
			},
			offset = {
				0,
				0,
				1
			}
		}
	},
	{
		visibility_function = " content.focused ",
		pass_type = "rect",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			color = {
				200,
				255,
				255,
				255
			},
			size = {
				10,
				10
			},
			offset = {
				0,
				0,
				2
			}
		}
	}
}
GridPassTemplates.grid_divider = {
	{
		value = "content/ui/materials/dividers/skull_center_03",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				468,
				16
			},
			color = {
				255,
				119,
				78,
				45
			}
		}
	}
}

return GridPassTemplates
