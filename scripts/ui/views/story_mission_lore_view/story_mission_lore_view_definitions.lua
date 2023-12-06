local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local lore_window_size = {
	700,
	650
}
local lore_grid_size = {
	lore_window_size[1] - 40,
	lore_window_size[2]
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			3
		}
	},
	page_header = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			1300,
			194
		},
		position = {
			60,
			60,
			0
		}
	},
	lore_window = {
		vertical_alignment = "top",
		parent = "page_header",
		horizontal_alignment = "left",
		size = lore_window_size,
		position = {
			194,
			180,
			10
		}
	},
	lore_grid = {
		vertical_alignment = "bottom",
		parent = "lore_window",
		horizontal_alignment = "center",
		size = lore_grid_size,
		position = {
			-5,
			-20,
			1
		}
	},
	trailer_button = {
		vertical_alignment = "bottom",
		parent = "lore_grid",
		horizontal_alignment = "center",
		size = {
			347,
			50
		},
		position = {
			0,
			110,
			1
		}
	}
}
local widget_definitions = {
	trailer_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "trailer_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_story_mission_lore_menu_video_button_text")),
		hotspot = {}
	}, nil, {
		text = {
			line_spacing = 0.7
		}
	}),
	page_header = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			style = {
				font_type = "machine_medium",
				font_size = 55,
				material = "content/ui/materials/font_gradients/slug_font_gradient_header",
				drop_shadow = true,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				text_color = Color.white(nil, true),
				offset = {
					214,
					0,
					1
				}
			},
			value = Localize("loc_story_mission_lore_menu_title")
		},
		{
			value = "content/ui/materials/story_mission/event_logo",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					0
				},
				size = {
					194,
					194
				}
			}
		}
	}, "page_header"),
	lore_window = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					0,
					10
				}
			}
		}
	}, "lore_window")
}
local item_category_tabs_content = {
	{
		icon = "content/ui/materials/icons/categories/melee",
		hide_display_name = true,
		slot_types = {
			"slot_primary"
		}
	},
	{
		icon = "content/ui/materials/icons/categories/ranged",
		hide_display_name = true,
		slot_types = {
			"slot_secondary"
		}
	},
	{
		icon = "content/ui/materials/icons/categories/devices",
		hide_display_name = true,
		slot_types = {
			"slot_attachment_1",
			"slot_attachment_2",
			"slot_attachment_3"
		}
	}
}
local grid_blueprints = {
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
	}
}
grid_blueprints.header = {
	size = {
		lore_grid_size[1],
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
				font_size = 24,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
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
}
grid_blueprints.body = {
	size = {
		lore_grid_size[1],
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
				text_vertical_alignment = "center",
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
		local optional_text_color = element.text_color

		if optional_text_color then
			ColorUtilities.color_copy(optional_text_color, style.text.text_color)
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
}
grid_blueprints.body_centered = {
	size = {
		lore_grid_size[1],
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
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
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
		local optional_text_color = element.text_color

		if optional_text_color then
			ColorUtilities.color_copy(optional_text_color, style.text.text_color)
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
}
local animations = {
	on_enter = {
		{
			name = "fade_in",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent.animation_alpha_multiplier = 0

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = 0
				end
			end
		},
		{
			name = "move",
			end_time = 0.45,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = anim_progress
				end

				parent.animation_alpha_multiplier = anim_progress
				local x_anim_distance_max = 50
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress

				parent:_set_scenegraph_position("page_header", scenegraph_definition.page_header.position[1] - x_anim_distance)
			end
		}
	}
}

return {
	animations = animations,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	grid_blueprints = grid_blueprints,
	item_category_tabs_content = item_category_tabs_content
}
