DefaultGameParameters = DefaultGameParameters or {}
DefaultGameParameters.log_level = 2
DefaultGameParameters.time_step_policy = {
	"no_smoothing",
	"external_step_range",
	0,
	1000,
	"system_step_range",
	0,
	1000
}
DefaultGameParameters.mission = false
DefaultGameParameters.debug_mission = false
DefaultGameParameters.disable_flow_timescale = false
DefaultGameParameters.fixed_time_step = 0.016
DefaultGameParameters.level_seed = false
DefaultGameParameters.max_players = 4
DefaultGameParameters.max_players_hub = 100
DefaultGameParameters.skip_cinematics = false
DefaultGameParameters.skip_first_character_creation = false
DefaultGameParameters.crash_countdown = -1
DefaultGameParameters.pong_timeout = 10
DefaultGameParameters.prod_like_backend = true
DefaultGameParameters.wan_server_port = 4600
DefaultGameParameters.network_wan = DefaultGameParameters.prod_like_backend
DefaultGameParameters.wan_disable_accelerated_endpoint = false
DefaultGameParameters.multiplayer_mode = "host"
DefaultGameParameters.fixed_frame_transmit_rate = 0.001
DefaultGameParameters.default_transmit_rate = 0.03
DefaultGameParameters.window_title = ""
DefaultGameParameters.backend_fetch_master_items = false
DefaultGameParameters.aws_matchmaking = false
DefaultGameParameters.aws_matchmaking_mission_server_alias = "mission-v1"
DefaultGameParameters.aws_matchmaking_hub_server_alias = "hub-v1"
DefaultGameParameters.default_max_ragdolls = DEDICATED_SERVER and 0 or 10
DefaultGameParameters.default_max_impact_decals = DEDICATED_SERVER and 0 or 30
DefaultGameParameters.default_max_blood_decals = DEDICATED_SERVER and 0 or 30
DefaultGameParameters.default_decal_lifetime = DEDICATED_SERVER and 0 or 20
DefaultGameParameters.default_ui_shading_environment = "content/shading_environments/ui_default"
DefaultGameParameters.default_graphics_quality = "high"
DefaultGameParameters.default_ray_tracing_quality_quality = "off"
DefaultGameParameters.lowest_resolution = 1440
DefaultGameParameters.bone_lod_in_distance = 7
DefaultGameParameters.bone_lod_out_distance = 8
DefaultGameParameters.debug_frame_tables = false
DefaultGameParameters.dump_dev_parameters_on_startup = false
DefaultGameParameters.dump_game_parameters_on_startup = false
DefaultGameParameters.circumstance = "default"
DefaultGameParameters.side_mission = "default"
DefaultGameParameters.testify = false
DefaultGameParameters.testify_time_scale = false
DefaultGameParameters.debug_testify = false
DefaultGameParameters.machine_name = ""
DefaultGameParameters.steam_branch = ""
DefaultGameParameters.svn_branch = ""
DefaultGameParameters.skip_gamertag_popup = false
DefaultGameParameters.nvidia_ai_agent = true
DefaultGameParameters.show_marks_store = true
DefaultGameParameters.show_contracts = true
DefaultGameParameters.skip_prologue = false
DefaultGameParameters.save_file_name = "default"
DefaultGameParameters.cloud_save_enabled = true
DefaultGameParameters.enable_stay_in_party_feature = true
DefaultGameParameters.debug_disable_xbox_live = false
DefaultGameParameters.show_watermark_overlay = false
DefaultGameParameters.watermark_overlay_alpha_multiplier = 0.0196078431372549
DefaultGameParameters.watermark_overlay_text = "CLOSED ALPHA TEST"
DefaultGameParameters.show_beta_label_overlay = false
DefaultGameParameters.beta_label_overlay_text = "Closed Beta Test October 14-16 2022"
DefaultGameParameters.enable_string_tags = false
DefaultGameParameters.vertical_fov = 65
DefaultGameParameters.min_vertical_fov = 45
DefaultGameParameters.max_vertical_fov = 120
DefaultGameParameters.min_console_vertical_fov = 45
DefaultGameParameters.max_console_vertical_fov = 90
DefaultGameParameters.prod_like_backend = true
DefaultGameParameters.backend_fetch_master_items = true
DefaultGameParameters.show_beta_label_overlay = true
DefaultGameParameters.prod_like_backend = true
DefaultGameParameters.backend_fetch_master_items = true
DefaultGameParameters.show_beta_label_overlay = true

return DefaultGameParameters
