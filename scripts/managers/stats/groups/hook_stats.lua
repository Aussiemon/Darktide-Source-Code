local Factory = require("scripts/managers/stats/utility/stat_factory")
local HookStats = Factory.create_group()

Factory.add_to_group(HookStats, Factory.create_hook("hook_mission", {
	"mission_name",
	"main_objective_type",
	"difficulty",
	"win",
	"mission_time",
	"team_downs",
	"team_deaths",
	"side_objective_complete",
	"side_objective_name",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_objective", {
	"mission_name",
	"objective_name",
	"objective_type",
	"objective_time",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_damage", {
	"breed_name",
	"weapon_template_name",
	"weapon_attack_type",
	"hit_zone_name",
	"distance",
	"player_health_percent",
	"action",
	"id",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_blocked_damage", {
	"weapon_template_name",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_kill", {
	"breed_name",
	"weapon_template_name",
	"weapon_attack_type",
	"hit_zone_name",
	"distance",
	"player_health_percent",
	"action",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_boss_kill", {
	"breed_name",
	"max_health",
	"id",
	"time_since_first_damage",
	"action"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_kill"))
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
Factory.add_to_group(HookStats, Factory.create_hook("hook_respawn_ally", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_help_ally", {
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
	"type",
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_death", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_knock_down", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_damage_taken", {
	"player_class"
}))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_damage_taken"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_death"))
Factory.add_to_group(HookStats, Factory.create_hook("hook_team_knock_down"))
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
