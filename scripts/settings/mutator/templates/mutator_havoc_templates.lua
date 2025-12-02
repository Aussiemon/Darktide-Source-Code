-- chunkname: @scripts/settings/mutator/templates/mutator_havoc_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local HavocMutatorLocalSettings = require("scripts/settings/havoc/havoc_mutator_local_settings")
local mutator_stimmed_minions_breed_chances = HavocMutatorLocalSettings.mutator_stimmed_minions.breed_chances
local mutator_encroaching_gardens_breed_chances = HavocMutatorLocalSettings.mutator_encroaching_garden.breed_chances
local mutator_havoc_enraged_breed_chances = HavocMutatorLocalSettings.mutator_havoc_enraged.breed_chances
local mutator_havoc_tougher_skin_breed_chances = HavocMutatorLocalSettings.mutator_havoc_tougher_skin.breed_chances
local bolstering_minions_01_breed_chances = HavocMutatorLocalSettings.bolstering_minions_01.breed_chances
local mutator_havoc_enemies_parasite_headshot_breed_chances = HavocMutatorLocalSettings.mutator_havoc_enemies_parasite_headshot.breed_chances
local mutator_havoc_rotten_armor_breed_chances = HavocMutatorLocalSettings.mutator_havoc_rotten_armor.breed_chances
local mutator_havoc_enemies_corrupted_breed_chances = HavocMutatorLocalSettings.mutator_havoc_enemies_corrupted.breed_chances
local buff_keywords = BuffSettings.keywords
local mutator_templates = {
	mutator_common_minions_on_fire = {
		class = "scripts/managers/mutator/mutators/mutator_modify_havoc",
		init_modify_horde = {
			horde_buffed_config = {
				buff_name = "common_minion_on_fire",
				breed_allowed = {
					chaos_newly_infected = true,
					chaos_poxwalker = true,
				},
			},
		},
	},
	mutator_corrupted_enemies = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"havoc_corrupted_enemies",
			},
			breed_chances = mutator_havoc_enemies_corrupted_breed_chances,
		},
	},
	mutator_rotten_armor = {
		class = "scripts/managers/mutator/mutators/mutator_minion_visual_override",
		template_name = "rotten_armor",
		random_spawn_buff_templates = {
			buffs = {
				"mutator_rotten_armor",
			},
			breed_chances = mutator_havoc_rotten_armor_breed_chances,
		},
		fx_overrides = {
			override_armor_type = "rotten_armor",
		},
	},
	mutator_headshot_parasite_enemies = {
		class = "scripts/managers/mutator/mutators/mutator_minion_visual_override",
		template_name = "head_parasite",
		random_spawn_buff_templates = {
			buffs = {
				"headshot_parasite_enemies",
			},
			breed_chances = mutator_havoc_enemies_parasite_headshot_breed_chances,
		},
	},
	mutator_bolstering_minions = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"havoc_bolstering",
			},
			ignored_buff_keyword = buff_keywords.stimmed,
			breed_chances = bolstering_minions_01_breed_chances,
		},
	},
	mutator_tough_skin_enemies = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"havoc_toughened_skin",
			},
			breed_chances = mutator_havoc_tougher_skin_breed_chances,
		},
	},
	mutator_havoc_sticky_poxburster = {
		class = "scripts/managers/mutator/mutators/mutator_nurgle_warp",
		random_spawn_buff_templates = {
			buffs = {
				"havoc_sticky_poxburster",
			},
			breed_chances = {
				chaos_armored_bomber = 1,
				chaos_poxwalker_bomber = 1,
			},
		},
		compositions = {
			{
				"chaos_poxwalker",
				"chaos_poxwalker",
				"chaos_poxwalker",
				"chaos_lesser_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
			},
			{
				"chaos_lesser_mutated_poxwalker",
				"chaos_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
			},
			{
				"chaos_lesser_mutated_poxwalker",
				"chaos_poxwalker",
				"chaos_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
				"chaos_mutated_poxwalker",
			},
		},
	},
	mutator_havoc_enraged = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"havoc_enraged_enemies_trigger",
			},
			breed_chances = mutator_havoc_enraged_breed_chances,
		},
	},
	mutator_encroaching_garden = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"havoc_encroaching_garden",
			},
			breed_chances = mutator_encroaching_gardens_breed_chances,
		},
	},
	mutator_havoc_no_stagger_ritualist = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"havoc_no_stagger",
			},
			breed_chances = {
				chaos_mutator_ritualist = 1,
			},
		},
	},
	mutator_enable_auric = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			is_auric = true,
		},
	},
	mutator_stimmed_minions = {
		class = "scripts/managers/mutator/mutators/mutator_stimmed_minions",
		breed_chances = mutator_stimmed_minions_breed_chances,
	},
	mutator_havoc_override_horde_pacing_01 = {
		class = "scripts/managers/mutator/mutators/mutator_horde_pacing_overrides",
		pacing_override = "havoc_01",
		template_name = "mutator_horde",
	},
	mutator_havoc_override_horde_pacing_02 = {
		class = "scripts/managers/mutator/mutators/mutator_horde_pacing_overrides",
		pacing_override = "havoc_02",
		template_name = "mutator_horde",
	},
	mutator_havoc_bauble = {
		class = "scripts/managers/mutator/mutators/mutator_pestilent_bauble",
	},
}

return mutator_templates
