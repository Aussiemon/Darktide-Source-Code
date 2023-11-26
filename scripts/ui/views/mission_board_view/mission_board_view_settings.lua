-- chunkname: @scripts/ui/views/mission_board_view/mission_board_view_settings.lua

local MissionBoardViewSettings = {
	resource_renderer_enabled = false,
	resource_renderer_material = "content/ui/materials/mission_board/render_target_scanlines",
	quickplay_vo_profile = "pilot_a",
	fetch_retry_cooldown = 5,
	default_danger = 1,
	resource_renderer_name = "mission_board_view_scanlines_ui_renderer",
	color_background = {
		200,
		0,
		0,
		0
	},
	color_corner = Color.terminal_corner(nil, true),
	color_frame = Color.terminal_frame(nil, true),
	color_main = {
		255,
		169,
		211,
		158
	},
	color_main_light = Color.terminal_text_header(nil, true),
	color_accent = Color.golden_rod(nil, true),
	color_disabled = {
		30,
		78,
		87,
		80
	},
	color_gray = {
		200,
		135,
		153,
		131
	},
	color_cursor = Color.golden_rod(nil, true),
	color_dark_opacity = {
		75,
		0,
		0,
		0
	},
	color_green_faded = {
		128,
		169,
		211,
		158
	},
	color_text_title = Color.terminal_text_header(nil, true),
	color_text_body = Color.terminal_text_body(nil, true),
	color_text_sub_header = Color.terminal_text_body_sub_header(nil, true),
	colors_by_mission_type = {
		normal = {
			color_background = {
				200,
				0,
				0,
				0
			},
			color_corner = Color.terminal_corner(nil, true),
			color_frame = Color.terminal_frame(nil, true),
			color_main = {
				255,
				169,
				211,
				158
			},
			color_accent = {
				255,
				238,
				186,
				74
			},
			color_disabled = {
				30,
				78,
				87,
				80
			},
			color_gray = {
				200,
				135,
				153,
				131
			},
			color_cursor = Color.golden_rod(nil, true),
			color_dark_opacity = {
				75,
				0,
				0,
				0
			},
			color_green_faded = {
				128,
				169,
				211,
				158
			},
			color_text_title = Color.terminal_text_header(nil, true),
			color_text_body = Color.terminal_text_body(nil, true)
		},
		auric = {
			color_background = {
				200,
				0,
				0,
				0
			},
			color_corner = {
				255,
				249,
				231,
				115
			},
			color_frame = {
				255,
				164,
				139,
				86
			},
			color_main = {
				255,
				228,
				197,
				130
			},
			color_accent = Color.golden_rod(nil, true),
			color_disabled = {
				30,
				78,
				87,
				80
			},
			color_gray = {
				200,
				135,
				153,
				131
			},
			color_cursor = Color.golden_rod(nil, true),
			color_dark_opacity = {
				75,
				0,
				0,
				0
			},
			color_green_faded = {
				255,
				171,
				146,
				92
			},
			color_text_title = Color.terminal_text_header(nil, true),
			color_text_body = Color.terminal_text_body(nil, true)
		}
	},
	mission_positions = {
		normal = {
			{
				83,
				631,
				index = 1,
				prefered_danger = 1
			},
			{
				246,
				701,
				index = 2,
				prefered_danger = 1
			},
			{
				345,
				550,
				index = 3,
				prefered_danger = 1
			},
			{
				467,
				420,
				index = 4,
				prefered_danger = 1
			},
			{
				485,
				612,
				index = 5,
				prefered_danger = 1
			},
			{
				630,
				685,
				index = 6,
				prefered_danger = 2
			},
			{
				468,
				820,
				index = 7,
				prefered_danger = 2
			},
			{
				820,
				730,
				index = 8,
				prefered_danger = 2
			},
			{
				950,
				645,
				index = 9,
				prefered_danger = 2
			},
			{
				700,
				855,
				index = 10,
				prefered_danger = 2
			},
			{
				989,
				840,
				index = 11,
				prefered_danger = 3
			},
			{
				1092,
				616,
				index = 12,
				prefered_danger = 3
			},
			{
				1229,
				682,
				index = 13,
				prefered_danger = 3
			},
			{
				1004,
				8400,
				index = 14,
				prefered_danger = 3
			},
			{
				1160,
				860,
				index = 15,
				prefered_danger = 3
			},
			{
				1094,
				70,
				index = 16,
				prefered_danger = 4
			},
			{
				1054,
				271,
				index = 17,
				prefered_danger = 4
			},
			{
				1150,
				430,
				index = 18,
				prefered_danger = 4
			},
			{
				925,
				208,
				index = 19,
				prefered_danger = 4
			},
			{
				950,
				445,
				index = 20,
				prefered_danger = 4
			},
			{
				850,
				45,
				index = 21,
				prefered_danger = 5
			},
			{
				467,
				147,
				index = 22,
				prefered_danger = 5
			},
			{
				590,
				271,
				index = 23,
				prefered_danger = 5
			},
			{
				685,
				96,
				index = 24,
				prefered_danger = 5
			},
			{
				785,
				281,
				index = 25,
				prefered_danger = 5
			},
			flash_mission_position = {
				600,
				500
			},
			quickplay_mission_position = {
				120,
				175
			}
		},
		auric = {
			{
				431,
				420,
				index = 1
			},
			{
				560,
				290,
				index = 2
			},
			{
				830,
				290,
				index = 3
			},
			{
				954,
				420,
				index = 4
			},
			{
				954,
				620,
				index = 5
			},
			{
				830,
				735,
				index = 6
			},
			{
				695,
				820,
				index = 7
			},
			{
				560,
				735,
				index = 8
			},
			{
				431,
				620,
				index = 9
			},
			{
				695,
				220,
				index = 10
			},
			flash_mission_position = {
				600,
				500
			},
			quickplay_mission_position = {
				120,
				175
			}
		}
	},
	fluff_frames = {
		"content/ui/materials/fluff/hologram/frames/fluff_frame_01",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_02",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_03",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_04",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_05",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_06",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_07",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_08"
	},
	stepper_difficulty = {
		normal = {
			max_danger = 5,
			min_danger = 1
		},
		auric = {
			max_danger = 5,
			min_danger = 4
		}
	},
	gamepad_cursor_settings = {
		snap_selection_speed_threshold = 10,
		stickiness_radius = 25,
		widget_drag_coefficient = 0.45,
		bounds_min_y = 50,
		cursor_friction_coefficient = 0.002,
		average_speeed_smoothing = 0.5,
		snap_input_length_threshold = 0.05,
		snap_movement_rate = 0.005,
		stickiness_speed_threshold = 500,
		default_size_y = 135,
		bounds_max_x = 1250,
		size_resize_rate = 0.001,
		bounds_max_y = 950,
		cursor_acceleration = 8000,
		default_size_x = 115,
		arrow_rotate_rate = 0.001,
		snap_delay = 0.1,
		bounds_min_x = 50,
		cursor_minimum_speed = 0.1
	},
	world_spawner_settings = {
		viewport_name = "mission_board_viewport",
		level_name = "content/levels/ui/mission_board/mission_board",
		viewport_shading_environment = "content/shading_environments/ui/mission_board",
		viewport_layer = 1,
		viewport_type = "default",
		world_timer_name = "ui",
		world_layer = 1,
		world_name = "mission_board"
	},
	game_settings = {
		{
			description = "loc_mission_board_toggle_solo_play_description",
			display_name = "loc_mission_board_toggle_solo_play",
			setting_name = "solo_play",
			value_get = function ()
				return true
			end
		},
		{
			description = "loc_mission_board_disable_bots_description",
			display_name = "loc_mission_board_disable_bots",
			setting_name = "solo_play_disable_bots",
			value_get = function ()
				return true
			end
		}
	},
	mission_difficulty_complete_icons = {
		"content/ui/materials/icons/mission_difficulty_complete/difficulty_completed_1",
		"content/ui/materials/icons/mission_difficulty_complete/difficulty_completed_2",
		"content/ui/materials/icons/mission_difficulty_complete/difficulty_completed_3",
		"content/ui/materials/icons/mission_difficulty_complete/difficulty_completed_4",
		"content/ui/materials/icons/mission_difficulty_complete/difficulty_completed_5"
	}
}

return settings("MissionBoardViewSettings", MissionBoardViewSettings)
