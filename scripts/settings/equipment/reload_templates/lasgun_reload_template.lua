local reload_template = {
	name = "lasgun",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 3.17,
		state_transitions = {
			eject_mag = 1.7,
			cock_weapon = 1,
			fit_new_mag = 0.35
		},
		functionality = {
			refill_ammunition = 1.7,
			remove_ammunition = 0.35
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 2.5,
		state_transitions = {
			eject_mag = 1.2,
			cock_weapon = 0.45
		},
		functionality = {
			refill_ammunition = 1.2
		}
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 1,
		state_transitions = {
			eject_mag = 0.5
		},
		functionality = {
			refill_ammunition = 0.5
		}
	}
}

return reload_template
