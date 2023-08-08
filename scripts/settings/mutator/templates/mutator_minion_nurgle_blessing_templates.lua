local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_keywords = BuffSettings.keywords
local mutator_templates = {
	mutator_minion_nurgle_blessing = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"mutator_minion_nurgle_blessing_tougher"
			},
			breed_chances = {
				cultist_assault = 0.05,
				chaos_spawn = 0.25,
				renegade_assault = 0.05,
				cultist_flamer = 0.15,
				chaos_hound_mutator = 0.1,
				cultist_mutant = 0.12,
				chaos_daemonhost = 0.25,
				chaos_plague_ogryn = 0.25,
				cultist_melee = 0.05,
				chaos_poxwalker = 0.075,
				cultist_shocktrooper = 0.15,
				chaos_beast_of_nurgle = 0.25,
				chaos_ogryn_gunner = 0.1,
				renegade_berzerker = 0.15,
				chaos_newly_infected = 0.025,
				renegade_sniper = 0.15,
				renegade_flamer = 0.15,
				renegade_shocktrooper = 0.15,
				renegade_gunner = 0.1,
				renegade_netgunner = 0.15,
				cultist_berzerker = 0.15,
				renegade_rifleman = 0.05,
				renegade_grenadier = 0.1,
				cultist_grenadier = 0.15,
				renegade_captain = 0.1,
				chaos_hound = 0.15,
				chaos_ogryn_bulwark = 0.1,
				cultist_gunner = 0.1,
				renegade_melee = 0.05,
				renegade_executor = 0.1,
				chaos_ogryn_executor = 0.1
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
	mutator_stimmed_minions_blue = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"mutator_stimmed_minion_blue"
			},
			ignored_buff_keyword = buff_keywords.stimmed,
			breed_chances = {
				cultist_assault = 0.05,
				cultist_grenadier = 0.1,
				renegade_assault = 0.05,
				renegade_grenadier = 0.1,
				cultist_mutant = 0.25,
				renegade_flamer = 0.25,
				renegade_rifleman = 0.05,
				chaos_plague_ogryn = 0.1,
				cultist_melee = 0.05,
				chaos_poxwalker = 0.05,
				renegade_netgunner = 0.25,
				cultist_shocktrooper = 0.1,
				chaos_ogryn_gunner = 0.25,
				renegade_berzerker = 0.1,
				chaos_spawn = 0.1,
				renegade_sniper = 0.1,
				chaos_beast_of_nurgle = 0.1,
				renegade_shocktrooper = 0.1,
				renegade_gunner = 0.1,
				chaos_ogryn_executor = 0.25,
				cultist_berzerker = 0.1,
				chaos_newly_infected = 0.05,
				chaos_hound = 0.2,
				chaos_ogryn_bulwark = 0.25,
				cultist_gunner = 0.1,
				renegade_melee = 0.05,
				renegade_executor = 0.1,
				cultist_flamer = 0.1
			}
		}
	},
	mutator_stimmed_minions_red = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"mutator_stimmed_minion_red"
			},
			ignored_buff_keyword = buff_keywords.stimmed,
			breed_chances = {
				renegade_flamer = 0.2,
				cultist_mutant = 0.15,
				renegade_assault = 0.1,
				cultist_assault = 0.1,
				renegade_rifleman = 0.1,
				chaos_beast_of_nurgle = 0.2,
				chaos_ogryn_executor = 0.3,
				chaos_plague_ogryn = 0.2,
				cultist_melee = 0.1,
				chaos_poxwalker = 0.05,
				cultist_shocktrooper = 0.2,
				chaos_ogryn_gunner = 0.3,
				renegade_berzerker = 0.2,
				renegade_sniper = 0.2,
				renegade_shocktrooper = 0.2,
				renegade_gunner = 0.2,
				cultist_berzerker = 0.2,
				chaos_newly_infected = 0.05,
				chaos_hound = 0.15,
				chaos_ogryn_bulwark = 0.3,
				cultist_gunner = 0.2,
				renegade_melee = 0.2,
				renegade_executor = 0.2,
				cultist_flamer = 0.2
			}
		}
	},
	mutator_stimmed_minions_yellow = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			roamer_stimmed_config = {
				buff_name = "mutator_stimmed_minion_yellow",
				chance_to_stim_per_pack_size = {
					0.1,
					0.15,
					0.2,
					0.4
				}
			},
			specials_stimmed_config = {
				buff_name = "mutator_stimmed_minion_yellow",
				chance_to_stim = 0.3
			},
			trickle_horde_stimmed_config = {
				buff_name = "mutator_stimmed_minion_yellow",
				chance_to_stim = 1
			},
			boss_patrol_stimmed_config = {
				buff_name = "mutator_stimmed_minion_yellow",
				chance_to_stim = 1
			}
		}
	},
	mutator_stimmed_minions_green = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"mutator_stimmed_minion_green"
			},
			ignored_buff_keyword = buff_keywords.stimmed,
			breed_chances = {
				renegade_berzerker = 0.4,
				chaos_hound = 0.25,
				chaos_plague_ogryn = 0.1,
				chaos_ogryn_bulwark = 0.3,
				cultist_berzerker = 0.4,
				chaos_newly_infected = 0.2,
				cultist_melee = 0.1,
				chaos_poxwalker = 0.2,
				chaos_beast_of_nurgle = 0.1,
				renegade_melee = 0.1,
				renegade_executor = 0.4,
				chaos_ogryn_executor = 0.3
			}
		}
	},
	mutator_stimmed_minions_purple = {
		class = "scripts/managers/mutator/mutators/mutator_purple_stimmed",
		random_spawn_buff_templates = {
			buffs = {
				"mutator_stimmed_minion_purple"
			},
			ignored_buff_keyword = buff_keywords.stimmed,
			breed_chances = {
				renegade_flamer = 0.35,
				chaos_hound = 0.35,
				renegade_assault = 0.1,
				renegade_rifleman = 0.1,
				cultist_mutant = 0.35,
				cultist_assault = 0.1,
				chaos_daemonhost = 1,
				chaos_plague_ogryn = 1,
				cultist_melee = 0.1,
				chaos_poxwalker_bomber = 0.35,
				chaos_ogryn_executor = 0.35,
				cultist_shocktrooper = 0.25,
				chaos_ogryn_gunner = 0.25,
				renegade_berzerker = 0.25,
				renegade_netgunner = 0.35,
				renegade_sniper = 0.35,
				chaos_beast_of_nurgle = 1,
				renegade_shocktrooper = 0.25,
				renegade_gunner = 0.25,
				renegade_grenadier = 0.25,
				cultist_berzerker = 0.25,
				cultist_grenadier = 0.35,
				renegade_captain = 0.2,
				chaos_spawn = 1,
				chaos_ogryn_bulwark = 0.35,
				cultist_gunner = 0.1,
				renegade_melee = 0.1,
				renegade_executor = 0.25,
				cultist_flamer = 0.35
			}
		}
	}
}

return mutator_templates
