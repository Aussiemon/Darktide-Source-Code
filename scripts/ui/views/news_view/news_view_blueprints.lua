-- chunkname: @scripts/ui/views/news_view/news_view_blueprints.lua

local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local NewsViewSettings = require("scripts/ui/views/news_view/news_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local window_size = NewsViewSettings.window_size
local grid_size = NewsViewSettings.grid_size

local function _button_input_handler(self, input_service)
	if not input_service:get(self.content.entry.input_action) then
		return false
	end

	if self.content.hotspot.disabled then
		return false
	end

	self.content.hotspot.pressed_callback()

	return true
end

local function _button_factory(button_pass_template)
	return {
		pass_template_function = function (self, config, ui_renderer)
			local passes = table.clone(button_pass_template)

			return passes
		end,
		size_function = function (parent, config, ui_renderer)
			if config.size and #config.size == 2 then
				return config.size
			end

			local size = table.clone(button_pass_template.size)
			local parent_size = grid_size

			if not config.size then
				local ratio = size[2] / size[1]

				size[1] = parent_size and parent_size[1] or size[1]
				size[2] = ratio * size[1]

				return size
			end

			size[2] = config.size[1]
			size[1] = parent_size and parent_size[1] or size[1]

			return size
		end,
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local content = widget.content

			content.input_action = element.input_action
			content.gamepad_action = element.input_action
			content.original_text = element.text
			content.hotspot.pressed_callback = element.callback
			widget.handle_input = _button_input_handler
		end,
	}
end

local widget_blueprints_by_type = {
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
	image = {
		size = {
			grid_size[1],
			100,
		},
		pass_template = {
			{
				pass_type = "texture",
				style_id = "texture",
				value = "content/ui/materials/backgrounds/default_square",
				value_id = "texture",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = Color.white(255, true),
					offset = {
						0,
						0,
						1,
					},
					size_addition = {
						0,
						0,
					},
				},
			},
		},
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
		end,
	},
	header = {
		size = {
			grid_size[1],
			100,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 28,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "top",
					text_color = Color.terminal_text_header(255, true),
					size = {
						grid_size[1],
						0,
					},
					offset = {
						0,
						0,
						1,
					},
					size_addition = {
						0,
						0,
					},
				},
			},
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
		end,
	},
	sub_header = {
		size = {
			grid_size[1],
			100,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 20,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "top",
					text_color = Color.terminal_text_body_sub_header(255, true),
					size = {
						grid_size[1],
						0,
					},
					offset = {
						0,
						0,
						1,
					},
					size_addition = {
						0,
						0,
					},
				},
			},
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
		end,
	},
	body = {
		size = {
			grid_size[1],
			100,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 20,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "top",
					text_color = Color.text_default(255, true),
					offset = {
						0,
						0,
						3,
					},
				},
			},
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
		end,
	},
	terminal_button = _button_factory(ButtonPassTemplates.terminal_button),
	default_button = _button_factory(ButtonPassTemplates.default_button),
	aquila_button = _button_factory(ButtonPassTemplates.aquila_button),
}

return widget_blueprints_by_type
