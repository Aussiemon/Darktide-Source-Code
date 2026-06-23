-- chunkname: @scripts/settings/mutator/templates/live_event_mutator_templates/mutator_live_event_leftover_templates.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local MutatorStatTriggerUtilities = require("scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_utilities")
local EnemyCompositions = require("scripts/settings/live_event/live_event_enemy_compositions/stolen_rations_enemy_compositions")
local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local MutatorGameplayLiveEventLeftover = require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_leftover")
local _side_notification_settings = {
	interaction_type_loc_strings = {
		"loc_player_leftover_pickup_notification",
	},
	pickup_localization_by_size = {
		large = "loc_leftover_pickup_large",
		medium = "loc_leftover_pickup_medium",
		small = "loc_leftover_pickup_small",
	},
	pickup_icon_by_size = {
		large = "content/ui/materials/icons/currencies/live_events/leftover_live_event_large",
		medium = "content/ui/materials/icons/currencies/live_events/leftover_live_event_medium",
		small = "content/ui/materials/icons/currencies/live_events/leftover_live_event_small",
	},
}
local spawn_enemy_composition = {
	{
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						4,
						4,
					},
				},
				{
					name = "cultist_vanguard",
					amount = {
						1,
						4,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						2,
						8,
					},
				},
				{
					name = "cultist_vanguard",
					amount = {
						1,
						4,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						4,
						8,
					},
				},
				{
					name = "cultist_vanguard",
					amount = {
						2,
						4,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						6,
						12,
					},
				},
				{
					name = "cultist_vanguard",
					amount = {
						3,
						4,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						8,
						14,
					},
				},
				{
					name = "cultist_vanguard",
					amount = {
						3,
						4,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						12,
						14,
					},
				},
				{
					name = "cultist_vanguard",
					amount = {
						4,
						8,
					},
				},
			},
		},
	},
}
local mutator_templates = {
	mutator_leftover_main_path_pickup_spawns = {
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		num_to_spawn = 40,
		trigger_distance = 55,
		spawn_locations = MutatorSpawnerLocationSources.main_path_locations(),
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
				template = {
					asset_package = "packages/content/live_events/leftover/leftover_assets",
					use_raycast = true,
					levels = {
						level_size_2 = {
							"content/levels/live_events/leftover/live_event_leftover_pickup_spawn_large",
							"content/levels/live_events/leftover/live_event_leftover_pickup_spawn_medium",
							"content/levels/live_events/leftover/live_event_leftover_pickup_spawn_small",
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
	mutator_leftover_gameplay_logic = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/leftover/leftover_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_gameplay",
		gameplay_template = {
			path = "scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_leftover",
			start_module_on_activate = true,
			settings = {},
		},
		side_notification = _side_notification_settings,
	},
	mutator_live_event_leftover_hub = {
		activate_on_load = true,
		class = "scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_leftover_hub",
	},
	mutator_drop_leftover_01_pickup_small_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_leftover_01_pickup_small_on_death",
			},
			breed_chances = {
				chaos_armored_infected = 0.05,
				chaos_hound = 0.1,
				chaos_newly_infected = 0.05,
				chaos_poxwalker = 0.05,
				cultist_assault = 0.05,
				cultist_melee = 0.05,
				renegade_assault = 0.05,
				renegade_melee = 0.05,
				renegade_rifleman = 0.05,
			},
		},
	},
	mutator_drop_leftover_01_pickup_medium_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_leftover_01_pickup_medium_on_death",
			},
			breed_chances = {
				chaos_ogryn_bulwark = 0.2,
				chaos_ogryn_executor = 0.2,
				chaos_ogryn_gunner = 0.2,
				cultist_berzerker = 0.1,
				cultist_flamer = 0.1,
				cultist_grenadier = 0.1,
				cultist_gunner = 0.1,
				cultist_mutant = 0.1,
				cultist_shocktrooper = 0.1,
				renegade_berzerker = 0.1,
				renegade_executor = 0.1,
				renegade_flamer = 0.1,
				renegade_grenadier = 0.1,
				renegade_gunner = 0.1,
				renegade_netgunner = 0.1,
				renegade_plasma_gunner = 0.1,
				renegade_shocktrooper = 0.1,
				renegade_sniper = 0.1,
			},
		},
	},
	mutator_drop_leftover_01_pickup_medium_many_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_leftover_01_pickup_medium_many_on_death",
			},
			breed_chances = {
				chaos_beast_of_nurgle = 1,
				chaos_daemonhost = 1,
				chaos_ogryn_houndmaster = 1,
				chaos_plague_ogryn = 1,
				chaos_spawn = 1,
				renegade_captain = 1,
				renegade_twin_captain = 1,
				renegade_twin_captain_two = 1,
			},
		},
	},
	mutator_live_event_leftover_drop_large_pickups_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"live_event_leftover_drop_many_large_pickups_on_death",
			},
			breed_chances = {
				chaos_beast_of_nurgle = 1,
				chaos_daemonhost = 1,
				chaos_ogryn_houndmaster = 1,
				chaos_plague_ogryn = 1,
				chaos_spawn = 1,
				renegade_captain = 1,
				renegade_twin_captain = 1,
				renegade_twin_captain_two = 1,
			},
		},
	},
	mutator_live_event_leftover_loot_point_spawns = {
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		num_to_spawn = 6,
		proximity_trigger_distance = 50,
		spawn_type = "proximity",
		trigger_distance = 50,
		spawn_locations = MutatorSpawnerLocationSources.mission_provided_gizmo(),
		size = {
			level_size_4 = true,
		},
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
				template = {
					asset_package = "packages/content/live_events/leftover/leftover_assets",
					use_raycast = false,
					levels = {
						level_size_4 = {
							"content/levels/live_events/leftover/live_event_leftover_loot_point",
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
						cultist = spawn_enemy_composition,
					},
					spawn_settings = {
						position_offset = 1,
					},
					enemy_placement_method = MutatorSpawnerNode.CIRCLE_PLACEMENT,
				},
			},
		},
	},
}

return mutator_templates
