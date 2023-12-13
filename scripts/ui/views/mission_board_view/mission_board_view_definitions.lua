local MissionBoardViewStyles = require("scripts/ui/views/mission_board_view/mission_board_view_styles")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local InputDevice = require("scripts/managers/input/input_device")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local MissionBoardViewDefinitions = {
	pass_templates = {}
}
MissionBoardViewDefinitions.pass_templates.mission_board_checkbox = {
	{
		pass_type = "hotspot",
		content_id = "hotspot_on",
		style = {
			offset = {
				0,
				0,
				0
			},
			size = {
				50,
				50
			}
		}
	},
	{
		pass_type = "hotspot",
		content_id = "hotspot_off",
		style = {
			offset = {
				50,
				0,
				0
			},
			size = {
				50,
				50
			}
		}
	},
	{
		pass_type = "rect",
		style = {
			offset = {
				0,
				0,
				1
			},
			size = {
				50,
				50
			},
			color = {
				200,
				0,
				0,
				0
			}
		}
	},
	{
		pass_type = "rect",
		style = {
			offset = {
				50,
				0,
				1
			},
			size = {
				50,
				50
			},
			color = {
				200,
				0,
				0,
				0
			}
		}
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		pass_type = "texture",
		style = {
			scale_to_material = true,
			offset = {
				0,
				0,
				2
			},
			size = {
				50,
				50
			},
			color = Color.terminal_frame(nil, true)
		}
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		pass_type = "texture",
		style = {
			scale_to_material = true,
			offset = {
				50,
				0,
				2
			},
			size = {
				50,
				50
			},
			color = Color.terminal_frame(nil, true)
		}
	},
	{
		value = "content/ui/materials/frames/frame_corner_2px",
		pass_type = "texture",
		style = {
			offset = {
				0,
				0,
				3
			},
			size = {
				50,
				50
			},
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true)
		}
	},
	{
		value = "content/ui/materials/frames/frame_corner_2px",
		pass_type = "texture",
		style = {
			offset = {
				0,
				0,
				3
			},
			size = {
				50,
				50
			},
			default_color = Color.terminal_corner(nil, true),
			selected_color = Color.terminal_corner_selected(nil, true)
		}
	},
	{
		style_id = "option_on",
		pass_type = "text",
		value = Localize("loc_settings_menu_on"),
		style = {
			text_horizontal_alignment = "left",
			font_size = 24,
			text_vertical_alignment = "center",
			drop_shadow = true,
			font_type = "proxima_nova_bold",
			default_color = Color.terminal_text_header(255, true),
			text_color = Color.terminal_text_header(255, true),
			hover_color = Color.terminal_text_header_selected(255, true),
			disabled_color = Color.ui_grey_light(255, true),
			offset = {
				5,
				0,
				5
			},
			size = {
				50,
				50
			}
		}
	},
	{
		style_id = "option_off",
		pass_type = "text",
		value = Localize("loc_settings_menu_off"),
		style = {
			text_horizontal_alignment = "left",
			font_size = 24,
			text_vertical_alignment = "center",
			drop_shadow = true,
			font_type = "proxima_nova_bold",
			default_color = Color.terminal_text_header(255, true),
			text_color = Color.terminal_text_header(255, true),
			hover_color = Color.terminal_text_header_selected(255, true),
			disabled_color = Color.ui_grey_light(255, true),
			offset = {
				55,
				0,
				5
			},
			size = {
				50,
				50
			}
		}
	}
}
MissionBoardViewDefinitions.scenegraph_definition = {
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
	gamepad_cursor_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			1,
			1
		},
		position = {
			0,
			0,
			500
		}
	},
	gamepad_cursor = {
		vertical_alignment = "center",
		parent = "gamepad_cursor_pivot",
		horizontal_alignment = "center",
		size = {
			80,
			125
		},
		position = {
			0,
			0,
			0
		}
	},
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			172,
			230
		},
		position = {
			0,
			0,
			0
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			172,
			230
		},
		position = {
			0,
			0,
			0
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			220,
			268
		},
		position = {
			0,
			0,
			63
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			220,
			268
		},
		position = {
			0,
			0,
			63
		}
	},
	planet = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			800,
			40
		},
		position = {
			110,
			40,
			5
		}
	},
	happening = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			480,
			50
		},
		position = {
			95,
			160,
			10
		}
	},
	detail = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			483,
			384
		},
		position = {
			-100,
			60,
			0
		}
	},
	detail_timer = {
		vertical_alignment = "top",
		parent = "detail",
		horizontal_alignment = "right",
		size = {
			483,
			40
		},
		position = {
			0,
			0,
			10
		}
	},
	detail_header = {
		vertical_alignment = "bottom",
		parent = "detail_timer",
		horizontal_alignment = "right",
		size = {
			483,
			75
		},
		position = {
			0,
			73,
			10
		}
	},
	detail_difficulty = {
		vertical_alignment = "center",
		parent = "detail_header",
		horizontal_alignment = "right",
		size = {
			170,
			75
		},
		position = {
			0,
			0,
			10
		}
	},
	detail_location = {
		vertical_alignment = "bottom",
		parent = "detail_header",
		horizontal_alignment = "right",
		size = {
			483,
			269
		},
		position = {
			0,
			267,
			10
		}
	},
	detail_circumstance = {
		vertical_alignment = "bottom",
		parent = "detail_location",
		horizontal_alignment = "right",
		size = {
			483,
			100
		},
		position = {
			0,
			0,
			10
		}
	},
	objective = {
		vertical_alignment = "top",
		parent = "detail",
		horizontal_alignment = "center",
		size = {
			483,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	objective_header = {
		vertical_alignment = "top",
		parent = "objective",
		horizontal_alignment = "left",
		size = {
			483,
			68
		},
		position = {
			0,
			0,
			10
		}
	},
	objective_credits = {
		vertical_alignment = "bottom",
		parent = "objective",
		horizontal_alignment = "left",
		size = {
			110,
			33
		},
		position = {
			-10,
			10,
			10
		}
	},
	objective_xp = {
		vertical_alignment = "bottom",
		parent = "objective_credits",
		horizontal_alignment = "left",
		size = {
			110,
			33
		},
		position = {
			115,
			0,
			0
		}
	},
	objective_speaker = {
		vertical_alignment = "bottom",
		parent = "objective",
		horizontal_alignment = "right",
		size = {
			40,
			48
		},
		position = {
			10,
			10,
			10
		}
	},
	difficulty_stepper = {
		vertical_alignment = "top",
		parent = "detail",
		horizontal_alignment = "center",
		size = {
			483,
			178
		},
		position = {
			0,
			0,
			0
		}
	},
	difficulty_stepper_header = {
		vertical_alignment = "top",
		parent = "difficulty_stepper",
		horizontal_alignment = "left",
		size = {
			483,
			38
		},
		position = {
			0,
			0,
			5
		}
	},
	difficulty_stepper_window = {
		vertical_alignment = "top",
		parent = "difficulty_stepper",
		horizontal_alignment = "left",
		size = {
			483,
			140
		},
		position = {
			0,
			0,
			-5
		}
	},
	game_settings = {
		vertical_alignment = "bottom",
		parent = "detail_location",
		horizontal_alignment = "center",
		size = {
			563,
			390
		},
		position = {
			0,
			430,
			500
		}
	},
	game_settings_header = {
		vertical_alignment = "top",
		parent = "game_settings",
		horizontal_alignment = "left",
		size = {
			563,
			40
		},
		position = {
			0,
			0,
			10
		}
	},
	info_box = {
		vertical_alignment = "bottom",
		parent = "detail_location",
		horizontal_alignment = "center",
		size = {
			380,
			60
		},
		position = {
			0,
			570,
			0
		}
	},
	search_text = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			1600,
			500
		},
		position = {
			0,
			0,
			5
		}
	},
	play_team_button = {
		vertical_alignment = "bottom",
		parent = "detail_location",
		horizontal_alignment = "center",
		size = ButtonPassTemplates.default_button.size,
		position = {
			0,
			460,
			100
		}
	},
	mission_small = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			80,
			125
		},
		position = {
			0,
			0,
			1
		}
	},
	mission_small_difficulty = {
		vertical_alignment = "top",
		parent = "mission_small",
		horizontal_alignment = "left",
		size = {
			80,
			28
		},
		position = {
			0,
			0,
			10
		}
	},
	mission_small_timer = {
		vertical_alignment = "top",
		parent = "mission_small",
		horizontal_alignment = "left",
		size = {
			80,
			5
		},
		position = {
			0,
			28,
			5
		}
	},
	mission_small_location = {
		vertical_alignment = "top",
		parent = "mission_small",
		horizontal_alignment = "left",
		size = {
			80,
			92
		},
		position = {
			0,
			33,
			10
		}
	},
	mission_small_objective_1 = {
		vertical_alignment = "top",
		parent = "mission_small_location",
		horizontal_alignment = "right",
		size = {
			32,
			32
		},
		position = {
			18,
			6,
			20
		}
	},
	mission_small_objective_2 = {
		vertical_alignment = "top",
		parent = "mission_small_objective_1",
		horizontal_alignment = "left",
		size = {
			32,
			32
		},
		position = {
			0,
			31,
			0
		}
	},
	mission_small_circumstance = {
		vertical_alignment = "bottom",
		parent = "mission_small_location",
		horizontal_alignment = "right",
		size = {
			32,
			32
		},
		position = {
			18,
			16,
			20
		}
	},
	mission_medium = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			281,
			152
		},
		position = {
			0,
			0,
			1
		}
	},
	mission_medium_difficulty = {
		vertical_alignment = "top",
		parent = "mission_medium",
		horizontal_alignment = "left",
		size = {
			80,
			28
		},
		position = {
			10,
			10,
			10
		}
	},
	mission_medium_timer = {
		vertical_alignment = "top",
		parent = "mission_medium",
		horizontal_alignment = "right",
		size = {
			210,
			6
		},
		position = {
			0,
			-20,
			1
		}
	},
	mission_medium_location = {
		vertical_alignment = "top",
		parent = "mission_medium",
		horizontal_alignment = "left",
		size = {
			281,
			152
		},
		position = {
			0,
			0,
			5
		}
	},
	mission_medium_objective_1 = {
		vertical_alignment = "bottom",
		parent = "mission_medium",
		horizontal_alignment = "right",
		size = {
			32,
			32
		},
		position = {
			18,
			-88,
			20
		}
	},
	mission_medium_objective_2 = {
		vertical_alignment = "bottom",
		parent = "mission_medium_objective_1",
		horizontal_alignment = "left",
		size = {
			32,
			32
		},
		position = {
			0,
			35,
			0
		}
	},
	mission_medium_circumstance = {
		vertical_alignment = "bottom",
		parent = "mission_medium",
		horizontal_alignment = "right",
		size = {
			32,
			32
		},
		position = {
			18,
			-50,
			20
		}
	},
	mission_medium_title = {
		vertical_alignment = "bottom",
		parent = "mission_medium",
		horizontal_alignment = "left",
		size = {
			281,
			40
		},
		position = {
			1,
			0,
			10
		}
	},
	mission_medium_bonus = {
		vertical_alignment = "top",
		parent = "mission_medium",
		horizontal_alignment = "left",
		size = {
			251,
			20
		},
		position = {
			20,
			25,
			10
		}
	},
	region = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			500,
			50
		},
		position = {
			-100,
			20,
			2
		}
	},
	mission_type_selection_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			105,
			95,
			2
		}
	},
	story_mission_view_button_frame = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			450,
			336
		},
		position = {
			40,
			-60,
			10
		}
	},
	story_mission_view_button = {
		vertical_alignment = "bottom",
		parent = "story_mission_view_button_frame",
		horizontal_alignment = "center",
		size = {
			248,
			45
		},
		position = {
			0,
			-83,
			10
		}
	}
}
MissionBoardViewDefinitions.widget_definitions = {
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/panel_horizontal_half",
			pass_type = "texture_uv",
			style = {
				offset = {
					300,
					0,
					0
				},
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				color = {
					120,
					0,
					0,
					0
				}
			}
		}
	}, "screen")
}
MissionBoardViewDefinitions.widget_definitions_functions = {}
MissionBoardViewDefinitions.widget_definitions.gamepad_cursor = UIWidget.create_definition({
	{
		value = "content/ui/materials/frames/frame_glow_01",
		style_id = "glow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = MissionBoardViewSettings.color_cursor,
			offset = {
				0,
				0,
				5
			},
			size_addition = {
				24,
				24
			}
		}
	},
	{
		style_id = "rect",
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			color = MissionBoardViewSettings.color_cursor,
			offset = {
				0,
				0,
				1
			}
		}
	},
	{
		value = "content/ui/materials/icons/generic/light_arrow",
		style_id = "arrow",
		pass_type = "rotated_texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			angle = -math.pi / 2,
			color = MissionBoardViewSettings.color_cursor,
			offset = {
				0,
				0,
				2
			},
			size = {
				16,
				28
			}
		}
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "frame",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			color = MissionBoardViewSettings.color_cursor,
			offset = {
				0,
				0,
				3
			},
			size_addition = {
				0,
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
			scale_to_material = true,
			horizontal_alignment = "center",
			color = MissionBoardViewSettings.color_cursor,
			offset = {
				0,
				0,
				4
			},
			size_addition = {
				15,
				15
			}
		}
	}
}, "gamepad_cursor")
MissionBoardViewDefinitions.widget_definitions.screen_decorations = UIWidget.create_definition({
	{
		pass_type = "rect",
		style_id = "overlay"
	},
	{
		style_id = "overlay_top",
		pass_type = "rect",
		visibility_function = function ()
			return InputDevice.gamepad_active
		end
	},
	{
		value = "content/ui/materials/frames/screen/mission_board_01_upper",
		style_id = "corner_left",
		pass_type = "texture",
		scenegraph_id = "corner_top_left"
	},
	{
		value = "content/ui/materials/frames/screen/mission_board_01_upper",
		style_id = "corner_right",
		pass_type = "texture_uv",
		scenegraph_id = "corner_top_right"
	},
	{
		value = "content/ui/materials/frames/screen/mission_board_01_lower",
		style_id = "corner_left",
		pass_type = "texture",
		scenegraph_id = "corner_bottom_left"
	},
	{
		value = "content/ui/materials/frames/screen/mission_board_01_lower",
		style_id = "corner_right",
		pass_type = "texture_uv",
		scenegraph_id = "corner_bottom_right"
	}
}, "screen", nil, nil, MissionBoardViewStyles.screen_decorations_widget_style)
MissionBoardViewDefinitions.widget_definitions.planet = UIWidget.create_definition({
	{
		value_id = "title",
		style_id = "title",
		pass_type = "text",
		scenegraph_id = "planet",
		value = Localize("loc_mission_board_view_header_tertium_hive")
	}
}, "planet", nil, nil, MissionBoardViewStyles.planet_widget_style)
MissionBoardViewDefinitions.widget_definitions.happening = UIWidget.create_definition({
	{
		scenegraph_id = "happening",
		style_id = "background",
		pass_type = "rect"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "frame",
		pass_type = "texture",
		scenegraph_id = "happening"
	},
	{
		value = "content/ui/materials/gradients/gradient_horizontal",
		style_id = "gradient",
		pass_type = "texture",
		scenegraph_id = "happening"
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture",
		scenegraph_id = "happening",
		value = "content/ui/materials/icons/generic/transmission"
	},
	{
		value_id = "title",
		style_id = "title",
		pass_type = "text",
		scenegraph_id = "happening",
		value = Localize("loc_mission_info_happening_label")
	},
	{
		value_id = "subtitle",
		style_id = "subtitle",
		pass_type = "text",
		scenegraph_id = "happening",
		value = "subtitle"
	}
}, "happening", nil, nil, MissionBoardViewStyles.happening_widget_style)

local function _has_difficulty(content)
	return content.danger
end

local function _has_completed_on_difficulty(content)
	return content.completed_danger
end

local function _has_timer(content)
	return content.start_game_time
end

local function _has_circumstance(content)
	return content.circumstance_icon
end

local function _has_credits_reward(content)
	return content.credits
end

local function _has_xp_reward(content)
	return content.xp
end

local function _has_speaker(content)
	return content.speaker_icon
end

local function _difficulty(content)
	return content.danger
end

local function _difficulty_1(content)
	local danger = content.danger

	return danger and danger >= 1
end

local function _difficulty_2(content)
	local danger = content.danger

	return danger and danger >= 2
end

local function _difficulty_3(content)
	local danger = content.danger

	return danger and danger >= 3
end

local function _difficulty_4(content)
	local danger = content.danger

	return danger and danger >= 4
end

local function _difficulty_5(content)
	local danger = content.danger

	return danger and danger >= 5
end

local function _has_objective_2(content)
	return content.objective_2_icon
end

local function _is_flash(content)
	return content.is_flash
end

local function _is_locked(content)
	return content.is_locked
end

local function _is_not_locked(content)
	return not content.is_locked
end

local function _change_function_difficulty(danger)
	return function (content, style)
		local content_danger = content.danger

		if content_danger then
			if content_danger < danger then
				ColorUtilities.color_copy(style.color_disabled, style.color, true)
			else
				MissionBoardViewStyles.difficulty_bar_change_function(content, style)
			end
		end
	end
end

MissionBoardViewDefinitions.widget_definitions.detail = UIWidget.create_definition({
	{
		pass_type = "logic",
		value = MissionBoardViewStyles.timer_logic
	},
	{
		scenegraph_id = "detail_timer",
		style_id = "background",
		pass_type = "rect",
		visibility_function = _has_timer
	},
	{
		style_id = "timer_frame",
		scenegraph_id = "detail_timer",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		visibility_function = _has_timer
	},
	{
		style_id = "timer_bar",
		scenegraph_id = "detail_timer",
		pass_type = "texture",
		value = "content/ui/materials/mission_board/timer",
		visibility_function = _has_timer
	},
	{
		style_id = "timer_hourglass",
		scenegraph_id = "detail_timer",
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/hourglass",
		visibility_function = _has_timer
	},
	{
		value_id = "timer_text",
		style_id = "timer_text",
		pass_type = "text",
		scenegraph_id = "detail_timer",
		value = "00:00",
		visibility_function = _has_timer
	},
	{
		scenegraph_id = "detail_header",
		style_id = "background",
		pass_type = "rect"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "header_frame",
		pass_type = "texture",
		scenegraph_id = "detail_header"
	},
	{
		value_id = "header_title",
		style_id = "header_title",
		pass_type = "text",
		scenegraph_id = "detail_header",
		value = "header_title"
	},
	{
		value_id = "header_subtitle",
		style_id = "header_subtitle",
		pass_type = "text",
		scenegraph_id = "detail_header",
		value = "header_subtitle"
	},
	{
		style_id = "difficulty_icon",
		scenegraph_id = "detail_difficulty",
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/danger",
		visibility_function = _has_difficulty
	},
	{
		style_id = "difficulty_bar_1",
		scenegraph_id = "detail_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty,
		change_function = _change_function_difficulty(1)
	},
	{
		style_id = "difficulty_bar_2",
		scenegraph_id = "detail_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty,
		change_function = _change_function_difficulty(2)
	},
	{
		style_id = "difficulty_bar_3",
		scenegraph_id = "detail_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty,
		change_function = _change_function_difficulty(3)
	},
	{
		style_id = "difficulty_bar_4",
		scenegraph_id = "detail_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty,
		change_function = _change_function_difficulty(4)
	},
	{
		style_id = "difficulty_bar_5",
		scenegraph_id = "detail_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty,
		change_function = _change_function_difficulty(5)
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "location_frame",
		pass_type = "texture",
		scenegraph_id = "detail_location"
	},
	{
		value_id = "location_image",
		style_id = "location_image",
		pass_type = "texture",
		scenegraph_id = "detail_location",
		value = "content/ui/materials/mission_board/texture_with_grid_effect"
	},
	{
		value = "content/ui/materials/frames/inner_shadow_medium",
		style_id = "location_vignette",
		pass_type = "texture",
		scenegraph_id = "detail_location"
	},
	{
		style_id = "location_lock",
		scenegraph_id = "detail_location",
		pass_type = "text",
		value = "",
		visibility_function = _is_locked
	},
	{
		value_id = "bonus_title",
		style_id = "bonus_title",
		pass_type = "text",
		scenegraph_id = "detail_location",
		value = Localize("loc_mission_board_bonus_reward_title")
	},
	{
		value_id = "bonus_text",
		style_id = "bonus_text",
		pass_type = "text",
		scenegraph_id = "detail_location",
		value = ""
	},
	{
		scenegraph_id = "detail_circumstance",
		style_id = "background",
		pass_type = "rect",
		visibility_function = _has_circumstance
	},
	{
		style_id = "circumstance_frame",
		scenegraph_id = "detail_circumstance",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		visibility_function = _has_circumstance
	},
	{
		scenegraph_id = "detail_circumstance",
		style_id = "circumstance_detail",
		pass_type = "rect",
		visibility_function = _has_circumstance
	},
	{
		value_id = "circumstance_icon",
		style_id = "circumstance_icon",
		pass_type = "texture",
		scenegraph_id = "detail_circumstance",
		value = "content/ui/materials/icons/circumstances/assault_01",
		visibility_function = _has_circumstance
	},
	{
		value_id = "circumstance_label",
		style_id = "circumstance_label",
		pass_type = "text",
		scenegraph_id = "detail_circumstance",
		value = Localize("loc_mission_info_circumstance_label"),
		visibility_function = _has_circumstance
	},
	{
		value_id = "circumstance_name",
		scenegraph_id = "detail_circumstance",
		pass_type = "text",
		style_id = "circumstance_name",
		visibility_function = _has_circumstance
	},
	{
		value_id = "circumstance_description",
		style_id = "circumstance_description",
		pass_type = "text",
		scenegraph_id = "detail_circumstance",
		value = "circumstance_description",
		visibility_function = _has_circumstance
	},
	{
		scenegraph_id = "detail_circumstance",
		style_id = "maelstrom_background",
		pass_type = "rect",
		visibility_function = _is_flash
	},
	{
		style_id = "maelstrom_text",
		scenegraph_id = "detail_circumstance",
		pass_type = "text",
		value = Localize("loc_mission_board_maelstrom_header"),
		visibility_function = _is_flash
	}
}, "detail", nil, nil, MissionBoardViewStyles.detail_widget_style)
local objective_pass_template = {
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "header_frame",
		pass_type = "texture",
		scenegraph_id = "objective_header"
	},
	{
		value = "content/ui/materials/gradients/gradient_horizontal",
		style_id = "header_gradient",
		pass_type = "texture",
		scenegraph_id = "objective_header"
	},
	{
		value_id = "header_icon",
		style_id = "header_icon",
		pass_type = "texture",
		scenegraph_id = "objective_header",
		value = "content/ui/materials/icons/mission_types/mission_type_01"
	},
	{
		style_id = "header_title",
		value_id = "header_title",
		pass_type = "text",
		scenegraph_id = "objective_header"
	},
	{
		value_id = "header_subtitle",
		style_id = "header_subtitle",
		pass_type = "text",
		scenegraph_id = "objective_header",
		value = "header_subtitle"
	},
	{
		pass_type = "rect",
		style_id = "body_background"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "body_frame",
		pass_type = "texture"
	},
	{
		value = "body_text",
		value_id = "body_text",
		pass_type = "text",
		style_id = "body_text"
	},
	{
		scenegraph_id = "objective_credits",
		style_id = "reward_background",
		pass_type = "rect",
		visibility_function = _has_credits_reward
	},
	{
		style_id = "reward_gradient",
		scenegraph_id = "objective_credits",
		pass_type = "texture",
		value = "content/ui/materials/gradients/gradient_vertical",
		visibility_function = _has_credits_reward
	},
	{
		style_id = "reward_frame",
		scenegraph_id = "objective_credits",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		visibility_function = _has_credits_reward
	},
	{
		style_id = "reward_icon",
		scenegraph_id = "objective_credits",
		pass_type = "texture",
		value = "content/ui/materials/icons/currencies/credits_small",
		visibility_function = _has_credits_reward
	},
	{
		value_id = "credits",
		style_id = "reward_text",
		pass_type = "text",
		scenegraph_id = "objective_credits",
		value = "0",
		visibility_function = _has_credits_reward
	},
	{
		scenegraph_id = "objective_xp",
		style_id = "reward_background",
		pass_type = "rect",
		visibility_function = _has_xp_reward
	},
	{
		style_id = "reward_gradient",
		scenegraph_id = "objective_xp",
		pass_type = "texture",
		value = "content/ui/materials/gradients/gradient_vertical",
		visibility_function = _has_xp_reward
	},
	{
		style_id = "reward_frame",
		scenegraph_id = "objective_xp",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		visibility_function = _has_xp_reward
	},
	{
		style_id = "reward_icon",
		scenegraph_id = "objective_xp",
		pass_type = "texture",
		value = "content/ui/materials/icons/currencies/experience_small",
		visibility_function = _has_xp_reward
	},
	{
		value_id = "xp",
		style_id = "reward_text",
		pass_type = "text",
		scenegraph_id = "objective_xp",
		value = "0",
		visibility_function = _has_xp_reward
	},
	{
		value_id = "speaker_text",
		style_id = "speaker_text",
		pass_type = "text",
		value = "speaker_text",
		visibility_function = _has_speaker
	},
	{
		style_id = "speaker_frame",
		scenegraph_id = "objective_speaker",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		visibility_function = _has_speaker
	},
	{
		style_id = "speaker_corner",
		scenegraph_id = "objective_speaker",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_corner_2px",
		visibility_function = _has_speaker
	},
	{
		value_id = "speaker_icon",
		style_id = "speaker_icon",
		pass_type = "texture",
		scenegraph_id = "objective_speaker",
		value = "content/ui/materials/icons/npc_portraits/mission_givers/sergeant_a_small",
		visibility_function = _has_speaker
	}
}
local objective_1 = UIWidget.create_definition(objective_pass_template, "objective", nil, nil, MissionBoardViewStyles.objective_widget_style)
objective_1.content.header_title = Localize("loc_misison_board_main_objective_title")
objective_1.style.header_gradient.color = objective_1.style.header_gradient.color_main
MissionBoardViewDefinitions.widget_definitions.objective_1 = objective_1
local objective_2 = UIWidget.create_definition(objective_pass_template, "objective", nil, nil, MissionBoardViewStyles.objective_widget_style)
objective_2.content.header_title = Localize("loc_mission_info_side_mission_label")
objective_2.style.header_gradient.color = objective_2.style.header_gradient.color_side
objective_2.offset = {
	0,
	190,
	0
}
MissionBoardViewDefinitions.widget_definitions.objective_2 = objective_2
MissionBoardViewDefinitions.widget_definitions.difficulty_stepper_window = UIWidget.create_definition({
	{
		pass_type = "rect",
		style_id = "background"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "frame",
		pass_type = "texture"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "header_frame",
		pass_type = "texture",
		scenegraph_id = "difficulty_stepper_header"
	},
	{
		value = "content/ui/materials/gradients/gradient_horizontal",
		style_id = "header_gradient",
		pass_type = "texture",
		scenegraph_id = "difficulty_stepper_header"
	},
	{
		style_id = "header_title",
		pass_type = "text",
		scenegraph_id = "difficulty_stepper_header",
		value = Localize("loc_mission_board_select_difficulty")
	}
}, "difficulty_stepper_window", nil, nil, MissionBoardViewStyles.difficulty_stepper_window_widget_style)
MissionBoardViewDefinitions.widget_definitions.difficulty_stepper = UIWidget.create_definition(StepperPassTemplates.difficulty_stepper, "difficulty_stepper", nil, nil, MissionBoardViewStyles.difficulty_stepper_style)
MissionBoardViewDefinitions.widget_definitions.game_settings = UIWidget.create_definition({
	{
		pass_type = "rect",
		style_id = "background"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "frame",
		pass_type = "texture"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "header_frame",
		pass_type = "texture",
		scenegraph_id = "game_settings_header"
	},
	{
		value = "content/ui/materials/gradients/gradient_horizontal",
		style_id = "header_gradient",
		pass_type = "texture",
		scenegraph_id = "game_settings_header"
	},
	{
		style_id = "header_title",
		pass_type = "text",
		scenegraph_id = "game_settings_header",
		value = Localize("loc_mission_board_open_game_settings")
	}
}, "game_settings", nil, nil, MissionBoardViewStyles.game_settings_widget_style)
MissionBoardViewDefinitions.widget_definitions.info_box = UIWidget.create_definition({
	{
		pass_type = "rect",
		style_id = "background"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "frame",
		pass_type = "texture"
	},
	{
		value = "",
		value_id = "text",
		pass_type = "text",
		style_id = "text"
	}
}, "info_box", nil, nil, MissionBoardViewStyles.info_box_widget_style)
MissionBoardViewDefinitions.widget_definitions.search_text = UIWidget.create_definition({
	{
		value_id = "text",
		pass_type = "text",
		style_id = "text",
		value = Localize("loc_social_menu_find_player_searching")
	}
}, "search_text", nil, nil, MissionBoardViewStyles.search_text_style)
MissionBoardViewDefinitions.widget_definitions.play_team_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "play_team_button", {
	gamepad_action = "confirm_pressed",
	original_text = Utf8.upper(Localize("loc_mission_board_view_accept_mission")),
	hotspot = {}
}, nil, {
	text = {
		line_spacing = 0.7
	}
})
MissionBoardViewDefinitions.widget_definitions.story_mission_view_button_frame = UIWidget.create_definition({
	{
		value = "content/ui/materials/frames/mission_board_story_mission_frame",
		style_id = "frame",
		pass_type = "texture",
		style = {
			offset = {
				0,
				0,
				2
			}
		}
	},
	{
		value = "content/ui/materials/frames/mission_board_story_mission_char",
		style_id = "char",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			offset = {
				0,
				-40,
				0
			},
			size = {
				144,
				144
			},
			material_values = {}
		}
	},
	{
		value = "content/ui/materials/frames/mission_board_story_mission_char_overlay",
		style_id = "char_overlay",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			offset = {
				0,
				-40,
				1
			},
			size = {
				144,
				144
			},
			color = Color.terminal_grid_background(150, true)
		}
	}
}, "story_mission_view_button_frame", {
	visible = false
})
MissionBoardViewDefinitions.widget_definitions.story_mission_view_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "story_mission_view_button", {
	gamepad_action = "hotkey_menu_special_2",
	visible = false,
	original_text = Utf8.upper(Localize("loc_story_mission_menu_access_button_text")),
	hotspot = {}
}, nil, {
	text = {
		line_spacing = 0.7,
		font_size = 20
	}
})
MissionBoardViewDefinitions.widget_definitions.play_team_button_legend = UIWidget.create_definition({
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = {
			horizontal_alignment = "center"
		}
	}
}, "play_team_button", nil, nil, MissionBoardViewStyles.play_team_button_legend)
local mission_widget_hotspot_content = {
	on_hover_sound = UISoundEvents.mission_board_node_hover,
	on_pressed_sound = UISoundEvents.mission_board_node_pressed
}
MissionBoardViewDefinitions.mission_small_widget_template = UIWidget.create_definition({
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = mission_widget_hotspot_content
	},
	{
		value = "content/ui/materials/frames/frame_glow_01",
		style_id = "glow",
		pass_type = "texture",
		change_function = MissionBoardViewStyles.mission_glow_change_function
	},
	{
		pass_type = "logic",
		value = MissionBoardViewStyles.timer_logic
	},
	{
		scenegraph_id = "mission_small_timer",
		style_id = "background",
		pass_type = "rect"
	},
	{
		value = "content/ui/materials/mission_board/timer",
		style_id = "timer_bar",
		pass_type = "texture",
		scenegraph_id = "mission_small_timer"
	},
	{
		scenegraph_id = "mission_small_difficulty",
		style_id = "background",
		pass_type = "rect"
	},
	{
		scenegraph_id = "mission_small_difficulty",
		pass_type = "texture",
		style_id = "difficulty_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_frame_selected(255, true),
			hover_color = Color.terminal_frame_hover(255, true),
			default_color = Color.terminal_frame(255, true)
		}
	},
	{
		scenegraph_id = "mission_small_difficulty",
		pass_type = "texture",
		style_id = "difficulty_corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
			default_color = Color.terminal_corner(255, true)
		}
	},
	{
		scenegraph_id = "mission_small_difficulty",
		pass_type = "texture",
		style_id = "difficulty_icon",
		value = "content/ui/materials/icons/generic/danger",
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_1",
		scenegraph_id = "mission_small_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_1,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_2",
		scenegraph_id = "mission_small_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_2,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_3",
		scenegraph_id = "mission_small_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_3,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_4",
		scenegraph_id = "mission_small_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_4,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_5",
		scenegraph_id = "mission_small_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_5,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		value_id = "location_image",
		style_id = "location_image",
		pass_type = "texture",
		scenegraph_id = "mission_small_location",
		value = "content/ui/materials/mission_board/texture_with_grid_effect"
	},
	{
		scenegraph_id = "mission_small_location",
		style_id = "location_rect",
		pass_type = "rect"
	},
	{
		value = "content/ui/materials/frames/inner_shadow_medium",
		style_id = "location_vignette",
		pass_type = "texture",
		scenegraph_id = "mission_small_location"
	},
	{
		scenegraph_id = "mission_small_location",
		pass_type = "texture",
		style_id = "location_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_frame_selected(255, true),
			hover_color = Color.terminal_frame_hover(255, true),
			default_color = Color.terminal_frame(255, true)
		}
	},
	{
		scenegraph_id = "mission_small_location",
		pass_type = "texture",
		style_id = "location_corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
			default_color = Color.terminal_corner(255, true)
		}
	},
	{
		style_id = "location_lock",
		scenegraph_id = "mission_small_location",
		pass_type = "text",
		value = "",
		visibility_function = _is_locked
	},
	{
		scenegraph_id = "mission_small_objective_1",
		style_id = "background",
		pass_type = "rect"
	},
	{
		scenegraph_id = "mission_small_objective_1",
		pass_type = "texture",
		style_id = "objective_corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
			default_color = Color.terminal_corner(255, true)
		}
	},
	{
		style_id = "objective_1_icon",
		pass_type = "texture",
		scenegraph_id = "mission_small_objective_1",
		value = "content/ui/materials/icons/mission_types/mission_type_01",
		value_id = "objective_1_icon",
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		scenegraph_id = "mission_small_objective_2",
		style_id = "background",
		pass_type = "rect",
		visibility_function = _has_objective_2
	},
	{
		scenegraph_id = "mission_small_objective_2",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_corner_2px",
		style_id = "objective_corner",
		visibility_function = _has_objective_2,
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
			default_color = Color.terminal_corner(255, true)
		}
	},
	{
		style_id = "objective_2_icon",
		pass_type = "texture",
		scenegraph_id = "mission_small_objective_2",
		value = "content/ui/materials/icons/mission_types/mission_type_01",
		value_id = "objective_2_icon",
		visibility_function = _has_objective_2,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		scenegraph_id = "mission_small_circumstance",
		pass_type = "rect",
		style = {
			color = {
				200,
				0,
				0,
				0
			}
		},
		visibility_function = _has_circumstance
	},
	{
		scenegraph_id = "mission_small_circumstance",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_corner_2px",
		style_id = "circumstance_corner",
		visibility_function = _has_circumstance,
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
			default_color = Color.terminal_corner(255, true)
		}
	},
	{
		value_id = "circumstance_icon",
		style_id = "circumstance_icon",
		pass_type = "texture",
		scenegraph_id = "mission_small_circumstance",
		value = "content/ui/materials/icons/circumstances/assault_01",
		visibility_function = _has_circumstance
	},
	{
		style_id = "mission_line",
		pass_type = "texture",
		value_id = "mission_line",
		value = "content/ui/materials/mission_board/mission_line",
		change_function = MissionBoardViewStyles.update_mission_line
	},
	{
		style_id = "mission_completed_icon",
		pass_type = "texture",
		value_id = "mission_completed_icon",
		value = "content/ui/materials/icons/mission_difficulty_complete/difficulty_completed_1",
		change_function = MissionBoardViewStyles.update_mission_line,
		visibility_function = _has_completed_on_difficulty
	}
}, "mission_small", nil, nil, MissionBoardViewStyles.mission_widget_style)
MissionBoardViewDefinitions.mission_medium_widget_template = UIWidget.create_definition({
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = mission_widget_hotspot_content
	},
	{
		value = "content/ui/materials/frames/frame_glow_01",
		style_id = "glow",
		pass_type = "texture",
		change_function = MissionBoardViewStyles.mission_glow_change_function
	},
	{
		pass_type = "logic",
		value = MissionBoardViewStyles.timer_logic
	},
	{
		scenegraph_id = "mission_medium_timer",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "timer_frame",
		visibility_function = _has_timer,
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_frame_selected(255, true),
			hover_color = Color.terminal_frame_hover(255, true),
			default_color = Color.terminal_frame(255, true)
		}
	},
	{
		scenegraph_id = "mission_medium_timer",
		pass_type = "texture",
		value = "content/ui/materials/mission_board/timer",
		style_id = "timer_bar",
		visibility_function = _has_timer,
		change_function = MissionBoardViewStyles.timer_change_function
	},
	{
		style_id = "timer_hourglass",
		scenegraph_id = "mission_medium_timer",
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/hourglass",
		visibility_function = _has_timer
	},
	{
		value_id = "timer_text",
		style_id = "timer_text",
		pass_type = "text",
		scenegraph_id = "mission_medium_timer",
		value = "00:00",
		visibility_function = _has_timer
	},
	{
		scenegraph_id = "mission_medium_difficulty",
		style_id = "background",
		pass_type = "rect",
		visibility_function = _has_difficulty
	},
	{
		scenegraph_id = "mission_medium_difficulty",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "difficulty_frame",
		visibility_function = _has_difficulty,
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_frame_selected(255, true),
			hover_color = Color.terminal_frame_hover(255, true),
			default_color = Color.terminal_frame(255, true)
		}
	},
	{
		scenegraph_id = "mission_medium_difficulty",
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/danger",
		style_id = "difficulty_icon",
		visibility_function = _has_difficulty,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_1",
		scenegraph_id = "mission_medium_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_1,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_2",
		scenegraph_id = "mission_medium_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_2,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_3",
		scenegraph_id = "mission_medium_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_3,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_4",
		scenegraph_id = "mission_medium_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_4,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_5",
		scenegraph_id = "mission_medium_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_5,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		value_id = "location_image",
		style_id = "location_image",
		pass_type = "texture",
		scenegraph_id = "mission_medium_location",
		value = "content/ui/materials/mission_board/texture_with_grid_effect"
	},
	{
		scenegraph_id = "mission_medium_location",
		style_id = "location_rect",
		pass_type = "rect"
	},
	{
		value = "content/ui/materials/frames/inner_shadow_medium",
		style_id = "location_vignette",
		pass_type = "texture",
		scenegraph_id = "mission_medium_location"
	},
	{
		scenegraph_id = "mission_medium_location",
		pass_type = "texture",
		style_id = "location_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_frame_selected(255, true),
			hover_color = Color.terminal_frame_hover(255, true),
			default_color = Color.terminal_frame(255, true)
		}
	},
	{
		scenegraph_id = "mission_medium_location",
		pass_type = "texture",
		style_id = "location_corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
			default_color = Color.terminal_corner(255, true)
		}
	},
	{
		value = "content/ui/materials/icons/generic/aquila",
		style_id = "location_decoration",
		pass_type = "texture",
		scenegraph_id = "mission_medium_location"
	},
	{
		style_id = "location_lock",
		scenegraph_id = "mission_medium_location",
		pass_type = "text",
		value = "",
		visibility_function = _is_locked
	},
	{
		scenegraph_id = "mission_medium_objective_1",
		style_id = "background",
		pass_type = "rect"
	},
	{
		scenegraph_id = "mission_medium_objective_1",
		pass_type = "texture",
		style_id = "objective_corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
			default_color = Color.terminal_corner(255, true)
		}
	},
	{
		value_id = "objective_icon",
		style_id = "objective_1_icon",
		pass_type = "texture",
		scenegraph_id = "mission_medium_objective_1",
		value = "content/ui/materials/icons/mission_types/mission_type_01"
	},
	{
		scenegraph_id = "mission_medium_objective_2",
		style_id = "background",
		pass_type = "rect",
		visibility_function = _has_objective_2
	},
	{
		scenegraph_id = "mission_medium_objective_2",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_corner_2px",
		style_id = "objective_corner",
		visibility_function = _has_objective_2,
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
			default_color = Color.terminal_corner(255, true)
		}
	},
	{
		value_id = "objective_2_icon",
		style_id = "objective_2_icon",
		pass_type = "texture",
		scenegraph_id = "mission_medium_objective_2",
		value = "content/ui/materials/icons/mission_types/mission_type_01",
		visibility_function = _has_objective_2
	},
	{
		scenegraph_id = "mission_medium_circumstance",
		style_id = "background",
		pass_type = "rect",
		visibility_function = _has_circumstance
	},
	{
		scenegraph_id = "mission_medium_circumstance",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_corner_2px",
		style_id = "circumstance_corner",
		visibility_function = _has_circumstance,
		change_function = MissionBoardViewStyles.is_hover_with_locked_change_function,
		style = {
			disabled_color = MissionBoardViewSettings.color_disabled,
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
			default_color = Color.terminal_corner(255, true)
		}
	},
	{
		value_id = "circumstance_icon",
		style_id = "circumstance_icon",
		pass_type = "texture",
		scenegraph_id = "mission_medium_circumstance",
		value = "content/ui/materials/icons/circumstances/assault_01",
		visibility_function = _has_circumstance
	},
	{
		style_id = "title_gradient",
		scenegraph_id = "mission_medium_title",
		pass_type = "texture",
		value = "content/ui/materials/gradients/gradient_horizontal",
		visibility_function = function (parent, content)
			return content.title and content.title ~= ""
		end
	},
	{
		value_id = "title",
		style_id = "title_text",
		pass_type = "text",
		scenegraph_id = "mission_medium_title",
		value = Localize("loc_mission_board_quickplay_header")
	},
	{
		value_id = "bonus",
		style_id = "bonus_text",
		pass_type = "text",
		scenegraph_id = "mission_medium_bonus",
		value = "",
		visibility_function = function (content)
			return content.bonus ~= ""
		end
	}
}, "mission_medium", nil, nil, MissionBoardViewStyles.mission_widget_style)

local function game_settings_anim_main(widgets_by_name, s)
	widgets_by_name.game_settings.alpha_multiplier = s
	widgets_by_name.game_settings.offset[1] = 100 * (1 - s)
end

local function game_settings_anim_others(widgets_by_name, s)
	local difficulty_stepper = widgets_by_name.difficulty_stepper
	difficulty_stepper.alpha_multiplier = s
	difficulty_stepper.offset[1] = -100 * (1 - s)
	local difficulty_stepper_window = widgets_by_name.difficulty_stepper_window
	difficulty_stepper_window.alpha_multiplier = s
	difficulty_stepper_window.offset[1] = -100 * (1 - s)
	local objective_1 = widgets_by_name.objective_1
	objective_1.alpha_multiplier = s
	objective_1.offset[1] = -100 * (1 - s)
	local objective_2 = widgets_by_name.objective_2
	objective_2.alpha_multiplier = s
	objective_2.offset[1] = -100 * (1 - s)
end

MissionBoardViewDefinitions.bonus_data_widget_definitons = UIWidget.create_definition({
	{
		value_id = "icon",
		style_id = "bonus_icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/flash",
		style = {
			offset = {
				0,
				70,
				0
			},
			size = {
				40,
				28
			}
		}
	},
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = {
			font_type = "proxima_nova_bold",
			font_size = 20,
			text_vertical_alignment = "top",
			text_horizontal_alignment = "left",
			offset = {
				50,
				70,
				0
			},
			text_color = MissionBoardViewSettings.color_text_title
		}
	}
}, "detail_location")
MissionBoardViewDefinitions.animations = {
	mission_enter = {
		{
			name = "setup",
			end_time = 0.2,
			start_time = 0,
			init = function (parent, ui_scenegraph, _scenegraph_definition, widget, mission_board_view)
				widget.visible = true
				local style = widget.style

				for _, pass_style in pairs(style) do
					pass_style.visible = false
				end

				style.location_rect.visible = true
				style.location_corner.visible = true
				local size = {
					20,
					20
				}
				style.location_rect.original_size = _scenegraph_definition.size
				style.location_rect.size = size
				style.location_frame.size = size
				style.location_corner.size = size

				mission_board_view:_play_sound(UISoundEvents.mission_board_show_icon)
			end
		},
		{
			name = "grow_height",
			end_time = 0.3,
			start_time = 0.3,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widget, progress, mission_board_view)
				widget.style.location_rect.size[2] = widget.style.location_rect.size[2] * progress
			end
		},
		{
			name = "grow_width",
			end_time = 0.4,
			start_time = 0.4,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widget, progress, mission_board_view)
				widget.style.location_rect.size[1] = widget.style.location_rect.size[1] * progress
			end,
			on_complete = function (parent, ui_scenegraph, _scenegraph_definition, widget, mission_board_view)
				widget.style.location_rect.visible = false
				widget.style.location_image.visible = true
			end
		},
		{
			name = "finish",
			end_time = 0.45,
			start_time = 0.4,
			on_complete = function (parent, ui_scenegraph, _scenegraph_definition, widget, mission_board_view)
				local style = widget.style

				for _, pass_style in pairs(style) do
					pass_style.visible = true
				end

				style.location_rect.visible = false
				style.location_rect.size = nil
				style.location_frame.size = nil
				style.location_corner.size = nil
			end
		}
	},
	mission_exit = {
		{
			name = "exit",
			end_time = 0.3,
			start_time = 0,
			init = function (parent, ui_scenegraph, _scenegraph_definition, widget, mission_board_view)
				local style = widget.style

				for _, pass_style in pairs(style) do
					pass_style.visible = false
				end

				style.location_rect.visible = true
				style.location_image.visible = true
				style.location_corner.visible = true
				style.location_rect.color = {
					255,
					255,
					255,
					255
				}

				mission_board_view:_play_sound(UISoundEvents.mission_board_hide_icon)
			end,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widget, progress, mission_board_view)
				local style = widget.style
				style.location_rect.color[1] = 255 * (1 - progress)
			end,
			on_complete = function (parent, ui_scenegraph, _scenegraph_definition, widget, mission_board_view)
				mission_board_view:_callback_mission_widget_exit_done(widget)
			end
		}
	},
	game_settings_enter = {
		{
			name = "overlay_top_opacity",
			end_time = 0.4,
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets_by_name, progress, mission_board_view)
				widgets_by_name.screen_decorations.style.overlay_top.color[1] = 100 * progress
			end
		},
		{
			name = "others_exit",
			end_time = 0.1,
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets_by_name, progress, mission_board_view)
				game_settings_anim_others(widgets_by_name, 1 - math.easeInCubic(progress))
			end,
			on_complete = function (parent, ui_scenegraph, _scenegraph_definition, widgets_by_name, mission_board_view)
				widgets_by_name.difficulty_stepper.content.disabled = false
			end
		},
		{
			name = "game_settings_enter",
			end_time = 0.4,
			start_time = 0.1,
			init = function (parent, ui_scenegraph, _scenegraph_definition, widgets_by_name, mission_board_view)
				widgets_by_name.game_settings.visible = true

				game_settings_anim_main(widgets_by_name, 0)
			end,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets_by_name, progress, mission_board_view)
				game_settings_anim_main(widgets_by_name, math.easeOutCubic(progress))
			end
		}
	},
	game_settings_exit = {
		{
			name = "overlay_top_opacity",
			end_time = 0.4,
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets_by_name, progress, mission_board_view)
				widgets_by_name.screen_decorations.style.overlay_top.color[1] = 100 * (1 - progress)
			end
		},
		{
			name = "game_settings_exit",
			end_time = 0.1,
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets_by_name, progress, mission_board_view)
				game_settings_anim_main(widgets_by_name, 1 - math.easeInCubic(progress))
			end,
			on_complete = function (parent, ui_scenegraph, _scenegraph_definition, widgets_by_name, mission_board_view)
				widgets_by_name.game_settings.visible = false
			end
		},
		{
			name = "others_enter",
			end_time = 0.4,
			start_time = 0.1,
			init = function (parent, ui_scenegraph, _scenegraph_definition, widgets_by_name, mission_board_view)
				widgets_by_name.difficulty_stepper.content.disabled = true

				game_settings_anim_others(widgets_by_name, 0)
			end,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets_by_name, progress, mission_board_view)
				game_settings_anim_others(widgets_by_name, math.easeOutCubic(progress))
			end
		}
	},
	story_mission_button_anim_1 = {
		{
			name = "start",
			end_time = 0.3,
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				local story_mission_view_button_frame = widgets.story_mission_view_button_frame
				story_mission_view_button_frame.style.char.material_values.distortion = 0.2 + 0.5 * progress
			end
		},
		{
			name = "end",
			end_time = 1,
			start_time = 0.7,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				local story_mission_view_button_frame = widgets.story_mission_view_button_frame
				story_mission_view_button_frame.style.char.material_values.distortion = 0.2 + 0.5 * (1 - progress)
			end
		}
	},
	story_mission_button_anim_2 = {
		{
			name = "start",
			end_time = 0.3,
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				local story_mission_view_button_frame = widgets.story_mission_view_button_frame
				story_mission_view_button_frame.style.char.material_values.distortion = 0.2 + 0.5 * math.ease_out_elastic(progress)
			end
		},
		{
			name = "end",
			end_time = 0.7,
			start_time = 0.5,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				local story_mission_view_button_frame = widgets.story_mission_view_button_frame
				story_mission_view_button_frame.style.char.material_values.distortion = 0.2 + 0.5 * (1 - progress)
			end
		}
	},
	story_mission_button_anim_3 = {
		{
			name = "start",
			end_time = 0.2,
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				local story_mission_view_button_frame = widgets.story_mission_view_button_frame
				story_mission_view_button_frame.style.char.material_values.distortion = 0.2 + 0.2 * math.bounce(progress)
			end
		},
		{
			name = "end",
			end_time = 0.5,
			start_time = 0.3,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				local story_mission_view_button_frame = widgets.story_mission_view_button_frame
				story_mission_view_button_frame.style.char.material_values.distortion = 0.2 + 0.2 * (1 - progress)
			end
		}
	},
	story_mission_button_anim_4 = {
		{
			name = "start",
			end_time = 0.2,
			start_time = 0,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				local story_mission_view_button_frame = widgets.story_mission_view_button_frame
				story_mission_view_button_frame.style.char.material_values.distortion = 0.2 + 0.7 * math.bounce(progress)
			end
		},
		{
			name = "end",
			end_time = 0.5,
			start_time = 0.3,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				local story_mission_view_button_frame = widgets.story_mission_view_button_frame
				story_mission_view_button_frame.style.char.material_values.distortion = 0.2 + 0.7 * math.ease_pulse(1 - progress)
			end
		}
	}
}
MissionBoardViewDefinitions.legend_inputs = {
	{
		on_pressed_callback = "_on_back_pressed",
		input_action = "back",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		input_action = "hotkey_menu_special_1",
		display_name = "loc_mission_board_view_options",
		alignment = "right_alignment",
		on_pressed_callback = "_callback_open_options",
		visibility_function = function (parent, id)
			return not parent._mission_board_options and not parent._is_in_matchmaking
		end
	}
}

MissionBoardViewDefinitions.widget_definitions_functions.screen_decorations_pass_function = function (mission_type)
	return UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "overlay"
		},
		{
			style_id = "overlay_top",
			pass_type = "rect",
			visibility_function = function ()
				return InputDevice.gamepad_active
			end
		},
		{
			value = "content/ui/materials/frames/screen/mission_board_01_upper",
			style_id = "corner_left",
			pass_type = "texture",
			scenegraph_id = "corner_top_left"
		},
		{
			value = "content/ui/materials/frames/screen/mission_board_01_upper",
			style_id = "corner_right",
			pass_type = "texture_uv",
			scenegraph_id = "corner_top_right"
		},
		{
			value = "content/ui/materials/frames/screen/mission_board_01_lower",
			style_id = "corner_left",
			pass_type = "texture",
			scenegraph_id = "corner_bottom_left"
		},
		{
			value = "content/ui/materials/frames/screen/mission_board_01_lower",
			style_id = "corner_right",
			pass_type = "texture_uv",
			scenegraph_id = "corner_bottom_right"
		}
	}, "screen", nil, nil, MissionBoardViewStyles.screen_decorations_widget_style_function(mission_type))
end

MissionBoardViewDefinitions.widget_definitions_functions.planet_pass_function = function (mission_type)
	return UIWidget.create_definition({
		{
			value_id = "title",
			style_id = "title",
			pass_type = "text",
			scenegraph_id = "planet",
			value = Localize("loc_mission_board_view_header_tertium_hive")
		}
	}, "planet", nil, nil, MissionBoardViewStyles.planet_widget_style_function(mission_type))
end

MissionBoardViewDefinitions.widget_definitions_functions.happening_pass_function = function (mission_type)
	return UIWidget.create_definition({
		{
			scenegraph_id = "happening",
			style_id = "background",
			pass_type = "rect"
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "frame",
			pass_type = "texture",
			scenegraph_id = "happening"
		},
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			style_id = "gradient",
			pass_type = "texture",
			scenegraph_id = "happening"
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			scenegraph_id = "happening",
			value = "content/ui/materials/icons/generic/transmission"
		},
		{
			value_id = "title",
			style_id = "title",
			pass_type = "text",
			scenegraph_id = "happening",
			value = Localize("loc_mission_info_happening_label")
		},
		{
			value_id = "subtitle",
			style_id = "subtitle",
			pass_type = "text",
			scenegraph_id = "happening",
			value = "subtitle"
		}
	}, "happening", nil, nil, MissionBoardViewStyles.happening_widget_style_function(mission_type))
end

MissionBoardViewDefinitions.widget_definitions_functions.detail_pass_function = function (mission_type)
	return UIWidget.create_definition({
		{
			pass_type = "logic",
			value = MissionBoardViewStyles.timer_logic
		},
		{
			scenegraph_id = "detail_timer",
			style_id = "background",
			pass_type = "rect",
			visibility_function = _has_timer
		},
		{
			style_id = "timer_frame",
			scenegraph_id = "detail_timer",
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_tile_2px",
			visibility_function = _has_timer
		},
		{
			style_id = "timer_bar",
			scenegraph_id = "detail_timer",
			pass_type = "texture",
			value = "content/ui/materials/mission_board/timer",
			visibility_function = _has_timer
		},
		{
			style_id = "timer_hourglass",
			scenegraph_id = "detail_timer",
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/hourglass",
			visibility_function = _has_timer
		},
		{
			value_id = "timer_text",
			style_id = "timer_text",
			pass_type = "text",
			scenegraph_id = "detail_timer",
			value = "00:00",
			visibility_function = _has_timer
		},
		{
			scenegraph_id = "detail_header",
			style_id = "background",
			pass_type = "rect"
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "header_frame",
			pass_type = "texture",
			scenegraph_id = "detail_header"
		},
		{
			value_id = "header_title",
			style_id = "header_title",
			pass_type = "text",
			scenegraph_id = "detail_header",
			value = "header_title"
		},
		{
			value_id = "header_subtitle",
			style_id = "header_subtitle",
			pass_type = "text",
			scenegraph_id = "detail_header",
			value = "header_subtitle"
		},
		{
			style_id = "difficulty_icon",
			scenegraph_id = "detail_difficulty",
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/danger",
			visibility_function = _has_difficulty
		},
		{
			style_id = "difficulty_bar_1",
			scenegraph_id = "detail_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty,
			change_function = _change_function_difficulty(1)
		},
		{
			style_id = "difficulty_bar_2",
			scenegraph_id = "detail_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty,
			change_function = _change_function_difficulty(2)
		},
		{
			style_id = "difficulty_bar_3",
			scenegraph_id = "detail_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty,
			change_function = _change_function_difficulty(3)
		},
		{
			style_id = "difficulty_bar_4",
			scenegraph_id = "detail_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty,
			change_function = _change_function_difficulty(4)
		},
		{
			style_id = "difficulty_bar_5",
			scenegraph_id = "detail_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty,
			change_function = _change_function_difficulty(5)
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "location_frame",
			pass_type = "texture",
			scenegraph_id = "detail_location"
		},
		{
			value_id = "location_image",
			style_id = "location_image",
			pass_type = "texture",
			scenegraph_id = "detail_location",
			value = "content/ui/materials/mission_board/texture_with_grid_effect"
		},
		{
			value = "content/ui/materials/frames/inner_shadow_medium",
			style_id = "location_vignette",
			pass_type = "texture",
			scenegraph_id = "detail_location"
		},
		{
			style_id = "location_lock",
			scenegraph_id = "detail_location",
			pass_type = "text",
			value = "",
			visibility_function = _is_locked
		},
		{
			value_id = "bonus_title",
			style_id = "bonus_title",
			pass_type = "text",
			scenegraph_id = "detail_location",
			value = Localize("loc_mission_board_bonus_reward_title")
		},
		{
			value_id = "bonus_text",
			style_id = "bonus_text",
			pass_type = "text",
			scenegraph_id = "detail_location",
			value = ""
		},
		{
			scenegraph_id = "detail_circumstance",
			style_id = "background",
			pass_type = "rect",
			visibility_function = _has_circumstance
		},
		{
			style_id = "circumstance_frame",
			scenegraph_id = "detail_circumstance",
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_tile_2px",
			visibility_function = _has_circumstance
		},
		{
			scenegraph_id = "detail_circumstance",
			style_id = "circumstance_detail",
			pass_type = "rect",
			visibility_function = _has_circumstance
		},
		{
			value_id = "circumstance_icon",
			style_id = "circumstance_icon",
			pass_type = "texture",
			scenegraph_id = "detail_circumstance",
			value = "content/ui/materials/icons/circumstances/assault_01",
			visibility_function = _has_circumstance
		},
		{
			value_id = "circumstance_label",
			style_id = "circumstance_label",
			pass_type = "text",
			scenegraph_id = "detail_circumstance",
			value = Localize("loc_mission_info_circumstance_label"),
			visibility_function = _has_circumstance
		},
		{
			value_id = "circumstance_name",
			scenegraph_id = "detail_circumstance",
			pass_type = "text",
			style_id = "circumstance_name",
			visibility_function = _has_circumstance
		},
		{
			value_id = "circumstance_description",
			style_id = "circumstance_description",
			pass_type = "text",
			scenegraph_id = "detail_circumstance",
			value = "circumstance_description",
			visibility_function = _has_circumstance
		},
		{
			scenegraph_id = "detail_circumstance",
			style_id = "maelstrom_background",
			pass_type = "rect",
			visibility_function = _is_flash
		},
		{
			style_id = "maelstrom_text",
			scenegraph_id = "detail_circumstance",
			pass_type = "text",
			value = Utf8.upper(Localize("loc_mission_board_maelstrom_header")),
			visibility_function = _is_flash
		}
	}, "detail", nil, nil, MissionBoardViewStyles.detail_widget_style_function(mission_type))
end

MissionBoardViewDefinitions.widget_definitions_functions.objective_1_pass_function = function (mission_type)
	local objective_1 = UIWidget.create_definition(objective_pass_template, "objective", nil, nil, MissionBoardViewStyles.objective_widget_style_function(mission_type))
	objective_1.content.header_title = Localize("loc_misison_board_main_objective_title")
	objective_1.style.header_gradient.color = objective_1.style.header_gradient.color_main

	return objective_1
end

MissionBoardViewDefinitions.widget_definitions_functions.objective_2_pass_function = function (mission_type)
	local objective_2 = UIWidget.create_definition(objective_pass_template, "objective", nil, nil, MissionBoardViewStyles.objective_widget_style_function(mission_type))
	objective_2.content.header_title = Localize("loc_mission_info_side_mission_label")
	objective_2.style.header_gradient.color = objective_2.style.header_gradient.color_side
	objective_2.offset = {
		0,
		190,
		0
	}

	return objective_2
end

MissionBoardViewDefinitions.widget_definitions_functions.difficulty_stepper_window_pass_function = function (mission_type)
	return UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "frame",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "header_frame",
			pass_type = "texture",
			scenegraph_id = "difficulty_stepper_header"
		},
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			style_id = "header_gradient",
			pass_type = "texture",
			scenegraph_id = "difficulty_stepper_header"
		},
		{
			style_id = "header_title",
			pass_type = "text",
			scenegraph_id = "difficulty_stepper_header",
			value = Localize("loc_mission_board_select_difficulty")
		}
	}, "difficulty_stepper_window", nil, nil, MissionBoardViewStyles.difficulty_stepper_window_widget_style_function(mission_type))
end

MissionBoardViewDefinitions.widget_definitions_functions.difficulty_stepper_pass_function = function (mission_type)
	return UIWidget.create_definition(StepperPassTemplates.difficulty_stepper, "difficulty_stepper", nil, nil, MissionBoardViewStyles.difficulty_stepper_style_function(mission_type))
end

MissionBoardViewDefinitions.widget_definitions_functions.game_settings_pass_function = function (mission_type)
	return UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "frame",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "header_frame",
			pass_type = "texture",
			scenegraph_id = "game_settings_header"
		},
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			style_id = "header_gradient",
			pass_type = "texture",
			scenegraph_id = "game_settings_header"
		},
		{
			style_id = "header_title",
			pass_type = "text",
			scenegraph_id = "game_settings_header",
			value = Localize("loc_mission_board_open_game_settings")
		}
	}, "game_settings", nil, nil, MissionBoardViewStyles.game_settings_widget_style_function(mission_type))
end

MissionBoardViewDefinitions.widget_definitions_functions.info_box_pass_function = function (mission_type)
	return UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "frame",
			pass_type = "texture"
		},
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style_id = "text"
		}
	}, "info_box", nil, nil, MissionBoardViewStyles.info_box_widget_style_function(mission_type))
end

MissionBoardViewDefinitions.widget_definitions_functions.play_team_button_legend_pass_function = function (mission_type)
	return UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = {
				horizontal_alignment = "center"
			}
		}
	}, "play_team_button", nil, nil, MissionBoardViewStyles.play_team_button_legend(mission_type))
end

MissionBoardViewDefinitions.widget_definitions_functions.mission_small_widget_pass_function = function (mission_type)
	return UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = mission_widget_hotspot_content
		},
		{
			value_id = "fluff_frame",
			style_id = "fluff_frame",
			pass_type = "texture",
			value = "content/ui/materials/fluff/hologram/frames/fluff_frame_01",
			visibility_function = _is_not_locked
		},
		{
			value = "content/ui/materials/frames/frame_glow_01",
			style_id = "glow",
			pass_type = "texture",
			change_function = MissionBoardViewStyles.mission_glow_change_function
		},
		{
			pass_type = "logic",
			value = MissionBoardViewStyles.timer_logic
		},
		{
			scenegraph_id = "mission_small_timer",
			style_id = "background",
			pass_type = "rect"
		},
		{
			value = "content/ui/materials/mission_board/timer",
			style_id = "timer_bar",
			pass_type = "texture",
			scenegraph_id = "mission_small_timer"
		},
		{
			scenegraph_id = "mission_small_difficulty",
			style_id = "background",
			pass_type = "rect"
		},
		{
			scenegraph_id = "mission_small_difficulty",
			pass_type = "texture",
			style_id = "difficulty_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			scenegraph_id = "mission_small_difficulty",
			pass_type = "texture",
			style_id = "difficulty_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			scenegraph_id = "mission_small_difficulty",
			pass_type = "texture",
			style_id = "difficulty_icon",
			value = "content/ui/materials/icons/generic/danger",
			change_function = MissionBoardViewStyles.is_locked_change_function
		},
		{
			style_id = "difficulty_bar_1",
			scenegraph_id = "mission_small_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty_1,
			change_function = MissionBoardViewStyles.difficulty_bar_change_function
		},
		{
			style_id = "difficulty_bar_2",
			scenegraph_id = "mission_small_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty_2,
			change_function = MissionBoardViewStyles.difficulty_bar_change_function
		},
		{
			style_id = "difficulty_bar_3",
			scenegraph_id = "mission_small_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty_3,
			change_function = MissionBoardViewStyles.difficulty_bar_change_function
		},
		{
			style_id = "difficulty_bar_4",
			scenegraph_id = "mission_small_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty_4,
			change_function = MissionBoardViewStyles.difficulty_bar_change_function
		},
		{
			style_id = "difficulty_bar_5",
			scenegraph_id = "mission_small_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty_5,
			change_function = MissionBoardViewStyles.difficulty_bar_change_function
		},
		{
			value_id = "location_image",
			style_id = "location_image",
			pass_type = "texture",
			scenegraph_id = "mission_small_location",
			value = "content/ui/materials/mission_board/texture_with_grid_effect"
		},
		{
			scenegraph_id = "mission_small_location",
			style_id = "location_rect",
			pass_type = "rect"
		},
		{
			value = "content/ui/materials/frames/inner_shadow_medium",
			style_id = "location_vignette",
			pass_type = "texture",
			scenegraph_id = "mission_small_location"
		},
		{
			scenegraph_id = "mission_small_location",
			pass_type = "texture",
			style_id = "location_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			scenegraph_id = "mission_small_location",
			pass_type = "texture",
			style_id = "location_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			style_id = "location_lock",
			scenegraph_id = "mission_small_location",
			pass_type = "text",
			value = "",
			visibility_function = _is_locked
		},
		{
			scenegraph_id = "mission_small_objective_1",
			style_id = "background",
			pass_type = "rect"
		},
		{
			scenegraph_id = "mission_small_objective_1",
			pass_type = "texture",
			style_id = "objective_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			style_id = "objective_1_icon",
			pass_type = "texture",
			scenegraph_id = "mission_small_objective_1",
			value = "content/ui/materials/icons/mission_types/mission_type_01",
			value_id = "objective_1_icon",
			change_function = MissionBoardViewStyles.is_locked_change_function
		},
		{
			scenegraph_id = "mission_small_objective_2",
			style_id = "background",
			pass_type = "rect",
			visibility_function = _has_objective_2
		},
		{
			scenegraph_id = "mission_small_objective_2",
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_corner_2px",
			style_id = "objective_corner",
			visibility_function = _has_objective_2,
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			style_id = "objective_2_icon",
			pass_type = "texture",
			scenegraph_id = "mission_small_objective_2",
			value = "content/ui/materials/icons/mission_types/mission_type_01",
			value_id = "objective_2_icon",
			visibility_function = _has_objective_2,
			change_function = MissionBoardViewStyles.is_locked_change_function
		},
		{
			scenegraph_id = "mission_small_circumstance",
			pass_type = "rect",
			style = {
				color = {
					200,
					0,
					0,
					0
				}
			},
			visibility_function = _has_circumstance
		},
		{
			scenegraph_id = "mission_small_circumstance",
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_corner_2px",
			style_id = "circumstance_corner",
			visibility_function = _has_circumstance,
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			value_id = "circumstance_icon",
			style_id = "circumstance_icon",
			pass_type = "texture",
			scenegraph_id = "mission_small_circumstance",
			value = "content/ui/materials/icons/circumstances/assault_01",
			visibility_function = _has_circumstance
		},
		{
			style_id = "mission_line",
			pass_type = "texture",
			value_id = "mission_line",
			value = "content/ui/materials/mission_board/mission_line",
			change_function = MissionBoardViewStyles.update_mission_line
		},
		{
			style_id = "mission_completed_icon",
			pass_type = "texture",
			value_id = "mission_completed_icon",
			value = "content/ui/materials/icons/mission_difficulty_complete/difficulty_completed_1",
			change_function = MissionBoardViewStyles.update_mission_line,
			visibility_function = _has_completed_on_difficulty
		}
	}, "mission_small", nil, nil, MissionBoardViewStyles.mission_widget_style_function(mission_type))
end

MissionBoardViewDefinitions.widget_definitions_functions.mission_medium_widget_pass_function = function (mission_type)
	return UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = mission_widget_hotspot_content
		},
		{
			value = "content/ui/materials/frames/frame_glow_01",
			style_id = "glow",
			pass_type = "texture",
			change_function = MissionBoardViewStyles.mission_glow_change_function
		},
		{
			pass_type = "logic",
			value = MissionBoardViewStyles.timer_logic
		},
		{
			scenegraph_id = "mission_medium_timer",
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "timer_frame",
			visibility_function = _has_timer,
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			scenegraph_id = "mission_medium_timer",
			pass_type = "texture",
			value = "content/ui/materials/mission_board/timer",
			style_id = "timer_bar",
			visibility_function = _has_timer,
			change_function = MissionBoardViewStyles.timer_change_function
		},
		{
			style_id = "timer_hourglass",
			scenegraph_id = "mission_medium_timer",
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/hourglass",
			visibility_function = _has_timer
		},
		{
			value_id = "timer_text",
			style_id = "timer_text",
			pass_type = "text",
			scenegraph_id = "mission_medium_timer",
			value = "00:00",
			visibility_function = _has_timer
		},
		{
			scenegraph_id = "mission_medium_difficulty",
			style_id = "background",
			pass_type = "rect",
			visibility_function = _has_difficulty
		},
		{
			scenegraph_id = "mission_medium_difficulty",
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "difficulty_frame",
			visibility_function = _has_difficulty,
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			scenegraph_id = "mission_medium_difficulty",
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/danger",
			style_id = "difficulty_icon",
			visibility_function = _has_difficulty,
			change_function = MissionBoardViewStyles.is_locked_change_function
		},
		{
			style_id = "difficulty_bar_1",
			scenegraph_id = "mission_medium_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty_1,
			change_function = MissionBoardViewStyles.difficulty_bar_change_function
		},
		{
			style_id = "difficulty_bar_2",
			scenegraph_id = "mission_medium_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty_2,
			change_function = MissionBoardViewStyles.difficulty_bar_change_function
		},
		{
			style_id = "difficulty_bar_3",
			scenegraph_id = "mission_medium_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty_3,
			change_function = MissionBoardViewStyles.difficulty_bar_change_function
		},
		{
			style_id = "difficulty_bar_4",
			scenegraph_id = "mission_medium_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty_4,
			change_function = MissionBoardViewStyles.difficulty_bar_change_function
		},
		{
			style_id = "difficulty_bar_5",
			scenegraph_id = "mission_medium_difficulty",
			pass_type = "rect",
			visibility_function = _difficulty_5,
			change_function = MissionBoardViewStyles.difficulty_bar_change_function
		},
		{
			value_id = "location_image",
			style_id = "location_image",
			pass_type = "texture",
			scenegraph_id = "mission_medium_location",
			value = "content/ui/materials/mission_board/texture_with_grid_effect"
		},
		{
			scenegraph_id = "mission_medium_location",
			style_id = "location_rect",
			pass_type = "rect"
		},
		{
			value = "content/ui/materials/frames/inner_shadow_medium",
			style_id = "location_vignette",
			pass_type = "texture",
			scenegraph_id = "mission_medium_location"
		},
		{
			scenegraph_id = "mission_medium_location",
			pass_type = "texture",
			style_id = "location_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			scenegraph_id = "mission_medium_location",
			pass_type = "texture",
			style_id = "location_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			value = "content/ui/materials/icons/generic/aquila",
			style_id = "location_decoration",
			pass_type = "texture",
			scenegraph_id = "mission_medium_location"
		},
		{
			style_id = "location_lock",
			scenegraph_id = "mission_medium_location",
			pass_type = "text",
			value = "",
			visibility_function = _is_locked
		},
		{
			scenegraph_id = "mission_medium_objective_1",
			style_id = "background",
			pass_type = "rect"
		},
		{
			scenegraph_id = "mission_medium_objective_1",
			pass_type = "texture",
			style_id = "objective_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			value_id = "objective_1_icon",
			style_id = "objective_1_icon",
			pass_type = "texture",
			scenegraph_id = "mission_medium_objective_1",
			value = "content/ui/materials/icons/mission_types/mission_type_01"
		},
		{
			scenegraph_id = "mission_medium_objective_2",
			style_id = "background",
			pass_type = "rect",
			visibility_function = _has_objective_2
		},
		{
			scenegraph_id = "mission_medium_objective_2",
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_corner_2px",
			style_id = "objective_corner",
			visibility_function = _has_objective_2,
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			value_id = "objective_2_icon",
			style_id = "objective_2_icon",
			pass_type = "texture",
			scenegraph_id = "mission_medium_objective_2",
			value = "content/ui/materials/icons/mission_types/mission_type_01",
			visibility_function = _has_objective_2
		},
		{
			scenegraph_id = "mission_medium_circumstance",
			style_id = "background",
			pass_type = "rect",
			visibility_function = _has_circumstance
		},
		{
			scenegraph_id = "mission_medium_circumstance",
			pass_type = "texture",
			value = "content/ui/materials/frames/frame_corner_2px",
			style_id = "circumstance_corner",
			visibility_function = _has_circumstance,
			change_function = MissionBoardViewStyles.is_hover_with_locked_change_function
		},
		{
			value_id = "circumstance_icon",
			style_id = "circumstance_icon",
			pass_type = "texture",
			scenegraph_id = "mission_medium_circumstance",
			value = "content/ui/materials/icons/circumstances/assault_01",
			visibility_function = _has_circumstance
		},
		{
			scenegraph_id = "mission_medium_title",
			style_id = "title_background",
			pass_type = "rect",
			visibility_function = function (content)
				return content.title and content.title ~= ""
			end
		},
		{
			value_id = "title",
			style_id = "title_text",
			pass_type = "text",
			scenegraph_id = "mission_medium_title",
			value = Localize("loc_mission_board_quickplay_header")
		},
		{
			value_id = "bonus",
			style_id = "bonus_text",
			pass_type = "text",
			scenegraph_id = "mission_medium_bonus",
			value = "",
			visibility_function = function (content)
				return content.bonus ~= ""
			end
		}
	}, "mission_medium", nil, nil, MissionBoardViewStyles.mission_widget_style_function(mission_type))
end

MissionBoardViewDefinitions.dynamic_widget_definitions = {
	screen_decorations = MissionBoardViewDefinitions.widget_definitions_functions.screen_decorations_pass_function,
	planet = MissionBoardViewDefinitions.widget_definitions_functions.planet_pass_function,
	happening = MissionBoardViewDefinitions.widget_definitions_functions.happening_pass_function,
	detail = MissionBoardViewDefinitions.widget_definitions_functions.detail_pass_function,
	difficulty_stepper_window = MissionBoardViewDefinitions.widget_definitions_functions.difficulty_stepper_window_pass_function,
	game_settings = MissionBoardViewDefinitions.widget_definitions_functions.game_settings_pass_function,
	info_box = MissionBoardViewDefinitions.widget_definitions_functions.info_box_pass_function,
	play_team_button_legend = MissionBoardViewDefinitions.widget_definitions_functions.play_team_pass_function,
	objective_1 = MissionBoardViewDefinitions.widget_definitions_functions.objective_1_pass_function,
	objective_2 = MissionBoardViewDefinitions.widget_definitions_functions.objective_2_pass_function,
	difficulty_stepper = MissionBoardViewDefinitions.widget_definitions_functions.difficulty_stepper_pass_function
}

return settings("MissionBoardViewDefinitions", MissionBoardViewDefinitions)
