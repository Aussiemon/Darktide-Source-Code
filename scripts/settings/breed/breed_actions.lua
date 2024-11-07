-- chunkname: @scripts/settings/breed/breed_actions.lua

local breed_actions = {}

local function _create_breed_action_entry(path)
	local actions_data = require(path)
	local breed_name = actions_data.name

	breed_actions[breed_name] = actions_data
end

_create_breed_action_entry("scripts/settings/breed/breed_actions/bot_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_beast_of_nurgle_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_daemonhost_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_hound_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_newly_infected_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_armored_infected_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_ogryn_bulwark_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_mutated_poxwalker_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_lesser_mutated_poxwalker_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_ogryn_executor_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_ogryn_gunner_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_plague_ogryn_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_poxwalker_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_poxwalker_bomber_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/chaos/chaos_spawn_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/cultist/cultist_assault_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/cultist/cultist_berzerker_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/cultist/cultist_captain_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/cultist/cultist_flamer_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/cultist/cultist_grenadier_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/cultist/cultist_gunner_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/cultist/cultist_melee_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/cultist/cultist_mutant_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/cultist/cultist_shocktrooper_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_assault_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_berzerker_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_captain_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_executor_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_flamer_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_flamer_mutator_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_grenadier_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_gunner_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_melee_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_netgunner_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_twin_captain_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_twin_captain_two_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_rifleman_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_shocktrooper_actions")
_create_breed_action_entry("scripts/settings/breed/breed_actions/renegade/renegade_sniper_actions")

for _, actions_data in pairs(breed_actions) do
	for action_name, action_data in pairs(actions_data) do
		if type(action_data) == "table" then
			action_data.name = action_name
		end
	end
end

return settings("BreedActions", breed_actions)
