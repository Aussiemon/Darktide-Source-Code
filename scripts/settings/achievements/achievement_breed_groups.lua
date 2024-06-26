-- chunkname: @scripts/settings/achievements/achievement_breed_groups.lua

local BreedQueries = require("scripts/utilities/breed_queries")
local minion_breeds = BreedQueries.minion_breeds()
local path = "content/ui/textures/icons/achievements/"
local AchievementBreedGroups = {}

AchievementBreedGroups.all = {
	"chaos_beast_of_nurgle",
	"chaos_daemonhost",
	"chaos_hound",
	"chaos_hound_mutator",
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
	"cultist_flamer",
	"cultist_grenadier",
	"cultist_gunner",
	"cultist_melee",
	"cultist_mutant",
	"cultist_mutant_mutator",
	"cultist_shocktrooper",
	"renegade_assault",
	"renegade_berzerker",
	"renegade_captain",
	"renegade_executor",
	"renegade_flamer",
	"renegade_grenadier",
	"renegade_gunner",
	"renegade_melee",
	"renegade_netgunner",
	"renegade_twin_captain",
	"renegade_twin_captain_two",
	"renegade_rifleman",
	"renegade_shocktrooper",
	"renegade_sniper",
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

return AchievementBreedGroups
