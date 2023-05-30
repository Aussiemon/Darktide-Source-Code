local breeds = {}

local function _create_breed_entry(path)
	local breed_data = require(path)
	local breed_name = breed_data.name
	breeds[breed_name] = breed_data
end

_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_beast_of_nurgle_breed")
_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_daemonhost_breed")
_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_hound_breed")
_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_hound_mutator_breed")
_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_newly_infected_breed")
_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_ogryn_bulwark_breed")
_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_ogryn_executor_breed")
_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_ogryn_gunner_breed")
_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_plague_ogryn_breed")
_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_poxwalker_bomber_breed")
_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_poxwalker_breed")
_create_breed_entry("scripts/settings/breed/breeds/chaos/chaos_spawn_breed")
_create_breed_entry("scripts/settings/breed/breeds/cultist/cultist_assault_breed")
_create_breed_entry("scripts/settings/breed/breeds/cultist/cultist_berzerker_breed")
_create_breed_entry("scripts/settings/breed/breeds/cultist/cultist_flamer_breed")
_create_breed_entry("scripts/settings/breed/breeds/cultist/cultist_gunner_breed")
_create_breed_entry("scripts/settings/breed/breeds/cultist/cultist_melee_breed")
_create_breed_entry("scripts/settings/breed/breeds/cultist/cultist_mutant_breed")
_create_breed_entry("scripts/settings/breed/breeds/cultist/cultist_shocktrooper_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_assault_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_berzerker_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_captain_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_executor_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_flamer_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_grenadier_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_gunner_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_melee_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_netgunner_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_rifleman_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_shocktrooper_breed")
_create_breed_entry("scripts/settings/breed/breeds/renegade/renegade_sniper_breed")
_create_breed_entry("scripts/settings/breed/breeds/human_breed")
_create_breed_entry("scripts/settings/breed/breeds/ogryn_breed")

local init_breed_nav_settings_func = require("scripts/settings/breed/breed_nav_init")

init_breed_nav_settings_func(breeds)

local init_breed_settings_func = require("scripts/settings/breed/breed_init")

init_breed_settings_func(breeds)

return settings("Breeds", breeds)
