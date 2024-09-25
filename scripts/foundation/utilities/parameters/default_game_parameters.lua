-- chunkname: @scripts/foundation/utilities/parameters/default_game_parameters.lua

DefaultGameParameters = DefaultGameParameters or {}
DefaultGameParameters.log_level = 2
DefaultGameParameters.time_step_policy = {
	"no_smoothing",
	"external_step_range",
	0,
	1000,
	"system_step_range",
	0,
	1000,
}
DefaultGameParameters.mission = false
DefaultGameParameters.debug_mission = false
DefaultGameParameters.disable_flow_timescale = false
DefaultGameParameters.tick_rate = 52
DefaultGameParameters.level_seed = false
DefaultGameParameters.max_players = 4
DefaultGameParameters.max_players_hub = 32
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
DefaultGameParameters.save_achievements_in_batch = true
DefaultGameParameters.use_fleetiq = false
DefaultGameParameters.aws_matchmaking = false
DefaultGameParameters.aws_matchmaking_mission_server_alias = "mission-v1"
DefaultGameParameters.aws_matchmaking_hub_server_alias = "hub-v1"
DefaultGameParameters.default_lod_object_multiplier = 1
DefaultGameParameters.default_max_ragdolls = DEDICATED_SERVER and 0 or 10
DefaultGameParameters.default_max_impact_decals = DEDICATED_SERVER and 0 or 30
DefaultGameParameters.default_max_blood_decals = DEDICATED_SERVER and 0 or 30
DefaultGameParameters.default_decal_lifetime = DEDICATED_SERVER and 0 or 20
DefaultGameParameters.default_ui_shading_environment = "content/shading_environments/ui_default"
DefaultGameParameters.default_graphics_quality = "high"
DefaultGameParameters.default_ray_tracing_quality_quality = "off"
DefaultGameParameters.lowest_resolution = 1440
DefaultGameParameters.sharpness = 0.5
DefaultGameParameters.force_stream_mesh_timeout = 2
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
DefaultGameParameters.show_premium_store = true
DefaultGameParameters.show_marks_store = true
DefaultGameParameters.show_contracts = true
DefaultGameParameters.show_crafting = true
DefaultGameParameters.show_group_finder = true
DefaultGameParameters.skip_prologue = false
DefaultGameParameters.save_file_name = "default"
DefaultGameParameters.cloud_save_enabled = true
DefaultGameParameters.enable_stay_in_party_feature = true
DefaultGameParameters.debug_disable_xbox_live = false
DefaultGameParameters.enable_backend_gear_cache = true
DefaultGameParameters.enable_trait_sticker_book_cache = true
DefaultGameParameters.enable_wallets_cache = true
DefaultGameParameters.show_watermark_overlay = false
DefaultGameParameters.watermark_overlay_alpha_multiplier = 0.0196078431372549
DefaultGameParameters.watermark_overlay_text = "CLOSED ALPHA TEST"
DefaultGameParameters.show_beta_label_overlay = false
DefaultGameParameters.beta_label_overlay_text = "Closed Beta Test October 14-16 2022"
DefaultGameParameters.enable_string_tags = false
DefaultGameParameters.vertical_fov = 65
DefaultGameParameters.min_vertical_fov = 45
DefaultGameParameters.max_vertical_fov = 85
DefaultGameParameters.min_console_vertical_fov = 45
DefaultGameParameters.max_console_vertical_fov = 85
DefaultGameParameters.blood_decals_enabled = not DEDICATED_SERVER
DefaultGameParameters.attack_ragdolls_enabled = not DEDICATED_SERVER
DefaultGameParameters.minion_wounds_enabled = not DEDICATED_SERVER
DefaultGameParameters.gibbing_enabled = not DEDICATED_SERVER
DefaultGameParameters.enable_afk_check = BUILD == "release"
DefaultGameParameters.afk_warning_time_hub = 10
DefaultGameParameters.afk_kick_time_hub = 15
DefaultGameParameters.afk_warning_time_mission = 5
DefaultGameParameters.afk_kick_time_mission = 10
DefaultGameParameters.reset_keybind_on_start = false
DefaultGameParameters.is_modded_crashify_property = false
DefaultGameParameters.wallet_cap_credits = 5000000
DefaultGameParameters.wallet_cap_marks = 100000
DefaultGameParameters.wallet_cap_plasteel = 1000000
DefaultGameParameters.wallet_cap_diamantine = 1000000
DefaultGameParameters.wallet_cap_aquilas = false
DefaultGameParameters.error_codes_crashifyreport = false
DefaultGameParameters.launcher_verification_passed_crashify_property = false
DefaultGameParameters.prod_like_backend = true
DefaultGameParameters.backend_fetch_master_items = true

return DefaultGameParameters
