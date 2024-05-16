-- chunkname: @scripts/ui/pass_templates/grid_pass_templates.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local GridPassTemplates = {}
local grid_button_font_setting_name = "button_medium"
local grid_button_font_settings = UIFontSettings[grid_button_font_setting_name]

GridPassTemplates.grid_button = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/buttons/list_big_hover",
		style = {
			color = {
				255,
				119,
				78,
				45,
			},
			offset = {
				0,
				0,
				2,
			},
		},
		change_function = function (content, style)
			style.color[1] = content.hotspot.anim_hover_progress * 100
		end,
	},
	{
		pass_type = "rect",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			color = {
				255,
				197,
				159,
				121,
			},
			offset = {
				-5,
				0,
				5,
			},
			size = {
				15,
				15,
			},
		},
		visibility_function = function (content)
			return content.focused
		end,
	},
	{
		pass_type = "rect",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			color = {
				255,
				197,
				159,
				121,
			},
			offset = {
				-10,
				0,
				5,
			},
			size = {
				15,
				15,
			},
		},
		visibility_function = function (content)
			return content.draw_arrow
		end,
	},
	{
		pass_type = "text",
		value = "Button",
		value_id = "text",
		style = table.merge_recursive({
			offset = {
				15,
				0,
				3,
			},
		}, grid_button_font_settings),
		change_function = function (content, style)
			local default_text_color = style.default_text_color
			local text_color = style.text_color
			local progress = 1 - content.hotspot.anim_input_progress * 0.3

			text_color[2] = default_text_color[2] * progress
			text_color[3] = default_text_color[3] * progress
			text_color[4] = default_text_color[4] * progress
		end,
	},
}
GridPassTemplates.grid_rect = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
	},
	{
		pass_type = "rect",
		style_id = "rect",
	},
	{
		pass_type = "rect",
		style = {
			color = {
				50,
				50,
				50,
				50,
			},
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			style.color[1] = content.hotspot.anim_hover_progress * 80
		end,
	},
	{
		pass_type = "rect",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			color = {
				200,
				255,
				255,
				255,
			},
			size = {
				10,
				10,
			},
			offset = {
				0,
				0,
				2,
			},
		},
		visibility_function = function (content)
			return content.focused
		end,
	},
}
GridPassTemplates.grid_texture = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
	},
	{
		pass_type = "texture",
		style_id = "texture",
	},
	{
		pass_type = "rect",
		style = {
			color = {
				50,
				50,
				50,
				50,
			},
			offset = {
				0,
				0,
				1,
			},
		},
		change_function = function (content, style)
			style.color[1] = content.hotspot.anim_hover_progress * 80
		end,
	},
	{
		pass_type = "rect",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			color = {
				200,
				255,
				255,
				255,
			},
			size = {
				10,
				10,
			},
			offset = {
				0,
				0,
				2,
			},
		},
		visibility_function = function (content)
			return content.focused
		end,
	},
}
GridPassTemplates.grid_divider = {
	{
		pass_type = "texture",
		value = "content/ui/materials/dividers/skull_center_03",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				468,
				16,
			},
			color = {
				255,
				119,
				78,
				45,
			},
		},
	},
}

return GridPassTemplates
