local reload_template = {
	name = "autogun",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 3.32,
		state_transitions = {
			eject_mag = 2.55,
			cock_weapon = 1.8,
			fit_new_mag = 1
		},
		functionality = {
			refill_ammunition = 2.5,
			remove_ammunition = 1
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 2.15,
		state_transitions = {
			eject_mag = 1.35,
			cock_weapon = 0.7
		},
		functionality = {
			refill_ammunition = 1.35
		}
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 1.32,
		state_transitions = {
			eject_mag = 0.75
		},
		functionality = {
			refill_ammunition = 0.75
		}
	}
}

return reload_template
