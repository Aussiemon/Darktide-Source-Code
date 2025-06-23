-- chunkname: @scripts/ui/constant_elements/elements/group_finder_status/constant_element_group_finder_status_definitions.lua

local ConstantMissionLobbyStatusSettings = require("scripts/ui/constant_elements/elements/mission_lobby_status/constant_element_mission_lobby_status_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	top_panel = UIWorkspaceSettings.top_panel,
	pivot = {
		vertical_alignment = "top",
		parent = "top_panel",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			900
		}
	},
	party_panel = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "right",
		size = {
			500,
			37
		},
		position = {
			0,
			0,
			1
		}
	},
	request_panel = {
		vertical_alignment = "bottom",
		parent = "party_panel",
		horizontal_alignment = "right",
		size = {
			500,
			25
		},
		position = {
			0,
			0,
			1
		}
	},
	team_status_text = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "right",
		size = {
			600,
			37
		},
		position = {
			-240,
			0,
			2
		}
	},
	request_text = {
		vertical_alignment = "center",
		parent = "request_panel",
		horizontal_alignment = "right",
		size = {
			800,
			20
		},
		position = {
			-40,
			0,
			2
		}
	}
}
local team_status_text_style = table.clone(UIFontSettings.header_4)

team_status_text_style.text_vertical_alignment = "center"
team_status_text_style.text_horizontal_alignment = "right"
team_status_text_style.offset = {
	0,
	0,
	0
}
team_status_text_style.font_type = "machine_medium"
team_status_text_style.text_color = Color.terminal_text_body(255, true)

local request_text_style = table.clone(UIFontSettings.body_small)

request_text_style.text_vertical_alignment = "center"
request_text_style.text_horizontal_alignment = "right"
request_text_style.offset = {
	0,
	-2,
	1
}
request_text_style.text_color = Color.terminal_corner_selected(255, true)

local widget_definitions = {
	team_status_text = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			value = Localize("loc_group_finder_status_panel_title"),
			style = team_status_text_style
		}
	}, "team_status_text"),
	request_text = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = request_text_style
		}
	}, "request_text"),
	party_panel = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/group_finder_corner",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					160,
					74
				},
				offset = {
					0,
					0,
					10
				},
				color = Color.white(255, true)
			}
		},
		{
			pass_type = "circle",
			style = {
				horizontal_alignment = "right",
				size = {
					60,
					60
				},
				offset = {
					12,
					0,
					8
				},
				color = Color.black(255, true)
			}
		},
		{
			pass_type = "circle",
			style = {
				horizontal_alignment = "right",
				size = {
					60,
					60
				},
				offset = {
					12,
					0,
					9
				},
				color = Color.terminal_corner_hover(255, true),
				default_color = Color.terminal_corner_hover(255, true),
				highlight_color = Color.terminal_corner_selected(255, true)
			},
			change_function = function (content, style, _, dt)
				local has_requests = content.has_requests
				local anim_speed = 2
				local color_change_progress = content.color_change_progress or 0

				if has_requests then
					color_change_progress = math.min(color_change_progress + dt * anim_speed, 1)
				else
					color_change_progress = math.max(color_change_progress - dt * anim_speed, 0)
				end

				content.color_change_progress = color_change_progress

				local default_color = style.default_color
				local highlight_color = style.highlight_color

				ColorUtilities.color_lerp(default_color, highlight_color, color_change_progress, style.color)

				local pulse_speed = 3
				local pulse_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)

				style.color[1] = 180 + 75 * pulse_progress
			end
		},
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = Color.terminal_frame(255, true)
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				size = {
					nil,
					2
				},
				offset = {
					0,
					0,
					6
				},
				color = Color.terminal_text_body(255, true)
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				size = {
					nil,
					2
				},
				offset = {
					0,
					1,
					5
				},
				color = {
					255,
					30,
					30,
					30
				}
			}
		},
		{
			style_id = "team_member_icon_1",
			value_id = "team_member_icon_1",
			pass_type = "text",
			value = "",
			style = {
				font_size = 28,
				text_vertical_alignment = "center",
				horizontal_alignment = "right",
				text_horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "machine_medium",
				text_color = {
					255,
					255,
					255,
					255
				},
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					32,
					40
				},
				offset = {
					-191,
					0,
					3
				}
			}
		},
		{
			style_id = "team_member_icon_2",
			value_id = "team_member_icon_2",
			pass_type = "text",
			value = "",
			style = {
				font_size = 28,
				text_vertical_alignment = "center",
				horizontal_alignment = "right",
				text_horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "machine_medium",
				text_color = {
					255,
					255,
					255,
					255
				},
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					32,
					40
				},
				offset = {
					-154,
					0,
					3
				}
			}
		},
		{
			style_id = "team_member_icon_3",
			value_id = "team_member_icon_3",
			pass_type = "text",
			value = "",
			style = {
				font_size = 28,
				text_vertical_alignment = "center",
				horizontal_alignment = "right",
				text_horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "machine_medium",
				text_color = {
					255,
					255,
					255,
					255
				},
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					32,
					40
				},
				offset = {
					-117,
					0,
					3
				}
			}
		},
		{
			style_id = "team_member_icon_4",
			value_id = "team_member_icon_4",
			pass_type = "text",
			value = "",
			style = {
				font_size = 28,
				text_vertical_alignment = "center",
				horizontal_alignment = "right",
				text_horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "machine_medium",
				text_color = {
					255,
					255,
					255,
					255
				},
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					32,
					40
				},
				offset = {
					-80,
					0,
					3
				}
			}
		}
	}, "party_panel"),
	request_panel = UIWidget.create_definition({
		{
			value = "content/ui/materials/gradients/gradient_horizontal_shine",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = Color.ui_terminal_dark(255, true),
				material_values = {
					shine_progress = 0,
					shine_color = ColorUtilities.format_color_to_material(Color.terminal_text_key_value(255, true))
				}
			},
			change_function = function (content, style, animations, dt)
				local shine_delay = content.shine_delay or 0

				if shine_delay <= 0 then
					local material_values = style.material_values
					local shine_time = content.shine_time or 0
					local shine_duration = 2

					if shine_duration <= shine_time then
						content.shine_time = 0
						content.shine_delay = 1
						material_values.shine_progress = 1
					else
						shine_time = math.clamp(shine_time + dt, 0, shine_duration)

						local duration_progress = shine_time / shine_duration

						material_values.shine_progress = math.ease_out_exp(duration_progress)
						content.shine_time = shine_time
					end
				else
					content.shine_delay = math.max(shine_delay - dt, 0)
					style.material_values.shine_progress = 1
				end
			end
		},
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				size = {
					nil,
					2
				},
				offset = {
					0,
					0,
					2
				},
				color = Color.terminal_corner_selected(255, true)
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				size = {
					nil,
					2
				},
				offset = {
					0,
					1,
					1
				},
				color = {
					255,
					30,
					30,
					30
				}
			}
		}
	}, "request_panel")
}
local ready_status_definition = UIWidget.create_definition({
	{
		value = "content/ui/materials/backgrounds/lobby_timer/ready_line",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			hdr = true,
			horizontal_alignment = "center",
			size = {
				22,
				46
			},
			offset = {
				0,
				0,
				2
			},
			color = Color.ui_terminal(76.5, true)
		},
		visibility_function = function (content, style)
			return content.occupied
		end
	},
	{
		value = "content/ui/materials/backgrounds/lobby_timer/ready_fill",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			hdr = true,
			horizontal_alignment = "center",
			size = {
				22,
				46
			},
			offset = {
				0,
				0,
				2
			},
			color = Color.ui_terminal(255, true)
		},
		visibility_function = function (content, style)
			return content.selected and content.occupied
		end
	},
	{
		value = "content/ui/materials/backgrounds/lobby_timer/not_ready",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				22,
				46
			},
			offset = {
				0,
				0,
				2
			},
			color = Color.ui_red_light(127.5, true)
		},
		visibility_function = function (content, style)
			return not content.occupied
		end
	}
}, "team_status")
local animations = {
	player_request_enter = {
		{
			name = "reset",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.request_text.alpha_multiplier = 0
				widgets.request_panel.alpha_multiplier = 1
			end
		},
		{
			name = "expand",
			end_time = 0.6,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local default_height = 25
				local new_height = default_height * anim_progress

				parent:_set_scenegraph_size("request_panel", nil, new_height)
				parent:set_scenegraph_position("request_panel", nil, new_height)
			end
		},
		{
			name = "text_fade_in",
			end_time = 1.2,
			start_time = 0.6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				widgets.request_text.alpha_multiplier = anim_progress
			end
		},
		{
			name = "text_move",
			end_time = 1.6,
			start_time = 0.6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				widgets.request_text.offset[1] = -50 + 0 * anim_progress
			end
		},
		{
			name = "shine_delay",
			end_time = 1.8,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				widgets.request_panel.content.shine_delay = 1
			end
		},
		{
			name = "done",
			end_time = 2,
			start_time = 1.4,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.request_panel.content.shine_delay = 0
			end
		}
	},
	player_request_exit = {
		{
			name = "text_move",
			end_time = 0.6,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(1 - progress)

				widgets.request_text.offset[1] = -50 + 0 * anim_progress
			end
		},
		{
			name = "text_fade_in",
			end_time = 0.6,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(1 - progress)

				widgets.request_text.alpha_multiplier = anim_progress
			end
		},
		{
			name = "expand",
			end_time = 1.2,
			start_time = 0.4,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(1 - progress)
				local default_height = 25
				local new_height = default_height * anim_progress

				parent:_set_scenegraph_size("request_panel", nil, new_height)
				parent:set_scenegraph_position("request_panel", nil, new_height)
			end
		},
		{
			name = "done",
			end_time = 1.2,
			start_time = 1.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.request_panel.alpha_multiplier = 0
			end
		}
	}
}

return {
	animations = animations,
	ready_status_definition = ready_status_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
