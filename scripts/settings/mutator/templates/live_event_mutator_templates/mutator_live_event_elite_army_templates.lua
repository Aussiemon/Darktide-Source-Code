-- chunkname: @scripts/settings/mutator/templates/live_event_mutator_templates/mutator_live_event_elite_army_templates.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local RoamerPacks = require("scripts/settings/roamer/roamer_packs")
local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local mutator_templates = {
	mutator_live_elite_army_replacement = {
		class = "scripts/managers/mutator/mutators/mutator_replace_breed",
		init_replacement_breed = {
			breed_replacement = {
				chaos_newly_infected = "renegade_berzerker",
				chaos_poxwalker = "renegade_executor",
				cultist_melee = "cultist_berzerker",
				renegade_rifleman = "renegade_gunner",
			},
		},
	},
	mutator_live_elite_army_more_monsters = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			monster_spawn_type = "monsters",
			monsters_per_travel_distance = 90,
			monster_breed_name = {
				"chaos_plague_ogryn",
				"chaos_beast_of_nurgle",
				"chaos_spawn",
			},
		},
	},
	mutator_live_elite_army_less_roamers = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_num_roamer_range = {
				2,
				4,
			},
		},
	},
	mutator_live_elite_army_override_roamer_pack = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_roamer_packs = {
				low = {
					renegade = RoamerPacks.mutator_renegade_mixed_low_elite_only,
					cultist = RoamerPacks.mutator_cultist_mixed_low_elite_only,
				},
				high = {
					renegade = RoamerPacks.mutator_renegade_mixed_high_elite_only,
					cultist = RoamerPacks.mutator_cultist_mixed_high_elite_only,
				},
			},
		},
	},
	mutator_only_elite_terror_events = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			replace_terror_event_tags = {
				villains = {
					horde = "elite",
					roamer = "elite",
				},
			},
			replace_excluded_terror_event_tags = {
				villains = {
					elite = true,
				},
			},
		},
	},
	mutator_live_event_increase_terror_event_points = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			terror_event_point_multiplier = 1,
		},
	},
}

return mutator_templates
