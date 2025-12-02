-- chunkname: @scripts/ui/views/talent_builder_view/talent_builder_view_summary_blueprints.lua

local ColorUtilities = require("scripts/utilities/ui/colors")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local TalentBuilderViewSettings = require("scripts/ui/views/talent_builder_view/talent_builder_view_settings")
local Text = require("scripts/utilities/ui/text")
local summary_grid_size = TalentBuilderViewSettings.summary_grid_size
local talent_blueprint_description_style = table.clone(UIFontSettings.body)

talent_blueprint_description_style.offset = {
	98,
	20,
	8,
}
talent_blueprint_description_style.size = {
	summary_grid_size[1] - 106,
	500,
}
talent_blueprint_description_style.font_size = 18
talent_blueprint_description_style.text_horizontal_alignment = "left"
talent_blueprint_description_style.text_vertical_alignment = "top"
talent_blueprint_description_style.text_color = Color.terminal_text_body(255, true)

local talent_blueprint_title_style = table.clone(UIFontSettings.header_3)

talent_blueprint_title_style.offset = {
	98,
	0,
	8,
}
talent_blueprint_title_style.size = {
	summary_grid_size[1] - 106,
}
talent_blueprint_title_style.font_size = 18
talent_blueprint_title_style.text_horizontal_alignment = "left"
talent_blueprint_title_style.text_vertical_alignment = "top"
talent_blueprint_title_style.text_color = Color.terminal_text_header(255, true)

local grid_blueprints = {
	talent_info = {
		size = {
			summary_grid_size[1],
			114,
		},
		size_function = function (parent, element, ui_renderer)
			local description = element.description
			local description_height = Text.text_height(ui_renderer, description, talent_blueprint_description_style, talent_blueprint_description_style.size)
			local entry_height = math.max(68, description_height + 25)

			return {
				summary_grid_size[1],
				entry_height,
			}
		end,
		pass_template = {
			{
				pass_type = "text",
				value = "n/a",
				value_id = "display_name",
				style = talent_blueprint_title_style,
			},
			{
				pass_type = "text",
				style_id = "description",
				value = "n/a",
				value_id = "description",
				style = talent_blueprint_description_style,
			},
			{
				pass_type = "texture",
				style_id = "icon",
				value = "content/ui/materials/frames/talents/talent_icon_container",
				value_id = "icon",
				style = {
					size = {
						64,
						64,
					},
					material_values = {
						intensity = 0,
						saturation = 1,
					},
					offset = {
						20,
						0,
						8,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "frame_default",
				value = "content/ui/materials/frames/talents/circular_small_frame",
				style = {
					size = {
						64,
						64,
					},
					offset = {
						20,
						0,
						9,
					},
					color = Color.white(255, true),
				},
				visibility_function = function (content, style)
					return not content.icon_texture
				end,
			},
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style

			content.element = element

			local description = element.description

			content.description = description

			local display_name = element.display_name

			content.display_name = display_name

			local icon = element.icon
			local gradient_map = element.gradient_map
			local frame = element.frame
			local icon_mask = element.icon_mask
			local node_type = element.node_type

			if node_type == "stat" then
				content.icon = "content/ui/materials/frames/talents/circular_small_bg"
				style.icon.offset[2] = -14
				style.frame_default.offset[2] = -14
			else
				content.icon_texture = icon
				style.icon.material_values.icon_mask = icon_mask
				style.icon.material_values.icon = icon
				style.icon.material_values.frame = frame
				style.icon.material_values.gradient_map = gradient_map
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			return
		end,
	},
	stat = {
		size = {
			summary_grid_size[1],
			100,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 18,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						27,
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
			local height = Text.text_height(ui_renderer, text, text_style, size)

			size[2] = height + 0
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
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
		size = {
			64,
			64,
		},
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
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
	dynamic_button = {
		size = {
			summary_grid_size[1],
			100,
		},
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = {
					on_pressed_sound = nil,
					on_released_sound = nil,
					on_hover_sound = UISoundEvents.default_mouse_hover,
				},
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					size_addition = {
						0,
						0,
					},
					default_color = Color.terminal_frame(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						3,
					},
				},
				change_function = ButtonPassTemplates.default_button_hover_change_function,
				visibility_function = function (content, style)
					return not content.hotspot.disabled
				end,
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					size_addition = {
						0,
						0,
					},
					default_color = Color.terminal_corner(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						4,
					},
				},
				change_function = ButtonPassTemplates.default_button_hover_change_function,
				visibility_function = function (content, style)
					return not content.hotspot.disabled
				end,
			},
			{
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					size_addition = {
						0,
						0,
					},
					default_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						2,
					},
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return not content.hotspot.disabled
				end,
			},
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 20,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_header(255, true),
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

			local hotspot = content.hotspot

			hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)

			local size = content.size
			local text_style = style.text
			local height = Text.text_height(ui_renderer, text, text_style, size)

			size[2] = height + 20
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
	header = {
		size = {
			summary_grid_size[1],
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
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_body_sub_header(255, true),
					offset = {
						27,
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
			local height = Text.text_height(ui_renderer, text, text_style, size)

			size[2] = height + 0
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
}

return grid_blueprints
