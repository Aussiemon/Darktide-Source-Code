local reload_template = {
	name = "flamer_rifle",
	states = {
		"remove_canister",
		"replace_canister"
	},
	remove_canister = {
		anim_1p = "reload_start",
		time = 4,
		state_transitions = {
			replace_canister = 1.5,
			remove_canister = 2.75
		},
		functionality = {
			refill_ammunition = 2.75,
			remove_ammunition = 1.5
		}
	},
	replace_canister = {
		anim_1p = "reload_middle",
		time = 2.5,
		state_transitions = {
			remove_canister = 1.5
		},
		functionality = {
			refill_ammunition = 1.5
		}
	}
}

return reload_template
