-- chunkname: @scripts/settings/mutator/templates/mutator_monster_spawner_templates.lua

local HavocMutatorLocalSettings = require("scripts/settings/havoc/havoc_mutator_local_settings")
local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local EnemyEventSpawnerSettings = require("scripts/settings/components/enemy_event_spawner_settings")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local havoc_twins_settings = HavocMutatorLocalSettings.mutator_havoc_twins_settings
local mutator_havoc_chaos_rituals = HavocMutatorLocalSettings.mutator_havoc_chaos_rituals
local mutator_templates = {
	mutator_monster_spawner = {
		class = "scripts/managers/mutator/mutators/mutator_monster_spawner",
		spawner_template = mutator_havoc_chaos_rituals,
	},
	mutator_monster_havoc_twins = {
		class = "scripts/managers/mutator/mutators/mutator_monster_spawner",
		spawner_template = havoc_twins_settings,
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
