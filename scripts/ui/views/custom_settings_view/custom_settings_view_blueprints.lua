local SliderPassTemplates = require("scripts/ui/pass_templates/slider_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local grid_width = 1720
local description_font_style = table.clone(UIFontSettings.list_button)
description_font_style.offset = {
	0,
	0,
	3
}
description_font_style.text_horizontal_alignment = "center"
local blueprints = {
	brightness_texture = {
		size = {
			grid_width,
			600
		},
		pass_template = {
			{
				style_id = "texture",
				value_id = "texture",
				pass_type = "texture",
				style = {
					horizontal_alignment = "center",
					size = {
						600,
						600
					},
					material_values = {
						tonemap = 0
					}
				}
			}
		},
		init = function (parent, widget, entry, callback_name)
			local template = widget.entry
			local tonemap = template:update()
			widget.style.texture.material_values.tonemap = tonemap
			widget.content.texture = entry.texture
		end,
		update = function (parent, widget, input_service, dt, t)
			local template = widget.entry
			local tonemap = template:update()
			widget.style.texture.material_values.tonemap = tonemap
		end
	},
	gamma_texture = {
		size = {
			grid_width,
			600
		},
		pass_template = {
			{
				value = "content/ui/materials/patterns/brightness_comparison_dark_01",
				style_id = "texture_dark",
				pass_type = "texture",
				style = {
					vertical_alignment = "bottom",
					horizontal_alignment = "center",
					size = {
						400,
						200
					},
					offset = {
						-220,
						-120,
						0
					},
					material_values = {
						tonemap = 0.5
					}
				}
			},
			{
				value = "content/ui/materials/patterns/brightness_comparison_light_01",
				style_id = "texture_light",
				pass_type = "texture",
				style = {
					vertical_alignment = "bottom",
					horizontal_alignment = "center",
					size = {
						400,
						200
					},
					offset = {
						220,
						-120,
						0
					},
					material_values = {
						tonemap = 0.5
					}
				}
			}
		},
		init = function (parent, widget, entry, callback_name)
			local template = widget.entry
			local tonemap = template:update()
			widget.style.texture_dark.material_values.tonemap = tonemap
			widget.style.texture_light.material_values.tonemap = tonemap
		end,
		update = function (parent, widget, input_service, dt, t)
			local template = widget.entry
			local tonemap = template:update()
			widget.style.texture_dark.material_values.tonemap = tonemap
			widget.style.texture_light.material_values.tonemap = tonemap
		end
	}
}
blueprints.value_slider = {
	size = {
		grid_width,
		64
	},
	pass_template = SliderPassTemplates.value_slider(grid_width, 64, true),
	init = function (parent, widget, entry, callback_name)
		local content = widget.content
		content.entry = entry
		content.area_length = grid_width
		content.step_size = entry.normalized_step_size
		content.apply_on_drag = entry.apply_on_drag and true
		local get_function = entry.get_function
		local value = get_function(entry)
		local slider_value = math.normalize_01(value, entry.min_value, entry.max_value)
		content.previous_slider_value = slider_value
		content.slider_value = slider_value
		content.pressed_callback = callback(parent, callback_name, widget, entry)
	end,
	update = function (parent, widget, input_service, dt, t)
		local using_gamepad = not parent:using_cursor_navigation()
		local content = widget.content
		local entry = content.entry
		local min_value = entry.min_value
		local max_value = entry.max_value
		local get_function = entry.get_function
		local explode_function = entry.explode_function
		local value = get_function(entry)
		local normalized_value = math.normalize_01(value, min_value, max_value)
		local on_activated = entry.on_activated
		local format_value_function = entry.format_value_function
		local drag_value, new_normalized_value = nil
		local apply_on_drag = content.apply_on_drag
		local drag_active = content.drag_active
		local drag_previously_active = content.drag_previously_active
		local focused = content.exclusive_focus and using_gamepad

		if drag_active or focused then
			local slider_value = content.slider_value
			drag_value = slider_value and explode_function(slider_value, entry) or get_function(entry)
		elseif not focused or drag_previously_active then
			local previous_slider_value = content.previous_slider_value
			local slider_value = content.slider_value

			if drag_previously_active then
				if previous_slider_value ~= slider_value then
					new_normalized_value = slider_value
					drag_value = slider_value and explode_function(slider_value, entry) or get_function(entry)
				end
			elseif normalized_value ~= slider_value then
				content.slider_value = normalized_value
				content.previous_slider_value = normalized_value
				content.scroll_add = nil
			end

			content.previous_slider_value = slider_value
		end

		content.drag_previously_active = drag_active
		local display_value = format_value_function(drag_value or value)

		if display_value then
			content.value_text = display_value
		end

		local hotspot = content.hotspot

		if hotspot.on_pressed then
			if focused then
				new_normalized_value = content.slider_value
			elseif using_gamepad then
				content.pressed_callback()
			end
		end

		if focused and parent:can_exit() then
			parent:set_can_exit(false)
		end

		if apply_on_drag and drag_value and not new_normalized_value and content.slider_value ~= content.previous_slider_value then
			new_normalized_value = content.slider_value
		end

		if new_normalized_value then
			local new_value = explode_function(new_normalized_value, entry)

			if on_activated then
				on_activated(new_value, entry)
			end

			content.slider_value = new_normalized_value
			content.previous_slider_value = new_normalized_value
			content.scroll_add = nil
		end

		local pass_input = true

		return pass_input
	end
}
blueprints.description = {
	size = {
		grid_width,
		50
	},
	pass_template = {
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "n/a",
			style = description_font_style
		}
	},
	init = function (parent, widget, entry, callback_name)
		local content = widget.content
		local style = widget.style
		local text_style = style.text
		local display_name = entry.display_name
		local localized_text = Managers.localization:localize(display_name)
		local ui_renderer = parent._ui_renderer
		local size = content.size
		local text_options = UIFonts.get_font_options_by_style(text_style)
		local _, height = UIRenderer.text_size(ui_renderer, localized_text, text_style.font_type, text_style.font_size, size, text_options)
		size[2] = math.ceil(height)
		content.text = localized_text
	end,
	update = function (parent, widget, input_service, dt, t)
		return
	end
}

return settings("CustomSettingsViewContentBlueprints", blueprints)
