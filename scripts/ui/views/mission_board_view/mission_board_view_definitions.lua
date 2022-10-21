local MissionBoardViewStyles = require("scripts/ui/views/mission_board_view/mission_board_view_styles")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
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
			0
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
			0
		}
	},
	planet = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			650,
			80
		},
		position = {
			50,
			50,
			10
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
			50,
			90,
			10
		}
	},
	detail = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			563,
			900
		},
		position = {
			-50,
			100,
			0
		}
	},
	detail_timer = {
		vertical_alignment = "top",
		parent = "detail",
		horizontal_alignment = "right",
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
	detail_header = {
		vertical_alignment = "bottom",
		parent = "detail_timer",
		horizontal_alignment = "left",
		size = {
			563,
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
			-5,
			-2,
			10
		}
	},
	detail_location = {
		vertical_alignment = "bottom",
		parent = "detail_header",
		horizontal_alignment = "left",
		size = {
			563,
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
			563,
			100
		},
		position = {
			0,
			198,
			10
		}
	},
	objective = {
		vertical_alignment = "bottom",
		parent = "detail_location",
		horizontal_alignment = "center",
		size = {
			480,
			155
		},
		position = {
			0,
			190,
			0
		}
	},
	objective_header = {
		vertical_alignment = "top",
		parent = "objective",
		horizontal_alignment = "left",
		size = {
			480,
			50
		},
		position = {
			0,
			0,
			0
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
	play_button = {
		vertical_alignment = "bottom",
		parent = "detail_location",
		horizontal_alignment = "center",
		size = {
			347,
			76
		},
		position = {
			0,
			550,
			10
		}
	},
	mission_S = {
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
	mission_S_difficulty = {
		vertical_alignment = "top",
		parent = "mission_S",
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
	mission_S_timer = {
		vertical_alignment = "top",
		parent = "mission_S",
		horizontal_alignment = "left",
		size = {
			80,
			5
		},
		position = {
			0,
			28,
			1
		}
	},
	mission_S_location = {
		vertical_alignment = "top",
		parent = "mission_S",
		horizontal_alignment = "left",
		size = {
			80,
			92
		},
		position = {
			0,
			33,
			2
		}
	},
	mission_S_objective_1 = {
		vertical_alignment = "top",
		parent = "mission_S_location",
		horizontal_alignment = "left",
		size = {
			32,
			32
		},
		position = {
			-22,
			13,
			10
		}
	},
	mission_S_objective_2 = {
		vertical_alignment = "bottom",
		parent = "mission_S_objective_1",
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
	mission_S_circumstance = {
		vertical_alignment = "bottom",
		parent = "mission_S",
		horizontal_alignment = "right",
		size = {
			32,
			32
		},
		position = {
			22,
			-15,
			10
		}
	},
	mission_M = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			281,
			152
		},
		position = {
			300,
			0,
			1
		}
	},
	mission_M_difficulty = {
		vertical_alignment = "top",
		parent = "mission_M",
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
	mission_M_timer = {
		vertical_alignment = "top",
		parent = "mission_M",
		horizontal_alignment = "right",
		size = {
			210,
			6
		},
		position = {
			0,
			-24,
			1
		}
	},
	mission_M_location = {
		vertical_alignment = "top",
		parent = "mission_M",
		horizontal_alignment = "left",
		size = {
			281,
			152
		},
		position = {
			0,
			0,
			2
		}
	},
	mission_M_objective = {
		vertical_alignment = "bottom",
		parent = "mission_M",
		horizontal_alignment = "left",
		size = {
			32,
			32
		},
		position = {
			-15,
			-10,
			10
		}
	},
	mission_M_circumstance = {
		vertical_alignment = "bottom",
		parent = "mission_M",
		horizontal_alignment = "right",
		size = {
			32,
			32
		},
		position = {
			15,
			-42,
			10
		}
	}
}
local screen_decorations_definition = UIWidget.create_definition({
	{
		pass_type = "rect",
		style_id = "overlay"
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
local planet_widget_definition = UIWidget.create_definition({
	{
		value_id = "title",
		style_id = "title",
		pass_type = "text",
		scenegraph_id = "planet",
		value = Localize("loc_mission_board_view_header_tertium_hive")
	}
}, "planet", nil, nil, MissionBoardViewStyles.planet_widget_style)
local happening_widget_definition = UIWidget.create_definition({
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

local function _difficulty_1(content)
	local danger = content.danger

	return danger and danger > 1
end

local function _difficulty_2(content)
	local danger = content.danger

	return danger and danger > 2
end

local function _difficulty_3(content)
	local danger = content.danger

	return danger and danger > 3
end

local function _difficulty_4(content)
	local danger = content.danger

	return danger and danger > 4
end

local function _difficulty_5(content)
	local danger = content.danger

	return danger and danger > 5
end

local function _has_objective_2(content)
	return content.objective_2_icon
end

local detail_widget_definition = UIWidget.create_definition({
	{
		scenegraph_id = "detail_timer",
		style_id = "background",
		pass_type = "rect",
		visibility_function = _has_timer
	},
	{
		pass_type = "logic",
		value = MissionBoardViewStyles.timer_logic
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
		scenegraph_id = "detail_difficulty",
		style_id = "difficulty_bar_1",
		pass_type = "rect",
		visibility_function = _difficulty_1
	},
	{
		scenegraph_id = "detail_difficulty",
		style_id = "difficulty_bar_2",
		pass_type = "rect",
		visibility_function = _difficulty_2
	},
	{
		scenegraph_id = "detail_difficulty",
		style_id = "difficulty_bar_3",
		pass_type = "rect",
		visibility_function = _difficulty_3
	},
	{
		scenegraph_id = "detail_difficulty",
		style_id = "difficulty_bar_4",
		pass_type = "rect",
		visibility_function = _difficulty_4
	},
	{
		scenegraph_id = "detail_difficulty",
		style_id = "difficulty_bar_5",
		pass_type = "rect",
		visibility_function = _difficulty_5
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
		scenegraph_id = "objective_header",
		pass_type = "texture",
		style_id = "header_gradient",
		value = "content/ui/materials/gradients/gradient_horizontal",
		change_function = MissionBoardViewStyles.objective_gradient_change_function
	},
	{
		value_id = "header_icon",
		style_id = "header_icon",
		pass_type = "texture",
		scenegraph_id = "objective_header",
		value = "content/ui/materials/icons/mission_types/mission_type_01"
	},
	{
		value_id = "header_title",
		style_id = "header_title",
		pass_type = "text",
		scenegraph_id = "objective_header",
		value = Localize("loc_misison_board_main_objective_title")
	},
	{
		value_id = "header_subtitle",
		style_id = "header_subtitle",
		pass_type = "text",
		scenegraph_id = "objective_header",
		value = "header_subtitle"
	},
	{
		scenegraph_id = "objective",
		style_id = "background",
		pass_type = "rect"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "body_frame",
		pass_type = "texture",
		scenegraph_id = "objective"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "body_background",
		pass_type = "texture",
		scenegraph_id = "objective"
	},
	{
		value = "body_text",
		value_id = "body_text",
		pass_type = "text",
		style_id = "body_text"
	},
	{
		value_id = "speaker_text",
		style_id = "speaker_text",
		pass_type = "text",
		scenegraph_id = "objective",
		value = "speaker_text",
		visibility_function = _has_speaker
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
		pass_type = "text",
		value = "",
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
		pass_type = "text",
		value = "",
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
local objective_1_widget_definition = UIWidget.create_definition(objective_pass_template, "objective", nil, nil, MissionBoardViewStyles.objective_widget_style)
local objective_2_widget_definition = UIWidget.create_definition(objective_pass_template, "objective", nil, nil, MissionBoardViewStyles.objective_widget_style)
objective_2_widget_definition.content.is_side = true
objective_2_widget_definition.content.header_title = Localize("loc_mission_info_side_mission_label")
objective_2_widget_definition.offset = {
	0,
	200,
	0
}
local play_button_widget_definition = UIWidget.create_definition({
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_released_sound = UISoundEvents.mission_board_start_mission
		}
	},
	{
		pass_type = "logic",
		value = MissionBoardViewStyles.play_button_widget_logic
	},
	{
		pass_type = "rect",
		style_id = "background"
	},
	{
		value = "content/ui/materials/buttons/background_selected",
		style_id = "background_selected",
		pass_type = "texture"
	},
	{
		value = "content/ui/materials/gradients/gradient_vertical",
		style_id = "gradient",
		pass_type = "texture_uv"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "frame",
		pass_type = "texture"
	},
	{
		value = "content/ui/materials/frames/frame_corner_2px",
		style_id = "corner",
		pass_type = "texture"
	},
	{
		value_id = "text",
		pass_type = "text",
		style_id = "text",
		value = Utf8.upper(Localize("loc_mission_board_view_accept_mission"))
	}
}, "play_button", nil, nil, MissionBoardViewStyles.play_button_widget_style)
local mission_widget_hotspot_content = {
	on_hover_sound = UISoundEvents.mission_board_node_hover,
	on_pressed_sound = UISoundEvents.mission_board_node_pressed
}
local mission_S_widget_definition = UIWidget.create_definition({
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
		visibility_function = function (content)
			return not content.is_locked
		end
	},
	{
		value = "content/ui/materials/frames/frame_glow_01",
		style_id = "glow",
		pass_type = "texture",
		change_function = MissionBoardViewStyles.mission_glow_change_function
	},
	{
		scenegraph_id = "mission_S_timer",
		style_id = "timer_mini",
		pass_type = "rect"
	},
	{
		scenegraph_id = "mission_S_difficulty",
		style_id = "background",
		pass_type = "rect"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "difficulty_frame",
		pass_type = "texture",
		scenegraph_id = "mission_S_difficulty"
	},
	{
		scenegraph_id = "mission_S_difficulty",
		pass_type = "texture",
		style_id = "difficulty_icon",
		value = "content/ui/materials/icons/generic/danger",
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_1",
		scenegraph_id = "mission_S_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_1,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_2",
		scenegraph_id = "mission_S_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_2,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_3",
		scenegraph_id = "mission_S_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_3,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_4",
		scenegraph_id = "mission_S_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_4,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "difficulty_bar_5",
		scenegraph_id = "mission_S_difficulty",
		pass_type = "rect",
		visibility_function = _difficulty_5,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		value_id = "location_image",
		style_id = "location_image",
		pass_type = "texture",
		scenegraph_id = "mission_S_location",
		value = "content/ui/materials/mission_board/texture_with_grid_effect"
	},
	{
		value = "content/ui/materials/frames/inner_shadow_medium",
		style_id = "location_vignette",
		pass_type = "texture",
		scenegraph_id = "mission_S_location"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "location_frame",
		pass_type = "texture",
		scenegraph_id = "mission_S_location"
	},
	{
		value = "content/ui/materials/frames/frame_corner_2px",
		style_id = "location_corner",
		pass_type = "texture",
		scenegraph_id = "mission_S_location"
	},
	{
		scenegraph_id = "mission_S_objective_1",
		style_id = "background",
		pass_type = "rect"
	},
	{
		scenegraph_id = "mission_S_objective_1",
		pass_type = "texture",
		style_id = "objective_corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "objective_1_icon",
		pass_type = "texture",
		scenegraph_id = "mission_S_objective_1",
		value = "content/ui/materials/icons/mission_types/mission_type_01",
		value_id = "objective_1_icon",
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		scenegraph_id = "mission_S_objective_2",
		style_id = "background",
		pass_type = "rect",
		visibility_function = _has_objective_2
	},
	{
		scenegraph_id = "mission_S_objective_2",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_corner_2px",
		style_id = "objective_corner",
		visibility_function = _has_objective_2,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "objective_2_icon",
		pass_type = "texture",
		scenegraph_id = "mission_S_objective_2",
		value = "content/ui/materials/icons/mission_types/mission_type_01",
		value_id = "objective_2_icon",
		visibility_function = _has_objective_2,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		scenegraph_id = "mission_S_circumstance",
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
		scenegraph_id = "mission_S_circumstance",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_corner_2px",
		style_id = "circumstance_corner",
		visibility_function = _has_circumstance,
		change_function = MissionBoardViewStyles.is_locked_change_function
	},
	{
		style_id = "circumstance_icon",
		pass_type = "texture",
		scenegraph_id = "mission_S_circumstance",
		value = "content/ui/materials/icons/circumstances/assault_01",
		value_id = "circumstance_icon",
		visibility_function = _has_circumstance,
		change_function = MissionBoardViewStyles.is_locked_change_function
	}
}, "mission_S", nil, nil, MissionBoardViewStyles.mission_widget_style)
local mission_M_widget_definition = UIWidget.create_definition({
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
		style_id = "timer_frame",
		scenegraph_id = "mission_M_timer",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		visibility_function = _has_timer
	},
	{
		scenegraph_id = "mission_M_timer",
		pass_type = "texture",
		value = "content/ui/materials/mission_board/timer",
		style_id = "timer_bar",
		visibility_function = _has_timer,
		change_function = MissionBoardViewStyles.timer_change_function
	},
	{
		style_id = "timer_hourglass",
		scenegraph_id = "mission_M_timer",
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/hourglass",
		visibility_function = _has_timer
	},
	{
		value_id = "timer_text",
		style_id = "timer_text",
		pass_type = "text",
		scenegraph_id = "mission_M_timer",
		value = "00:00",
		visibility_function = _has_timer
	},
	{
		scenegraph_id = "mission_M_difficulty",
		style_id = "background",
		pass_type = "rect",
		visibility_function = _has_difficulty
	},
	{
		style_id = "difficulty_frame",
		scenegraph_id = "mission_M_difficulty",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_tile_2px",
		visibility_function = _has_difficulty
	},
	{
		style_id = "difficulty_icon",
		scenegraph_id = "mission_M_difficulty",
		pass_type = "texture",
		value = "content/ui/materials/icons/generic/danger",
		visibility_function = _has_difficulty
	},
	{
		scenegraph_id = "mission_M_difficulty",
		style_id = "difficulty_bar_1",
		pass_type = "rect",
		visibility_function = _difficulty_1
	},
	{
		scenegraph_id = "mission_M_difficulty",
		style_id = "difficulty_bar_2",
		pass_type = "rect",
		visibility_function = _difficulty_2
	},
	{
		scenegraph_id = "mission_M_difficulty",
		style_id = "difficulty_bar_3",
		pass_type = "rect",
		visibility_function = _difficulty_3
	},
	{
		scenegraph_id = "mission_M_difficulty",
		style_id = "difficulty_bar_4",
		pass_type = "rect",
		visibility_function = _difficulty_4
	},
	{
		scenegraph_id = "mission_M_difficulty",
		style_id = "difficulty_bar_5",
		pass_type = "rect",
		visibility_function = _difficulty_5
	},
	{
		value_id = "location_image",
		style_id = "location_image",
		pass_type = "texture",
		scenegraph_id = "mission_M_location",
		value = "content/ui/materials/mission_board/texture_with_grid_effect"
	},
	{
		value = "content/ui/materials/frames/inner_shadow_medium",
		style_id = "location_vignette",
		pass_type = "texture",
		scenegraph_id = "mission_M_location"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "location_frame",
		pass_type = "texture",
		scenegraph_id = "mission_M_location"
	},
	{
		value = "content/ui/materials/frames/frame_corner_2px",
		style_id = "location_corner",
		pass_type = "texture",
		scenegraph_id = "mission_M_location"
	},
	{
		value = "content/ui/materials/icons/generic/aquila",
		style_id = "location_decoration",
		pass_type = "texture",
		scenegraph_id = "mission_M_location"
	},
	{
		scenegraph_id = "mission_M_objective",
		style_id = "background",
		pass_type = "rect"
	},
	{
		value = "content/ui/materials/frames/frame_corner_2px",
		style_id = "objective_corner",
		pass_type = "texture",
		scenegraph_id = "mission_M_objective"
	},
	{
		value_id = "objective_icon",
		style_id = "objective_icon",
		pass_type = "texture",
		scenegraph_id = "mission_M_objective",
		value = "content/ui/materials/icons/mission_types/mission_type_01"
	},
	{
		scenegraph_id = "mission_M_circumstance",
		style_id = "background",
		pass_type = "rect",
		visibility_function = _has_circumstance
	},
	{
		style_id = "circumstance_corner",
		scenegraph_id = "mission_M_circumstance",
		pass_type = "texture",
		value = "content/ui/materials/frames/frame_corner_2px",
		visibility_function = _has_circumstance
	},
	{
		value_id = "circumstance_icon",
		style_id = "circumstance_icon",
		pass_type = "texture",
		scenegraph_id = "mission_M_circumstance",
		value = "content/ui/materials/icons/circumstances/assault_01",
		visibility_function = _has_circumstance
	}
}, "mission_M", nil, nil, MissionBoardViewStyles.mission_widget_style)
local animations = {
	mission_S_enter = {
		{
			name = "fade_in_icon",
			end_time = 1,
			start_time = 0,
			init = function (parent, ui_scenegraph, _scenegraph_definition, widgets, params)
				local icon_widget = params.widget
				icon_widget.alpha_multiplier = 0
			end,
			update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
				local icon_widget = params.widget
				icon_widget.alpha_multiplier = math.easeCubic(progress)
			end,
			on_complete = function (parent, ui_scenegraph, _scenegraph_definition, widgets, params)
				local icon_widget = params.widget
				icon_widget.alpha_multiplier = 1
				local content = icon_widget.content
				content.animation_id = nil
			end
		}
	},
	mission_widget_small_exit = {}
}

return settings("MissionBoardViewDefinitions", {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = {
		screen_decorations = screen_decorations_definition,
		planet = planet_widget_definition,
		happening = happening_widget_definition,
		detail = detail_widget_definition,
		objective_1 = objective_1_widget_definition,
		objective_2 = objective_2_widget_definition,
		play_button = play_button_widget_definition
	},
	animations = animations,
	mission_S_widget_definition = mission_S_widget_definition,
	mission_M_widget_definition = mission_M_widget_definition
})
