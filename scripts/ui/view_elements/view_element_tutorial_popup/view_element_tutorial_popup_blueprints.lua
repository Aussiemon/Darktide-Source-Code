-- chunkname: @scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup_blueprints.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local Settings = require("scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup_settings")
local Text = require("scripts/utilities/ui/text")
local tutorial_window_size = Settings.tutorial_window_size
local grid_blueprints = {
	dynamic_spacing = {
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2],
			} or {
				225,
				20,
			}
		end,
	},
	texture = {
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2],
			} or {
				64,
				64,
			}
		end,
		pass_template = {
			{
				pass_type = "texture",
				style_id = "texture",
				value_id = "texture",
				style = {
					color = {
						255,
						255,
						255,
						255,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local texture = element.texture

			content.texture = texture

			local texture_color = element.color

			if texture_color then
				local color = style.texture.color

				color[1] = texture_color[1]
				color[2] = texture_color[2]
				color[3] = texture_color[3]
				color[4] = texture_color[4]
			end
		end,
	},
	header = {
		size_function = function (parent, element, ui_renderer)
			local text = element.text
			local width = element.width or tutorial_window_size[1]

			return {
				width,
				100,
			}
		end,
		pass_template_function = function (parent, element, ui_renderer)
			local title_style = table.clone(UIFontSettings.header_3)

			title_style.offset = {
				element.x_offset or 0,
				0,
				8,
			}
			title_style.font_size = 18
			title_style.text_horizontal_alignment = element.text_horizontal_alignment or "left"
			title_style.text_vertical_alignment = "top"
			title_style.text_color = Color.terminal_text_header(255, true)

			local pass_templates = {
				{
					pass_type = "text",
					style_id = "text",
					value = "n/a",
					value_id = "text",
					style = title_style,
				},
			}

			return pass_templates
		end,
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
			local height = Text.text_height(ui_renderer, text, text_style, size)

			size[2] = height + 0
		end,
	},
	text = {
		size_function = function (parent, element, ui_renderer)
			local text = element.text
			local width = element.width or tutorial_window_size[1]

			return {
				width,
				100,
			}
		end,
		pass_template_function = function (parent, element, ui_renderer)
			local description_style = table.clone(UIFontSettings.body)

			description_style.offset = {
				element.x_offset or 0,
				0,
				8,
			}
			description_style.font_size = 18
			description_style.text_horizontal_alignment = element.text_horizontal_alignment or "left"
			description_style.text_vertical_alignment = "top"
			description_style.text_color = Color.terminal_text_body(255, true)

			local pass_templates = {
				{
					pass_type = "text",
					style_id = "text",
					value = "n/a",
					value_id = "text",
					style = description_style,
				},
			}

			return pass_templates
		end,
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
			local height = Text.text_height(ui_renderer, text, text_style, size)

			size[2] = height
		end,
	},
	counter = {
		size_function = function (parent, element, ui_renderer)
			local text = element.text
			local width = element.width or tutorial_window_size[1]

			return {
				width,
				100,
			}
		end,
		pass_template_function = function (parent, element, ui_renderer)
			local pass_templates = {
				{
					pass_type = "text",
					style_id = "text",
					value = "n/a",
					value_id = "text",
					style = {
						font_size = 20,
						font_type = "proxima_nova_bold",
						text_color = Color.terminal_text_body_sub_header(255, true),
						offset = {
							element.x_offset or 0,
							0,
							7,
						},
						text_horizontal_alignment = element.text_horizontal_alignment or "left",
					},
				},
			}

			return pass_templates
		end,
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = string.format("%d/%d", element.current_page, element.total_pages)

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local height = Text.text_height(ui_renderer, text, text_style, size)

			size[2] = height
		end,
	},
	main_header = {
		size_function = function (parent, element, ui_renderer)
			local text = element.text
			local width = element.width or tutorial_window_size[1]

			return {
				width,
				100,
			}
		end,
		pass_template_function = function (parent, element, ui_renderer)
			local pass_templates = {
				{
					pass_type = "text",
					style_id = "text",
					value = "n/a",
					value_id = "text",
					style = {
						font_size = 28,
						font_type = "proxima_nova_bold",
						text_color = Color.terminal_text_header(255, true),
						offset = {
							element.x_offset or 0,
							0,
							7,
						},
						text_horizontal_alignment = element.text_horizontal_alignment or "left",
					},
				},
			}

			return pass_templates
		end,
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local height = Text.text_height(ui_renderer, text, text_style, size)

			size[2] = height
		end,
	},
}

return grid_blueprints
