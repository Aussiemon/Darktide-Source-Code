local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ElementSettings = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_settings")
local element_styles = ElementSettings.styles
local details_panel_size = {
	600,
	1080
}
local mission_info_size = {
	details_panel_size[1] - 50,
	160
}
local circumstance_info_size = {
	details_panel_size[1] - 50,
	120
}
local screen_size = UIWorkspaceSettings.screen.size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = screen_size,
		position = {
			0,
			0,
			100
		}
	},
	left_panel = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "left",
		size = details_panel_size,
		position = {
			-details_panel_size[1],
			0,
			0
		}
	},
	mission_info_panel = {
		vertical_alignment = "center",
		parent = "left_panel",
		horizontal_alignment = "center",
		size = mission_info_size,
		position = {
			0,
			-mission_info_size[2] / 2,
			1
		}
	},
	circumstance_info_panel = {
		vertical_alignment = "center",
		parent = "left_panel",
		horizontal_alignment = "center",
		size = circumstance_info_size,
		position = {
			0,
			mission_info_size[2] / 2 + 20,
			1
		}
	}
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/hud/tactical_overlay_background",
			pass_type = "texture",
			style = {
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "background")
}
local left_panel_widgets_definitions = {
	danger_info = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/generic/danger",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					169,
					191,
					153
				},
				offset = {
					5,
					5,
					2
				},
				size = {
					50,
					50
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "diffulty_icon_background",
			pass_type = "multi_texture"
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "diffulty_icon_background_frame",
			pass_type = "multi_texture"
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "difficulty_icon",
			pass_type = "multi_texture"
		}
	}, "mission_info_panel", nil, nil, element_styles.difficulty),
	mission_info = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/generic/danger",
			value_id = "icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					25,
					2
				},
				size = {
					60,
					60
				}
			}
		},
		{
			style_id = "mission_name",
			value_id = "mission_name",
			pass_type = "text",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				text_vertical_alignment = "top",
				font_size = 34,
				text_horizontal_alignment = "left",
				offset = {
					65,
					15,
					10
				},
				size = {
					mission_info_size[1] + 100,
					50
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		},
		{
			style_id = "mission_type",
			value_id = "mission_type",
			pass_type = "text",
			style = {
				vertical_alignment = "bottom",
				text_vertical_alignment = "top",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				offset = {
					65,
					0,
					10
				},
				size = {
					mission_info_size[1],
					50
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		}
	}, "mission_info_panel"),
	circumstance_info = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/backgrounds/fade_horizontal",
			pass_type = "texture_uv",
			style = {
				color = Color.terminal_background(160, true),
				offset = {
					0,
					0,
					-3
				},
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			pass_type = "rect",
			style = {
				horizontal_alignment = "left",
				size = {
					3,
					circumstance_info_size[2]
				},
				color = Color.golden_rod(255, true)
			}
		},
		{
			pass_type = "text",
			value = Utf8.upper(Localize("loc_glossary_term_circumstance_hazard")),
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				offset = {
					0,
					-40,
					10
				},
				size = {
					mission_info_size[1],
					30
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		},
		{
			value = "content/ui/materials/icons/generic/danger",
			value_id = "icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = Color.golden_rod(255, true),
				offset = {
					25,
					10,
					2
				},
				size = {
					40,
					40
				}
			}
		},
		{
			value_id = "circumstance_name",
			pass_type = "text",
			style = {
				vertical_alignment = "top",
				text_vertical_alignment = "top",
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				offset = {
					75,
					20,
					10
				},
				size = {
					mission_info_size[1] - 75,
					40
				},
				text_color = Color.golden_rod(255, true)
			}
		},
		{
			value_id = "circumstance_description",
			pass_type = "text",
			style = {
				vertical_alignment = "center",
				text_vertical_alignment = "top",
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				offset = {
					25,
					25,
					10
				},
				size = {
					mission_info_size[1] - 25,
					60
				},
				text_color = {
					255,
					169,
					191,
					153
				}
			}
		}
	}, "circumstance_info_panel")
}
local animations = {
	enter = {
		{
			name = "reset",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local left_panel_widgets = parent._left_panel_widgets

				for _, widget in ipairs(left_panel_widgets) do
					widget.alpha_multiplier = 0
				end
			end
		},
		{
			name = "left_panel_enter",
			end_time = 0.5,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local new_pos = details_panel_size[1] * math.easeOutCubic(progress)
				local left_panel_widgets = parent._left_panel_widgets

				for _, widget in ipairs(left_panel_widgets) do
					widget.alpha_multiplier = progress
					widget.offset[1] = new_pos
				end

				return true
			end
		}
	},
	exit = {
		{
			name = "left_panel_exit",
			end_time = 0.5,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local new_pos = -details_panel_size[1] * math.easeOutCubic(progress)
				local left_panel_widgets = parent._left_panel_widgets

				for _, widget in ipairs(left_panel_widgets) do
					widget.alpha_multiplier = 1 - progress
					widget.offset[1] = new_pos
				end

				return true
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	left_panel_widgets_definitions = left_panel_widgets_definitions
}
