-- chunkname: @scripts/settings/mutator/templates/live_event_mutator_templates/mutator_live_event_barren_templates.lua

local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local EnemyEventSpawnerSettings = require("scripts/settings/components/enemy_event_spawner_settings")
local LevelProps = require("scripts/settings/level_prop/level_props")
local ResistanceUtils = require("scripts/managers/pacing/utilities/resistance_utils")
local Breeds = require("scripts/settings/breed/breeds")
local _stimm_drop_breed_chances = {
	0.1,
	0.1,
	0.1,
	0.1,
	0.1,
	0.1,
}
local _deployable_drop_chances = {
	1,
	1,
	1,
	1,
	1,
	1,
}
local _grenade_drop_chances = {
	0.1,
	0.08,
	0.06,
	0.04,
	0.02,
	0.02,
}
local _small_clip_drop_chances = {
	0.1,
	0.08,
	0.06,
	0.04,
	0.02,
	0.02,
}
local _small_metal_drop_chances = {
	0.025,
	0.025,
	0.025,
	0.025,
	0.025,
	0.025,
}
local _small_platinum_drop_chances = {
	0.01,
	0.01,
	0.01,
	0.01,
	0.01,
	0.01,
}
local _all_breed_small_metal_chances = {}
local _all_breed_small_platinum_chances = {}

for breed, _ in pairs(Breeds) do
	_all_breed_small_metal_chances[breed] = _small_metal_drop_chances
	_all_breed_small_platinum_chances[breed] = _small_platinum_drop_chances
end

local mutator_templates = {
	mutator_live_event_barren_melee_elite_drops = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"live_event_barren_drop_random_stimm_on_death",
			},
			breed_chances = {
				renegade_berzerker = _stimm_drop_breed_chances,
				cultist_berzerker = _stimm_drop_breed_chances,
				renegade_executor = _stimm_drop_breed_chances,
				chaos_ogryn_bulwark = _stimm_drop_breed_chances,
				chaos_ogryn_executor = _stimm_drop_breed_chances,
			},
		},
	},
	mutator_live_event_barren_monstrosity_drops = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"live_event_barren_drop_random_deployable_on_death",
			},
			breed_chances = {
				chaos_beast_of_nurgle = _deployable_drop_chances,
				chaos_daemonhost = _deployable_drop_chances,
				chaos_plague_ogryn = _deployable_drop_chances,
				chaos_spawn = _deployable_drop_chances,
				chaos_ogryn_houndmaster = _deployable_drop_chances,
			},
		},
	},
	mutator_live_event_barren_grenadier_drops = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"live_event_barren_drop_grenade_on_death",
			},
			breed_chances = {
				cultist_grenadier = _grenade_drop_chances,
				renegade_grenadier = _grenade_drop_chances,
			},
		},
	},
	mutator_live_event_barren_ranged_elite_drops = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"live_event_barren_drop_small_clip_on_death",
			},
			breed_chances = {
				chaos_ogryn_gunner = _small_clip_drop_chances,
				cultist_gunner = _small_clip_drop_chances,
				cultist_shocktrooper = _small_clip_drop_chances,
				renegade_gunner = _small_clip_drop_chances,
				renegade_netgunner = _small_clip_drop_chances,
				renegade_plasma_gunner = _small_clip_drop_chances,
				renegade_shocktrooper = _small_clip_drop_chances,
				renegade_sniper = _small_clip_drop_chances,
				cultist_flamer = _small_clip_drop_chances,
				renegade_flamer = _small_clip_drop_chances,
			},
		},
	},
	mutator_live_event_barren_drop_small_metal_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"live_event_barren_drop_small_metal_on_death",
			},
			breed_chances = _all_breed_small_metal_chances,
		},
	},
	mutator_live_event_barren_drop_small_platinum_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"live_event_barren_drop_small_platinum_on_death",
			},
			breed_chances = _all_breed_small_platinum_chances,
		},
	},
	mutator_live_event_barren_gameplay_lua = {
		activate_on_load = true,
		class = "scripts/managers/mutator/mutators/mutator_gameplay",
		gameplay_template = {
			path = "scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_barren_lua",
			start_module_on_activate = true,
			settings = {},
		},
	},
}

return mutator_templates
