local action_handler_settings = {
	abort_sprint = {
		"block",
		"reload_state",
		"vent_overheat",
		"vent_warp_charge"
	},
	prevent_sprint = {
		"block",
		"push",
		"vent_overheat",
		"vent_warp_charge"
	},
	sprint_requires_press_to_interrupt = {
		"reload_state"
	},
	allowed_action_kinds_during_sprint = {
		"block",
		"reload_state",
		"unwield_to_previous",
		"unwield"
	},
	disallowed_action_kinds_during_lunge = {
		"reload_shotgun",
		"reload_state"
	}
}

return settings("ActionHandlerSettings", action_handler_settings)
