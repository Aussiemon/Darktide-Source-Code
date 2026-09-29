-- chunkname: @scripts/settings/mutator/templates/live_event_mutator_templates/mutator_live_event_torment_templates.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local LevelProps = require("scripts/settings/level_prop/level_props")
local mutator_templates = {
	mutator_torment_gameplay_logic = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/torment/torment_assets",
		class = "scripts/managers/mutator/mutators/mutator_gameplay",
		gameplay_template = {
			path = "scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_torment",
			run_on_client = true,
			start_module_on_activate = true,
			settings = {
				notifications = {
					torment_daemonhost_alert = {
						style = "alert",
						subtitle = "loc_torment_chaos_daemonhost_spawn_alert_subtitle",
						title = "loc_torment_chaos_daemonhost_spawn_alert_title",
						sound_event = UISoundEvents.notification_warning,
					},
				},
				light_flicker = {
					inner_radius = 25,
					outer_radius = 50,
					step_frequency = 10,
					pattern = {
						1,
						1,
						0.2,
						1,
						1,
						1,
						0.1,
						1,
						0.6,
						1,
						1,
						0.3,
						1,
						0,
						1,
						0.4,
						1,
						1,
					},
				},
			},
		},
	},
	mutator_torment_flashlight_boost = {
		activate_on_load = true,
		class = "scripts/managers/mutator/mutators/mutator_torment_flashlight_boost",
		player_light = {
			falloff_scale = 3,
			intensity_scale = 2.5,
		},
	},
	mutator_live_event_torment_witch_spawner = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/torment/torment_assets",
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		max_spawned_per_section = 1,
		num_to_spawn = 3,
		spawn_type = "default",
		trigger_distance = 80,
		spawn_locations = MutatorSpawnerLocationSources.mission_provided_gizmo(),
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_enemy_template",
				template = {
					injection_template_settings = {
						force_horde_on_spawn = false,
						name = "torment_witch",
					},
					enemy_placement_method = MutatorSpawnerNode.SINGLE_PLACEMENT,
					placement_method = MutatorSpawnerNode.SINGLE_PLACEMENT,
					composition = {
						cultist = nil,
						renegade = nil,
					},
					spawners = {
						{
							class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
							template = {
								asset_package = "packages/content/live_events/torment/torment_assets",
								use_raycast = true,
								levels = {
									level_size_2 = {
										"content/levels/live_events/torment/live_event_torment_candles_01",
									},
								},
								placement_method = MutatorSpawnerNode.CIRCLE_PLACEMENT,
								size_lookup = {
									"level_size_2",
								},
								spawn_settings = {
									count = 8,
									position_offset = 3,
									randomize_rotation = true,
								},
							},
						},
					},
				},
			},
		},
	},
	mutator_live_event_torment_candle_spawner = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/torment/torment_assets",
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		num_to_spawn = 128,
		spawn_type = "default",
		trigger_distance = 80,
		spawn_locations = MutatorSpawnerLocationSources.main_path_locations(),
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
				template = {
					asset_package = "packages/content/live_events/torment/torment_assets",
					use_raycast = true,
					levels = {
						level_size_2 = {
							"content/levels/live_events/torment/live_event_torment_candles_01",
						},
					},
					placement_method = MutatorSpawnerNode.CIRCLE_PLACEMENT,
					size_lookup = {
						"level_size_2",
					},
					spawn_settings = {
						count = 1,
						randomize_rotation = true,
					},
				},
			},
		},
	},
	mutator_live_event_torment_eye_glow = {
		activate_on_load = true,
		class = "scripts/managers/mutator/mutators/mutator_base",
		buff_templates = {
			"live_event_torment_eye_glow",
		},
		excluded_breed_tags = {
			"witch",
		},
		excluded_breeds = {
			"renegade_gunner",
			"renegade_plasma_gunner",
			"renegade_rifleman",
			"renegade_netgunner",
			"renegade_sniper",
		},
	},
}

return mutator_templates
