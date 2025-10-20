-- chunkname: @scripts/settings/mutator/templates/mutator_monster_spawner_templates.lua

local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local MutatorSpawnerNodeLevelInstance = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance")
local MutatorSpawnerNodeHordeTrigger = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_horde_trigger")
local MutatorSpawnerNodeEnemyTemplate = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_enemy_template")
local EnemyEventSpawnerSettings = require("scripts/settings/components/enemy_event_spawner_settings")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local mutator_templates = {
	mutator_monster_spawner = {
		class = "scripts/managers/mutator/mutators/mutator_monster_spawner",
		spawner_template = {
			force_horde_on_spawn = true,
			trigger_distance = 55,
			monster_breed_name = {
				"chaos_mutator_daemonhost",
			},
			num_to_spawn_per_mission = {
				cm_archives = 5,
				cm_habs = 3,
				cm_raid = 5,
				core_research = 4,
				dm_forge = 5,
				dm_propaganda = 5,
				dm_rise = 5,
				dm_stockpile = 5,
				fm_armoury = 5,
				fm_cargo = 5,
				fm_resurgence = 5,
				hm_cartel = 5,
				hm_complex = 5,
				hm_strain = 5,
				km_enforcer = 5,
				km_heresy = 5,
				km_station = 5,
				lm_cooling = 5,
				lm_rails = 5,
				lm_scavenge = 5,
			},
		},
	},
	mutator_monster_havoc_twins = {
		class = "scripts/managers/mutator/mutators/mutator_monster_spawner",
		spawner_template = {
			force_horde_on_spawn = true,
			injection_template = "havoc_twins",
			num_to_spawn = 1,
			trigger_distance = 55,
			monster_breed_name = {
				"havoc_twins",
			},
		},
	},
	mutator_nurgle_totem = {
		asset_package = "content/characters/enemy/mutators/skull_totems_assets",
		class = "scripts/managers/mutator/mutators/mutator_monster_spawner",
		spawner_template = {
			force_horde_on_spawn = true,
			injection_template = "nurgle_totems",
			num_to_spawn = 3,
			spawn_locations = "skulls_locations",
			trigger_distance = 55,
			monster_breed_name = {
				"nurgle_totems",
			},
		},
	},
	mutator_plasma_smuggler_groups = {
		asset_package = "packages/content/live_events/plasma_smugglers/plasma_smugglers_assets",
		class = "scripts/managers/mutator/mutators/mutator_monster_spawner",
		spawner_template = {
			force_horde_on_spawn = true,
			injection_template = "plasma_smugglers",
			num_to_spawn = 3,
			spawn_locations = "skulls_locations",
			trigger_distance = 55,
			monster_breed_name = {
				"plasma_smugglers",
			},
		},
	},
	mutator_plasma_smuggler_groups_tree_test = {
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		num_to_spawn = 3,
		trigger_distance = 55,
		spawn_locations = MutatorSpawnerLocationSources.prebaked_mission_locations("skulls_locations"),
		spawners = {
			MutatorSpawnerNodeLevelInstance:new({
				asset_package = "packages/content/live_events/plasma_smugglers/plasma_smugglers_assets",
				run_on_init = true,
				levels = {
					"content/levels/live_events/plasma_smugglers_props_1",
					"content/levels/live_events/plasma_smugglers_props_2",
					"content/levels/live_events/plasma_smugglers_props_3",
				},
				placement_method = MutatorSpawnerNode.SINGLE_PLACEMENT,
				spawn_settings = {
					randomize_rotation = true,
				},
			}),
			MutatorSpawnerNodeHordeTrigger:new({}),
			MutatorSpawnerNodeEnemyTemplate:new({
				placement_method = MutatorSpawnerNode.SINGLE_PLACEMENT,
				composition = EnemyEventSpawnerSettings.live_event_plasma_smugglers,
				enemy_placement_method = MutatorSpawnerNode.CIRCLE_PLACEMENT,
			}),
		},
	},
}

return mutator_templates
