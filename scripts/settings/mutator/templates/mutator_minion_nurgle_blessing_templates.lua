-- chunkname: @scripts/settings/mutator/templates/mutator_minion_nurgle_blessing_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_keywords = BuffSettings.keywords
local mutator_templates = {
	mutator_minion_nurgle_blessing = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"mutator_minion_nurgle_blessing_tougher",
			},
			breed_chances = {
				chaos_beast_of_nurgle = 0.25,
				chaos_daemonhost = 0.25,
				chaos_hound = 0.15,
				chaos_hound_mutator = 0.1,
				chaos_newly_infected = 0.025,
				chaos_ogryn_bulwark = 0.1,
				chaos_ogryn_executor = 0.1,
				chaos_ogryn_gunner = 0.1,
				chaos_plague_ogryn = 0.25,
				chaos_poxwalker = 0.075,
				chaos_spawn = 0.25,
				cultist_assault = 0.05,
				cultist_berzerker = 0.15,
				cultist_flamer = 0.15,
				cultist_grenadier = 0.15,
				cultist_gunner = 0.1,
				cultist_melee = 0.05,
				cultist_mutant = 0.12,
				cultist_mutant_mutator = 0.1,
				cultist_shocktrooper = 0.15,
				renegade_assault = 0.05,
				renegade_berzerker = 0.15,
				renegade_captain = 0.1,
				renegade_executor = 0.1,
				renegade_flamer = 0.15,
				renegade_grenadier = 0.1,
				renegade_gunner = 0.1,
				renegade_melee = 0.05,
				renegade_netgunner = 0.15,
				renegade_rifleman = 0.05,
				renegade_shocktrooper = 0.15,
				renegade_sniper = 0.15,
			},
		},
	},
	mutator_corruption_over_time = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		buff_templates = {
			"mutator_corruption_over_time",
		},
	},
	mutator_corruption_over_time_2 = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		buff_templates = {
			"mutator_corruption_over_time_2",
		},
	},
	mutator_bolstering_minions = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"damnation_plus_bolstering_01",
			},
			ignored_buff_keyword = buff_keywords.stimmed,
			breed_chances = {
				chaos_beast_of_nurgle = 1,
				chaos_daemonhost = 0.1,
				chaos_hound = 0.35,
				chaos_newly_infected = 0.05,
				chaos_ogryn_bulwark = 0.35,
				chaos_ogryn_executor = 0.35,
				chaos_ogryn_gunner = 0.25,
				chaos_plague_ogryn = 1,
				chaos_poxwalker = 0.05,
				chaos_poxwalker_bomber = 0.35,
				chaos_spawn = 1,
				cultist_assault = 0.1,
				cultist_berzerker = 0.25,
				cultist_flamer = 0.35,
				cultist_grenadier = 0.35,
				cultist_gunner = 0.1,
				cultist_melee = 0.1,
				cultist_mutant = 0.35,
				cultist_shocktrooper = 0.25,
				renegade_assault = 0.1,
				renegade_berzerker = 0.25,
				renegade_captain = 0.2,
				renegade_executor = 0.25,
				renegade_flamer = 0.35,
				renegade_grenadier = 0.25,
				renegade_gunner = 0.25,
				renegade_melee = 0.1,
				renegade_netgunner = 0.35,
				renegade_rifleman = 0.1,
				renegade_shocktrooper = 0.25,
				renegade_sniper = 0.35,
			},
		},
	},
}

return mutator_templates
