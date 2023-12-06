local breed_combat_ranges = {}

local function _create_breed_combat_range_entry(path)
	local combat_range_data = require(path)
	local breed_name = combat_range_data.name
	breed_combat_ranges[breed_name] = combat_range_data
end

_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/chaos/chaos_beast_of_nurgle_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/chaos/chaos_daemonhost_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/chaos/chaos_hound_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/chaos/chaos_hound_mutator_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/chaos/chaos_ogryn_bulwark_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/chaos/chaos_ogryn_executor_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/chaos/chaos_ogryn_gunner_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/chaos/chaos_poxwalker_bomber_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/chaos/chaos_poxwalker_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_assault_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_captain_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_executor_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_flamer_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_grenadier_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_gunner_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_melee_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_netgunner_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_twin_captain_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_twin_captain_two_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_rifleman_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_shocktrooper_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/renegade/renegade_sniper_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/cultist/cultist_assault_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/cultist/cultist_berzerker_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/cultist/cultist_flamer_combat_ranges")
_create_breed_combat_range_entry("scripts/settings/breed/breed_combat_ranges/cultist/cultist_shocktrooper_combat_ranges")

return settings("BreedCombatRanges", breed_combat_ranges)
