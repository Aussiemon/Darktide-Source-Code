local Hooks = require("scripts/managers/stats/groups/hook_stats")
local Factory = require("scripts/managers/stats/utility/stat_factory")
local Flags = require("scripts/settings/stats/stat_flags")
local Activations = require("scripts/managers/stats/utility/activation_functions")
local Comparators = require("scripts/managers/stats/utility/comparator_functions")
local Conditions = require("scripts/managers/stats/utility/conditional_functions")
local Parameters = require("scripts/managers/stats/utility/parameter_functions")
local Values = require("scripts/managers/stats/utility/value_functions")
local BreedGroups = require("scripts/settings/achievements/achievement_breed_groups")
local WeaponCategories = require("scripts/settings/achievements/achievement_weapon_categories")
local MissionTypes = require("scripts/settings/mission/mission_types")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local AchievementStats = Factory.create_group()
local FROM_START_OF_MISSION_PROGRESSION_CUTOFF = 0.05
local _specializations = {
	"zealot_2",
	"psyker_2",
	"veteran_2",
	"ogryn_2"
}
local _weakspot_condition = Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_kill, "weapon_attack_type", "ranged"), Conditions.is_weakspot(Hooks.definitions.hook_kill))

local function _get_parameter_value(stat_to_check, parameter_name, ...)
	local index_of_parameter = table.index_of(stat_to_check:get_parameters(), parameter_name)
	local parameter_value = select(index_of_parameter, ...)

	return parameter_value
end

Factory.add_to_group(AchievementStats, Factory.ping_on_any("death_or_down", nil, Hooks.definitions.hook_death, Hooks.definitions.hook_knock_down))
Factory.add_to_group(AchievementStats, Factory.create_flag("has_died", Hooks.definitions.hook_death))
Factory.add_to_group(AchievementStats, Factory.create_flag("has_been_downed", AchievementStats.definitions.death_or_down))
Factory.add_to_group(AchievementStats, Factory.create_flag("has_taken_damage", Hooks.definitions.hook_damage_taken))
Factory.add_to_group(AchievementStats, Factory.create_echo("dash_dodges", Hooks.definitions.hook_dodge, Conditions.param_has_value(Hooks.definitions.hook_dodge, "reason", "dodge")))
Factory.add_to_group(AchievementStats, Factory.create_simple("progression_when_player_joined", Hooks.definitions.hook_player_joined, Activations.min, nil, 1))
Factory.add_to_group(AchievementStats, Factory.create_echo("flawless_mission", Hooks.definitions.hook_mission, Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.inverse(Conditions.flag_is_set(AchievementStats.definitions.has_been_downed)), Conditions.stat_is_less_then(AchievementStats.definitions.progression_when_player_joined, FROM_START_OF_MISSION_PROGRESSION_CUTOFF))))
Factory.add_to_group(AchievementStats, Factory.create_echo("flawless_mission_difficult", AchievementStats.definitions.flawless_mission, Conditions.param_is_greater_then(AchievementStats.definitions.flawless_mission, "difficulty", 2)))
Factory.add_to_group(AchievementStats, Factory.create_dynamic_reducer("boss_damage_by_id", Hooks.definitions.hook_damage, {
	"id"
}, Activations.on_condition(Conditions.breed_is_boss(Hooks.definitions.hook_damage), Activations.sum)))
Factory.add_to_group(AchievementStats, Factory.create_flag("used_range_weapon_flag", Hooks.definitions.hook_ranged_attack_concluded))
Factory.add_to_group(AchievementStats, Factory.create_flag_switch("alternate_fire_active", Hooks.definitions.hook_alternate_fire_start, Hooks.definitions.hook_alternate_fire_stop))
Factory.add_to_group(AchievementStats, Factory.create_flag_switch("lunge_active", Hooks.definitions.hook_lunge_start, Hooks.definitions.hook_lunge_stop))
Factory.add_to_group(AchievementStats, Factory.create_echo("off_ledge_kills", Hooks.definitions.hook_kill, Conditions.param_has_value(Hooks.definitions.hook_kill, "damage_profile_name", "kill_volume_and_ofF_navmesh")))
Factory.add_to_group(AchievementStats, Factory.create_echo("hit_weakspot", Hooks.definitions.hook_ranged_attack_concluded, Conditions.param_has_value(Hooks.definitions.hook_ranged_attack_concluded, "hit_weakspot", true)))
Factory.add_to_group(AchievementStats, Factory.create_echo("missed_weakspot", Hooks.definitions.hook_ranged_attack_concluded, Conditions.param_has_value(Hooks.definitions.hook_ranged_attack_concluded, "hit_weakspot", false)))
Factory.add_to_group(AchievementStats, Factory.create_echo("head_shot_kill", Hooks.definitions.hook_kill, _weakspot_condition))
Factory.add_to_group(AchievementStats, Factory.create_echo("non_head_shot_kill", Hooks.definitions.hook_kill, Conditions.inverse(_weakspot_condition)))

local function _add_generic_weapon_stats(category_name)
	local echo_id = string.format("kill_%s", category_name)

	Factory.add_to_group(AchievementStats, Factory.create_echo(echo_id, Hooks.definitions.hook_kill, Conditions.weapon_has_keywords(Hooks.definitions.hook_kill, WeaponCategories[category_name])))

	local total_kill_id = string.format("total_kills_%s", category_name)

	Factory.add_to_group(AchievementStats, Factory.create_simple(total_kill_id, AchievementStats.definitions[echo_id], Activations.clamp(Activations.increment, 0, 40000), {
		Flags.save_to_backend
	}))

	local kill_flag_id = string.format("_flag_%s_kill", category_name)

	Factory.add_to_group(AchievementStats, Factory.create_flag(kill_flag_id, AchievementStats.definitions[echo_id]))

	local missions_won_with_weapon_id = string.format("missions_%s", category_name)

	Factory.add_to_group(AchievementStats, Factory.create_simple(missions_won_with_weapon_id, Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.flag_is_set(AchievementStats.definitions[kill_flag_id])), Activations.clamp(Activations.increment, 0, 250)), {
		Flags.save_to_backend
	}))
end

for i = 1, #_specializations do
	local specialization = _specializations[i]
	local id = string.format("max_rank_%s", specialization)

	Factory.add_to_group(AchievementStats, Factory.create_simple(id, Hooks.definitions.hook_spawn_player, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_spawn_player, "player_class", specialization), Activations.clamp(Activations.max, 1, 30)), {
		Flags.save_to_backend
	}))
end

local function _complete_all_mission_types(id, ...)
	local flags = {}

	for _, mission_type in pairs(MissionTypes) do
		local flag_id = string.format("_%s_%s_flag", id, mission_type.id)

		Factory.add_to_group(AchievementStats, Factory.create_flag(flag_id, Hooks.definitions.hook_mission, Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.param_has_value(Hooks.definitions.hook_mission, "main_objective_type", mission_type.id), ...), {
			Flags.save_to_backend
		}))

		flags[#flags + 1] = AchievementStats.definitions[flag_id]
	end

	Factory.add_to_group(AchievementStats, Factory.create_flag_checker(id, flags, {
		Flags.save_to_backend
	}))
end

Factory.add_to_group(AchievementStats, Factory.create_simple("missions", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Activations.clamp(Activations.increment, 0, 1500)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("mission_flash", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.param_has_value(Hooks.definitions.hook_mission, "is_flash", true)), Activations.clamp(Activations.increment, 0, 200)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("highest_flash_difficulty", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.param_has_value(Hooks.definitions.hook_mission, "is_flash", true)), Activations.clamp(Activations.replace_trigger_value(Activations.max, Values.param(Hooks.definitions.hook_mission, "difficulty")), 0, 5)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("mission_circumstance", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.inverse(Conditions.param_has_value(Hooks.definitions.hook_mission, "circumstance_name", "default"))), Activations.clamp(Activations.increment, 0, 500)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("mission_no_damage", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.inverse(Conditions.flag_is_set(AchievementStats.definitions.has_taken_damage)), Conditions.stat_is_less_then(AchievementStats.definitions.progression_when_player_joined, FROM_START_OF_MISSION_PROGRESSION_CUTOFF)), Activations.set(1)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_in_a_row("flawless_mission_in_a_row", AchievementStats.definitions.flawless_mission_difficult, AchievementStats.definitions.death_or_down, {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_flawless_mission_in_a_row", AchievementStats.definitions.flawless_mission_in_a_row, Activations.clamp(Activations.max, 0, 15), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("team_flawless_missions", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.param_has_value(Hooks.definitions.hook_mission, "team_downs", 0), Conditions.stat_is_less_then(AchievementStats.definitions.progression_when_player_joined, FROM_START_OF_MISSION_PROGRESSION_CUTOFF)), Activations.clamp(Activations.increment, 0, 100)), {
	Flags.save_to_backend
}))

for i = 1, #_specializations do
	local specialization = _specializations[i]
	local id = string.format("missions_%s", specialization)

	Factory.add_to_group(AchievementStats, Factory.create_simple(id, Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "player_class", specialization), Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true)), Activations.clamp(Activations.increment, 0, 250)), {
		Flags.save_to_backend
	}))
end

for _, mission_type in pairs(MissionTypes) do
	local id = string.format("type_%s_missions", mission_type.id)

	Factory.add_to_group(AchievementStats, Factory.create_simple(id, Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "main_objective_type", mission_type.id), Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true)), Activations.clamp(Activations.sum, 0, 250)), {
		Flags.save_to_backend
	}))
end

for i = 1, #_specializations do
	local specialization = _specializations[i]

	_complete_all_mission_types(string.format("mission_%s_1_objectives", specialization), Conditions.param_has_value(Hooks.definitions.hook_mission, "player_class", specialization))
	_complete_all_mission_types(string.format("mission_%s_2_objectives", specialization), Conditions.param_has_value(Hooks.definitions.hook_mission, "player_class", specialization), Conditions.param_is_greater_then(Hooks.definitions.hook_mission, "difficulty", 2))
	_complete_all_mission_types(string.format("mission_%s_3_objectives", specialization), Conditions.param_has_value(Hooks.definitions.hook_mission, "player_class", specialization), Conditions.param_is_greater_then(Hooks.definitions.hook_mission, "difficulty", 3))
end

for difficulty = 1, 5 do
	_complete_all_mission_types(string.format("mission_difficulty_%s_objectives", difficulty), Conditions.param_is_greater_then(Hooks.definitions.hook_mission, "difficulty", difficulty - 1))
end

for i = 1, #BreedGroups.all do
	local breed_name = BreedGroups.all[i]
	local stat_name = string.format("_echo_%s_kills", breed_name)

	Factory.add_to_group(AchievementStats, Factory.create_echo(stat_name, Hooks.definitions.hook_kill, Conditions.param_has_value(Hooks.definitions.hook_kill, "breed_name", breed_name)))
end

local function _kill_group(id, needed_kills, breed_name_array)
	local _stats = {}

	for i = 1, #breed_name_array do
		local breed_name = breed_name_array[i]
		local echo_id = string.format("_echo_%s_kills", breed_name)
		local stat_name = string.format("_%s_%s", id, breed_name)

		Factory.add_to_group(AchievementStats, Factory.create_simple(stat_name, AchievementStats.definitions[echo_id], Activations.clamp(Activations.increment, 0, needed_kills), {
			Flags.save_to_backend
		}))

		_stats[#_stats + 1] = AchievementStats.definitions[stat_name]
	end

	Factory.add_to_group(AchievementStats, Factory.create_merger(id, _stats, Activations.on_condition(Conditions.trigger_value_equals_to(needed_kills), Activations.clamp(Activations.increment, 0, #_stats)), {
		Flags.save_to_backend
	}))
end

_kill_group("chaos_specials_killed", 10, BreedGroups.chaos_special)
_kill_group("chaos_elites_killed", 10, BreedGroups.chaos_elite)
_kill_group("chaos_killed", 1, BreedGroups.chaos)
_kill_group("cultist_specials_killed", 10, BreedGroups.cultist_special)
_kill_group("cultist_elites_killed", 10, BreedGroups.cultist_elite)
_kill_group("cultist_killed", 1, BreedGroups.cultist)
_kill_group("renegade_specials_killed", 10, BreedGroups.renegade_special)
_kill_group("renegade_elites_killed", 10, BreedGroups.renegade_elite)
_kill_group("renegade_killed", 1, BreedGroups.renegade)
Factory.add_to_group(AchievementStats, Factory.create_simple("total_renegade_grenadier_melee", AchievementStats.definitions._echo_renegade_grenadier_kills, Activations.on_condition(Conditions.param_has_value(AchievementStats.definitions._echo_renegade_grenadier_kills, "weapon_attack_type", "melee"), Activations.clamp(Activations.increment, 0, 10)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_renegade_executors_non_headshot", AchievementStats.definitions._echo_renegade_executor_kills, Activations.on_condition(Conditions.inverse(_weakspot_condition), Activations.clamp(Activations.increment, 0, 10)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_cultist_berzerker_head", AchievementStats.definitions._echo_cultist_berzerker_kills, Activations.on_condition(Conditions.param_has_value(AchievementStats.definitions._echo_cultist_berzerker_kills, "hit_zone_name", "head"), Activations.clamp(Activations.increment, 0, 10)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_ogryn_gunner_melee", AchievementStats.definitions._echo_chaos_ogryn_gunner_kills, Activations.on_condition(Conditions.param_has_value(AchievementStats.definitions._echo_chaos_ogryn_gunner_kills, "weapon_attack_type", "melee"), Activations.clamp(Activations.increment, 0, 10)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("kill_daemonhost", Hooks.definitions.hook_boss_kill, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_boss_kill, "breed_name", "chaos_daemonhost"), Activations.set(1)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_kills", Hooks.definitions.hook_kill, Activations.clamp(Activations.increment, 0, 1000000), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_renegade_kills", Hooks.definitions.hook_kill, Activations.on_condition(Conditions.breed_is_faction(Hooks.definitions.hook_kill, "renegade"), Activations.clamp(Activations.increment, 0, 25000)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_cultist_kills", Hooks.definitions.hook_kill, Activations.on_condition(Conditions.breed_is_faction(Hooks.definitions.hook_kill, "cultist"), Activations.clamp(Activations.increment, 0, 25000)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_chaos_kills", Hooks.definitions.hook_kill, Activations.on_condition(Conditions.breed_is_faction(Hooks.definitions.hook_kill, "chaos"), Activations.clamp(Activations.increment, 0, 50000)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_sum_over_time("kills_last_60_sec", Hooks.definitions.hook_kill, 60))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_kills_last_60_sec", AchievementStats.definitions.kills_last_60_sec, Activations.clamp(Activations.max, 0, 120), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("kill_climbing", Hooks.definitions.hook_kill, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_kill, "action", "climb"), Activations.clamp(Activations.increment, 0, 50)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_sum_over_time("head_shot_kills_last_10_sec", AchievementStats.definitions.head_shot_kill, 10))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_head_shot_kills_last_10_sec", AchievementStats.definitions.head_shot_kills_last_10_sec, Activations.clamp(Activations.max, 0, 15), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_in_a_row("head_shot_kill_in_a_row", AchievementStats.definitions.head_shot_kill, AchievementStats.definitions.non_head_shot_kill))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_head_shot_in_a_row", AchievementStats.definitions.head_shot_kill_in_a_row, Activations.clamp(Activations.max, 0, 20), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("fastest_boss_kill", Hooks.definitions.hook_boss_kill, Activations.clamp(Activations.replace_trigger_value(Activations.min, Values.param(Hooks.definitions.hook_boss_kill, "time_since_first_damage")), 0, 3599), {
	Flags.save_to_backend
}, 3599))
Factory.add_to_group(AchievementStats, Factory.create_sum_over_time("damage_blocked_last_20_sec", Hooks.definitions.hook_blocked_damage, 20))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_damage_blocked_last_20_sec", AchievementStats.definitions.damage_blocked_last_20_sec, Activations.clamp(Activations.max, 0, 900), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_melee_toughness_regen", Hooks.definitions.hook_toughness_regenerated, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_toughness_regenerated, "reason", "melee_kill"), Activations.clamp(Activations.sum, 0, 40000)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_in_a_row("dodges_in_a_row", AchievementStats.definitions.dash_dodges, Hooks.definitions.hook_damage_taken))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_dodges_in_a_row", AchievementStats.definitions.dodges_in_a_row, Activations.clamp(Activations.max, 0, 20), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_sprint_dodges", Hooks.definitions.hook_dodge, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_dodge, "attack_type", "ranged"), Conditions.param_has_value(Hooks.definitions.hook_dodge, "reason", "sprint")), Activations.clamp(Activations.increment, 0, 99)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_slide_dodges", Hooks.definitions.hook_dodge, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_dodge, "reason", "slide"), Activations.clamp(Activations.increment, 0, 1)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_player_assists", Hooks.definitions.hook_help_ally, Activations.clamp(Activations.increment, 0, 1000), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_player_rescues", Hooks.definitions.hook_respawn_ally, Activations.clamp(Activations.increment, 0, 500), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_dynamic_reducer("rescued_player_ids", Hooks.definitions.hook_respawn_ally, {
	"target_player_id"
}, Activations.set(1)))
Factory.add_to_group(AchievementStats, Factory.create_simple("different_players_rescued", AchievementStats.definitions.rescued_player_ids, Activations.increment))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_different_players_rescued", AchievementStats.definitions.different_players_rescued, Activations.max, {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_coherency_toughness", Hooks.definitions.hook_toughness_regenerated, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_toughness_regenerated, "reason", "coherency"), Activations.clamp(Activations.sum, 0, 2000)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_deployables_placed", Hooks.definitions.hook_place_item, Activations.on_condition(Conditions.any(Conditions.param_has_value(Hooks.definitions.hook_place_item, "pickup_name", "medical_crate_deployable"), Conditions.param_has_value(Hooks.definitions.hook_place_item, "pickup_name", "ammo_cache_deployable")), Activations.clamp(Activations.increment, 0, 500)), {
	Flags.save_to_backend
}))

local ogryn_2_specialization = "ogryn_2"

Factory.add_to_group(AchievementStats, Factory.create_sum_over_time("ogryn_2_lunge_distance_last_25_seconds", Hooks.definitions.hook_lunge_distance, 25, Conditions.all(Conditions.difficulty_is_at_least(4), Conditions.param_has_value(Hooks.definitions.hook_lunge_distance, "player_class", ogryn_2_specialization))))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_ogryn_2_lunge_distance_last_25_seconds", AchievementStats.definitions.ogryn_2_lunge_distance_last_25_seconds, Activations.clamp(Activations.max, 0, 70), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_ogryn_2_lunge_number_of_enemies_hit", Hooks.definitions.hook_lunge_stop, Activations.on_condition(Conditions.all(Conditions.difficulty_is_at_least(3), Conditions.param_has_value(Hooks.definitions.hook_lunge_stop, "player_class", ogryn_2_specialization)), Activations.clamp(Activations.max, 0, 100)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_flag("ogryn_2_killed_corruptor_with_grenade_impact", Hooks.definitions.hook_kill, Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_kill, "player_class", ogryn_2_specialization), Conditions.is_breed(Hooks.definitions.hook_kill, "corruptor_body"), Conditions.param_has_value(Hooks.definitions.hook_kill, "weapon_template_name", "ogryn_grenade_box"))))

local coherency_exit_flag = "ogryn_2_exit_without_death_flag"

Factory.add_to_group(AchievementStats, Factory.create_flag(coherency_exit_flag, Hooks.definitions.hook_coherency_exit, Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_coherency_exit, "player_class", ogryn_2_specialization), Conditions.param_has_value(Hooks.definitions.hook_coherency_exit, "is_alive", true))))
Factory.add_to_group(AchievementStats, Factory.create_flag("ogryn_2_win_with_coherency_all_alive_units", Hooks.definitions.hook_mission, Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "player_class", ogryn_2_specialization), Conditions.difficulty_is_at_least(3), Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.stat_is_less_then(AchievementStats.definitions.progression_when_player_joined, FROM_START_OF_MISSION_PROGRESSION_CUTOFF), Conditions.inverse(Conditions.flag_is_set(AchievementStats.definitions[coherency_exit_flag])))))

local zealot_2_specialization = "zealot_2"
local HEALTH_REPORT_TIME = 1

Factory.add_to_group(AchievementStats, Factory.create_simple("zealot_2_health_on_last_segment_time", Hooks.definitions.hook_health_update, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_health_update, "player_class", zealot_2_specialization), function (_, _, trigger_value, ...)
	local is_knocked_down = _get_parameter_value(Hooks.definitions.hook_health_update, "is_knocked_down", ...)
	local below_last_health_segement = trigger_value <= 0

	return not is_knocked_down and below_last_health_segement
end), function (_, current_value, _, ...)
	return 0, current_value + HEALTH_REPORT_TIME
end)))
Factory.add_to_group(AchievementStats, Factory.create_flag("zealot_2_health_on_last_segment_enough_mission_end", Hooks.definitions.hook_mission, Conditions.all(Conditions.difficulty_is_at_least(4), Conditions.param_has_value(Hooks.definitions.hook_mission, "player_class", zealot_2_specialization), Conditions.param_is_less_then(Hooks.definitions.hook_mission, "mission_time", 600), function (stat_table, _, _, ...)
	local time_with_one_segement = AchievementStats.definitions.zealot_2_health_on_last_segment_time:get_value(stat_table)
	local mission_time = _get_parameter_value(Hooks.definitions.hook_mission, "mission_time", ...)
	local percentage_under_one_segement = time_with_one_segement / mission_time
	local enough_under = percentage_under_one_segement > 0.75

	return enough_under
end)))
Factory.add_to_group(AchievementStats, Factory.create_simple("zealot_2_stagger_sniper_with_grenade_distance", Hooks.definitions.hook_damage, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_damage, "player_class", zealot_2_specialization), Conditions.param_has_value(Hooks.definitions.hook_damage, "breed_name", "renegade_sniper"), Conditions.param_has_value(Hooks.definitions.hook_damage, "weapon_template_name", "shock_grenade")), Activations.use_parameter_value(Hooks.definitions.hook_damage, "distance"))))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_zealot_2_stagger_sniper_with_grenade_distance", AchievementStats.definitions.zealot_2_stagger_sniper_with_grenade_distance, Activations.clamp(Activations.max, 0, 40), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_zealot_2_health_healed_with_leech_during_resist_death", Hooks.definitions.hook_zealot_2_health_healed_with_leech_during_resist_death, Activations.on_condition(Conditions.all(Conditions.difficulty_is_at_least(4), Conditions.param_has_value(Hooks.definitions.hook_zealot_2_health_healed_with_leech_during_resist_death, "player_class", zealot_2_specialization)), Activations.clamp(Activations.max, 0, 100)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_sum_over_time("zealot_2_kills_of_shocked_enemies_last_15", Hooks.definitions.hook_kill, 10, Conditions.all(Conditions.difficulty_is_at_least(4), Conditions.param_has_value(Hooks.definitions.hook_kill, "player_class", zealot_2_specialization), Conditions.param_table_has_value(Hooks.definitions.hook_kill, "buff_keywords", "shock_grenade_shock", true))))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_zealot_2_kills_of_shocked_enemies_last_15", AchievementStats.definitions.zealot_2_kills_of_shocked_enemies_last_15, Activations.clamp(Activations.max, 0, 50), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_flag("zealot_2_not_use_ranged_attacks", Hooks.definitions.hook_mission, Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "player_class", zealot_2_specialization), Conditions.difficulty_is_at_least(3), Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.stat_is_less_then(AchievementStats.definitions.progression_when_player_joined, FROM_START_OF_MISSION_PROGRESSION_CUTOFF), Conditions.inverse(Conditions.flag_is_set(AchievementStats.definitions.used_range_weapon_flag)))))
Factory.add_to_group(AchievementStats, Factory.create_flag("zelot_2_kill_mutant_charger_with_melee_while_dashing", Hooks.definitions.hook_kill, Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_kill, "player_class", zealot_2_specialization), Conditions.flag_is_set(AchievementStats.definitions.lunge_active), Conditions.param_has_value(Hooks.definitions.hook_damage, "breed_name", "cultist_mutant"), Conditions.param_has_value(Hooks.definitions.hook_damage, "weapon_attack_type", AttackSettings.attack_types.melee))))

local veteran_2_specialization = "veteran_2"

Factory.add_to_group(AchievementStats, Factory.create_flag_switch("volley_fire_active", Hooks.definitions.hook_volley_fire_start, Hooks.definitions.hook_volley_fire_stop))
Factory.add_to_group(AchievementStats, Factory.create_echo("weakspot_hit_while_volley_fire_and_alternate_fire_are_active", AchievementStats.definitions.hit_weakspot, Conditions.all(Conditions.flag_is_set(AchievementStats.definitions.volley_fire_active), Conditions.flag_is_set(AchievementStats.definitions.alternate_fire_active))))
Factory.add_to_group(AchievementStats, Factory.create_echo("elite_weakspot_kill_while_volley_fire_and_alternate_fire_are_active", Hooks.definitions.hook_kill, Conditions.all(Conditions.difficulty_is_at_least(4), Conditions.is_weakspot(Hooks.definitions.hook_kill), Conditions.breed_has_flag(Hooks.definitions.hook_kill, "volley_fire_target"), Conditions.flag_is_set(AchievementStats.definitions.volley_fire_active), Conditions.flag_is_set(AchievementStats.definitions.alternate_fire_active))))
Factory.add_to_group(AchievementStats, Factory.create_merger("volley_end_or_non_weakspot_hit", {
	Hooks.definitions.hook_volley_fire_stop,
	AchievementStats.definitions.missed_weakspot
}, Activations.constant(1)))
Factory.add_to_group(AchievementStats, Factory.create_in_a_row("weakspot_hit_during_volley_fire_alternate_fire", AchievementStats.definitions.weakspot_hit_while_volley_fire_and_alternate_fire_are_active, AchievementStats.definitions.volley_end_or_non_weakspot_hit))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_weakspot_hit_during_volley_fire_alternate_fire", AchievementStats.definitions.weakspot_hit_during_volley_fire_alternate_fire, Activations.clamp(Activations.max, 0, 4), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_in_a_row("elite_weakspot_kill_during_volley_fire_alternate_fire", AchievementStats.definitions.elite_weakspot_kill_while_volley_fire_and_alternate_fire_are_active, Hooks.definitions.hook_volley_fire_stop))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_elite_weakspot_kill_during_volley_fire_alternate_fire", AchievementStats.definitions.elite_weakspot_kill_during_volley_fire_alternate_fire, Activations.clamp(Activations.max, 0, 5), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_echo("melee_damage_taken", Hooks.definitions.hook_damage_taken, Conditions.param_has_value(Hooks.definitions.hook_damage_taken, "attack_type", AttackSettings.attack_types.melee)))
Factory.add_to_group(AchievementStats, Factory.create_flag("has_taken_melee_damage", AchievementStats.definitions.melee_damage_taken))
Factory.add_to_group(AchievementStats, Factory.create_simple("veteran_2_mission_no_melee_damage_taken", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.inverse(Conditions.flag_is_set(AchievementStats.definitions.has_taken_melee_damage)), Conditions.difficulty_is_at_least(3), Conditions.param_has_value(Hooks.definitions.hook_mission, "player_class", veteran_2_specialization)), Activations.set(1))))
Factory.add_to_group(AchievementStats, Factory.create_echo("veteran_2_kills_with_last_round_in_mag", Hooks.definitions.hook_ranged_attack_concluded, Conditions.all(Conditions.difficulty_is_at_least(3), Conditions.param_has_value(Hooks.definitions.hook_ranged_attack_concluded, "player_class", veteran_2_specialization), Conditions.param_has_value(Hooks.definitions.hook_ranged_attack_concluded, "last_round_in_mag", true), Conditions.param_has_value(Hooks.definitions.hook_ranged_attack_concluded, "kill", true))))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_veteran_2_kills_with_last_round_in_mag", AchievementStats.definitions.veteran_2_kills_with_last_round_in_mag, Activations.clamp(Activations.increment, 0, 5), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_flag("has_missed_shot", Hooks.definitions.hook_ranged_attack_concluded, Conditions.inverse(Conditions.param_has_value(Hooks.definitions.hook_ranged_attack_concluded, "hit_minion", true))))
Factory.add_to_group(AchievementStats, Factory.create_simple("remaining_ammo_clip_slot_primary", Hooks.definitions.hook_ammo_consumed, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_ammo_consumed, "slot_name", "slot_primary"), Activations.use_parameter_value(Hooks.definitions.hook_ammo_consumed, "remaining_clip")), nil, 1))
Factory.add_to_group(AchievementStats, Factory.create_simple("remaining_ammo_clip_slot_secondary", Hooks.definitions.hook_ammo_consumed, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_ammo_consumed, "slot_name", "slot_secondary"), Activations.use_parameter_value(Hooks.definitions.hook_ammo_consumed, "remaining_clip")), nil, 1))
Factory.add_to_group(AchievementStats, Factory.create_simple("remaining_ammo_reserve_slot_primary", Hooks.definitions.hook_ammo_consumed, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_ammo_consumed, "slot_name", "slot_primary"), Activations.use_parameter_value(Hooks.definitions.hook_ammo_consumed, "remaining_reserve")), nil, 1))
Factory.add_to_group(AchievementStats, Factory.create_simple("remaining_ammo_reserve_slot_secondary", Hooks.definitions.hook_ammo_consumed, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_ammo_consumed, "slot_name", "slot_secondary"), Activations.use_parameter_value(Hooks.definitions.hook_ammo_consumed, "remaining_reserve")), nil, 1))
Factory.add_to_group(AchievementStats, Factory.create_simple("veteran_2_mission_no_missed_shots_empty_ammo", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.difficulty_is_at_least(4), Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.inverse(Conditions.flag_is_set(AchievementStats.definitions.has_missed_shot)), Conditions.any(Conditions.all(Conditions.stat_is_equal_to(AchievementStats.definitions.remaining_ammo_clip_slot_primary, 0), Conditions.stat_is_equal_to(AchievementStats.definitions.remaining_ammo_reserve_slot_primary, 0)), Conditions.all(Conditions.stat_is_equal_to(AchievementStats.definitions.remaining_ammo_clip_slot_secondary, 0), Conditions.stat_is_equal_to(AchievementStats.definitions.remaining_ammo_reserve_slot_secondary, 0)))), Activations.set(1))))

local psyker_2_specialization = "psyker_2"

Factory.add_to_group(AchievementStats, Factory.create_simple("smite_hound_mid_leap", Hooks.definitions.hook_kill, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_kill, "breed_name", "chaos_hound"), Conditions.param_has_value(Hooks.definitions.hook_kill, "weapon_template_name", "psyker_smite"), Conditions.param_has_value(Hooks.definitions.hook_kill, "action", "leap")), Activations.set(1))))
Factory.add_to_group(AchievementStats, Factory.create_echo("elite_or_special_kill_with_smite", Hooks.definitions.hook_kill, Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_kill, "weapon_template_name", "psyker_smite"), Conditions.any(Conditions.breed_has_tag(Hooks.definitions.hook_kill, "elite"), Conditions.breed_has_tag(Hooks.definitions.hook_kill, "special")))))
Factory.add_to_group(AchievementStats, Factory.create_sum_over_time("elite_or_special_kills_with_smite_last_10_sec", AchievementStats.definitions.elite_or_special_kill_with_smite, 10))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_elite_or_special_kills_with_smite_last_10_sec", AchievementStats.definitions.elite_or_special_kills_with_smite_last_10_sec, Activations.on_condition(Conditions.difficulty_is_at_least(4), Activations.clamp(Activations.max, 0, 5)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_psyker_2_time_at_max_souls", Hooks.definitions.hook_psyker_2_max_souls_hook, Activations.on_condition(Conditions.difficulty_is_at_least(4), Activations.clamp(Activations.max, 0, 300)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_sum_over_time("psyker_2_edge_kills_last_2_sec", AchievementStats.definitions.off_ledge_kills, 2, Conditions.param_has_value(Hooks.definitions.hook_kill, "player_class", psyker_2_specialization)))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_psyker_2_edge_kills_last_2_sec", AchievementStats.definitions.psyker_2_edge_kills_last_2_sec, Activations.clamp(Activations.max, 0, 20), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_dynamic_reducer("smite_boss_damage_by_id", Hooks.definitions.hook_damage, {
	"id"
}, Activations.on_condition(Conditions.all(Conditions.breed_is_boss(Hooks.definitions.hook_damage), Conditions.param_has_value(Hooks.definitions.hook_damage, "damage_type", "smite")), Activations.sum)))
Factory.add_to_group(AchievementStats, Factory.create_simple("kill_boss_solo_with_smite", Hooks.definitions.hook_kill, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_kill, "player_class", psyker_2_specialization), Conditions.difficulty_is_at_least(4), Conditions.breed_is_boss(Hooks.definitions.hook_kill), Conditions.param_has_value(Hooks.definitions.hook_kill, "solo_kill", true), Conditions.calculated_value_comparasions(Values.stat(Hooks.definitions.hook_kill, AchievementStats.definitions.smite_boss_damage_by_id, {
	id = "id"
}, {}), Values.stat(Hooks.definitions.hook_kill, AchievementStats.definitions.boss_damage_by_id, {
	id = "id"
}, {}), Comparators.equals)), Activations.set(1))))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_hacks", Hooks.definitions.hook_hacked_terminal, Activations.clamp(Activations.increment, 0, 200), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("perfect_hacks", Hooks.definitions.hook_hacked_terminal, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_hacked_terminal, "mistakes", 0), Activations.clamp(Activations.increment, 0, 1)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_scans", Hooks.definitions.hook_scanned_objects, Activations.clamp(Activations.sum, 0, 200), {
	Flags.save_to_backend
}))

return AchievementStats
