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
	"hit_zone_name",
	"damage_profile_name",
	"distance",
	"player_health_percent",
	"action",
	"id",
	"damage_type",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_blocked_damage", {
	"weapon_template_name",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_blocked_damage"))
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
	"buff_keywords",
	"damage_type",
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
Factory.add_to_group(HookStats, Factory.create_hook("hook_toughness_regenerated", {
	"reason",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_dodge", {
	"attack_type",
	"attacker_breed",
	"reason",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_ranged_attack_concluded", {
	"hit_minion",
	"hit_weakspot",
	"kill",
	"last_round_in_mag",
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
Factory.add_to_group(HookStats, Factory.create_hook("hook_respawn_ally", {
	"target_player_id",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_help_ally", {
	"target_player_id",
	"player_class"
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
	"attack_type"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_damage_taken"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_death"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_knock_down"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_coherency_exit", {
	"is_alive",
	"num_units_in_coherency",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_health_update", {
	"is_knocked_down",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_lunge_start", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_lunge_stop", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_lunge_distance", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_volley_fire_start"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_volley_fire_stop"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_zealot_2_health_healed_with_leech_during_resist_death", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_psyker_2_max_souls_hook", {
	"player_class"
}))
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
