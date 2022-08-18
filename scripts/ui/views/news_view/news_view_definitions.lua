local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local NewsViewSettings = require("scripts/ui/views/news_view/news_view_settings")
local TextStyles = require("scripts/ui/views/news_view/news_view_text_styles")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local button_size = {
	400,
	50
}
local horizontal_margin = 50
local anim_start_delay = 0
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
	title_text = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			-470,
			1
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
	previous_button = {
		vertical_alignment = "center",
		parent = "button_pivot",
		size = button_size,
		position = {
			-960 + horizontal_margin,
			0,
			0
		}
	},
	next_button = {
		vertical_alignment = "center",
		parent = "button_pivot",
		horizontal_alignment = "right",
		size = button_size,
		position = {
			960 - horizontal_margin,
			0,
			0
		}
	},
	slide_wrapper = {
		vertical_alignment = "top",
		parent = "screen",
		scale = "fit_width",
		horizontal_alignment = "center",
		size = {
			UIWorkspaceSettings.screen.size[1],
			800
		},
		position = {
			0,
			140,
			1
		}
	},
	slide_pivot = {
		parent = "slide_wrapper"
	},
	slide_content_left = {
		vertical_alignment = "top",
		parent = "slide_pivot",
		horizontal_alignment = "left",
		size = {
			UIWorkspaceSettings.screen.size[1] / 2,
			800
		},
		position = {
			0,
			0,
			1
		}
	},
	slide_content_right = {
		vertical_alignment = "top",
		parent = "slide_pivot",
		horizontal_alignment = "right",
		size = {
			UIWorkspaceSettings.screen.size[1] / 2,
			800
		},
		position = {
			0,
			0,
			1
		}
	},
	slide_content_grid = {
		vertical_alignment = "center",
		parent = "slide_content_right",
		horizontal_alignment = "center",
		size = {
			740,
			670
		},
		position = {
			0,
			0,
			1
		}
	},
	slide_content_grid_mask = {
		vertical_alignment = "center",
		parent = "slide_content_grid",
		horizontal_alignment = "center",
		size = {
			770,
			690
		},
		position = {
			0,
			0,
			0
		}
	},
	slide_content_grid_interaction = {
		vertical_alignment = "top",
		parent = "slide_content_grid",
		horizontal_alignment = "left",
		size = {
			740,
			670
		},
		position = {
			0,
			0,
			0
		}
	},
	slide_content_grid_content = {
		vertical_alignment = "top",
		parent = "slide_content_grid",
		horizontal_alignment = "left",
		size = {
			675,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	slide_content_grid_scrollbar = {
		vertical_alignment = "center",
		parent = "slide_content_grid",
		horizontal_alignment = "right",
		size = {
			10,
			670
		},
		position = {
			0,
			0,
			1
		}
	},
	slide_page_indicator = {
		vertical_alignment = "bottom",
		parent = "slide_pivot",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			30,
			1
		}
	}
}
local widget_definitions = {
	overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = {
					160,
					0,
					0,
					0
				}
			}
		}
	}, "screen"),
	background_icon = UIWidget.create_definition({
		{
			value = "content/ui/vector_textures/symbols/cog_skull_01",
			pass_type = "slug_icon",
			offset = {
				0,
				0,
				1
			},
			style = {
				color = {
					80,
					0,
					0,
					0
				}
			}
		}
	}, "background_icon"),
	title_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Localize("loc_news_view_title"),
			style = TextStyles.title_text_style
		}
	}, "title_text"),
	previous_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "previous_button", {
		text = Localize("loc_news_view_previous")
	}),
	next_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "next_button", {
		text = Localize("loc_news_view_next")
	}),
	slide_background = UIWidget.create_definition({
		{
			style_id = "content_rect",
			pass_type = "rect",
			style = {
				color = {
					230,
					18,
					19,
					21
				}
			}
		}
	}, "slide_pivot"),
	slide_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, "slide_content_grid_scrollbar"),
	slide_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
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
	}, "slide_content_grid_mask"),
	slide_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "slide_content_grid_interaction"),
	edge_top = UIWidget.create_definition({
		{
			value = "content/ui/materials/buttons/background_selected_edge",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				hdr = true,
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					-2,
					2
				},
				size = {
					nil,
					4
				},
				color = Color.ui_terminal(255, true)
			}
		}
	}, "slide_pivot"),
	edge_bottom = UIWidget.create_definition({
		{
			value = "content/ui/materials/buttons/background_selected_edge",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				hdr = true,
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					2,
					2
				},
				size = {
					nil,
					4
				},
				color = Color.ui_terminal(255, true)
			}
		}
	}, "slide_pivot"),
	skull_top = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/skull_rendered_center_01",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					280,
					36
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-50,
					2
				}
			}
		}
	}, "slide_pivot"),
	skull_bottom = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/skull_rendered_center_01",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					280,
					36
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					100,
					2
				}
			}
		}
	}, "slide_pivot")
}
local animation_definitions = {
	on_enter = {
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
			end
		},
		{
			name = "fade_in",
			start_time = anim_start_delay + 0.2,
			end_time = anim_start_delay + 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = anim_progress
				end
			end
		}
	},
	on_exit = {
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
			end
		},
		{
			name = "fade_out",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeInCubic(1 - progress)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = anim_progress
				end
			end
		}
	}
}
local slide_circle_widget_definition = UIWidget.create_definition({
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			size = {
				10,
				10
			}
		}
	},
	{
		style_id = "circ",
		pass_type = "circle",
		style = {
			color = {
				255,
				90,
				90,
				90
			},
			size = {
				10,
				10
			},
			offset = {
				0,
				0
			}
		}
	},
	{
		pass_type = "circle",
		style = {
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				10,
				10
			},
			offset = {
				0,
				0,
				1
			}
		},
		change_function = function (content, style)
			style.color[1] = content.hotspot.anim_hover_progress * 255
		end
	},
	{
		pass_type = "circle",
		style = {
			color = {
				255,
				227,
				197,
				122
			},
			size = {
				10,
				10
			},
			offset = {
				0,
				0,
				2
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
