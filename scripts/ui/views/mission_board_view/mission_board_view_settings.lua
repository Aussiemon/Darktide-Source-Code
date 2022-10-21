local MissionBoardViewSettings = {
	resource_renderer_enabled = true,
	mission_time_grace_period = 1,
	resource_renderer_name = "mission_board_view_scanlines_ui_renderer",
	resource_renderer_material = "content/ui/materials/mission_board/render_target_scanlines",
	fetch_retry_cooldown = 5,
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
	color_accent = Color.golden_rod(nil, true),
	color_disabled = {
		50,
		161,
		175,
		158
	},
	color_gray = {
		200,
		161,
		175,
		158
	},
	mission_positions = {
		{
			234.736,
			835.341,
			index = 1
		},
		{
			1118.371,
			365.955,
			index = 2
		},
		{
			1197.436,
			720.065,
			index = 3
		},
		{
			844.629,
			741.424,
			index = 4
		},
		{
			853.249,
			96.558,
			index = 5
		},
		{
			177.226,
			598.332,
			index = 6
		},
		{
			899.525,
			391.039,
			index = 7
		},
		{
			1016.314,
			576.887,
			index = 8
		},
		{
			1030.706,
			169.407,
			index = 9
		},
		{
			618.534,
			842.57,
			index = 10
		},
		{
			615.872,
			138.585,
			index = 11
		},
		{
			270.279,
			317.813,
			index = 12
		},
		{
			1046.255,
			851.528,
			index = 13
		},
		{
			406.033,
			750.475,
			index = 14
		},
		{
			380.706,
			529.623,
			index = 15
		}
	},
	flash_mission_position = {
		704.213501,
		552.210754,
		index = 0,
		length = 0
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
	world_spawner_settings = {
		viewport_name = "mission_board_viewport",
		level_name = "content/levels/ui/mission_board/mission_board",
		viewport_shading_environment = "content/shading_environments/ui/mission_board",
		viewport_layer = 1,
		viewport_type = "default",
		world_timer_name = "ui",
		world_layer = 1,
		world_name = "mission_board"
	}
}

return settings("MissionBoardViewSettings", MissionBoardViewSettings)
