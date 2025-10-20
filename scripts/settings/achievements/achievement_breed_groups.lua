-- chunkname: @scripts/settings/achievements/achievement_breed_groups.lua

local BreedQueries = require("scripts/utilities/breed_queries")
local minion_breeds = BreedQueries.minion_breeds()
local path = "content/ui/textures/icons/achievements/"
local breed_kill_targets = {
	elite = {
		100,
		250,
		500,
		1000,
		1500,
	},
	special = {
		50,
		100,
		150,
		200,
		250,
	},
}
local AchievementBreedGroups = {}

AchievementBreedGroups.all = {
	"chaos_armored_infected",
	"chaos_beast_of_nurgle",
	"chaos_daemonhost",
	"chaos_hound_mutator",
	"chaos_hound",
	"chaos_lesser_mutated_poxwalker",
	"chaos_mutated_poxwalker",
	"chaos_mutator_daemonhost",
	"chaos_mutator_ritualist",
	"chaos_newly_infected",
	"chaos_ogryn_bulwark",
	"chaos_ogryn_executor",
	"chaos_ogryn_gunner",
	"chaos_plague_ogryn",
	"chaos_poxwalker_bomber",
	"chaos_poxwalker",
	"chaos_spawn",
	"cultist_assault",
	"cultist_berzerker",
	"cultist_captain",
	"cultist_flamer",
	"cultist_grenadier",
	"cultist_gunner",
	"cultist_melee",
	"cultist_mutant_mutator",
	"cultist_mutant",
	"cultist_ritualist",
	"cultist_shocktrooper",
	"renegade_assault",
	"renegade_berzerker",
	"renegade_captain",
	"renegade_executor",
	"renegade_flamer_mutator",
	"renegade_flamer",
	"renegade_grenadier",
	"renegade_gunner",
	"renegade_melee",
	"renegade_netgunner",
	"renegade_plasma_gunner",
	"renegade_radio_operator",
	"renegade_rifleman",
	"renegade_shocktrooper",
	"renegade_sniper",
	"renegade_twin_captain_two",
	"renegade_twin_captain",
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
	"renegade_plasma_gunner",
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
	"renegade_plasma_gunner",
	"renegade_shocktrooper",
}
AchievementBreedGroups.special_and_elite_breed_lookup = {
	{
		local_variable = "loc_breed_flamer_generic_desc",
		name = "flamer",
		title_local_variable = "loc_breed_flamer_generic_name",
		icon = path .. "havoc_achievements/havoc_missions_flamer",
		targets = breed_kill_targets.special,
	},
	{
		local_variable = "loc_breed_grenadier_generic_desc",
		name = "grenadier",
		title_local_variable = "loc_breed_grenadier_generic_name",
		icon = path .. "havoc_achievements/havoc_missions_grenadier",
		targets = breed_kill_targets.special,
	},
	{
		local_variable = "loc_breed_berzerker_generic_desc",
		name = "berzerker",
		title_local_variable = "loc_breed_berzerker_generic_name",
		icon = path .. "havoc_achievements/havoc_missions_rager",
		targets = breed_kill_targets.elite,
	},
	{
		local_variable = "loc_breed_gunner_generic_desc",
		name = "gunner",
		title_local_variable = "loc_breed_gunner_generic_name",
		icon = path .. "havoc_achievements/havoc_missions_gunner",
		targets = breed_kill_targets.special,
	},
	{
		local_variable = "loc_breed_display_name_renegade_netgunner",
		name = "renegade_netgunner",
		title_local_variable = "loc_breed_display_name_renegade_netgunner",
		icon = path .. "havoc_achievements/havoc_missions_trappers",
		targets = breed_kill_targets.special,
	},
	{
		local_variable = "loc_breed_display_name_renegade_sniper",
		name = "renegade_sniper",
		title_local_variable = "loc_breed_display_name_renegade_sniper",
		icon = path .. "havoc_achievements/havoc_missions_sniper",
		targets = breed_kill_targets.special,
	},
	{
		local_variable = "loc_breed_display_name_renegade_executor",
		name = "renegade_executor",
		title_local_variable = "loc_breed_display_name_renegade_executor",
		icon = path .. "havoc_achievements/havoc_missions_mauler",
		targets = breed_kill_targets.elite,
	},
	{
		local_variable = "loc_breed_shocktrooper_generic_desc",
		name = "shocktrooper",
		title_local_variable = "loc_breed_shocktrooper_generic_name",
		icon = path .. "havoc_achievements/havoc_missions_shocktrooper",
		targets = breed_kill_targets.elite,
	},
	{
		local_variable = "loc_breed_display_name_cultist_mutant",
		name = "cultist_mutant",
		title_local_variable = "loc_breed_display_name_cultist_mutant",
		icon = path .. "havoc_achievements/havoc_missions_charger",
		targets = breed_kill_targets.special,
	},
	{
		local_variable = "loc_breed_display_name_chaos_ogryn_bulwark",
		name = "chaos_ogryn_bulwark",
		title_local_variable = "loc_breed_display_name_chaos_ogryn_bulwark",
		icon = path .. "havoc_achievements/havoc_missions_bulwark",
		targets = breed_kill_targets.elite,
	},
	{
		local_variable = "loc_breed_display_name_chaos_ogryn_executor",
		name = "chaos_ogryn_executor",
		title_local_variable = "loc_breed_display_name_chaos_ogryn_executor",
		icon = path .. "havoc_achievements/havoc_missions_crusher_exec",
		targets = breed_kill_targets.elite,
	},
	{
		local_variable = "loc_breed_display_name_chaos_ogryn_gunner",
		name = "chaos_ogryn_gunner",
		title_local_variable = "loc_breed_display_name_chaos_ogryn_gunner",
		icon = path .. "havoc_achievements/havoc_missions_reaper",
		targets = breed_kill_targets.elite,
	},
	{
		local_variable = "loc_breed_display_name_chaos_hound",
		name = "chaos_hound",
		title_local_variable = "loc_breed_display_name_chaos_hound",
		icon = path .. "havoc_achievements/havoc_missions_pox_hound_penance",
		targets = breed_kill_targets.special,
	},
	{
		local_variable = "loc_breed_display_name_renegade_plasma_gunner",
		name = "renegade_plasma_gunner",
		title_local_variable = "loc_breed_display_name_renegade_plasma_gunner",
		icon = path .. "havoc_achievements/havoc_missions_plasma_gunner",
		targets = breed_kill_targets.elite,
	},
	{
		local_variable = "loc_breed_display_name_chaos_poxwalker_bomber",
		name = "chaos_poxwalker_bomber",
		title_local_variable = "loc_breed_display_name_chaos_poxwalker_bomber",
		icon = path .. "havoc_achievements/havoc_missions_poxbuster",
		targets = breed_kill_targets.special,
	},
}
AchievementBreedGroups.companion = {
	"companion_dog",
}

return AchievementBreedGroups
