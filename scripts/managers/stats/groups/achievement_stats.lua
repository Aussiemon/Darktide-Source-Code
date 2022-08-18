local Hooks = require("scripts/managers/stats/groups/hook_stats")
local Factory = require("scripts/managers/stats/utility/stat_factory")
local Flags = require("scripts/settings/stats/stat_flags")
local Activations = require("scripts/managers/stats/utility/activation_functions")
local Parameters = require("scripts/managers/stats/utility/parameter_functions")
local Conditions = require("scripts/managers/stats/utility/conditional_functions")
local Comparators = require("scripts/managers/stats/utility/comparator_functions")
local Values = require("scripts/managers/stats/utility/value_functions")
local WeaponCategories = require("scripts/settings/achievements/achievement_weapon_categories")
local AchievementStats = Factory.create_group()
local _specializations = {
	"zealot_1",
	"zealot_2",
	"zealot_3",
	"psyker_1",
	"psyker_2",
	"psyker_3",
	"veteran_1",
	"veteran_2",
	"veteran_3",
	"ogryn_1",
	"ogryn_2",
	"ogryn_3"
}
local _mission_objectives = {
	{
		objective_name = "kill_objective",
		stat_name = "kill"
	},
	{
		objective_name = "demolition_objective",
		stat_name = "demolition"
	},
	{
		objective_name = "luggable_objective",
		stat_name = "luggable"
	},
	{
		objective_name = "decode_objective",
		stat_name = "decode"
	},
	{
		objective_name = "fortification_objective",
		stat_name = "fortification"
	},
	{
		objective_name = "control_objective",
		stat_name = "scanning"
	}
}

Factory.add_to_group(AchievementStats, Factory.create_flag("has_died", Hooks.definitions.hook_death))
Factory.add_to_group(AchievementStats, Factory.create_flag("has_been_downed", Hooks.definitions.hook_knock_down))
Factory.add_to_group(AchievementStats, Factory.create_flag("has_taken_damage", Hooks.definitions.hook_damage_taken))
Factory.add_to_group(AchievementStats, Factory.create_echo("dash_dodges", Hooks.definitions.hook_dodge, Conditions.param_has_value(Hooks.definitions.hook_dodge, "reason", "dodge")))
Factory.add_to_group(AchievementStats, Factory.create_dynamic_reducer("boss_damage_by_id", Hooks.definitions.hook_damage, {
	"id"
}, Activations.on_condition(Conditions.breed_is_boss(Hooks.definitions.hook_damage), Activations.sum)))
Factory.add_to_group(AchievementStats, Factory.create_echo("kill_boss", Hooks.definitions.hook_boss_kill, Conditions.calculated_value_comparasions(Values.stat(Hooks.definitions.hook_boss_kill, AchievementStats.definitions.boss_damage_by_id, {
	id = "id"
}, {}), Values.multiply(Values.param(Hooks.definitions.hook_boss_kill, "max_health"), 0.1), Comparators.greater_than)))

local head_shot_condition = Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_kill, "weapon_attack_type", "ranged"), Conditions.param_has_value(Hooks.definitions.hook_kill, "hit_zone_name", "head"))

Factory.add_to_group(AchievementStats, Factory.create_echo("head_shot_kill", Hooks.definitions.hook_kill, head_shot_condition))
Factory.add_to_group(AchievementStats, Factory.create_echo("non_head_shot_kill", Hooks.definitions.hook_kill, Conditions.inverse(head_shot_condition)))

local function _add_generic_weapon_stats(category_name)
	local echo_id = string.format("kill_%s", category_name)

	Factory.add_to_group(AchievementStats, Factory.create_echo(echo_id, Hooks.definitions.hook_kill, Conditions.weapon_has_keywords(Hooks.definitions.hook_kill, WeaponCategories[category_name])))

	local total_kill_id = string.format("total_kills_%s", category_name)

	Factory.add_to_group(AchievementStats, Factory.create_simple(total_kill_id, AchievementStats.definitions[echo_id], Activations.clamp(Activations.increment, 0, 20000), {
		Flags.save_to_backend
	}))

	local kill_flag_id = string.format("_flag_%s_kill", category_name)

	Factory.add_to_group(AchievementStats, Factory.create_flag(kill_flag_id, AchievementStats.definitions[echo_id]))

	local missions_won_with_weapon_id = string.format("missions_%s", category_name)

	Factory.add_to_group(AchievementStats, Factory.create_simple(missions_won_with_weapon_id, Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.flag_is_set(AchievementStats.definitions[kill_flag_id])), Activations.clamp(Activations.increment, 0, 300)), {
		Flags.save_to_backend
	}))
end

_add_generic_weapon_stats("autogun_p1")
_add_generic_weapon_stats("autogun_p2")
_add_generic_weapon_stats("autogun_p3")
_add_generic_weapon_stats("autopistol_p1")
_add_generic_weapon_stats("autopistol_p2")
_add_generic_weapon_stats("bolter_p1")
_add_generic_weapon_stats("chain_axe_p1")
_add_generic_weapon_stats("chain_sword_p1")
_add_generic_weapon_stats("combat_axe_p1")
_add_generic_weapon_stats("combat_axe_p2")
_add_generic_weapon_stats("combat_axe_p3")
_add_generic_weapon_stats("combat_blade_p1")
_add_generic_weapon_stats("combat_knife_p1")
_add_generic_weapon_stats("combat_sword_p1")
_add_generic_weapon_stats("combat_sword_p2")
_add_generic_weapon_stats("combat_sword_p3")
_add_generic_weapon_stats("flamer_p1")
_add_generic_weapon_stats("force_staff_p1")
_add_generic_weapon_stats("force_staff_p2")
_add_generic_weapon_stats("force_staff_p3")
_add_generic_weapon_stats("force_sword_p1")
_add_generic_weapon_stats("grenadier_gauntlet_p1")
_add_generic_weapon_stats("heavystubber_p1")
_add_generic_weapon_stats("lasgun_p1")
_add_generic_weapon_stats("lasgun_p2")
_add_generic_weapon_stats("lasgun_p3")
_add_generic_weapon_stats("laspistol_p1")
_add_generic_weapon_stats("ogryn_club_p1")
_add_generic_weapon_stats("ogryn_club_p2")
_add_generic_weapon_stats("ogryn_power_maul_p1")
_add_generic_weapon_stats("ogryn_powermaul_slabshield_p1")
_add_generic_weapon_stats("plasma_rifle_p1")
_add_generic_weapon_stats("plasma_rifle_p2")
_add_generic_weapon_stats("power_maul_p1")
_add_generic_weapon_stats("power_sword_p1")
_add_generic_weapon_stats("rippergun_p1")
_add_generic_weapon_stats("shotgun_p1")
_add_generic_weapon_stats("shotgun_p3")
_add_generic_weapon_stats("shotgun_grenade_p1")
_add_generic_weapon_stats("stub_pistol_p1")
_add_generic_weapon_stats("stub_rifle_p1")
_add_generic_weapon_stats("thunder_hammer_p1")

for i = 1, #_specializations, 1 do
	local specialization = _specializations[i]
	local id = string.format("max_rank_%s", specialization)

	Factory.add_to_group(AchievementStats, Factory.create_simple(id, Hooks.definitions.hook_spawn_player, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_spawn_player, "player_class", specialization), Activations.clamp(Activations.max, 1, 30)), {
		Flags.save_to_backend
	}))
end

local function _complete_all_mission_types(id, ...)
	local flags = {}

	for i = 1, #_mission_objectives, 1 do
		local objective = _mission_objectives[i].objective_name
		local flag_id = string.format("_%s_%s_flag", id, objective)

		Factory.add_to_group(AchievementStats, Factory.create_flag(flag_id, Hooks.definitions.hook_mission, Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.param_has_value(Hooks.definitions.hook_mission, "main_objective_type", objective), ...), {
			Flags.save_to_backend
		}))

		flags[#flags + 1] = AchievementStats.definitions[flag_id]
	end

	Factory.add_to_group(AchievementStats, Factory.create_flag_checker(id, flags, {
		Flags.save_to_backend
	}))
end

Factory.add_to_group(AchievementStats, Factory.create_simple("missions", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Activations.clamp(Activations.sum, 0, 1200)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("mission_no_damage", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.inverse(Conditions.flag_is_set(AchievementStats.definitions.has_taken_damage))), Activations.set(1)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("highest_flawless_difficulty", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.inverse(Conditions.flag_is_set(AchievementStats.definitions.has_been_downed))), Activations.clamp(Activations.replace_trigger_value(Activations.max, Values.param(Hooks.definitions.hook_mission, "difficulty")), 0, 5)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("team_flawless_missions", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.param_has_value(Hooks.definitions.hook_mission, "team_downs", 0)), Activations.clamp(Activations.sum, 0, 1)), {
	Flags.save_to_backend
}))

for i = 1, #_specializations, 1 do
	local specialization = _specializations[i]
	local id = string.format("missions_%s", specialization)

	Factory.add_to_group(AchievementStats, Factory.create_simple(id, Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "player_class", specialization), Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true)), Activations.clamp(Activations.sum, 0, 500)), {
		Flags.save_to_backend
	}))
end

for i = 1, #_mission_objectives, 1 do
	local stat_name = _mission_objectives[i].stat_name
	local mission_objective = _mission_objectives[i].objective_name
	local id = string.format("%s_missions", stat_name)

	Factory.add_to_group(AchievementStats, Factory.create_simple(id, Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "main_objective_type", mission_objective), Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true)), Activations.clamp(Activations.sum, 0, 500)), {
		Flags.save_to_backend
	}))
end

for i = 1, #_specializations, 1 do
	local specialization = _specializations[i]

	_complete_all_mission_types(string.format("mission_%s_objectives", specialization), Conditions.param_has_value(Hooks.definitions.hook_mission, "player_class", specialization))
end

for difficulty = 1, 5, 1 do
	_complete_all_mission_types(string.format("mission_difficulty_%s_objectives", difficulty), Conditions.calculated_value_comparasions(Values.param(Hooks.definitions.hook_mission, "difficulty"), Values.constant(difficulty - 1), Comparators.greater_than))
end

Factory.add_to_group(AchievementStats, Factory.create_simple("total_kills", Hooks.definitions.hook_kill, Activations.clamp(Activations.increment, 0, 100000), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_renegade_kills", Hooks.definitions.hook_kill, Activations.on_condition(Conditions.breed_is_faction(Hooks.definitions.hook_kill, "renegade"), Activations.clamp(Activations.increment, 0, 60000)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_cultist_kills", Hooks.definitions.hook_kill, Activations.on_condition(Conditions.breed_is_faction(Hooks.definitions.hook_kill, "cultist"), Activations.clamp(Activations.increment, 0, 60000)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_chaos_kills", Hooks.definitions.hook_kill, Activations.on_condition(Conditions.breed_is_faction(Hooks.definitions.hook_kill, "chaos"), Activations.clamp(Activations.increment, 0, 60000)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_sum_over_time("kills_last_60_sec", Hooks.definitions.hook_kill, 60))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_kills_last_60_sec", AchievementStats.definitions.kills_last_60_sec, Activations.clamp(Activations.max, 0, 90), {
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
Factory.add_to_group(AchievementStats, Factory.create_simple("fastest_boss_kill", AchievementStats.definitions.kill_boss, Activations.clamp(Activations.replace_trigger_value(Activations.min, Values.param(AchievementStats.definitions.kill_boss, "time_since_first_damage")), 0, 3599), {
	Flags.save_to_backend
}, 3599))
Factory.add_to_group(AchievementStats, Factory.create_sum_over_time("damage_blocked_last_20_sec", Hooks.definitions.hook_blocked_damage, 20))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_damage_blocked_last_20_sec", AchievementStats.definitions.damage_blocked_last_20_sec, Activations.clamp(Activations.max, 0, 800), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_melee_toughness_regen", Hooks.definitions.hook_toughness_regenerated, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_toughness_regenerated, "reason", "melee_kill"), Activations.clamp(Activations.sum, 0, 40000)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_in_a_row("dodges_in_a_row", AchievementStats.definitions.dash_dodges, Hooks.definitions.hook_damage_taken))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_dodges_in_a_row", AchievementStats.definitions.dodges_in_a_row, Activations.clamp(Activations.max, 0, 37), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_sprint_dodges", Hooks.definitions.hook_dodge, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_dodge, "attack_type", "ranged"), Conditions.param_has_value(Hooks.definitions.hook_dodge, "reason", "sprint")), Activations.clamp(Activations.increment, 0, 99)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_slide_dodges", Hooks.definitions.hook_dodge, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_dodge, "reason", "slide"), Activations.clamp(Activations.increment, 0, 1)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_player_assists", Hooks.definitions.hook_help_ally, Activations.clamp(Activations.sum, 0, 1000), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_player_rescues", Hooks.definitions.hook_respawn_ally, Activations.clamp(Activations.sum, 0, 1000), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_coherency_toughness", Hooks.definitions.hook_toughness_regenerated, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_toughness_regenerated, "reason", "coherency"), Activations.clamp(Activations.sum, 0, 2000)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_renegade_grenadier_melee", Hooks.definitions.hook_kill, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_kill, "breed_name", "renegade_grenadier"), Conditions.param_has_value(Hooks.definitions.hook_kill, "weapon_attack_type", "melee")), Activations.clamp(Activations.increment, 0, 10)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("kill_daemonhost", Hooks.definitions.hook_kill, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_kill, "breed_name", "chaos_daemonhost"), Activations.set(1)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_hacks", Hooks.definitions.hook_hacked_terminal, Activations.clamp(Activations.increment, 0, 240), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("perfect_hacks", Hooks.definitions.hook_hacked_terminal, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_hacked_terminal, "mistakes", 0), Activations.clamp(Activations.increment, 0, 1)), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_scans", Hooks.definitions.hook_scanned_objects, Activations.clamp(Activations.sum, 0, 600), {
	Flags.save_to_backend
}))

return AchievementStats
