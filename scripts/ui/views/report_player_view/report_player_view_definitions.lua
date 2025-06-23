-- chunkname: @scripts/ui/views/report_player_view/report_player_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local CheckboxPassTemplates = require("scripts/ui/pass_templates/checkbox_pass_templates")
local ReportPlayerViewSettings = require("scripts/ui/views/report_player_view/report_player_view_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local Text = require("scripts/utilities/ui/text")
local window_size = ReportPlayerViewSettings.window_size
local content_size = ReportPlayerViewSettings.content_size
local dropdown_size = ReportPlayerViewSettings.dropdown_size
local comment_input_text_size = ReportPlayerViewSettings.comment_input_text_size
local report_button_size = ReportPlayerViewSettings.report_button_size
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
		parent = "screen",
		horizontal_alignment = "center",
		size = window_size,
		position = {
			0,
			0,
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
	title_icon = {
		vertical_alignment = "top",
		parent = "window_content",
		horizontal_alignment = "center",
		size = {
			92,
			72
		},
		position = {
			0,
			30,
			1
		}
	},
	window_title = {
		vertical_alignment = "bottom",
		parent = "title_icon",
		horizontal_alignment = "center",
		size = {
			content_size[1],
			50
		},
		position = {
			0,
			60,
			2
		}
	},
	player_title = {
		vertical_alignment = "bottom",
		parent = "window_title",
		horizontal_alignment = "center",
		size = {
			content_size[1],
			50
		},
		position = {
			0,
			20,
			1
		}
	},
	title_divider = {
		vertical_alignment = "bottom",
		parent = "player_title",
		horizontal_alignment = "center",
		size = {
			468,
			22
		},
		position = {
			0,
			35,
			1
		}
	},
	option_dropdown_report_type = {
		vertical_alignment = "bottom",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = dropdown_size,
		position = {
			0,
			dropdown_size[2] + 10,
			0
		}
	},
	report_details_title = {
		vertical_alignment = "bottom",
		parent = "option_dropdown_report_type",
		horizontal_alignment = "center",
		size = {
			content_size[1],
			50
		},
		position = {
			0,
			60,
			2
		}
	},
	input_text_report_details = {
		vertical_alignment = "bottom",
		parent = "report_details_title",
		horizontal_alignment = "center",
		size = comment_input_text_size,
		position = {
			0,
			comment_input_text_size[2] + 10,
			0
		}
	},
	description = {
		vertical_alignment = "bottom",
		parent = "input_text_report_details",
		horizontal_alignment = "center",
		size = {
			content_size[1],
			30
		},
		position = {
			0,
			30,
			1
		}
	},
	report_button = {
		vertical_alignment = "bottom",
		parent = "description",
		horizontal_alignment = "center",
		size = report_button_size,
		position = {
			0,
			report_button_size[2] + 10,
			0
		}
	},
	close_button = {
		vertical_alignment = "bottom",
		parent = "report_button",
		horizontal_alignment = "center",
		size = report_button_size,
		position = {
			0,
			report_button_size[2] + 10,
			2
		}
	}
}
local widget_definitions = {
	title_icon = UIWidget.create_definition({
		{
			value = "content/ui/materials/symbols/warning",
			pass_type = "texture",
			style = {
				color = Color.terminal_frame(255, true)
			}
		}
	}, "title_icon"),
	title_divider = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/skull_center_02",
			pass_type = "texture",
			style = {
				color = Color.terminal_frame(255, true)
			}
		}
	}, "title_divider"),
	window_title = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "n/a",
			style = {
				vertical_alignment = "center",
				font_size = 28,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "window_title"),
	report_details_title = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "n/a",
			style = {
				vertical_alignment = "center",
				font_size = 20,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "report_details_title"),
	player_title = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "<player_name_here>",
			style = {
				vertical_alignment = "bottom",
				font_size = 24,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "player_title"),
	description = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "",
			style = {
				vertical_alignment = "bottom",
				font_size = 20,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_body_sub_header(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "description"),
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
		}
	}, "window"),
	report_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button_hold_small, "report_button", {
		visible = true,
		original_text = Localize("loc_alias_view_hotkey_item_discard")
	}),
	close_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "close_button", {
		visible = true,
		original_text = Localize("loc_action_interaction_close")
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

				widgets.report_button.alpha_multiplier = 0
				widgets.close_button.alpha_multiplier = 0
				widgets.title_icon.alpha_multiplier = 0
				widgets.title_divider.alpha_multiplier = 0
				widgets.description.alpha_multiplier = 0
				widgets.option_dropdown_report_type.alpha_multiplier = 0
				widgets.input_text_report_details.alpha_multiplier = 0
				widgets.window_title.alpha_multiplier = 0
				widgets.report_details_title.alpha_multiplier = 0
				widgets.player_title.alpha_multiplier = 0
				parent._content_alpha_multiplier = 0
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
				window_style.window_background.color[1] = 200 * anim_progress
			end
		},
		{
			name = "fade_in_content",
			end_time = 0.7,
			start_time = 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent._content_alpha_multiplier = anim_progress
				widgets.report_button.alpha_multiplier = anim_progress
				widgets.close_button.alpha_multiplier = anim_progress
				widgets.title_icon.alpha_multiplier = anim_progress
				widgets.title_divider.alpha_multiplier = anim_progress
				widgets.description.alpha_multiplier = anim_progress
				widgets.option_dropdown_report_type.alpha_multiplier = anim_progress
				widgets.input_text_report_details.alpha_multiplier = anim_progress
				widgets.window_title.alpha_multiplier = anim_progress
				widgets.report_details_title.alpha_multiplier = anim_progress
				widgets.player_title.alpha_multiplier = anim_progress
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

				parent._content_alpha_multiplier = anim_progress
				widgets.report_button.alpha_multiplier = anim_progress
				widgets.close_button.alpha_multiplier = anim_progress
				widgets.title_icon.alpha_multiplier = anim_progress
				widgets.title_divider.alpha_multiplier = anim_progress
				widgets.description.alpha_multiplier = anim_progress
				widgets.option_dropdown_report_type.alpha_multiplier = anim_progress
				widgets.input_text_report_details.alpha_multiplier = anim_progress
				widgets.window_title.alpha_multiplier = anim_progress
				widgets.report_details_title.alpha_multiplier = anim_progress
				widgets.player_title.alpha_multiplier = anim_progress
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
				window_style.window_background.color[1] = 200 * anim_progress
			end
		},
		{
			name = "delay",
			end_time = 0.6,
			start_time = 0.5
		}
	}
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definitions,
	animations = animation_definitions
}
