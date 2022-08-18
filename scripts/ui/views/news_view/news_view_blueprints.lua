local UIFonts = require("scripts/managers/ui/ui_fonts")
local TextStyles = require("scripts/ui/views/news_view/news_view_text_styles")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local widget_width = 675
local widget_blueprints_by_type = {}
widget_blueprints_by_type.header = {
	pass_template = {
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			style = TextStyles.slide_title_style
		}
	},
	size = {
		widget_width,
		100
	},
	init = function (parent, widget, data)
		local content = widget.content
		local style = widget.style
		local text_style = style.text
		local widget_size = content.size
		content.text = data.text
		local text_options = UIFonts.get_font_options_by_style(text_style)
		local _, text_height = UIRenderer.text_size(parent._offscreen_renderer, data.text, text_style.font_type, text_style.font_size, widget_size, text_options)
		widget_size[2] = text_height
		widget.alpha_multiplier = 0
	end
}
widget_blueprints_by_type.body = {
	pass_template = {
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			style = TextStyles.slide_text_style
		}
	},
	size = {
		widget_width,
		800
	},
	init = function (parent, widget, data)
		local content = widget.content
		local style = widget.style
		local text_style = style.text
		local widget_size = content.size
		content.text = data.text
		local text_options = UIFonts.get_font_options_by_style(text_style)
		local _, text_height = UIRenderer.text_size(parent._offscreen_renderer, data.text, text_style.font_type, text_style.font_size, widget_size, text_options)
		widget_size[2] = text_height
		widget.alpha_multiplier = 0
	end
}
widget_blueprints_by_type.left_image = {
	pass_template = {
		{
			style_id = "left_image",
			pass_type = "texture",
			value_id = "left_image",
			style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	},
	init = function (parent, widget, data)
		local content = widget.content
		local style = widget.style
		content.left_image = data.texture
		widget.alpha_multiplier = 0
	end
}
widget_blueprints_by_type.spacing_vertical = {
	size = {
		widget_width,
		40
	}
}

return widget_blueprints_by_type
