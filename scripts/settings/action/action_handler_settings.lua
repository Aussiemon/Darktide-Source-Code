local action_handler_settings = {
	abort_sprint = {
		"block",
		"reload_state",
		"reload_shotgun",
		"vent_overheat",
		"vent_warp_charge",
		"inspect"
	},
	prevent_sprint = {
		"block",
		"push",
		"vent_overheat",
		"vent_warp_charge",
		"throw_grenade",
		"throw",
		"aim_projectile",
		"inspect"
	},
	sprint_requires_press_to_interrupt = {
		"reload_state",
		"reload_shotgun",
		"inspect"
	},
	allowed_action_kinds_during_sprint = {
		"block",
		"reload_state",
		"reload_shotgun",
		"unwield_to_previous",
		"unwield_to_specific",
		"unwield",
		"inspect"
	},
	disallowed_action_kinds_during_lunge = {
		"reload_shotgun",
		"reload_state"
	},
	combo_increase = {
		"sweep",
		"shoot_hit_scan",
		"shoot_pellets",
		"shoot_projectile",
		"spawn_projectile"
	},
	combo_hold = {
		"windup"
	}
}

return settings("ActionHandlerSettings", action_handler_settings)
