local mutator_templates = {
	mutator_minion_nurgle_blessing = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"mutator_minion_nurgle_blessing_tougher",
				"mutator_minion_nurgle_blessing_heal_over_time"
			},
			breed_chances = {
				cultist_assault = 0.2,
				chaos_hound = 1,
				cultist_mutant = 1,
				chaos_plague_ogryn = 1,
				cultist_berzerker = 0.4,
				chaos_beast_of_nurgle = 1,
				chaos_ogryn_bulwark = 0.3,
				chaos_newly_infected = 0.2,
				cultist_melee = 0.2,
				chaos_poxwalker = 0.2,
				chaos_ogryn_gunner = 0.3,
				cultist_shocktrooper = 0.4,
				cultist_gunner = 0.4,
				chaos_ogryn_executor = 0.3,
				cultist_flamer = 1
			}
		}
	},
	mutator_corruption_over_time = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		buff_templates = {
			"mutator_corruption_over_time"
		}
	},
	mutator_corruption_over_time_2 = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		buff_templates = {
			"mutator_corruption_over_time_2"
		}
	},
	mutator_stimmed_minions = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"mutator_stimmed_minion"
			},
			breed_chances = {
				renegade_flamer = 0.25,
				cultist_mutant = 1,
				renegade_assault = 0.2,
				cultist_assault = 0.2,
				renegade_rifleman = 0.25,
				chaos_beast_of_nurgle = 1,
				chaos_ogryn_executor = 0.3,
				chaos_plague_ogryn = 1,
				cultist_melee = 0.2,
				chaos_poxwalker = 0.2,
				cultist_shocktrooper = 0.4,
				chaos_ogryn_gunner = 0.3,
				renegade_berzerker = 0.4,
				renegade_sniper = 0.4,
				renegade_shocktrooper = 0.4,
				renegade_gunner = 0.4,
				cultist_berzerker = 0.4,
				chaos_newly_infected = 0.2,
				chaos_hound = 1,
				chaos_ogryn_bulwark = 0.3,
				cultist_gunner = 0.4,
				renegade_melee = 0.2,
				renegade_executor = 0.4,
				cultist_flamer = 1
			}
		}
	}
}

return mutator_templates
