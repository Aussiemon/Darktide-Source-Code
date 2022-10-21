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
local AttackSettings = require("scripts/settings/damage/attack_settings")
local AchievementStats = Factory.create_group()
local FROM_START_OF_MISSION_PROGRESSION_CUTOFF = 0.05
local _specializations = {
	"zealot_2",
	"psyker_2",
	"veteran_2",
	"ogryn_2"
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
local _weakspot_condition = Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_kill, "weapon_attack_type", "ranged"), Conditions.is_weakspot(Hooks.definitions.hook_kill))

local function _get_parameter_value(stat_to_check, parameter_name, ...)
	local index_of_parameter = table.index_of(stat_to_check:get_parameters(), parameter_name)
	local parameter_value = select(index_of_parameter, ...)

	return parameter_value
end

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

	Factory.add_to_group(AchievementStats, Factory.create_simple(total_kill_id, AchievementStats.definitions[echo_id], Activations.clamp(Activations.increment, 0, 20000), {
		Flags.save_to_backend
	}))
end

_add_generic_weapon_stats("autogun_p1")
_add_generic_weapon_stats("autopistol_p1")
_add_generic_weapon_stats("chain_sword_p1")
_add_generic_weapon_stats("combat_axe_p1")
_add_generic_weapon_stats("combat_axe_p3")
_add_generic_weapon_stats("combat_blade_p1")
_add_generic_weapon_stats("combat_sword_p1")
_add_generic_weapon_stats("force_staff_p1")
_add_generic_weapon_stats("force_sword_p1")
_add_generic_weapon_stats("lasgun_p1")
_add_generic_weapon_stats("ogryn_club_p2")
_add_generic_weapon_stats("rippergun_p1")
_add_generic_weapon_stats("shotgun_p1")
_add_generic_weapon_stats("shotgun_grenade_p1")
_add_generic_weapon_stats("stub_pistol_p1")
_add_generic_weapon_stats("thunder_hammer_p1")

for i = 1, #_specializations do
	local specialization = _specializations[i]
	local id = string.format("max_rank_%s", specialization)

	Factory.add_to_group(AchievementStats, Factory.create_simple(id, Hooks.definitions.hook_spawn_player, Activations.on_condition(Conditions.param_has_value(Hooks.definitions.hook_spawn_player, "player_class", specialization), Activations.clamp(Activations.max, 1, 30)), {
		Flags.save_to_backend
	}))
end

Factory.add_to_group(AchievementStats, Factory.create_simple("mission_circumstance", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.inverse(Conditions.param_has_value(Hooks.definitions.hook_mission, "circumstance_name", "default"))), Activations.clamp(Activations.increment, 0, 500)), {
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

for i = 1, #_specializations do
	local specialization = _specializations[i]
	local id = string.format("missions_%s", specialization)

	Factory.add_to_group(AchievementStats, Factory.create_simple(id, Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "player_class", specialization), Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true)), Activations.clamp(Activations.sum, 0, 500)), {
		Flags.save_to_backend
	}))
end

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
Factory.add_to_group(AchievementStats, Factory.create_simple("total_player_assists", Hooks.definitions.hook_help_ally, Activations.clamp(Activations.increment, 0, 1000), {
	Flags.save_to_backend
}))
Factory.add_to_group(AchievementStats, Factory.create_simple("total_player_rescues", Hooks.definitions.hook_respawn_ally, Activations.clamp(Activations.increment, 0, 1000), {
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

local ogryn_2_specialization = "ogryn_2"

Factory.add_to_group(AchievementStats, Factory.create_flag("ogryn_2_killed_corruptor_with_grenade_impact", Hooks.definitions.hook_kill, Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_kill, "player_class", ogryn_2_specialization), Conditions.is_breed(Hooks.definitions.hook_kill, "corruptor_body"), Conditions.param_has_value(Hooks.definitions.hook_kill, "weapon_attack_type", AttackSettings.attack_types.ranged), Conditions.param_has_value(Hooks.definitions.hook_kill, "weapon_template_name", "ogryn_grenade"))))

local zealot_2_specialization = "zealot_2"
local HEALTH_REPORT_TIME = 1

Factory.add_to_group(AchievementStats, Factory.create_simple("zealot_2_stagger_sniper_with_grenade_distance", Hooks.definitions.hook_damage, Activations.on_condition(Conditions.all(Conditions.difficulty_is_at_least(3), Conditions.param_has_value(Hooks.definitions.hook_damage, "player_class", zealot_2_specialization), Conditions.param_has_value(Hooks.definitions.hook_damage, "breed_name", "renegade_sniper"), Conditions.param_has_value(Hooks.definitions.hook_damage, "weapon_template_name", "shock_grenade")), Activations.use_parameter_value(Hooks.definitions.hook_damage, "distance"))))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_zealot_2_stagger_sniper_with_grenade_distance", AchievementStats.definitions.zealot_2_stagger_sniper_with_grenade_distance, Activations.clamp(Activations.max, 0, 40), {
	Flags.save_to_backend
}))
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

local psyker_2_specialization = "psyker_2"

Factory.add_to_group(AchievementStats, Factory.create_simple("smite_hound_mid_leap", Hooks.definitions.hook_damage, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_damage, "breed_name", "chaos_hound"), Conditions.param_has_value(Hooks.definitions.hook_damage, "weapon_template_name", "psyker_smite"), Conditions.param_has_value(Hooks.definitions.hook_damage, "action", "leap")), Activations.set(1))))
Factory.add_to_group(AchievementStats, Factory.create_sum_over_time("psyker_2_edge_kills_last_2_sec", AchievementStats.definitions.off_ledge_kills, 2, Conditions.param_has_value(Hooks.definitions.hook_kill, "player_class", psyker_2_specialization)))
Factory.add_to_group(AchievementStats, Factory.create_simple("max_psyker_2_edge_kills_last_2_sec", AchievementStats.definitions.psyker_2_edge_kills_last_2_sec, Activations.clamp(Activations.max, 0, 20), {
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
