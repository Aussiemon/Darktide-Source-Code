-- chunkname: @scripts/settings/mutator/templates/mutator_monster_spawner_templates.lua

local HavocMutatorLocalSettings = require("scripts/settings/havoc/havoc_mutator_local_settings")
local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local EnemyEventSpawnerSettings = require("scripts/settings/components/enemy_event_spawner_settings")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local havoc_twins_settings = HavocMutatorLocalSettings.mutator_havoc_twins_settings
local mutator_havoc_chaos_rituals = HavocMutatorLocalSettings.mutator_havoc_chaos_rituals
local mutator_templates = {
	mutator_monster_spawner = mutator_havoc_chaos_rituals,
	mutator_monster_havoc_twins = havoc_twins_settings,
	mutator_spawner_expedition_rotten_armor_size_04 = {
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		num_to_spawn = 4,
		proximity_trigger_distance = 30,
		spawn_type = "proximity",
		trigger_distance = 77,
		spawn_locations = MutatorSpawnerLocationSources.prebaked_mission_locations("expeditions_locations"),
		size = {
			level_size_4 = true,
		},
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
				template = {
					asset_package = "content/levels/expeditions/circumstances/exp_circ_assets",
					run_on_init = true,
					use_slot_specific_levels = true,
					levels = {
						level_size_4 = {
							"content/levels/expeditions/circumstances/exp_circ_04m_rotten_armor",
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
					composition = EnemyEventSpawnerSettings.nurgle_totem,
					enemy_placement_method = MutatorSpawnerNode.CIRCLE_PLACEMENT,
				},
			},
		},
	},
	mutator_spawner_expedition_rotten_armor_size_02 = {
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		num_to_spawn = 35,
		proximity_trigger_distance = 30,
		spawn_type = "proximity",
		trigger_distance = 77,
		spawn_locations = MutatorSpawnerLocationSources.prebaked_mission_locations("expeditions_locations"),
		size = {
			level_size_2 = true,
		},
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
				template = {
					asset_package = "content/levels/expeditions/circumstances/exp_circ_assets",
					run_on_init = true,
					use_slot_specific_levels = true,
					levels = {
						level_size_2 = {
							"content/levels/expeditions/circumstances/exp_circ_02m_rotten_armor_01",
						},
					},
					placement_method = MutatorSpawnerNode.SINGLE_PLACEMENT,
					size_lookup = {
						"level_size_2",
					},
					spawn_settings = {
						randomize_rotation = true,
					},
				},
			},
		},
	},
	mutator_plasma_smuggler_props = {
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		num_to_spawn = 3,
		trigger_distance = 55,
		spawn_locations = MutatorSpawnerLocationSources.prebaked_mission_locations("skulls_locations"),
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
				template = {
					asset_package = "packages/content/live_events/plasma_smugglers/plasma_smugglers_assets",
					use_raycast = true,
					levels = {
						level_size_4 = {
							"content/levels/live_events/plasma_smugglers_props_1",
							"content/levels/live_events/plasma_smugglers_props_2",
							"content/levels/live_events/plasma_smugglers_props_3",
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
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_horde_trigger",
				template = {},
			},
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_enemy_template",
				template = {
					placement_method = MutatorSpawnerNode.SINGLE_PLACEMENT,
					composition = EnemyEventSpawnerSettings.live_event_plasma_smugglers,
					enemy_placement_method = MutatorSpawnerNode.CIRCLE_PLACEMENT,
				},
			},
		},
	},
}

return mutator_templates
