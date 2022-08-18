local reload_template = {
	name = "plasma_rifle",
	states = {
		"lift_weapon",
		"remove_canister",
		"replace_canister"
	},
	lift_weapon = {
		anim_1p = "reload",
		time = 9,
		state_transitions = {
			lift_weapon = 6.7,
			remove_canister = 2,
			replace_canister = 5.3
		},
		functionality = {
			refill_ammunition = 6.7,
			clear_overheat = 3.1,
			remove_ammunition = 3.1
		}
	},
	remove_canister = {
		anim_1p = "reload_middle",
		time = 4.5,
		state_transitions = {
			replace_canister = 2.8,
			lift_weapon = 3.6
		},
		functionality = {
			refill_ammunition = 3.1
		}
	},
	replace_canister = {
		anim_1p = "reload_end_long",
		time = 3,
		state_transitions = {
			lift_weapon = 0.5
		},
		functionality = {
			refill_ammunition = 0.5
		}
	}
}

return reload_template
