local Factory = require("scripts/managers/stats/utility/stat_factory")
local HookStats = Factory.create_group()

Factory.add_to_group(HookStats, Factory.create_hook("hook_mission", {
	"mission_name",
	"main_objective_type",
	"circumstance_name",
	"difficulty",
	"win",
	"mission_time",
	"team_kills",
	"team_downs",
	"team_deaths",
	"side_objective_count",
	"side_objective_complete",
	"side_objective_name",
	"is_flash",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_objective", {
	"mission_name",
	"objective_name",
	"objective_type",
	"objective_time",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_decoder_ignored"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_damage", {
	"breed_name",
	"weapon_template_name",
	"weapon_attack_type",
	"attack_result",
	"hit_zone_name",
	"damage_profile_name",
	"distance",
	"player_health_percent",
	"action",
	"id",
	"damage_type",
	"is_critical_hit",
	"is_weapon_special",
	"stagger_result",
	"stagger_type",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_blocked_damage", {
	"weapon_template_name",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_blocked_damage"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_buff", {
	"breed_name",
	"buff_template_name",
	"stack_count",
	"weapon_template_name",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_kill", {
	"breed_name",
	"weapon_template_name",
	"weapon_attack_type",
	"hit_zone_name",
	"damage_profile_name",
	"distance",
	"player_health_percent",
	"action",
	"id",
	"target_buff_keywords",
	"damage_type",
	"is_critical_hit",
	"is_weapon_special",
	"solo_kill",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_boss_kill", {
	"breed_name",
	"max_health",
	"id",
	"time_since_first_damage",
	"action"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_kill", {
	"breed_name",
	"weapon_attack_type"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_killed_disabler", {
	"breed_name",
	"has_disabled_player",
	"weapon_template_name",
	"weapon_attack_type",
	"damage_profile_name",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_toughness_regenerated", {
	"starting_amount",
	"reason",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_toughness_broken", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_dodge", {
	"attack_type",
	"attacker_breed",
	"reason",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_sweep_finished", {
	"num_hit_units",
	"num_killed_enemies",
	"combo_count",
	"hit_weakspot",
	"is_heavy",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_ranged_attack_concluded", {
	"hit_minion",
	"hit_weakspot",
	"kill",
	"last_round_in_mag",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_projectile_impact_concluded", {
	"num_hit_on_impact",
	"num_hit_weakspot",
	"num_kill",
	"num_hit_elite",
	"num_hit_special",
	"weapon_template_name",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_alternate_fire_start"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_alternate_fire_stop"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_ammo_consumed", {
	"slot_name",
	"amount",
	"remaining_clip",
	"remaining_reserve"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_rescue_ally", {
	"target_player_id",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_assist_ally", {
	"target_player_id",
	"assist_type",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_exit_disabled_character_state", {
	"state_name",
	"time_in_state"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_pickup_item", {
	"pickup_name",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_place_item", {
	"pickup_name",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_share_item", {
	"pickup_name",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_collect_material", {
	"type"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_death", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_knock_down", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_damage_taken", {
	"player_class",
	"attack_type",
	"is_attacker_elite"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_damage_taken"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_death"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_knock_down"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_coherency_exit", {
	"is_alive",
	"num_units_in_coherency",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_coherency_update", {
	"num_units_in_coherency",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_health_update", {
	"is_knocked_down",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_lunge_start", {
	"has_target",
	"target_is_wielding_ranged_weapon",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_lunge_stop", {
	"number_of_hit_ranged",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_lunge_distance", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_volley_fire_start"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_volley_fire_stop", {
	"volley_fire_total_time"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_veteran_2_ammo_given"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_veteran_2_kill_volley_fire_target"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_zealot_2_health_healed_with_leech_during_resist_death", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_zealot_2_martyrdom_stacks", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_psyker_2_time_at_max_souls_hook", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_psyker_2_survived_perils", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_psyker_2_reached_max_souls"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_psyker_2_lost_max_souls"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_player_joined", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_spawn_player", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_hacked_terminal", {
	"mistakes",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_scanned_objects", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_corruptor_destroyed"))

return settings("HookStats", HookStats)
