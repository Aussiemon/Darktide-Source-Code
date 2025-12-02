-- chunkname: @scripts/settings/mutator/templates/mutator_live_event_templates.lua

local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local MutatorStatTriggerUtilities = require("scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_utilities")
local EnemyCompositions = require("scripts/settings/live_event/live_event_enemy_compositions/stolen_rations_enemy_compositions")
local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local mutator_templates = {
	mutator_drop_shocktrooper_grenade_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_shocktrooper_grenade_on_death",
			},
			breed_chances = {
				cultist_shocktrooper = 0.8,
				renegade_shocktrooper = 0.8,
			},
		},
	},
	mutator_drop_pickup_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_pickup_on_death",
			},
			breed_chances = {
				chaos_beast_of_nurgle = 1,
				chaos_daemonhost = 1,
				chaos_hound = 0.2,
				chaos_newly_infected = 0.05,
				chaos_ogryn_bulwark = 0.25,
				chaos_ogryn_executor = 0.25,
				chaos_ogryn_gunner = 0.25,
				chaos_plague_ogryn = 1,
				chaos_poxwalker = 0.1,
				chaos_spawn = 1,
				cultist_assault = 0.05,
				cultist_berzerker = 0.25,
				cultist_flamer = 0.25,
				cultist_grenadier = 0.25,
				cultist_gunner = 0.25,
				cultist_melee = 0.05,
				cultist_mutant = 0.25,
				cultist_shocktrooper = 0.1,
				renegade_assault = 0.05,
				renegade_berzerker = 0.25,
				renegade_executor = 0.25,
				renegade_flamer = 0.25,
				renegade_grenadier = 0.25,
				renegade_gunner = 0.1,
				renegade_melee = 0.05,
				renegade_netgunner = 0.25,
				renegade_rifleman = 0.05,
				renegade_shocktrooper = 0.1,
				renegade_sniper = 0.25,
			},
		},
	},
	mutator_drop_stolen_rations_01_pickup_small_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_stolen_rations_01_pickup_small_on_death",
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
	mutator_drop_stolen_rations_01_pickup_medium_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_stolen_rations_01_pickup_medium_on_death",
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
	mutator_drop_stolen_rations_01_pickup_medium_many_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_stolen_rations_01_pickup_medium_many_on_death",
			},
			breed_chances = {
				chaos_beast_of_nurgle = 1,
				chaos_daemonhost = 1,
				chaos_plague_ogryn = 1,
				chaos_spawn = 1,
				renegade_captain = 1,
				renegade_twin_captain = 1,
				renegade_twin_captain_two = 1,
			},
		},
	},
	mutator_attack_selection_template_override_plasma = {
		class = "scripts/managers/mutator/mutators/mutator_base",
	},
	mutator_enable_twin_havoc_inventory = {
		activate_on_load = true,
		class = "scripts/managers/mutator/mutators/mutator_base",
	},
	mutator_player_buff_stolen_rations_destroy = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/stolen_rations/stolen_rations_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_player_buff",
		trigger_on_events = {
			"mission_buffs_event_player_spawned",
		},
		externally_controlled_buffs = {
			"live_event_stolen_rations_destroy_ranged",
		},
	},
	mutator_player_buff_stolen_rations_recover = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/stolen_rations/stolen_rations_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_player_buff",
		trigger_on_events = {
			"event_player_action_use_syringe",
		},
		externally_controlled_buffs = {
			"live_event_stolen_rations_recover_syringe",
		},
	},
	mutator_stat_trigger_stolen_rations_core = {
		activate_on_load = true,
		class = "scripts/managers/mutator/mutators/mutator_stat_trigger",
		team_stats = {
			stolen_rations_destroyed_team = {
				triggers = {
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count",
						template = {
							trigger_amount = 50,
							trigger_once = false,
							on_trigger = {
								MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde(EnemyCompositions.live_event_stolen_rations_stat_destroy_spawn_horde, "flood_horde"),
								MutatorStatTriggerUtilities.on_trigger_send_live_event_notification("notification_destroy"),
							},
						},
					},
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count",
						template = {
							trigger_amount = 50,
							trigger_once = false,
							on_trigger = {
								MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde(EnemyCompositions.live_event_stolen_rations_stat_destroy_boss, "flood_horde"),
							},
						},
					},
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count",
						template = {
							trigger_amount = 350,
							trigger_once = false,
							on_trigger = {
								MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde(EnemyCompositions.live_event_stolen_rations_stat_destroy_super_boss, "flood_horde"),
							},
						},
					},
				},
			},
			stolen_rations_recovered_team = {
				triggers = {
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count",
						template = {
							trigger_amount = 50,
							trigger_once = false,
							on_trigger = {
								MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde(EnemyCompositions.live_event_stolen_rations_stat_recover_spawn_horde, "flood_horde"),
								MutatorStatTriggerUtilities.on_trigger_send_live_event_notification("notification_recover"),
							},
						},
					},
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count",
						template = {
							trigger_amount = 100,
							trigger_once = false,
							on_trigger = {
								MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde(EnemyCompositions.live_event_stolen_rations_stat_recover_boss, "flood_horde"),
							},
						},
					},
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count",
						template = {
							trigger_amount = 350,
							trigger_once = false,
							on_trigger = {
								MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde(EnemyCompositions.live_event_stolen_rations_stat_recover_super_boss, "flood_horde"),
							},
						},
					},
				},
			},
		},
	},
	mutator_stolen_rations_main_path_pickup_spawns = {
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		num_to_spawn = 18,
		trigger_distance = 40,
		spawn_locations = MutatorSpawnerLocationSources.main_path_locations(),
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
				template = {
					asset_package = "packages/content/live_events/stolen_rations/stolen_rations_assets",
					use_raycast = true,
					levels = {
						level_size_2 = {
							"content/levels/live_events/stolen_rations/stolen_rations_01_prop_medium",
							"content/levels/live_events/stolen_rations/stolen_rations_01_prop_medium",
							"content/levels/live_events/stolen_rations/stolen_rations_01_prop_small",
							"content/levels/live_events/stolen_rations/stolen_rations_01_prop_small",
							"content/levels/live_events/stolen_rations/stolen_rations_01_prop_small",
							"content/levels/live_events/stolen_rations/stolen_rations_01_prop_small",
							"content/levels/live_events/stolen_rations/stolen_rations_01_prop_small",
							"content/levels/live_events/stolen_rations/stolen_rations_01_prop_small",
						},
					},
					placement_method = MutatorSpawnerNode.CIRCLE_PLACEMENT,
					size_lookup = {
						"level_size_2",
					},
					spawn_settings = {
						count = 5,
						position_offset = 5,
						randomize_rotation = true,
					},
				},
			},
		},
	},
	mutator_stolen_rations_recover_mutant_waves = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				min_players_alive = 2,
				not_during_terror_events = false,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_mutants,
							},
							low = {
								HordeCompositions.mutator_mutants,
							},
							high = {
								HordeCompositions.mutator_mutants,
							},
							poxwalkers = {
								HordeCompositions.mutator_mutants,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_mutants,
							},
							low = {
								HordeCompositions.mutator_mutants,
							},
							high = {
								HordeCompositions.mutator_mutants,
							},
							poxwalkers = {
								HordeCompositions.mutator_mutants,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					60,
					180,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				optional_main_path_offset = {
					-60,
					60,
				},
				num_trickle_waves = {
					{
						3,
						5,
					},
					{
						5,
						7,
					},
					{
						7,
						9,
					},
					{
						9,
						11,
					},
					{
						11,
						13,
					},
				},
				time_between_waves = {
					0.25,
					1,
				},
			},
		},
	},
	mutator_stolen_rations_headshot_parasite_enemies = {
		class = "scripts/managers/mutator/mutators/mutator_minion_visual_override",
		template_name = "head_parasite",
		random_spawn_buff_templates = {
			buffs = {
				"headshot_parasite_enemies",
			},
			breed_chances = {
				chaos_armored_infected = 0.15,
				chaos_beast_of_nurgle = 0,
				chaos_daemonhost = 0,
				chaos_hound = 0,
				chaos_lesser_mutated_poxwalker = 0.2,
				chaos_mutated_poxwalker = 0.25,
				chaos_newly_infected = 0.25,
				chaos_ogryn_bulwark = 0.2,
				chaos_ogryn_executor = 0.2,
				chaos_ogryn_gunner = 0.2,
				chaos_plague_ogryn = 0,
				chaos_poxwalker = 0.25,
				chaos_poxwalker_bomber = 0,
				chaos_spawn = 0,
				cultist_assault = 0.15,
				cultist_berzerker = 0.1,
				cultist_flamer = 0.1,
				cultist_grenadier = 0.1,
				cultist_gunner = 0.1,
				cultist_melee = 0.1,
				cultist_mutant = 0,
				cultist_shocktrooper = 0.15,
				renegade_assault = 0.15,
				renegade_berzerker = 0.25,
				renegade_captain = 0,
				renegade_executor = 0.05,
				renegade_flamer = 0.05,
				renegade_grenadier = 0.1,
				renegade_gunner = 0.1,
				renegade_melee = 0.1,
				renegade_netgunner = 0,
				renegade_rifleman = 0.15,
				renegade_shocktrooper = 0.15,
				renegade_sniper = 0,
			},
		},
	},
	mutator_respawn_modifier = {
		activate_on_load = false,
		class = "scripts/managers/mutator/mutators/mutator_respawn_modifier",
		respawn_state = "walking",
		time = 0,
	},
}

return mutator_templates
