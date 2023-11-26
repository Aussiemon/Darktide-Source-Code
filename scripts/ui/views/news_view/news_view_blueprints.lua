-- chunkname: @scripts/ui/views/news_view/news_view_blueprints.lua

local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local NewsViewSettings = require("scripts/ui/views/news_view/news_view_settings")
local window_size = NewsViewSettings.window_size
local grid_size = NewsViewSettings.grid_size
local widget_blueprints_by_type = {
	dynamic_spacing = {
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2]
			} or {
				225,
				20
			}
		end
	},
	image = {
		size = {
			grid_size[1],
			100
		},
		pass_template = {
			{
				style_id = "texture",
				value_id = "texture",
				pass_type = "texture",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					color = Color.white(255, true),
					offset = {
						0,
						0,
						1
					},
					size_addition = {
						0,
						0
					}
				}
			}
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2]
			} or {
				225,
				20
			}
		end,
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local image = element.image
			local color = element.color

			content.element = element
			content.texture = image

			if color then
				style.texture.color = color
			end
		end
	},
	header = {
		size = {
			grid_size[1],
			100
		},
		pass_template = {
			{
				style_id = "text",
				value_id = "text",
				pass_type = "text",
				value = "n/a",
				style = {
					font_size = 28,
					text_vertical_alignment = "top",
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_color = Color.terminal_text_header(255, true),
					size = {
						grid_size[1],
						0
					},
					offset = {
						0,
						0,
						1
					},
					size_addition = {
						0,
						0
					}
				}
			}
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local new_indicator_width_offset = element.new_indicator_width_offset

			if new_indicator_width_offset then
				local offset = style.new_indicator.offset

				offset[1] = new_indicator_width_offset[1]
				offset[2] = new_indicator_width_offset[2]
				offset[3] = new_indicator_width_offset[3]
			end

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local height = ui_renderer and UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options) or size[2]

			size[2] = height + 0
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end
	},
	sub_header = {
		size = {
			grid_size[1],
			100
		},
		pass_template = {
			{
				style_id = "text",
				value_id = "text",
				pass_type = "text",
				value = "n/a",
				style = {
					font_size = 20,
					text_vertical_alignment = "top",
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_color = Color.terminal_text_body_sub_header(255, true),
					size = {
						grid_size[1],
						0
					},
					offset = {
						0,
						0,
						1
					},
					size_addition = {
						0,
						0
					}
				}
			}
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local new_indicator_width_offset = element.new_indicator_width_offset

			if new_indicator_width_offset then
				local offset = style.new_indicator.offset

				offset[1] = new_indicator_width_offset[1]
				offset[2] = new_indicator_width_offset[2]
				offset[3] = new_indicator_width_offset[3]
			end

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local height = ui_renderer and UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options) or size[2]

			size[2] = height + 0
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end
	},
	body = {
		size = {
			grid_size[1],
			100
		},
		pass_template = {
			{
				style_id = "text",
				value_id = "text",
				pass_type = "text",
				value = "n/a",
				style = {
					font_type = "proxima_nova_bold",
					font_size = 20,
					text_vertical_alignment = "top",
					text_horizontal_alignment = "left",
					text_color = Color.text_default(255, true),
					offset = {
						0,
						0,
						3
					}
				}
			}
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local new_indicator_width_offset = element.new_indicator_width_offset

			if new_indicator_width_offset then
				local offset = style.new_indicator.offset

				offset[1] = new_indicator_width_offset[1]
				offset[2] = new_indicator_width_offset[2]
				offset[3] = new_indicator_width_offset[3]
			end

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local height = ui_renderer and UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options) or size[2]

			size[2] = height + 0
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end
	}
}

return widget_blueprints_by_type
