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
	}
}
mission_board_view_settings.cell_size = {
	mission_board_view_settings.board_size[1] / mission_board_view_settings.grid_size[1] - mission_board_view_settings.grid_spacing[1],
	mission_board_view_settings.board_size[2] / mission_board_view_settings.grid_size[2] - mission_board_view_settings.grid_spacing[2]
}
mission_board_view_settings.view_fade_time = 0.3
mission_board_view_settings.timer_bar_fuzziness = 0.01
mission_board_view_settings.scrollbar_width = 8
mission_board_view_settings.icon_hover_animation_time = 0.25
mission_board_view_settings.icon_fade_time = 0.3
mission_board_view_settings.zone_line_draw_time = 0.2
mission_board_view_settings.icon_distance_scale_factor = 40
mission_board_view_settings.show_icon_sound_cooldown = 0.5
mission_board_view_settings.hide_icon_sound_cooldown = 0.5
mission_board_view_settings.minimum_refresh_wait_time = 15
mission_board_view_settings.num_icon_layers = 10
mission_board_view_settings.icon_layer_step = 4
mission_board_view_settings.furthest_icon_scale = 0.8
mission_board_view_settings.closest_icon_scale = 1
mission_board_view_settings.icon_placement_k = 29
mission_board_view_settings.icon_placement_v = 71
mission_board_view_settings.default_circumstance = "default"
mission_board_view_settings.node_name_format = "grid_%d_%d"
mission_board_view_settings.xp_format = "%d "
mission_board_view_settings.reward_format = "%d "
mission_board_view_settings.time_format = "%.2d:%.2d "
mission_board_view_settings.input_threshold = 0.7
mission_board_view_settings.main_objective_type_name = {
	fortification_objective = "loc_mission_type_fortification_objective",
	demolition_objective = "loc_mission_type_demolition_objective",
	kill_objective = "loc_mission_type_kill_objective",
	control_objective = "loc_mission_type_control_objective",
	default = "loc_mission_type_default",
	decode_objective = "loc_mission_type_decode_objective",
	luggable_objective = "loc_mission_type_luggable_objective"
}

return settings("MissionBoardViewSettingsNew", mission_board_view_settings)
