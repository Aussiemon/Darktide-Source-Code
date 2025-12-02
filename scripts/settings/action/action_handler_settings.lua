-- chunkname: @scripts/settings/action/action_handler_settings.lua

local action_handler_settings = {}

action_handler_settings.abort_sprint = {
	"block",
	"reload_state",
	"reload_shotgun",
	"vent_overheat",
	"vent_warp_charge",
	"inspect",
}
action_handler_settings.prevent_sprint = {
	"block",
	"push",
	"vent_overheat",
	"vent_warp_charge",
	"throw_grenade",
	"throw_luggable",
	"aim_projectile",
	"inspect",
}
action_handler_settings.sprint_requires_press_to_interrupt = {
	"reload_state",
	"reload_shotgun",
	"inspect",
}
action_handler_settings.no_interruption_for_sprint = {
	"shoot_pellets",
}
action_handler_settings.allowed_action_kinds_during_sprint = {
	"block",
	"reload_state",
	"reload_shotgun",
	"unwield_to_previous",
	"unwield_to_specific",
	"unwield",
	"inspect",
}
action_handler_settings.disallowed_action_kinds_during_lunge = {
	"reload_shotgun",
	"reload_state",
}
action_handler_settings.combo_increase = {
	"sweep",
	"shoot_hit_scan",
	"shoot_pellets",
	"shoot_projectile",
	"spawn_projectile",
}
action_handler_settings.combo_hold = {
	"windup",
}
action_handler_settings.gameplay_time_scale_limits = {
	ranged_load_special = 2,
	reload_special = 2,
	reload_state = 2,
	shoot = 2,
	shoot_hit_scan = 2,
	shoot_pellets = 2,
	shoot_projectile = 2,
	spawn_projectile = 2,
	sweep = 2,
}

return settings("ActionHandlerSettings", action_handler_settings)
