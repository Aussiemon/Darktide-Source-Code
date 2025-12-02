-- chunkname: @scripts/settings/mutator/templates/live_event_mutator_templates/mutator_live_event_saints_templates.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local MutatorGameplayLiveEventSaints = require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_saints")
local shrine_spawn_enemy_composition = {
	{
		{
			breeds = {
				{
					name = "cultist_ritualist",
					amount = {
						4,
						4,
					},
				},
				{
					name = "chaos_poxwalker",
					amount = {
						10,
						15,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "cultist_ritualist",
					amount = {
						4,
						4,
					},
				},
				{
					name = "chaos_poxwalker",
					amount = {
						12,
						15,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "cultist_ritualist",
					amount = {
						4,
						4,
					},
				},
				{
					name = "chaos_poxwalker",
					amount = {
						12,
						18,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "cultist_ritualist",
					amount = {
						4,
						4,
					},
				},
				{
					name = "chaos_poxwalker",
					amount = {
						15,
						20,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "cultist_ritualist",
					amount = {
						4,
						4,
					},
				},
				{
					name = "chaos_poxwalker",
					amount = {
						18,
						25,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_mutator_ritualist",
					amount = {
						4,
						4,
					},
				},
				{
					name = "chaos_poxwalker",
					amount = {
						20,
						25,
					},
				},
			},
		},
	},
}
local mutator_templates = {
	mutator_live_event_saints_shrine_spawns = {
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		num_to_spawn = 3,
		trigger_distance = 40,
		spawn_locations = MutatorSpawnerLocationSources.prebaked_mission_locations("skulls_locations"),
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
				template = {
					asset_package = "packages/content/live_events/saints/live_event_saints_assets",
					use_raycast = false,
					levels = {
						level_size_4 = {
							"content/levels/live_events/saints/live_event_saints_shrine_01",
						},
					},
					placement_method = MutatorSpawnerNode.SINGLE_PLACEMENT,
					size_lookup = {
						"level_size_4",
					},
					spawn_settings = {
						randomize_rotation = true,
					},
				},
			},
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_enemy_template",
				template = {
					placement_method = MutatorSpawnerNode.SINGLE_PLACEMENT,
					composition = {
						renegade = shrine_spawn_enemy_composition,
						cultist = shrine_spawn_enemy_composition,
					},
					enemy_placement_method = MutatorSpawnerNode.CIRCLE_PLACEMENT,
				},
			},
		},
	},
	mutator_saints_main_path_pickup_spawns = {
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		num_to_spawn = 14,
		trigger_distance = 40,
		spawn_locations = MutatorSpawnerLocationSources.main_path_locations(),
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
				template = {
					asset_package = "packages/content/live_events/saints/live_event_saints_assets",
					use_raycast = true,
					levels = {
						level_size_2 = {
							"content/levels/live_events/saints/live_event_saints_pickup_spawn_large",
							"content/levels/live_events/saints/live_event_saints_pickup_spawn_small",
							"content/levels/live_events/saints/live_event_saints_pickup_spawn_medium",
							"content/levels/live_events/saints/live_event_saints_pickup_spawn_medium",
							"content/levels/live_events/saints/live_event_saints_pickup_spawn_small",
							"content/levels/live_events/saints/live_event_saints_pickup_spawn_small",
							"content/levels/live_events/saints/live_event_saints_pickup_spawn_small",
							"content/levels/live_events/saints/live_event_saints_pickup_spawn_small",
							"content/levels/live_events/saints/live_event_saints_pickup_spawn_small",
							"content/levels/live_events/saints/live_event_saints_pickup_spawn_small",
						},
					},
					placement_method = MutatorSpawnerNode.CIRCLE_PLACEMENT,
					size_lookup = {
						"level_size_2",
					},
					spawn_settings = {
						count = 3,
						position_offset = 5,
						randomize_rotation = true,
					},
				},
			},
		},
	},
	mutator_live_event_saints_auto_events = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			auto_event_template = "live_event_saints_auto_event_template",
		},
	},
	mutator_live_event_saints_shrine_gameplay = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/saints/live_event_saints_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_gameplay",
		gameplay_template = {
			path = "scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_saints_simplified",
			settings = {
				shrine_points = 100,
				notifications = {
					wave_progress_notification_01 = {
						style = "alert",
						subtitle = "loc_saints_event_wave_progress_subtitle_01",
						title = "loc_saints_event_objective_notification_title",
						sound_event = UISoundEvents.notification_warning,
					},
					wave_progress_notification_02 = {
						style = "alert",
						subtitle = "loc_saints_event_wave_progress_subtitle_02",
						title = "loc_saints_event_objective_notification_title",
						sound_event = UISoundEvents.notification_warning,
					},
					wave_progress_notification_03 = {
						style = "alert",
						subtitle = "loc_saints_event_wave_progress_subtitle_03",
						title = "loc_saints_event_objective_notification_title",
						sound_event = UISoundEvents.notification_warning,
					},
					wave_progress_notification_04 = {
						style = "alert",
						subtitle = "loc_saints_event_wave_progress_subtitle_04",
						title = "loc_saints_event_objective_notification_title",
						sound_event = UISoundEvents.notification_warning,
					},
					wave_progress_notification_05 = {
						style = "alert",
						subtitle = "loc_saints_event_wave_progress_subtitle_05",
						title = "loc_saints_event_objective_notification_title",
						sound_event = UISoundEvents.notification_warning,
					},
				},
			},
		},
		side_notification = {
			interaction_type_loc_strings = {
				"loc_player_saints_relic_pickup_notification",
			},
			pickup_localization_by_size = {
				large = "loc_saints_relic_pickup_large",
				medium = "loc_saints_relic_pickup_medium",
				small = "loc_saints_relic_pickup_small",
			},
			pickup_icon_by_size = {
				large = "content/ui/materials/icons/currencies/live_events/saints_live_event_large",
				medium = "content/ui/materials/icons/currencies/live_events/saints_live_event_medium",
				small = "content/ui/materials/icons/currencies/live_events/saints_live_event_small",
			},
		},
	},
	mutator_live_event_saints_mission_buffs = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/saints/live_event_saints_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_stat_trigger",
		global_stats = {
			saint_red_victories = {
				triggers = {
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_on_delta",
						template = {
							trigger_amount = 1,
							trigger_once = false,
							on_trigger = {
								MutatorGameplayLiveEventSaints.on_global_stat_trigger_apply_player_buff_stacks("live_event_saints_buff_saint_red"),
							},
						},
					},
				},
			},
			saint_blue_victories = {
				triggers = {
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_on_delta",
						template = {
							trigger_amount = 1,
							trigger_once = false,
							on_trigger = {
								MutatorGameplayLiveEventSaints.on_global_stat_trigger_apply_player_buff_stacks("live_event_saints_buff_saint_blue"),
							},
						},
					},
				},
			},
		},
	},
	mutator_saints_headshot_parasite_enemies = {
		class = "scripts/managers/mutator/mutators/mutator_minion_visual_override",
		template_name = "head_parasite",
		random_spawn_buff_templates = {
			buffs = {
				"headshot_parasite_enemies",
			},
			breed_chances = {
				chaos_armored_infected = 0.5,
				chaos_beast_of_nurgle = 0,
				chaos_daemonhost = 0,
				chaos_hound = 0,
				chaos_lesser_mutated_poxwalker = 0.75,
				chaos_mutated_poxwalker = 0.75,
				chaos_newly_infected = 0.8,
				chaos_ogryn_bulwark = 0.1,
				chaos_ogryn_executor = 0.1,
				chaos_ogryn_gunner = 0.1,
				chaos_plague_ogryn = 0,
				chaos_poxwalker = 0.75,
				chaos_poxwalker_bomber = 0,
				chaos_spawn = 0,
				cultist_assault = 0,
				cultist_berzerker = 0,
				cultist_flamer = 0,
				cultist_grenadier = 0,
				cultist_gunner = 0,
				cultist_melee = 0,
				cultist_mutant = 0,
				cultist_shocktrooper = 0,
				renegade_assault = 0,
				renegade_berzerker = 0,
				renegade_captain = 0,
				renegade_executor = 0,
				renegade_flamer = 0,
				renegade_grenadier = 0,
				renegade_gunner = 0,
				renegade_melee = 0,
				renegade_netgunner = 0,
				renegade_rifleman = 0,
				renegade_shocktrooper = 0,
				renegade_sniper = 0,
			},
		},
	},
	mutator_saints_nurgle_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_replace_breed",
		init_replacement_breed = {
			breed_replacement = {
				chaos_newly_infected = "chaos_lesser_mutated_poxwalker",
				chaos_poxwalker = "chaos_mutated_poxwalker",
			},
		},
	},
	mutator_saints_horde_pacing = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			required_horde_travel_distance = 25,
		},
	},
}

return mutator_templates
