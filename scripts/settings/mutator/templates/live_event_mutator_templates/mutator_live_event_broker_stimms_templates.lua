-- chunkname: @scripts/settings/mutator/templates/live_event_mutator_templates/mutator_live_event_broker_stimms_templates.lua

local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local MutatorStatTriggerUtilities = require("scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_utilities")
local EnemyCompositions = require("scripts/settings/live_event/live_event_enemy_compositions/live_event_broker_stimms_enemy_composition")
local mutator_templates = {
	mutator_player_buff_broker_stimms_syringe_speed = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/broker_stimms/live_event_broker_stimms_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_player_buff",
		trigger_on_events = {
			event_player_action_use_syringe = {
				pocketable_name = "syringe_speed_boost_pocketable",
			},
		},
		externally_controlled_buffs = {
			"live_event_broker_stimms_toxic_gas_resistance",
		},
	},
	mutator_player_buff_broker_stimms_syringe_heal_corruption = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/broker_stimms/live_event_broker_stimms_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_player_buff",
		trigger_on_events = {
			event_player_action_use_syringe = {
				pocketable_name = "syringe_corruption_pocketable",
			},
		},
		externally_controlled_buffs = {
			"live_event_broker_stimms_toxic_gas_resistance",
		},
	},
	mutator_player_buff_broker_stimms_syringe_ability = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/broker_stimms/live_event_broker_stimms_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_player_buff",
		trigger_on_events = {
			event_player_action_use_syringe = {
				pocketable_name = "syringe_ability_boost_pocketable",
			},
		},
		externally_controlled_buffs = {
			"live_event_broker_stimms_toxic_gas_resistance",
		},
	},
	mutator_player_buff_broker_stimms_syringe_power = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/broker_stimms/live_event_broker_stimms_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_player_buff",
		trigger_on_events = {
			event_player_action_use_syringe = {
				pocketable_name = "syringe_power_boost_pocketable",
			},
		},
		externally_controlled_buffs = {
			"live_event_broker_stimms_toxic_gas_resistance",
		},
	},
	mutator_player_buff_broker_stimms_broker_extra_buff = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/broker_stimms/live_event_broker_stimms_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_player_buff",
		trigger_on_events = {
			event_player_action_use_syringe = {
				pocketable_name = "syringe_broker_pocketable",
			},
		},
		externally_controlled_buffs = {
			"live_event_broker_stimms_toxic_gas_resistance",
		},
	},
	mutator_live_event_broker_stimms_crate_spawns = {
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		num_to_spawn = 7,
		trigger_distance = 55,
		spawn_locations = MutatorSpawnerLocationSources.prebaked_mission_locations("skulls_locations"),
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
				template = {
					asset_package = "packages/content/live_events/broker_stimms/live_event_broker_stimms_assets",
					use_raycast = false,
					levels = {
						level_size_4 = {
							"content/levels/live_events/broker_stimms/live_event_broker_stimms_props_01",
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
		},
	},
	mutator_live_event_broker_stimms_more_tox_bombers = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			chance_of_coordinated_strike = 0.2,
		},
		init_modify_pacing = {
			chance_of_coordinated_strike = 1,
			specials_timer_modifier = 0.75,
			max_alive_specials_multiplier = {
				1,
				1,
				1.25,
				1.25,
				1.5,
				2,
			},
			max_of_same_override = {
				cultist_grenadier = 4,
			},
		},
	},
	mutator_live_event_broker_stimms_stat_trigger = {
		activate_on_load = true,
		class = "scripts/managers/mutator/mutators/mutator_stat_trigger",
		team_stats = {
			live_event_stimms_used_team = {
				triggers = {
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count",
						template = {
							trigger_amount = 4,
							trigger_once = false,
							on_trigger = {
								MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde(EnemyCompositions.horde_01, "flood_horde"),
							},
						},
					},
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count",
						template = {
							trigger_amount = 8,
							trigger_once = false,
							on_trigger = {
								MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde(EnemyCompositions.horde_02, "flood_horde"),
							},
						},
					},
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count",
						template = {
							trigger_amount = 20,
							trigger_once = false,
							on_trigger = {
								MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde(EnemyCompositions.horde_03, "flood_horde"),
							},
						},
					},
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count",
						template = {
							trigger_amount = 48,
							trigger_once = false,
							on_trigger = {
								MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde(EnemyCompositions.horde_04, "flood_horde"),
							},
						},
					},
					{
						class = "scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count",
						template = {
							trigger_amount = 64,
							trigger_once = false,
							on_trigger = {
								MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde(EnemyCompositions.horde_05, "flood_horde"),
							},
						},
					},
				},
			},
		},
	},
	mutator_live_event_broker_stimms_gameplay = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/broker_stimms/live_event_broker_stimms_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_gameplay",
		gameplay_template = {
			path = "scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_broker_stimms",
			start_module_on_activate = true,
			settings = {
				buff = "live_event_broker_stimms_perma_buff",
			},
		},
	},
}

return mutator_templates
