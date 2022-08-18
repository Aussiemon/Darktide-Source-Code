local mission_board_view_settings = {
	board_size = {
		1280,
		720
	},
	grid_size = {
		24,
		5
	},
	grid_blur_edge_size = {
		8,
		8
	},
	grid_spacing = {
		0,
		0
	},
	cell_size = {
		mission_board_view_settings.board_size[1] / mission_board_view_settings.grid_size[1] - mission_board_view_settings.grid_spacing[1],
		mission_board_view_settings.board_size[2] / mission_board_view_settings.grid_size[2] - mission_board_view_settings.grid_spacing[2]
	},
	view_fade_time = 0.3,
	timer_bar_fuzziness = 0.01,
	scrollbar_width = 8,
	icon_hover_animation_time = 0.25,
	icon_fade_time = 0.3,
	zone_line_draw_time = 0.2,
	icon_distance_scale_factor = 40,
	show_icon_sound_cooldown = 0.5,
	hide_icon_sound_cooldown = 0.5,
	minimum_refresh_wait_time = 15,
	num_icon_layers = 10,
	icon_layer_step = 4,
	furthest_icon_scale = 0.8,
	closest_icon_scale = 1,
	icon_placement_k = 29,
	icon_placement_v = 71,
	default_circumstance = "default",
	node_name_format = "grid_%d_%d",
	xp_format = "%d \ue032",
	reward_format = "%d \ue031",
	time_format = "%.2d:%.2d \ue007",
	input_threshold = 0.7,
	main_objective_type_name = {
		fortification_objective = "loc_mission_type_fortification_objective",
		demolition_objective = "loc_mission_type_demolition_objective",
		kill_objective = "loc_mission_type_kill_objective",
		control_objective = "loc_mission_type_control_objective",
		default = "loc_mission_type_default",
		decode_objective = "loc_mission_type_decode_objective",
		luggable_objective = "loc_mission_type_luggable_objective"
	}
}

return settings("MissionBoardViewSettingsNew", mission_board_view_settings)
