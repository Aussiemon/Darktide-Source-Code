-- chunkname: @scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Settings = require("scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local tutorial_window_size = Settings.tutorial_window_size
local tutorial_grid_size = Settings.tutorial_grid_size
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
			0
		}
	},
	tutorial_window = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = tutorial_window_size,
		position = {
			0,
			30,
			170
		}
	},
	tutorial_grid = {
		vertical_alignment = "bottom",
		parent = "tutorial_window",
		horizontal_alignment = "right",
		size = tutorial_grid_size,
		position = {
			-60,
			-120,
			2
		}
	},
	tutorial_button_1 = {
		vertical_alignment = "bottom",
		parent = "tutorial_window",
		horizontal_alignment = "center",
		size = {
			300,
			40
		},
		position = {
			-170,
			-40,
			3
		}
	},
	tutorial_button_2 = {
		vertical_alignment = "bottom",
		parent = "tutorial_window",
		horizontal_alignment = "center",
		size = {
			300,
			40
		},
		position = {
			170,
			-40,
			3
		}
	},
	tutorial_button_center = {
		vertical_alignment = "bottom",
		parent = "tutorial_window",
		horizontal_alignment = "center",
		size = {
			300,
			40
		},
		position = {
			0,
			-40,
			3
		}
	}
}
local widget_definitions = {
	tutorial_window = UIWidget.create_definition({
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
		},
		{
			value_id = "image",
			style_id = "image",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				size = {
					tutorial_window_size[1] - (tutorial_grid_size[1] + 60),
					tutorial_window_size[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
				}
			}
		},
		{
			style_id = "screen_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				scenegraph_id = "screen",
				horizontal_alignment = "center",
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					169
				},
				size_addition = {
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/masks/gradient_vignette",
			style_id = "screen_background_vignette",
			pass_type = "texture",
			style = {
				scenegraph_id = "screen",
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					168
				}
			}
		},
		{
			style_id = "window_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					-1
				},
				size_addition = {
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			style_id = "background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					24,
					24
				},
				color = Color.terminal_grid_background(nil, true)
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_vertical",
			style_id = "background_gradient",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.black(200, true),
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_large",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					96,
					96
				},
				offset = {
					0,
					0,
					5
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					4
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_corner_2px",
			style_id = "corner",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_corner(nil, true),
				offset = {
					0,
					0,
					5
				}
			}
		},
		{
			value_id = "title",
			pass_type = "text",
			style_id = "title",
			style = {
				font_size = 28,
				horizontal_alignment = "right",
				text_vertical_alignment = "top",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_header(255, true),
				size = {
					tutorial_grid_size[1],
					0
				},
				offset = {
					-60,
					35,
					7
				},
				size_addition = {
					0,
					0
				}
			},
			value = Localize("loc_alias_talent_builder_view_popup_title_summary")
		},
		{
			value_id = "page_counter",
			pass_type = "text",
			style_id = "page_counter",
			value = "0/0",
			style = {
				font_size = 20,
				horizontal_alignment = "right",
				text_vertical_alignment = "top",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body_sub_header(255, true),
				size = {
					tutorial_grid_size[1],
					0
				},
				offset = {
					-60,
					70,
					7
				},
				size_addition = {
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_upper",
			style_id = "edge_top",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					nil,
					10
				},
				size_addition = {
					10,
					0
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					-4,
					14
				}
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
			style_id = "edge_bottom",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					nil,
					10
				},
				size_addition = {
					10,
					0
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					4,
					14
				}
			}
		}
	}, "tutorial_window"),
	tutorial_button_1 = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "tutorial_button_1", {
		text = "tutorial_button_1",
		visible = true
	}),
	tutorial_button_2 = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "tutorial_button_2", {
		text = "tutorial_button_2",
		visible = true
	})
}
local tutorial_window_open_delay = 0.5
local animations = {
	tutorial_window_open = {
		{
			name = "init",
			start_time = 0,
			end_time = tutorial_window_open_delay,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				local tutorial_window = widgets.tutorial_window

				for _, pass_style in pairs(tutorial_window.style) do
					local color = pass_style.text_color or pass_style.color

					if color then
						color[1] = 0
					end
				end

				widgets.tutorial_button_1.alpha_multiplier = 0
				widgets.tutorial_button_2.alpha_multiplier = 0

				local tutorial_grid = parent._tutorial_grid
				local grid_widgets = tutorial_grid and tutorial_grid:widgets()

				if grid_widgets then
					for i = 1, #grid_widgets do
						grid_widgets[i].alpha_multiplier = 0
					end
				end
			end
		},
		{
			name = "fade_in_background",
			end_time = 1.2,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeCubic(progress)
				local tutorial_window = widgets.tutorial_window
				local alpha = 100 * anim_progress

				tutorial_window.style.screen_background.color[1] = alpha
				tutorial_window.style.screen_background_vignette.color[1] = alpha
			end
		},
		{
			name = "fade_in_window",
			start_time = tutorial_window_open_delay,
			end_time = tutorial_window_open_delay + 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				local tutorial_window = widgets.tutorial_window
				local alpha = 255 * anim_progress
				local window_style = tutorial_window.style

				window_style.background.color[1] = alpha
				window_style.background_gradient.color[1] = 200 * anim_progress
				window_style.outer_shadow.color[1] = 200 * anim_progress
				window_style.frame.color[1] = alpha
				window_style.corner.color[1] = alpha
				window_style.edge_top.color[1] = alpha
				window_style.edge_bottom.color[1] = alpha
				window_style.window_background.color[1] = alpha
			end
		},
		{
			name = "fade_in_content",
			start_time = tutorial_window_open_delay + 0.4,
			end_time = tutorial_window_open_delay + 0.7,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				local tutorial_grid = parent._tutorial_grid
				local grid_widgets = tutorial_grid and tutorial_grid:widgets()

				if grid_widgets then
					for i = 1, #grid_widgets do
						grid_widgets[i].alpha_multiplier = anim_progress
					end
				end

				widgets.tutorial_button_1.alpha_multiplier = anim_progress
				widgets.tutorial_button_2.alpha_multiplier = anim_progress

				local alpha = 255 * anim_progress
				local tutorial_window = widgets.tutorial_window

				tutorial_window.style.title.text_color[1] = alpha
				tutorial_window.style.page_counter.text_color[1] = alpha
				tutorial_window.style.image.color[1] = alpha
			end
		},
		{
			name = "move",
			start_time = tutorial_window_open_delay + 0,
			end_time = tutorial_window_open_delay + 0.4,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent:_set_scenegraph_size("tutorial_window", nil, 100)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeCubic(progress)
				local y_anim_distance_max = 50
				local y_anim_distance = y_anim_distance_max - y_anim_distance_max * anim_progress

				parent:_set_scenegraph_size("tutorial_window", nil, 100 + (scenegraph_definition.tutorial_window.size[2] - 100) * anim_progress)
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
