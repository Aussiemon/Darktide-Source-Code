-- chunkname: @scripts/ui/views/news_view/news_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local NewsViewSettings = require("scripts/ui/views/news_view/news_view_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local anim_start_delay = 0
local window_size = NewsViewSettings.window_size
local grid_size = NewsViewSettings.grid_size
local image_size = NewsViewSettings.image_size
local scenegraph_definitions = {
	screen = UIWorkspaceSettings.screen,
	background_icon = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1250,
			1250
		},
		position = {
			0,
			0,
			0
		}
	},
	button_pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			470,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		scale = "fit_width",
		size = {
			1920,
			window_size[2]
		},
		position = {
			0,
			30,
			20
		}
	},
	window_content = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = window_size,
		position = {
			0,
			0,
			2
		}
	},
	window_center_pivot = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	slide_content_grid = {
		vertical_alignment = "bottom",
		parent = "window_center_pivot",
		horizontal_alignment = "left",
		size = grid_size,
		position = {
			0,
			-170,
			2
		}
	},
	previous_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			300,
			40
		},
		position = {
			-170,
			-60,
			13
		}
	},
	next_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			300,
			40
		},
		position = {
			170,
			-60,
			13
		}
	},
	center_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			300,
			40
		},
		position = {
			0,
			-60,
			13
		}
	},
	slide_page_indicator = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-30,
			15
		}
	}
}
local widget_definitions = {
	window_image = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture_uv",
			value = "content/ui/materials/backgrounds/news_feed/article_image_blank",
			style = {
				vertical_alignment = "top",
				hdr = false,
				force_view = false,
				horizontal_alignment = "left",
				size = {
					image_size[1],
					image_size[2]
				},
				offset = {
					0,
					0,
					2
				},
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				material_values = {}
			},
			visibility_function = function (content, style)
				return style.material_values and not not style.material_values.texture or style.force_view
			end
		}
	}, "window_content"),
	window = UIWidget.create_definition({
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
					0
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
					1
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
					64,
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
				},
				size_addition = {
					40,
					0
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
				},
				size_addition = {
					40,
					0
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
				},
				size_addition = {
					40,
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
					80,
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
					80,
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
	}, "window"),
	previous_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "previous_button", {
		visible = true,
		original_text = Localize("loc_news_view_previous")
	}),
	next_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "next_button", {
		visible = true,
		original_text = "next_button"
	})
}
local animation_definitions = {
	on_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local window = widgets.window

				for _, pass_style in pairs(window.style) do
					local color = pass_style.text_color or pass_style.color

					if color then
						color[1] = 0
					end
				end

				widgets.previous_button.alpha_multiplier = 0
				widgets.next_button.alpha_multiplier = 0
				widgets.window_image.alpha_multiplier = 0
				parent._content_alpha_multiplier = 0

				if parent._slides then
					local slides_amount = #parent._slides

					for i = 1, slides_amount do
						local slide_circle_widget = widgets["slide_circ_" .. i]

						if slide_circle_widget then
							widgets["slide_circ_" .. i].alpha_multiplier = 0
						end
					end
				end

				local grid = parent._grid
				local grid_widgets = grid and grid:widgets()

				if grid_widgets then
					for i = 1, #grid_widgets do
						grid_widgets[i].alpha_multiplier = 0
					end

					local grid_scrollbar = grid:grid_scrollbar()

					if grid_scrollbar then
						grid_scrollbar.alpha_multiplier = 0
					end
				end
			end
		},
		{
			name = "fade_in_background",
			end_time = 1.2,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)
				local window = widgets.window
				local alpha = 100 * anim_progress

				window.style.screen_background.color[1] = alpha
				window.style.screen_background_vignette.color[1] = alpha
			end
		},
		{
			name = "fade_in_window",
			end_time = 0.2,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local window = widgets.window
				local alpha = 255 * anim_progress
				local window_style = window.style

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
			end_time = 0.7,
			start_time = 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local grid = parent._grid
				local grid_widgets = grid and grid:widgets()

				if grid_widgets then
					for i = 1, #grid_widgets do
						grid_widgets[i].alpha_multiplier = anim_progress
					end

					local grid_scrollbar = grid:grid_scrollbar()

					if grid_scrollbar then
						grid_scrollbar.alpha_multiplier = anim_progress
					end
				end

				parent._content_alpha_multiplier = anim_progress
				widgets.previous_button.alpha_multiplier = anim_progress
				widgets.next_button.alpha_multiplier = anim_progress
				widgets.window_image.alpha_multiplier = anim_progress

				if parent._slides then
					local slides_amount = #parent._slides

					for i = 1, slides_amount do
						local slide_circle_widget = widgets["slide_circ_" .. i]

						if slide_circle_widget then
							slide_circle_widget.alpha_multiplier = anim_progress
						end
					end
				end
			end
		},
		{
			name = "move",
			end_time = 0.4,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_set_scenegraph_size("window", nil, 100)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)
				local y_anim_distance_max = 50
				local y_anim_distance = y_anim_distance_max - y_anim_distance_max * anim_progress

				parent:_set_scenegraph_size("window", nil, 100 + (scenegraph_definition.window.size[2] - 100) * anim_progress)
			end
		}
	},
	on_exit = {
		{
			name = "fade_out_content",
			end_time = 0.3,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(1 - progress)
				local grid = parent._grid
				local grid_widgets = grid and grid:widgets()

				if grid_widgets then
					for i = 1, #grid_widgets do
						grid_widgets[i].alpha_multiplier = anim_progress
					end

					local grid_scrollbar = grid:grid_scrollbar()

					if grid_scrollbar then
						grid_scrollbar.alpha_multiplier = anim_progress
					end
				end

				parent._content_alpha_multiplier = anim_progress
				widgets.previous_button.alpha_multiplier = anim_progress
				widgets.next_button.alpha_multiplier = anim_progress
				widgets.window_image.alpha_multiplier = anim_progress

				local slides_amount = #parent._slides

				for i = 1, slides_amount do
					widgets["slide_circ_" .. i].alpha_multiplier = anim_progress
				end
			end
		},
		{
			name = "move",
			end_time = 0.7,
			start_time = 0.3,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_set_scenegraph_size("window", nil, 100)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(1 - progress)
				local y_anim_distance_max = 50
				local y_anim_distance = y_anim_distance_max - y_anim_distance_max * anim_progress

				parent:_set_scenegraph_size("window", nil, 100 + (scenegraph_definition.window.size[2] - 100) * anim_progress)
			end
		},
		{
			name = "fade_out_window",
			end_time = 0.5,
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(1 - progress)
				local window = widgets.window
				local alpha = 255 * anim_progress
				local window_style = window.style

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
			name = "delay",
			end_time = 0.6,
			start_time = 0.5
		}
	},
	change_content_in = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local alpha_multiplier = 0

				parent:_play_sound(UISoundEvents.news_feed_slide_enter)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = alpha_multiplier
				end

				parent._content_alpha_multiplier = 0
			end
		},
		{
			name = "fade_in",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = anim_progress
				end

				parent._content_alpha_multiplier = anim_progress
			end
		}
	},
	change_content_out = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local alpha_multiplier = 1

				parent:_play_sound(UISoundEvents.news_feed_slide_exit)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = alpha_multiplier
				end

				parent._content_alpha_multiplier = 0
			end
		},
		{
			name = "fade_out",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeInCubic(1 - progress)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = anim_progress
				end

				parent._content_alpha_multiplier = anim_progress
			end
		}
	}
}
local slide_thumb_size = NewsViewSettings.slide_thumb_size
local slide_circle_widget_definition = UIWidget.create_definition({
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = slide_thumb_size
		}
	},
	{
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.terminal_frame(nil, true),
			size = slide_thumb_size,
			offset = {
				0,
				0,
				0
			}
		}
	},
	{
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.terminal_icon(255, true),
			size = slide_thumb_size,
			offset = {
				0,
				0,
				1
			}
		},
		visibility_function = function (content, style)
			return content.active
		end
	},
	{
		value = "content/ui/materials/frames/frame_glow_01",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			color = Color.terminal_icon(150, true),
			size = slide_thumb_size,
			offset = {
				0,
				0,
				1
			},
			size_addition = {
				24,
				24
			}
		},
		visibility_function = function (content, style)
			return content.active
		end
	}
}, "slide_page_indicator")

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definitions,
	animations = animation_definitions,
	slide_circle_widget_definition = slide_circle_widget_definition
}
