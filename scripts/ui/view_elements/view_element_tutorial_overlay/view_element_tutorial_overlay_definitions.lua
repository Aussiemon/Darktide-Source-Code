-- chunkname: @scripts/ui/view_elements/view_element_tutorial_overlay/view_element_tutorial_overlay_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ViewElementTutorialOverlaySettings = require("scripts/ui/view_elements/view_element_tutorial_overlay/view_element_tutorial_overlay_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	entry_pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
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
	tooltip = {
		vertical_alignment = "top",
		parent = "entry_pivot",
		horizontal_alignment = "left",
		size = {
			300,
			400
		},
		position = {
			-5,
			-5,
			1
		}
	},
	tooltip_grid = {
		vertical_alignment = "top",
		parent = "tooltip",
		horizontal_alignment = "center",
		size = {
			225,
			100
		},
		position = {
			37.5,
			0,
			1
		}
	}
}
local widget_definitions = {
	tooltip = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					-20,
					-20
				}
			}
		},
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_grid_background_icon(255, true),
				size_addition = {
					-24,
					-24
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.terminal_grid_background(255, true),
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
	}, "tooltip")
}

local function icon_change_function(content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_hover = hotspot.is_hover
	local color = style.color
	local default_color = style.default_color
	local hover_color = style.hover_color
	local hover_progress = hotspot.anim_hover_progress
	local input_progress = hotspot.anim_input_progress
	local focus_progress = hotspot.anim_focus_progress
	local select_progress = hotspot.anim_select_progress

	color[1] = 255 * math.min(hover_progress)

	local ignore_alpha = true

	ColorUtilities.color_lerp(default_color, hover_color, input_progress, color, ignore_alpha)
end

local grid_blueprints = {
	dynamic_spacing = {
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2]
			} or {
				20,
				20
			}
		end
	},
	texture = {
		size = {
			64,
			64
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2]
			} or {
				64,
				64
			}
		end,
		pass_template = {
			{
				style_id = "texture",
				value_id = "texture",
				pass_type = "texture",
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
		end
	},
	dynamic_button = {
		size = {
			225,
			100
		},
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover
				}
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "center",
					size_addition = {
						0,
						0
					},
					default_color = Color.terminal_frame(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						3
					}
				},
				change_function = ButtonPassTemplates.default_button_hover_change_function,
				visibility_function = function (content, style)
					return not content.hotspot.disabled
				end
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "center",
					size_addition = {
						0,
						0
					},
					default_color = Color.terminal_corner(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						4
					}
				},
				change_function = ButtonPassTemplates.default_button_hover_change_function,
				visibility_function = function (content, style)
					return not content.hotspot.disabled
				end
			},
			{
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "center",
					size_addition = {
						0,
						0
					},
					default_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					offset = {
						0,
						0,
						2
					}
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
				visibility_function = function (content, style)
					return not content.hotspot.disabled
				end
			},
			{
				style_id = "text",
				value_id = "text",
				pass_type = "text",
				value = "n/a",
				style = {
					font_type = "proxima_nova_bold",
					font_size = 20,
					text_vertical_alignment = "center",
					text_horizontal_alignment = "center",
					text_color = Color.terminal_text_header(255, true),
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

			local hotspot = content.hotspot

			hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

			size[2] = height + 20
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end
	},
	text = {
		size = {
			225,
			100
		},
		size_function = function (parent, element, ui_renderer)
			local menu_settings = parent._menu_settings
			local grid_size = menu_settings.grid_size

			return {
				grid_size[1] or 0,
				100
			}
		end,
		pass_template = {
			{
				style_id = "text",
				value_id = "text",
				pass_type = "text",
				value = "n/a",
				style = {
					font_type = "proxima_nova_bold",
					font_size = 20,
					text_vertical_alignment = "center",
					text_horizontal_alignment = "center",
					text_color = Color.terminal_text_header(255, true),
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
			local override_style = element.style

			if override_style then
				table.merge_recursive(style.text, override_style)
			end

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
			local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

			size[2] = height + 0
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end
	},
	icon = {
		size = {
			45,
			45
		},
		pass_template = {
			{
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.default_click
				}
			},
			{
				pass_type = "rect",
				style = {
					color = {
						100,
						0,
						0,
						0
					}
				}
			},
			{
				value = "content/ui/materials/frames/inner_shadow_thin",
				pass_type = "texture",
				style = {
					scale_to_material = true,
					color = Color.terminal_corner_selected(nil, true),
					offset = {
						0,
						0,
						1
					}
				},
				visibility_function = function (content, style)
					return content.equipped
				end
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					offset = {
						0,
						0,
						6
					},
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					hover_color = Color.terminal_frame_hover(nil, true)
				},
				change_function = icon_change_function
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					offset = {
						0,
						0,
						7
					},
					color = Color.terminal_corner(nil, true),
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					hover_color = Color.terminal_corner_hover(nil, true)
				},
				change_function = icon_change_function
			},
			{
				value = "content/ui/materials/frames/frame_tile_1px",
				pass_type = "texture",
				style = {
					color = {
						255,
						0,
						0,
						0
					},
					offset = {
						0,
						0,
						3
					}
				}
			},
			{
				value_id = "icon",
				style_id = "icon",
				pass_type = "texture",
				value = "content/ui/materials/icons/presets/preset_01",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					offset = {
						0,
						0,
						2
					},
					size = {
						32,
						32
					},
					color = Color.terminal_icon(255, true)
				}
			}
		},
		init = function (parent, widget, element, callback_name)
			local style = widget.style
			local content = widget.content
			local hotspot = content.hotspot

			content.element = element
			hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)

			local icon_texture = element.icon

			if icon_texture then
				content.icon = icon_texture
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			return
		end
	}
}
local tooltip_window_open_delay = 0.25
local animations = {
	tutorial_window_open = {
		{
			name = "init",
			start_time = 0,
			end_time = tooltip_window_open_delay,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				widgets.tooltip.alpha_multiplier = 0

				local tooltip_grid = parent._tooltip_grid
				local grid_widgets = tooltip_grid and tooltip_grid:widgets()

				if grid_widgets then
					for i = 1, #grid_widgets do
						grid_widgets[i].alpha_multiplier = 0
					end
				end
			end
		},
		{
			name = "fade_in_window",
			start_time = tooltip_window_open_delay,
			end_time = tooltip_window_open_delay + 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)

				widgets.tooltip.alpha_multiplier = anim_progress
			end
		},
		{
			name = "fade_in_content",
			start_time = tooltip_window_open_delay + 0.4,
			end_time = tooltip_window_open_delay + 0.7,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				local tooltip_grid = parent._tooltip_grid
				local grid_widgets = tooltip_grid and tooltip_grid:widgets()

				if grid_widgets then
					for i = 1, #grid_widgets do
						grid_widgets[i].alpha_multiplier = anim_progress
					end
				end
			end
		},
		{
			name = "move",
			start_time = tooltip_window_open_delay + 0,
			end_time = tooltip_window_open_delay + 0.4,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent:_set_scenegraph_size("tooltip", nil, 100)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeCubic(progress)
				local y_anim_distance_max = 50
				local y_anim_distance = y_anim_distance_max - y_anim_distance_max * anim_progress
				local grid = parent._tooltip_grid
				local menu_settings = grid:menu_settings()
				local grid_size = menu_settings.grid_size
				local window_height = grid_size[2] + ViewElementTutorialOverlaySettings.window_margins_height
				local anim_height = 100 + (window_height - 100) * anim_progress

				parent:_set_scenegraph_size("tooltip", nil, anim_height)

				if parent.grow_from_center then
					widgets.tooltip.offset[2] = window_height * 0.25 * (1 - anim_progress)
				end
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	grid_blueprints = grid_blueprints
}
