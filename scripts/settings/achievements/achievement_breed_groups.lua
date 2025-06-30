-- chunkname: @scripts/settings/achievements/achievement_breed_groups.lua

local BreedQueries = require("scripts/utilities/breed_queries")
local minion_breeds = BreedQueries.minion_breeds()
local path = "content/ui/textures/icons/achievements/"
local AchievementBreedGroups = {}

AchievementBreedGroups.all = {
	"chaos_armored_infected",
	"chaos_beast_of_nurgle",
	"chaos_daemonhost",
	"chaos_hound",
	"chaos_hound_mutator",
	"chaos_lesser_mutated_poxwalker",
	"chaos_mutated_poxwalker",
	"chaos_mutator_daemonhost",
	"chaos_mutator_ritualist",
	"chaos_newly_infected",
	"chaos_ogryn_bulwark",
	"chaos_ogryn_executor",
	"chaos_ogryn_gunner",
	"chaos_plague_ogryn",
	"chaos_poxwalker",
	"chaos_poxwalker_bomber",
	"chaos_spawn",
	"cultist_assault",
	"cultist_berzerker",
	"cultist_captain",
	"cultist_flamer",
	"cultist_grenadier",
	"cultist_gunner",
	"cultist_melee",
	"cultist_mutant",
	"cultist_mutant_mutator",
	"cultist_ritualist",
	"cultist_shocktrooper",
	"renegade_assault",
	"renegade_berzerker",
	"renegade_captain",
	"renegade_executor",
	"renegade_flamer",
	"renegade_flamer_mutator",
	"renegade_grenadier",
	"renegade_gunner",
	"renegade_melee",
	"renegade_netgunner",
	"renegade_radio_operator",
	"renegade_rifleman",
	"renegade_shocktrooper",
	"renegade_sniper",
	"renegade_twin_captain",
	"renegade_twin_captain_two",
}
AchievementBreedGroups.chaos = {
	"chaos_hound",
	"chaos_newly_infected",
	"chaos_ogryn_bulwark",
	"chaos_ogryn_executor",
	"chaos_ogryn_gunner",
	"chaos_plague_ogryn",
	"chaos_poxwalker",
	"chaos_poxwalker_bomber",
}
AchievementBreedGroups.chaos_special = {
	"chaos_hound",
	"chaos_poxwalker_bomber",
}
AchievementBreedGroups.chaos_elite = {
	"chaos_ogryn_bulwark",
	"chaos_ogryn_executor",
	"chaos_ogryn_gunner",
}
AchievementBreedGroups.cultist = {
	"cultist_assault",
	"cultist_berzerker",
	"cultist_flamer",
	"cultist_grenadier",
	"cultist_gunner",
	"cultist_melee",
	"cultist_mutant",
	"cultist_shocktrooper",
}
AchievementBreedGroups.cultist_special = {
	"cultist_flamer",
	"cultist_grenadier",
	"cultist_mutant",
}
AchievementBreedGroups.cultist_elite = {
	"cultist_berzerker",
	"cultist_gunner",
	"cultist_shocktrooper",
}
AchievementBreedGroups.renegade = {
	"renegade_assault",
	"renegade_berzerker",
	"renegade_executor",
	"renegade_flamer",
	"renegade_grenadier",
	"renegade_gunner",
	"renegade_melee",
	"renegade_netgunner",
	"renegade_rifleman",
	"renegade_shocktrooper",
	"renegade_sniper",
}
AchievementBreedGroups.renegade_special = {
	"renegade_flamer",
	"renegade_grenadier",
	"renegade_netgunner",
	"renegade_sniper",
}
AchievementBreedGroups.renegade_elite = {
	"renegade_berzerker",
	"renegade_executor",
	"renegade_gunner",
	"renegade_shocktrooper",
}
AchievementBreedGroups.special_and_elite_breed_lookup = {
	flamer = {
		local_variable = "loc_breed_flamer_generic_desc",
		name = "flamer",
		title_local_variable = "loc_breed_flamer_generic_name",
		icon = path .. "havoc_achievements/havoc_missions_flamer",
		targets = {
			50,
			100,
			150,
			200,
			250,
		},
	},
	grenadier = {
		local_variable = "loc_breed_grenadier_generic_desc",
		name = "grenadier",
		title_local_variable = "loc_breed_grenadier_generic_name",
		icon = path .. "havoc_achievements/havoc_missions_grenadier",
		targets = {
			50,
			100,
			150,
			200,
			250,
		},
	},
	berzerker = {
		local_variable = "loc_breed_berzerker_generic_desc",
		name = "berzerker",
		title_local_variable = "loc_breed_berzerker_generic_name",
		icon = path .. "havoc_achievements/havoc_missions_rager",
		targets = {
			100,
			250,
			500,
			1000,
			1500,
		},
	},
	gunner = {
		local_variable = "loc_breed_gunner_generic_desc",
		name = "gunner",
		title_local_variable = "loc_breed_gunner_generic_name",
		icon = path .. "havoc_achievements/havoc_missions_gunner",
		targets = {
			100,
			250,
			500,
			1000,
			1500,
		},
	},
	renegade_netgunner = {
		local_variable = "loc_breed_display_name_renegade_netgunner",
		name = "renegade_netgunner",
		title_local_variable = "loc_breed_display_name_renegade_netgunner",
		icon = path .. "havoc_achievements/havoc_missions_trappers",
		targets = {
			50,
			100,
			150,
			200,
			250,
		},
	},
	renegade_sniper = {
		local_variable = "loc_breed_display_name_renegade_sniper",
		name = "renegade_sniper",
		title_local_variable = "loc_breed_display_name_renegade_sniper",
		icon = path .. "havoc_achievements/havoc_missions_sniper",
		targets = {
			50,
			100,
			150,
			200,
			250,
		},
	},
	renegade_executor = {
		local_variable = "loc_breed_display_name_renegade_executor",
		name = "renegade_executor",
		title_local_variable = "loc_breed_display_name_renegade_executor",
		icon = path .. "havoc_achievements/havoc_missions_mauler",
		targets = {
			100,
			250,
			500,
			1000,
			1500,
		},
	},
	renegade_shocktrooper = {
		local_variable = "loc_breed_shocktrooper_generic_desc",
		name = "shocktrooper",
		title_local_variable = "loc_breed_shocktrooper_generic_name",
		icon = path .. "havoc_achievements/havoc_missions_shocktrooper",
		targets = {
			100,
			250,
			500,
			1000,
			1500,
		},
	},
	cultist_mutant = {
		local_variable = "loc_breed_display_name_cultist_mutant",
		name = "cultist_mutant",
		title_local_variable = "loc_breed_display_name_cultist_mutant",
		icon = path .. "havoc_achievements/havoc_missions_charger",
		targets = {
			50,
			100,
			150,
			200,
			250,
		},
	},
	chaos_ogryn_bulwark = {
		local_variable = "loc_breed_display_name_chaos_ogryn_bulwark",
		name = "chaos_ogryn_bulwark",
		title_local_variable = "loc_breed_display_name_chaos_ogryn_bulwark",
		icon = path .. "havoc_achievements/havoc_missions_bulwark",
		targets = {
			100,
			250,
			500,
			1000,
			1500,
		},
	},
	chaos_ogryn_executor = {
		local_variable = "loc_breed_display_name_chaos_ogryn_executor",
		name = "chaos_ogryn_executor",
		title_local_variable = "loc_breed_display_name_chaos_ogryn_executor",
		icon = path .. "havoc_achievements/havoc_missions_crusher_exec",
		targets = {
			100,
			250,
			500,
			1000,
			1500,
		},
	},
	chaos_ogryn_gunner = {
		local_variable = "loc_breed_display_name_chaos_ogryn_gunner",
		name = "chaos_ogryn_gunner",
		title_local_variable = "loc_breed_display_name_chaos_ogryn_gunner",
		icon = path .. "havoc_achievements/havoc_missions_reaper",
		targets = {
			100,
			250,
			500,
			1000,
			1500,
		},
	},
	chaos_hound = {
		local_variable = "loc_breed_display_name_chaos_hound",
		name = "chaos_hound",
		title_local_variable = "loc_breed_display_name_chaos_hound",
		icon = path .. "havoc_achievements/havoc_missions_pox_hound_penance",
		targets = {
			50,
			100,
			150,
			200,
			250,
		},
	},
	chaos_poxwalker_bomber = {
		local_variable = "loc_breed_display_name_chaos_poxwalker_bomber",
		name = "chaos_poxwalker_bomber",
		title_local_variable = "loc_breed_display_name_chaos_poxwalker_bomber",
		icon = path .. "havoc_achievements/havoc_missions_poxbuster",
		targets = {
			50,
			100,
			150,
			200,
			250,
		},
	},
}
AchievementBreedGroups.companion = {
	"companion_dog",
}

return AchievementBreedGroups
