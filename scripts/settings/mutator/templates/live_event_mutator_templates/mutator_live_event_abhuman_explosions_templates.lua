-- chunkname: @scripts/settings/mutator/templates/live_event_mutator_templates/mutator_live_event_abhuman_explosions_templates.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local mutator_templates = {
	mutator_drop_ogryn_grenade_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_ogryn_grenade_on_death",
			},
			breed_chances = {
				chaos_ogryn_bulwark = 0.5,
			},
		},
	},
	mutator_abhuman_explosions_grenade_regen_on_elite_kill = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/abhuman_explosions/abhuman_explosions_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_player_buff",
		trigger_on_events = {
			mission_buffs_event_player_spawned = {},
		},
		externally_controlled_buffs = {
			"live_event_abhuman_explosions_grenade_regen_on_elite_kill",
		},
	},
	mutator_live_abhuman_explosions_replacement = {
		class = "scripts/managers/mutator/mutators/mutator_replace_breed",
		init_replacement_breed = {
			breed_replacement = {
				cultist_berzerker = "chaos_ogryn_bulwark",
				cultist_gunner = "chaos_ogryn_gunner",
				renegade_berzerker = "chaos_ogryn_bulwark",
				renegade_executor = "chaos_ogryn_executor",
				renegade_gunner = "chaos_ogryn_gunner",
			},
		},
	},
}

return mutator_templates
